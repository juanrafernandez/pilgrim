#!/usr/bin/env python3
"""
Create natural decoration sprites for the level
Following laws of nature - rocks, bushes, grass tufts
"""
from PIL import Image, ImageDraw
import os

# Color palette
ROCK_DARK = (85, 85, 85)
ROCK_MID = (119, 119, 119)
ROCK_LIGHT = (153, 153, 153)
GRASS_DARK = (51, 102, 51)
GRASS_MID = (68, 136, 68)
GRASS_LIGHT = (85, 170, 85)
BUSH_DARK = (34, 68, 34)
BUSH_MID = (51, 102, 51)
BUSH_LIGHT = (68, 136, 68)
DIRT = (102, 85, 68)
BLACK = (0, 0, 0)

OUTPUT_DIR = "assets/sprites/decorations/natural"
os.makedirs(OUTPUT_DIR, exist_ok=True)

def create_rock_small():
    """Small rock - 32x24px - jumpable obstacle"""
    img = Image.new('RGBA', (32, 24), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)

    # Main rock body (rounded)
    draw.polygon([
        (8, 23), (4, 18), (2, 12), (4, 6), (10, 2),
        (20, 2), (26, 6), (30, 12), (28, 18), (24, 23)
    ], fill=ROCK_MID, outline=BLACK)

    # Dark shadow side (left)
    draw.polygon([
        (8, 23), (4, 18), (2, 12), (6, 10), (8, 14), (10, 20)
    ], fill=ROCK_DARK, outline=None)

    # Light highlight (top-right)
    draw.polygon([
        (18, 4), (24, 6), (26, 10), (22, 8), (18, 6)
    ], fill=ROCK_LIGHT, outline=None)

    # Cracks/detail
    draw.line([(12, 8), (14, 12)], fill=BLACK, width=1)
    draw.line([(20, 10), (22, 14)], fill=BLACK, width=1)

    img.save(f"{OUTPUT_DIR}/rock_small.png")
    print(f"Created {OUTPUT_DIR}/rock_small.png (32x24px - jumpable)")

def create_rock_medium():
    """Medium rock - 48x32px - requires jump"""
    img = Image.new('RGBA', (48, 32), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)

    # Main body
    draw.polygon([
        (12, 31), (6, 24), (3, 16), (4, 8), (10, 3),
        (20, 1), (32, 2), (40, 6), (44, 14), (43, 22), (38, 28), (28, 31)
    ], fill=ROCK_MID, outline=BLACK)

    # Shadow
    draw.polygon([
        (12, 31), (6, 24), (3, 16), (8, 14), (12, 20), (14, 28)
    ], fill=ROCK_DARK, outline=None)

    # Highlights
    draw.polygon([
        (24, 3), (32, 4), (36, 8), (30, 6), (26, 5)
    ], fill=ROCK_LIGHT, outline=None)

    # Texture
    for x, y in [(16, 12), (26, 14), (18, 20), (32, 18)]:
        draw.point((x, y), fill=ROCK_DARK)

    img.save(f"{OUTPUT_DIR}/rock_medium.png")
    print(f"Created {OUTPUT_DIR}/rock_medium.png (48x32px - obstacle)")

def create_rock_large():
    """Large rock - 64x48px - blocking obstacle"""
    img = Image.new('RGBA', (64, 48), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)

    # Main boulder
    draw.polygon([
        (16, 47), (8, 38), (4, 26), (3, 14), (8, 6),
        (18, 2), (32, 1), (46, 3), (56, 10), (60, 20),
        (58, 32), (52, 40), (42, 46), (28, 47)
    ], fill=ROCK_MID, outline=BLACK)

    # Shadow side
    draw.polygon([
        (16, 47), (8, 38), (4, 26), (10, 22), (14, 30), (18, 42)
    ], fill=ROCK_DARK, outline=None)

    # Light side
    draw.polygon([
        (36, 4), (46, 6), (52, 12), (48, 8), (40, 6)
    ], fill=ROCK_LIGHT, outline=None)

    # Secondary highlight
    draw.polygon([
        (48, 18), (54, 22), (52, 28), (48, 24)
    ], fill=ROCK_LIGHT, outline=None)

    # Cracks
    draw.line([(24, 12), (26, 20), (24, 26)], fill=BLACK, width=1)
    draw.line([(40, 16), (42, 24)], fill=BLACK, width=1)

    img.save(f"{OUTPUT_DIR}/rock_large.png")
    print(f"Created {OUTPUT_DIR}/rock_large.png (64x48px - blocking)")

