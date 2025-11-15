#!/usr/bin/env python3
"""
Create pre-tiled terrain textures from 32x32 tiles
"""
from PIL import Image
import os

# Paths
TILES_DIR = "assets/tiles"
OUTPUT_DIR = "assets/tiles/tiled"

# Ensure output directory exists
os.makedirs(OUTPUT_DIR, exist_ok=True)

# Load base tiles
ground_grass = Image.open(f"{TILES_DIR}/ground/ground_grass_top.png")
ground_dirt = Image.open(f"{TILES_DIR}/ground/ground_dirt.png")
platform_stone = Image.open(f"{TILES_DIR}/platforms/platform_stone.png")

def create_tiled_texture(tile_img, width_px, height_px, output_path):
    """Create a tiled texture by repeating a tile image"""
    tile_width, tile_height = tile_img.size

    # Calculate how many tiles we need
    tiles_x = (width_px + tile_width - 1) // tile_width
    tiles_y = (height_px + tile_height - 1) // tile_height

    # Create canvas
    result = Image.new('RGBA', (width_px, height_px), (0, 0, 0, 0))

    # Tile the image
    for y in range(tiles_y):
        for x in range(tiles_x):
            result.paste(tile_img, (x * tile_width, y * tile_height))

    # Crop to exact size
    result = result.crop((0, 0, width_px, height_px))
    result.save(output_path)
    print(f"Created {output_path}: {width_px}x{height_px}px")

# Ground sections (220px height)
print("Creating ground section textures...")
create_tiled_texture(ground_grass, 1000, 220, f"{OUTPUT_DIR}/ground_1000x220.png")
create_tiled_texture(ground_grass, 300, 220, f"{OUTPUT_DIR}/ground_300x220.png")
create_tiled_texture(ground_grass, 600, 220, f"{OUTPUT_DIR}/ground_600x220.png")
create_tiled_texture(ground_grass, 500, 220, f"{OUTPUT_DIR}/ground_500x220.png")
create_tiled_texture(ground_grass, 550, 220, f"{OUTPUT_DIR}/ground_550x220.png")
create_tiled_texture(ground_grass, 800, 220, f"{OUTPUT_DIR}/ground_800x220.png")
create_tiled_texture(ground_grass, 900, 220, f"{OUTPUT_DIR}/ground_900x220.png")
create_tiled_texture(ground_grass, 1400, 220, f"{OUTPUT_DIR}/ground_1400x220.png")

# Platform sections (32px height)
print("Creating platform textures...")
create_tiled_texture(platform_stone, 200, 32, f"{OUTPUT_DIR}/platform_200x32.png")
create_tiled_texture(platform_stone, 250, 32, f"{OUTPUT_DIR}/platform_250x32.png")
create_tiled_texture(platform_stone, 180, 32, f"{OUTPUT_DIR}/platform_180x32.png")

# Bridge (40px height, use platform texture)
print("Creating bridge texture...")
create_tiled_texture(platform_stone, 300, 40, f"{OUTPUT_DIR}/bridge_300x40.png")

print("\nAll tiled textures created successfully!")
