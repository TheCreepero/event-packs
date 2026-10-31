"""Crops event pictures to the HOI4 event picture size and writes them as uncompressed DDS.

Reads a manifest of tab-separated lines: source picture path, destination .dds path, and
optionally the crop: 0 to 100, the share of the cut width left of the kept part (50 centres it),
or "fit" to keep the whole picture with black bars; and the tone: "none", "grey" (black and
white) or "warm" (black and white with a light sepia cast, close to the game's own pictures).
A destination newer than its source, and last converted with the same crop and tone (by the
--applied record, which this script keeps), is left alone unless --force is given.
Copied from mods/third-reich-events/tools/convert_event_pictures.py, with the tone added.
"""

import argparse
import os
import struct
import sys

from PIL import Image, ImageOps

DDSD_CAPS_HEIGHT_WIDTH_PITCH_PIXELFORMAT = 0x0000100F
DDPF_RGB_WITH_ALPHA = 0x00000041
DDSCAPS_TEXTURE = 0x00001000


def dds_header(width, height):
    pixel_format = struct.pack(
        "<II4sIIIII",
        32,
        DDPF_RGB_WITH_ALPHA,
        b"\0\0\0\0",
        32,
        0x00FF0000,
        0x0000FF00,
        0x000000FF,
        0xFF000000,
    )
    header = struct.pack(
        "<IIIIIII44s",
        124,
        DDSD_CAPS_HEIGHT_WIDTH_PITCH_PIXELFORMAT,
        height,
        width,
        width * 4,
        0,
        0,
        b"\0" * 44,
    )
    caps = struct.pack("<IIIII", DDSCAPS_TEXTURE, 0, 0, 0, 0)
    return b"DDS " + header + pixel_format + caps


def crop_to_aspect(image, width, height, focus=50):
    target_ratio = width / height
    source_width, source_height = image.size
    if source_width / source_height > target_ratio:
        kept_width = round(source_height * target_ratio)
        left = round((source_width - kept_width) * focus / 100)
        box = (left, 0, left + kept_width, source_height)
    else:
        kept_height = round(source_width / target_ratio)
        top = round((source_height - kept_height) * focus / 100)
        box = (0, top, source_width, top + kept_height)
    return image.crop(box).resize((width, height), Image.LANCZOS)


def fit_with_bars(image, width, height):
    source_width, source_height = image.size
    scale = min(width / source_width, height / source_height)
    scaled = image.resize((round(source_width * scale), round(source_height * scale)), Image.LANCZOS)
    canvas = Image.new("RGBA", (width, height), (0, 0, 0, 255))
    canvas.paste(scaled, ((width - scaled.width) // 2, (height - scaled.height) // 2))
    return canvas


def apply_tone(picture, tone):
    if tone == "none":
        return picture
    grey = ImageOps.grayscale(picture.convert("RGB"))
    if tone == "grey":
        toned = grey.convert("RGB")
    elif tone == "warm":
        toned = ImageOps.colorize(grey, black=(24, 18, 12), white=(240, 228, 205), mid=(140, 120, 95))
    else:
        raise ValueError(f"unknown tone {tone}")
    toned = toned.convert("RGBA")
    toned.putalpha(picture.getchannel("A"))
    return toned


def convert(source, destination, width, height, crop="50", tone="none"):
    with Image.open(source) as image:
        if crop == "fit":
            picture = fit_with_bars(image.convert("RGBA"), width, height)
        else:
            picture = crop_to_aspect(image.convert("RGBA"), width, height, int(crop))
    picture = apply_tone(picture, tone)
    os.makedirs(os.path.dirname(destination), exist_ok=True)
    with open(destination, "wb") as output:
        output.write(dds_header(width, height))
        output.write(picture.tobytes("raw", "BGRA"))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--manifest", required=True)
    parser.add_argument("--width", type=int, default=210)
    parser.add_argument("--height", type=int, default=176)
    parser.add_argument("--force", action="store_true")
    parser.add_argument("--applied", default="")
    arguments = parser.parse_args()
    applied = {}
    if arguments.applied and os.path.exists(arguments.applied):
        with open(arguments.applied, encoding="utf-8") as record:
            for line in record:
                fields = line.rstrip("\r\n").split("\t")
                if len(fields) == 2:
                    applied[fields[0]] = fields[1]
    now_applied = {}

    converted = skipped = 0
    failures = []
    with open(arguments.manifest, encoding="utf-8") as manifest:
        for line in manifest:
            line = line.rstrip("\r\n")
            if not line:
                continue
            fields = line.split("\t")
            source, destination = fields[0], fields[1]
            crop = fields[2] if len(fields) > 2 and fields[2] else "50"
            tone = fields[3] if len(fields) > 3 and fields[3] else "none"
            setting = f"{crop}/{tone}"
            up_to_date = (
                os.path.exists(destination)
                and os.path.getmtime(destination) >= os.path.getmtime(source)
                and applied.get(destination) == setting
            )
            if up_to_date and not arguments.force:
                now_applied[destination] = setting
                skipped += 1
                continue
            try:
                convert(source, destination, arguments.width, arguments.height, crop, tone)
                now_applied[destination] = setting
                converted += 1
            except Exception as error:
                failures.append(f"{source}: {error}")

    if arguments.applied:
        os.makedirs(os.path.dirname(os.path.abspath(arguments.applied)), exist_ok=True)
        with open(arguments.applied, "w", encoding="utf-8", newline="\n") as record:
            for destination in sorted(now_applied):
                record.write(f"{destination}\t{now_applied[destination]}\n")

    print(f"pictures converted={converted} up_to_date={skipped} failed={len(failures)}")
    for failure in failures:
        print(f"  FAILED {failure}")
    return 1 if failures else 0


if __name__ == "__main__":
    sys.exit(main())
