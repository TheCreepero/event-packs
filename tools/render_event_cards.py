"""Draws every event of a pack as the game's country event window, for the pack's Workshop page.

    python -I tools/render_event_cards.py --pack finland [--game-dir <install>] [--out <folder>] [--background cycle|load_<n>|none]

The window comes from the vanilla interface/eventwindow.gui (EventWindow, event_option_entry) and its
sprites, cornered tiles stretched [SPR-029]; the texts from the pack's generated English localisation,
drawn with the game's bitmap fonts [SPR-023] in their declared colours [GUW-011], measured by xadvance
[GUW-012] and kerned [SPR-030]; the pictures from the pack's .gfx and DDS files, or the vanilla
eventpictures.gfx [SPR-028]. The description grows the window to its full length [GUW-046], and the
midsection is the text's height plus DESC_GAP [GUW-047]. A text in a maxWidth box wraps [GUW-015], and
without fixedsize takes every line it needs, running past its maxHeight into what stands below [GUW-027].

Each window sits at 1:1 in the middle of a 16:9 image, the same size for every event of the pack, over
a blurred and dimmed vanilla loading screen (gfx/loadingscreens/load_<n>.dds): the screens in turn by
default, one named screen, or none (a plain dark backdrop). Each image is written as
NN-<event key>.png (a JPEG when the PNG is over 1 MB) into artifacts/workshop-images/<pack>/, which is
emptied first. 00-overview.png throws up to PILE_CARDS of the windows, spread over the pack, on a pile
over the first background: the first event on top, the rest turned a little and overlapping, laid out
the same way on every run of the pack.

Prints [WARN] for a title or option text that overflows its box, [ERROR] for a picture that cannot be found,
and ends with "Rendered <n> events to <folder>". Exit code 1 on any [ERROR].
Fonts and sprite reading follow mods/hoi4-1440p-ui-mod/tools/guiparse.py.
"""

import argparse
import json
import os
import random
import re
import struct
import sys
import zlib

from PIL import Image, ImageChops, ImageEnhance, ImageFilter

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
TOKEN_RE = re.compile(r'#[^\r\n]*|"[^"]*"|[{}=]|[^\s{}=#"]+')
MAX_BYTES = 1024 * 1024
MARGIN = 48
BACKDROP = (28, 30, 34)
DESC_GAP = 30
BLUR = 12
DIM = 0.6
SHADOW_DROP = 8
SHADOW_BLUR = 10
PILE_CARDS = 7
PILE_SIZE = (1600, 900)
PILE_TURN = 12


def find_game_dir(explicit=None):
    candidates = [explicit, os.environ.get("HOI4_GAME_DIR")]
    steam_roots = [r"C:\Program Files (x86)\Steam"]
    try:
        import winreg

        with winreg.OpenKey(winreg.HKEY_CURRENT_USER, r"Software\Valve\Steam") as key:
            steam_roots.insert(0, winreg.QueryValueEx(key, "SteamPath")[0].replace("/", "\\"))
    except (OSError, ImportError):
        pass
    for root in list(steam_roots):
        vdf = os.path.join(root, "steamapps", "libraryfolders.vdf")
        if os.path.isfile(vdf):
            with open(vdf, encoding="utf-8", errors="replace") as handle:
                steam_roots += [m.replace("\\\\", "\\") for m in re.findall(r'"path"\s+"([^"]+)"', handle.read())]
    candidates += [os.path.join(root, "steamapps", "common", "Hearts of Iron IV") for root in steam_roots]
    for candidate in candidates:
        if candidate and os.path.isfile(os.path.join(candidate, "interface", "eventwindow.gui")):
            return candidate
    return None