def create_bush():
    """Bush - 40x32px - background decoration"""
    img = Image.new('RGBA', (40, 32), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)

    # Bush clusters (3 rounded shapes)
    # Left cluster
    draw.ellipse([2, 12, 16, 28], fill=BUSH_DARK, outline=BLACK)
    draw.ellipse([4, 14, 14, 26], fill=BUSH_MID, outline=None)
    draw.ellipse([6, 16, 12, 22], fill=BUSH_LIGHT, outline=None)

    # Center cluster (taller)
    draw.ellipse([14, 6, 28, 28], fill=BUSH_DARK, outline=BLACK)
    draw.ellipse([16, 8, 26, 26], fill=BUSH_MID, outline=None)
    draw.ellipse([18, 10, 24, 20], fill=BUSH_LIGHT, outline=None)

    # Right cluster
    draw.ellipse([24, 14, 38, 30], fill=BUSH_DARK, outline=BLACK)
    draw.ellipse([26, 16, 36, 28], fill=BUSH_MID, outline=None)
    draw.ellipse([28, 18, 34, 24], fill=BUSH_LIGHT, outline=None)

    # Base (dirt/ground connection)
    draw.rectangle([8, 28, 32, 31], fill=DIRT, outline=None)

    img.save(f"{OUTPUT_DIR}/bush.png")
    print(f"Created {OUTPUT_DIR}/bush.png (40x32px - decoration)")

def create_grass_tuft():
    """Grass tuft - 16x12px - small ground decoration"""
    img = Image.new('RGBA', (16, 12), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)

    # Individual grass blades
    blades = [
        # x, y_start, y_end, width
        (3, 11, 4, 2),
        (6, 11, 2, 2),
        (9, 11, 5, 2),
        (12, 11, 3, 2),
    ]

    for x, y_start, y_end, width in blades:
        # Blade
        draw.line([(x, y_start), (x, y_end)], fill=GRASS_DARK, width=width)
        # Highlight
        draw.line([(x+1, y_start-1), (x+1, y_end+1)], fill=GRASS_LIGHT, width=1)

    img.save(f"{OUTPUT_DIR}/grass_tuft.png")
    print(f"Created {OUTPUT_DIR}/grass_tuft.png (16x12px - small decoration)")

def create_stone_marker():
    """Stone marker - 24x32px - path marker"""
    img = Image.new('RGBA', (24, 32), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)

    # Upright stone
    draw.polygon([
        (8, 31), (6, 28), (5, 20), (4, 10), (6, 4),
        (12, 1), (18, 4), (20, 10), (19, 20), (18, 28), (16, 31)
    ], fill=ROCK_MID, outline=BLACK)

    # Shadow
    draw.polygon([
        (8, 31), (6, 28), (5, 20), (7, 18), (9, 26), (10, 30)
    ], fill=ROCK_DARK, outline=None)

    # Highlight
    draw.polygon([
        (14, 4), (18, 6), (17, 12), (15, 8)
    ], fill=ROCK_LIGHT, outline=None)

    # Camino shell symbol (scallop)
    draw.arc([10, 12, 14, 16], 0, 180, fill=(170, 136, 102), width=1)

    img.save(f"{OUTPUT_DIR}/stone_marker.png")
    print(f"Created {OUTPUT_DIR}/stone_marker.png (24x32px - path marker)")

if __name__ == "__main__":
    print("Creating natural decoration sprites...")
    print("Following laws of nature: rocks sit on ground, plants grow from ground")
    print()

    create_rock_small()
    create_rock_medium()
    create_rock_large()
    create_bush()
    create_grass_tuft()
    create_stone_marker()

    print()
    print("Natural decorations created!")
    print()
    print("Usage guidelines:")
    print("- rock_small: Place on platforms, jumpable obstacles")
    print("- rock_medium: Terrain obstacles, requires jump")
    print("- rock_large: Blocking elements, change path")
    print("- bush: Background decoration on ground level")
    print("- grass_tuft: Small details along paths")
    print("- stone_marker: Camino waypoint markers")