def open_image(path):
    """An image file, with uncompressed 32-bit DDS files (the loading screens and many sprites) read in one step:
    Pillow decodes those pixel by pixel in Python, about 5 s for one loading screen."""
    if path.lower().endswith(".dds"):
        with open(path, "rb") as handle:
            header = handle.read(128)
            if len(header) == 128 and header[:4] == b"DDS ":
                height, width = struct.unpack_from("<II", header, 12)
                flags, _fourcc, bits, red, green, blue, alpha = struct.unpack_from("<I4sIIIII", header, 80)
                if flags & 0x40 and not flags & 0x4 and bits == 32 and (red, green, blue) == (0xFF0000, 0xFF00, 0xFF):
                    pixels = handle.read(width * height * 4)
                    if len(pixels) == width * height * 4:
                        image = Image.frombuffer("RGBA", (width, height), pixels, "raw", "BGRA", 0, 1).copy()
                        has_alpha = flags & 0x1 and alpha == 0xFF000000
                        return image if has_alpha else image.convert("RGB")
    return Image.open(path)


def read_text(path):
    with open(path, "rb") as handle:
        data = handle.read()
    if data.startswith(b"\xef\xbb\xbf"):
        data = data[3:]
    try:
        return data.decode("utf-8")
    except UnicodeDecodeError:
        return data.decode("latin-1")


def parse(text):
    """Clausewitz script as nested [key, value] lists; a block's value is a list of its children, and a
    bare word (a fontfiles line) is [word, None]."""
    root = []
    stack = [root]
    key = None
    expect_value = False
    for m in TOKEN_RE.finditer(text):
        token = m.group(0)
        if token.startswith("#"):
            continue
        if token == "{":
            if key is not None and not expect_value:
                stack[-1].append([key, None])
            block = []
            stack[-1].append([key if expect_value else "", block])
            stack.append(block)
            key, expect_value = None, False
        elif token == "}":
            if key is not None:
                stack[-1].append([key, None])
            key, expect_value = None, False
            if len(stack) > 1:
                stack.pop()
        elif token == "=":
            expect_value = True
        else:
            value = token[1:-1] if len(token) >= 2 and token.startswith('"') else token
            if expect_value:
                stack[-1].append([key, value])
                key, expect_value = None, False
            else:
                if key is not None:
                    stack[-1].append([key, None])
                key = value
    return root


def get(block, name, default=None):
    for key, value in block:
        if key and key.lower() == name.lower():
            return value
    return default


def blocks(block, name=None):
    return [value for key, value in block if isinstance(value, list) and (name is None or (key or "").lower() == name.lower())]


def find_named(block, name):
    for value in blocks(block):
        if get(value, "name") == name:
            return value
        found = find_named(value, name)
        if found is not None:
            return found
    return None


def xy(block, name, default=(0, 0)):
    sub = get(block, name)
    if not isinstance(sub, list):
        return default
    return int(float(get(sub, "x", get(sub, "width", default[0])))), int(float(get(sub, "y", get(sub, "height", default[1]))))


def load_sprites(folders):
    """name -> (texture path, border or None) for every sprite of the .gfx files in these folders."""
    sprites = {}
    for base, folder in folders:
        if not os.path.isdir(folder):
            continue
        for name in sorted(os.listdir(folder)):
            if not name.lower().endswith(".gfx"):
                continue
            for _section, children in [(k, v) for k, v in parse(read_text(os.path.join(folder, name))) if isinstance(v, list)]:
                for key, sprite in [(k, v) for k, v in children if isinstance(v, list)]:
                    if not (key or "").lower().endswith("spritetype") or not get(sprite, "name"):
                        continue
                    texture = get(sprite, "textureFile") or get(sprite, "textureFile1")
                    if not texture:
                        continue
                    border = xy(sprite, "borderSize") if isinstance(get(sprite, "borderSize"), list) else None
                    sprites[get(sprite, "name")] = (os.path.join(base, *re.split(r"[\\/]+", texture)), border)
    return sprites


class BitmapFont:
    """A bitmapfont of the .gfx files: its fontfiles in order (a glyph missing from one comes from the next)."""

    def __init__(self, fnt_paths, color):
        self.color = color
        self.line_height = 0
        self.chars = {}
        self.kerning = {}
        for path in fnt_paths:
            page_file = None
            with open(path, encoding="utf-8", errors="replace") as handle:
                for line in handle:
                    parts = line.split()
                    if not parts:
                        continue
                    attrs = dict(p.split("=", 1) for p in parts[1:] if "=" in p)
                    if parts[0] == "common" and not self.line_height:
                        self.line_height = int(attrs.get("lineHeight", 0))
                    elif parts[0] == "page":
                        page_file = attrs["file"].strip('"')
                    elif parts[0] == "char":
                        code = int(attrs["id"])
                        if code not in self.chars:
                            glyph = {k: int(attrs[k]) for k in ("x", "y", "width", "height", "xoffset", "yoffset", "xadvance")}
                            glyph["page"] = (path, page_file)
                            self.chars[code] = glyph
                    elif parts[0] == "kerning":
                        self.kerning.setdefault((int(attrs["first"]), int(attrs["second"])), int(attrs["amount"]))
        self.pages = {}

    def glyph(self, ch):
        return self.chars.get(ord(ch)) or self.chars.get(ord("?"))

    def advances(self, text):
        """(character, glyph, x offset from the line start) for each drawn character, kerning applied."""
        cursor = 0
        prev = None
        out = []
        for ch in text:
            glyph = self.glyph(ch)
            if glyph is None:
                continue
            cursor += self.kerning.get((prev, ord(ch)), 0)
            out.append((glyph, cursor))
            cursor += glyph["xadvance"]
            prev = ord(ch)
        return out, cursor

    def width(self, text):
        return self.advances(text)[1]

    def page(self, key):
        if key not in self.pages:
            path, page_file = key
            stem = os.path.splitext(path)[0]
            candidates = ([os.path.join(os.path.dirname(path), page_file)] if page_file else []) + [stem + ".dds", stem + ".tga"]
            self.pages[key] = open_image(next(c for c in candidates if os.path.isfile(c))).convert("RGBA")
        return self.pages[key]

    def draw(self, canvas, x, y, text):
        for g, offset in self.advances(text)[0]:
            if g["width"] and g["height"]:
                tile = self.page(g["page"]).crop((g["x"], g["y"], g["x"] + g["width"], g["y"] + g["height"]))
                if self.color != (255, 255, 255, 255):
                    alpha = tile.split()[3]
                    tile = ImageChops.multiply(tile, Image.new("RGBA", tile.size, self.color))
                    tile.putalpha(alpha)
                canvas.alpha_composite(tile, (int(x + offset + g["xoffset"]), int(y + g["yoffset"])))

    def wrap(self, text, max_width):
        lines = []
        for paragraph in text.split("\n"):
            line = ""
            for word in paragraph.split(" "):
                candidate = word if not line else line + " " + word
                if line and self.width(candidate) > max_width:
                    lines.append(line)
                    line = word
                else:
                    line = candidate
            lines.append(line)
        return lines


def load_fonts(game_dir):
    """name -> BitmapFont for every bitmapfont block of the vanilla .gfx files."""
    out = {}
    folder = os.path.join(game_dir, "interface")
    for name in sorted(os.listdir(folder)):
        if not name.lower().endswith(".gfx"):
            continue
        text = read_text(os.path.join(folder, name))
        if "bitmapfont" not in text:
            continue
        for section in blocks(parse(text), "bitmapfonts"):
            for font in blocks(section, "bitmapfont"):
                files = [k for k, v in (get(font, "fontfiles") or []) if v is None] if isinstance(get(font, "fontfiles"), list) else []
                files = files or ([get(font, "path")] if get(font, "path") else [])
                paths = [os.path.join(game_dir, *re.split(r"[\\/]+", f)) + ".fnt" for f in files]
                paths = [p for p in paths if os.path.isfile(p)]
                if not paths:
                    continue
                argb = int(str(get(font, "color") or "0xffffffff"), 16)
                out[get(font, "name")] = BitmapFont(paths, ((argb >> 16) & 255, (argb >> 8) & 255, argb & 255, 255))
    return out


def nine_slice(img, border, w, h):
    """A corneredTileSpriteType stretched to w x h with its borders kept."""
    bx, by = min(border[0], img.width // 2), min(border[1], img.height // 2)
    out = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    cols = [(0, bx, 0, bx), (bx, img.width - bx, bx, w - bx), (img.width - bx, img.width, w - bx, w)]
    rows = [(0, by, 0, by), (by, img.height - by, by, h - by), (img.height - by, img.height, h - by, h)]
    for sx1, sx2, dx1, dx2 in cols:
        for sy1, sy2, dy1, dy2 in rows:
            if sx2 <= sx1 or sy2 <= sy1 or dx2 <= dx1 or dy2 <= dy1:
                continue
            out.alpha_composite(img.crop((sx1, sy1, sx2, sy2)).resize((dx2 - dx1, dy2 - dy1), Image.LANCZOS), (dx1, dy1))
    return out


def load_localisation(pack_dir):
    out = {}
    folder = os.path.join(pack_dir, "localisation", "english")
    line_re = re.compile(r'^\s*([A-Za-z0-9_.\-]+):\d*\s*"(.*)"\s*(?:#.*)?$')
    for name in sorted(os.listdir(folder)) if os.path.isdir(folder) else []:
        if name.lower().endswith(".yml"):
            with open(os.path.join(folder, name), encoding="utf-8-sig") as handle:
                for line in handle:
                    m = line_re.match(line)
                    if m:
                        out[m.group(1)] = m.group(2).replace("\\n", "\n").replace('\\"', '"')
    return out


class EventWindow:
    def __init__(self, game_dir, pack_dir):
        gui = parse(read_text(os.path.join(game_dir, "interface", "eventwindow.gui")))
        self.window = find_named(gui, "EventWindow")
        self.entry = find_named(gui, "event_option_entry")
        self.sprites = load_sprites([(game_dir, os.path.join(game_dir, "interface")), (pack_dir, os.path.join(pack_dir, "interface"))])
        self.fonts = load_fonts(game_dir)
        self.images = {}

    def image(self, sprite_name):
        if sprite_name not in self.images:
            entry = self.sprites.get(sprite_name)
            self.images[sprite_name] = open_image(entry[0]).convert("RGBA") if entry and os.path.isfile(entry[0]) else None
        return self.images[sprite_name]

    def background(self, block):
        bg = get(block, "background")
        return (get(bg, "spriteType") or get(bg, "quadTextureSprite")) if isinstance(bg, list) else None

    def render(self, title, desc, options, picture_sprite):
        """The window image and the list of texts that overflow their box."""
        overflows = []
        width = xy(self.window, "size")[0]
        top = find_named(self.window, "top_Window")
        mid = find_named(self.window, "midsection")
        bottom = find_named(self.window, "bottom_Window")
        title_box = find_named(top, "Title")
        desc_box = find_named(mid, "Description")
        grid = find_named(bottom, "options_grid")
        name_box = find_named(self.entry, "Name")

        top_h = xy(top, "size")[1]
        bottom_h = xy(bottom, "size")[1]
        desc_font = self.fonts[get(desc_box, "font")]
        desc_x, desc_y = xy(desc_box, "position")
        desc_lines = desc_font.wrap(desc, int(get(desc_box, "maxWidth")))
        while desc_lines and not desc_lines[-1]:
            desc_lines.pop()
        mid_h = max(desc_y + len(desc_lines) * desc_font.line_height + DESC_GAP, 1)
        grid_x, grid_y = xy(grid, "position")
        slot_h = xy(grid, "slotsize")[1]
        bottom_h = max(bottom_h, grid_y + slot_h * len(options))
        height = top_h + mid_h + bottom_h

        canvas = Image.new("RGBA", (width, height), (0, 0, 0, 0))
        window_bg = self.image(self.background(self.window))
        if window_bg is not None:
            border = self.sprites[self.background(self.window)][1] or (0, 0)
            canvas.alpha_composite(nine_slice(window_bg, border, width, height))

        def paste(sprite_name, x, y):
            img = self.image(sprite_name)
            if img is not None:
                canvas.alpha_composite(img, (x, y))
            return img

        paste(self.background(top), 0, 0)
        title_font = self.fonts[get(title_box, "font")]
        tx, ty = xy(title_box, "position")
        title_max = int(get(title_box, "maxWidth"))
        title_lines = title_font.wrap(title, title_max)
        fit = max(1, int(get(title_box, "maxHeight")) // title_font.line_height)
        if len(title_lines) > fit:
            overflows.append("title is %d px wide, over its %d px box; it wraps to %d lines and runs into the description" % (title_font.width(title), title_max, len(title_lines)))
        for i, line in enumerate(title_lines):
            title_font.draw(canvas, tx + (title_max - title_font.width(line)) // 2, ty + i * title_font.line_height, line)
        minimize = find_named(top, "btn_minimize")
        paste(get(minimize, "spriteType"), *xy(minimize, "position"))

        mid_sprite = self.background(mid)
        mid_img = self.image(mid_sprite)
        if mid_img is not None:
            canvas.alpha_composite(nine_slice(mid_img, self.sprites[mid_sprite][1] or (0, 0), mid_img.width, mid_h), (0, top_h))
        for i, line in enumerate(desc_lines):
            desc_font.draw(canvas, desc_x, top_h + desc_y + i * desc_font.line_height, line)

        oy = top_h + mid_h
        paste(self.background(bottom), 0, oy)
        picture_box = find_named(bottom, "event_picture")
        px, py = xy(picture_box, "position")
        picture = self.image(picture_sprite)
        if picture is not None:
            canvas.alpha_composite(picture, (px, oy + py))
        clip = find_named(bottom, "event_pic_clip")
        cx, cy = xy(clip, "position")
        clip_img = self.image(get(clip, "spriteType"))
        if clip_img is not None:
            layer = Image.new("RGBA", (width + 8, height + 8), (0, 0, 0, 0))
            layer.alpha_composite(clip_img, (cx + 4, oy + cy + 4))
            canvas.alpha_composite(layer.crop((4, 4, width + 4, height + 4)))

        name_font = self.fonts[get(name_box, "font")]
        nx, ny = xy(name_box, "position")
        name_max = int(get(name_box, "maxWidth"))
        name_fit = max(1, int(get(name_box, "maxHeight")) // name_font.line_height)
        for index, text in enumerate(options):
            sx, sy = grid_x, oy + grid_y + index * slot_h
            paste(self.background(self.entry), sx, sy)
            lines = name_font.wrap(text, name_max)
            if len(lines) > name_fit:
                overflows.append("option %d is %d px wide; it wraps to %d lines at %d px and runs past its button" % (index + 1, name_font.width(text), len(lines), name_max))
            top_y = sy + ny + (int(get(name_box, "maxHeight")) - len(lines) * name_font.line_height) // 2
            for i, line in enumerate(lines):
                name_font.draw(canvas, sx + nx + (name_max - name_font.width(line)) // 2, top_y + i * name_font.line_height, line)
        return canvas, overflows, picture is not None


def loading_screens(game_dir):
    """The vanilla loading screens, gfx/loadingscreens/load_<n>.dds, in number order."""
    folder = os.path.join(game_dir, "gfx", "loadingscreens")
    names = [n for n in os.listdir(folder) if re.match(r"(?i)^load_\d+\.dds$", n)] if os.path.isdir(folder) else []
    return [os.path.join(folder, n) for n in sorted(names, key=lambda n: int(re.findall(r"\d+", n)[0]))]


def backdrop(path, size):
    """A loading screen filling size, blurred and dimmed so the window stands out."""
    if not path:
        return Image.new("RGB", size, BACKDROP)
    img = open_image(path).convert("RGB")
    scale = max(size[0] / img.width, size[1] / img.height)
    img = img.resize((max(size[0], round(img.width * scale)), max(size[1], round(img.height * scale))), Image.LANCZOS)
    left, top = (img.width - size[0]) // 2, (img.height - size[1]) // 2
    img = img.crop((left, top, left + size[0], top + size[1])).filter(ImageFilter.GaussianBlur(BLUR))
    return ImageEnhance.Brightness(img).enhance(DIM)


def compose(window, background):
    """The window centred on its background, over a soft shadow."""
    canvas = background.convert("RGBA")
    x, y = (canvas.width - window.width) // 2, (canvas.height - window.height) // 2
    shadow = Image.new("RGBA", canvas.size, (0, 0, 0, 0))
    alpha = window.split()[3].point(lambda a: a * 3 // 4)
    shadow.paste(Image.new("RGBA", window.size, (0, 0, 0, 255)), (x, y + SHADOW_DROP), alpha)
    canvas.alpha_composite(shadow.filter(ImageFilter.GaussianBlur(SHADOW_BLUR)))
    canvas.alpha_composite(window, (x, y))
    return canvas.convert("RGB")


def spread(items, count):
    """Up to count items, evenly spaced from the first to the last."""
    if len(items) <= count:
        return list(items)
    return [items[round(i * (len(items) - 1) / (count - 1))] for i in range(count)]


def drop_card(canvas, window, centre, angle):
    """A window turned by angle degrees, with its shadow, centred on centre."""
    card = window.rotate(angle, resample=Image.BICUBIC, expand=True)
    x, y = round(centre[0] - card.width / 2), round(centre[1] - card.height / 2)
    shadow = Image.new("RGBA", canvas.size, (0, 0, 0, 0))
    alpha = card.split()[3].point(lambda a: a * 4 // 5)
    shadow.paste(Image.new("RGBA", card.size, (0, 0, 0, 255)), (x + SHADOW_DROP, y + 2 * SHADOW_DROP), alpha)
    canvas.alpha_composite(shadow.filter(ImageFilter.GaussianBlur(2 * SHADOW_BLUR)))
    layer = Image.new("RGBA", canvas.size, (0, 0, 0, 0))
    layer.paste(card, (x, y), card)
    canvas.alpha_composite(layer)


def pile(windows, background, seed):
    """The windows thrown on a pile: the first on top near the middle, the rest spread under it, each
    turned a little, half of them each way. The same seed gives the same pile."""
    rng = random.Random(seed)
    canvas = background.convert("RGBA")
    width, height = canvas.size
    under = windows[1:]
    sides = [1 if k % 2 == 0 else -1 for k in range(len(under))]
    rng.shuffle(sides)
    places = []
    for k, window in enumerate(under):
        share = k / (len(under) - 1) if len(under) > 1 else 0.5
        x = width * (0.2 + 0.6 * share) + rng.uniform(-40, 40)
        y = height * (0.36 if k % 2 == 0 else 0.64) + rng.uniform(-30, 30)
        places.append((window, (x, y), sides[k] * rng.uniform(PILE_TURN / 4, PILE_TURN)))
    rng.shuffle(places)
    for window, centre, angle in places:
        drop_card(canvas, window, centre, angle)
    if windows:
        drop_card(canvas, windows[0], (width / 2 + rng.uniform(-30, 30), height / 2 + rng.uniform(-20, 20)), rng.uniform(-PILE_TURN / 3, PILE_TURN / 3))
    return canvas.convert("RGB")


def save(framed, folder, stem):
    path = os.path.join(folder, stem + ".png")
    framed.save(path)
    if os.path.getsize(path) > MAX_BYTES:
        os.remove(path)
        path = os.path.join(folder, stem + ".jpg")
        framed.save(path, quality=90)
        print("  %s.png was over 1 MB; written as JPEG" % stem)
    return path


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--pack", required=True)
    parser.add_argument("--game-dir")
    parser.add_argument("--out")
    parser.add_argument("--source-dir")
    parser.add_argument("--pack-dir")
    parser.add_argument("--background", default="cycle", help="cycle (the loading screens in turn), a loading screen such as load_6, or none")
    args = parser.parse_args()

    source_dir = args.source_dir or os.path.join(REPO_ROOT, "source", args.pack)
    pack_dir = args.pack_dir or os.path.join(REPO_ROOT, "packs", args.pack)
    out = args.out or os.path.join(REPO_ROOT, "artifacts", "workshop-images", args.pack)
    if args.game_dir and not os.path.isfile(os.path.join(args.game_dir, "interface", "eventwindow.gui")):
        print("[ERROR] --game-dir %s has no interface/eventwindow.gui" % args.game_dir)
        return 1
    if not os.path.isfile(os.path.join(source_dir, "events.json")):
        print("[ERROR] no %s" % os.path.join(source_dir, "events.json"))
        return 1
    game_dir = find_game_dir(args.game_dir)
    if not game_dir:
        print("[ERROR] no Hearts of Iron IV install found: pass --game-dir or set HOI4_GAME_DIR")
        return 1

    with open(os.path.join(source_dir, "events.json"), encoding="utf-8-sig") as handle:
        source = json.load(handle)
    namespace = source["namespace"]
    texts = load_localisation(pack_dir)
    window = EventWindow(game_dir, pack_dir)

    os.makedirs(out, exist_ok=True)
    for name in os.listdir(out):
        if name.lower().endswith((".png", ".jpg")):
            os.remove(os.path.join(out, name))

    screens = loading_screens(game_dir)
    if args.background == "none":
        screens = []
    elif args.background != "cycle":
        screens = [p for p in screens if os.path.splitext(os.path.basename(p))[0].lower() == args.background.lower()]
        if not screens:
            print("[ERROR] --background %s is not a loading screen in gfx/loadingscreens" % args.background)
            return 1

    errors = 0
    rendered = []
    events = sorted(source["events"], key=lambda e: e["id"])
    for event in events:
        prefix = "%s.%d" % (namespace, event["id"])
        picture = event["picture"]
        sprite = picture.split(":", 1)[1] if picture.startswith("vanilla:") else "GFX_%s_%s" % (namespace, picture)
        letters = [chr(ord("a") + i) for i in range(len(event["options"]))]
        title = texts.get(prefix + ".t", event["title"])
        desc = texts.get(prefix + ".desc", event["desc"])
        options = [texts.get("%s.%s" % (prefix, letter), option["name"]) for letter, option in zip(letters, event["options"])]
        image, overflows, has_picture = window.render(title, desc, options, sprite)
        for overflow in overflows:
            print("[WARN] %s: %s" % (prefix, overflow))
        if not has_picture:
            print("[ERROR] %s: picture %s not found" % (prefix, sprite))
            errors += 1
        rendered.append((event, image))

    height = max(image.height for _event, image in rendered) + 2 * MARGIN if rendered else 0
    size = (max([round(height * 16 / 9)] + [image.width + 2 * MARGIN for _event, image in rendered]), height)
    for index, (event, image) in enumerate(rendered):
        screen = screens[index % len(screens)] if screens else None
        save(compose(image, backdrop(screen, size)), out, "%02d-%s" % (event["id"], event["key"]))
    if rendered:
        chosen = spread([image for _event, image in rendered], PILE_CARDS)
        save(pile(chosen, backdrop(screens[0] if screens else None, PILE_SIZE), zlib.crc32(args.pack.encode("utf-8"))), out, "00-overview")
        print("  00-overview: %d events on a pile" % len(chosen))
    print("Rendered %d events to %s" % (len(events), out))
    return 1 if errors else 0


if __name__ == "__main__":
    sys.exit(main())
