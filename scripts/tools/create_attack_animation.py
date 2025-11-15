#!/usr/bin/env python3
"""
Create attack animation sprites for the pilgrim character
Based on retro game attack patterns (Castlevania, Ghost and Goblins)
"""
from PIL import Image, ImageDraw
import os

# Colors (matching pilgrim palette)
ROBE_DARK = (102, 85, 68)      # Dark brown
ROBE_MID = (136, 119, 102)     # Mid brown
ROBE_LIGHT = (170, 153, 136)   # Light brown
SKIN = (255, 204, 170)         # Skin tone
SKIN_SHADOW = (204, 153, 119)  # Skin shadow
STAFF_DARK = (85, 68, 51)      # Staff dark
STAFF_LIGHT = (136, 119, 85)   # Staff light
STAFF_HIGHLIGHT = (170, 153, 119) # Staff highlight
BLACK = (0, 0, 0)
MOTION_BLUR = (150, 150, 150, 128)  # Semi-transparent for blur effect

OUTPUT_DIR = "assets/sprites/characters/animations"
os.makedirs(OUTPUT_DIR, exist_ok=True)

def draw_pilgrim_base(draw, x_offset=0):
    """Draw base body parts that don't change much"""
    # Head
    draw.rectangle([24+x_offset, 8, 39+x_offset, 23], fill=SKIN, outline=BLACK)
    # Eyes
    draw.rectangle([27+x_offset, 13, 28+x_offset, 14], fill=BLACK)
    draw.rectangle([35+x_offset, 13, 36+x_offset, 14], fill=BLACK)
    # Nose
    draw.point((31+x_offset, 17), fill=SKIN_SHADOW)

    # Body (robe)
    draw.rectangle([20+x_offset, 24, 43+x_offset, 60], fill=ROBE_MID, outline=BLACK)
    # Robe shading
    draw.rectangle([21+x_offset, 25, 23+x_offset, 59], fill=ROBE_DARK)
    draw.rectangle([40+x_offset, 25, 42+x_offset, 59], fill=ROBE_LIGHT)

    # Belt
    draw.rectangle([20+x_offset, 40, 43+x_offset, 44], fill=STAFF_DARK, outline=BLACK)

def create_attack_frame_1():
    """Frame 1: Anticipation - pulling staff back"""
    img = Image.new('RGBA', (64, 96), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)

    draw_pilgrim_base(draw)

    # Right arm (pulling back)
    draw.rectangle([44, 28, 50, 42], fill=ROBE_MID, outline=BLACK)
    draw.ellipse([47, 23, 53, 29], fill=SKIN, outline=BLACK)  # Hand

    # Left arm (forward)
    draw.rectangle([13, 32, 19, 46], fill=ROBE_MID, outline=BLACK)
    draw.ellipse([10, 30, 16, 36], fill=SKIN, outline=BLACK)  # Hand

    # Staff (angled back, held high)
    # Staff from hand position to high-right
    draw.line([50, 26, 56, 14], fill=STAFF_DARK, width=3)
    draw.line([50, 26, 56, 14], fill=STAFF_LIGHT, width=2)
    draw.point((56, 14), fill=STAFF_HIGHLIGHT)

    # Legs
    draw.rectangle([24, 61, 30, 87], fill=ROBE_DARK, outline=BLACK)
    draw.rectangle([33, 61, 39, 87], fill=ROBE_DARK, outline=BLACK)
    # Feet
    draw.rectangle([23, 88, 31, 95], fill=STAFF_DARK, outline=BLACK)
    draw.rectangle([32, 88, 40, 95], fill=STAFF_DARK, outline=BLACK)

    img.save(f"{OUTPUT_DIR}/pilgrim_attack_1.png")
    print(f"Created {OUTPUT_DIR}/pilgrim_attack_1.png")

def create_attack_frame_2():
    """Frame 2: Swing start - staff moving forward"""
    img = Image.new('RGBA', (64, 96), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)

    draw_pilgrim_base(draw)

    # Right arm (extending forward-up)
    draw.rectangle([40, 20, 46, 34], fill=ROBE_MID, outline=BLACK)
    draw.ellipse([43, 16, 49, 22], fill=SKIN, outline=BLACK)  # Hand

    # Left arm (supporting)
    draw.rectangle([17, 26, 23, 40], fill=ROBE_MID, outline=BLACK)
    draw.ellipse([14, 24, 20, 30], fill=SKIN, outline=BLACK)  # Hand

    # Staff (diagonal, moving forward)
    draw.line([46, 19, 52, 8], fill=STAFF_DARK, width=3)
    draw.line([46, 19, 52, 8], fill=STAFF_LIGHT, width=2)
    draw.point((52, 8), fill=STAFF_HIGHLIGHT)

    # Legs (wider stance)
    draw.rectangle([22, 61, 28, 87], fill=ROBE_DARK, outline=BLACK)
    draw.rectangle([35, 61, 41, 87], fill=ROBE_DARK, outline=BLACK)
    # Feet
    draw.rectangle([21, 88, 29, 95], fill=STAFF_DARK, outline=BLACK)
    draw.rectangle([34, 88, 42, 95], fill=STAFF_DARK, outline=BLACK)

    img.save(f"{OUTPUT_DIR}/pilgrim_attack_2.png")
    print(f"Created {OUTPUT_DIR}/pilgrim_attack_2.png")

def create_attack_frame_3():
    """Frame 3: Impact - full swing with motion blur (smear effect)"""
    img = Image.new('RGBA', (64, 96), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)

    draw_pilgrim_base(draw, x_offset=-2)  # Body leans forward

    # Right arm (fully extended)
    draw.rectangle([42, 28, 48, 42], fill=ROBE_MID, outline=BLACK)
    draw.ellipse([45, 26, 51, 32], fill=SKIN, outline=BLACK)  # Hand

    # Left arm (raised for balance)
    draw.rectangle([12, 22, 18, 36], fill=ROBE_MID, outline=BLACK)
    draw.ellipse([9, 20, 15, 26], fill=SKIN, outline=BLACK)  # Hand

    # Staff (horizontal with SMEAR EFFECT)
    # Main staff
    draw.line([48, 29, 60, 29], fill=STAFF_DARK, width=3)
    draw.line([48, 29, 60, 29], fill=STAFF_LIGHT, width=2)

    # Motion blur trails (key to retro attack feel!)
    blur_alpha = 80
    for offset in [-2, -1, 1, 2]:
        blur_color = (*MOTION_BLUR[:3], blur_alpha)
        draw.line([48, 29+offset, 60, 29+offset], fill=blur_color, width=1)

    # Impact point indicator
    draw.ellipse([58, 26, 63, 31], fill=(255, 255, 200, 180), outline=None)
    draw.point((60, 29), fill=STAFF_HIGHLIGHT)

    # Legs (forward stance)
    draw.rectangle([20, 61, 26, 87], fill=ROBE_DARK, outline=BLACK)
    draw.rectangle([37, 61, 43, 87], fill=ROBE_DARK, outline=BLACK)
    # Feet
    draw.rectangle([19, 88, 27, 95], fill=STAFF_DARK, outline=BLACK)
    draw.rectangle([36, 88, 44, 95], fill=STAFF_DARK, outline=BLACK)

    img.save(f"{OUTPUT_DIR}/pilgrim_attack_3.png")
    print(f"Created {OUTPUT_DIR}/pilgrim_attack_3.png (with smear effect)")

def create_attack_frame_4():
    """Frame 4: Recovery - returning to ready position"""
    img = Image.new('RGBA', (64, 96), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)

    draw_pilgrim_base(draw)

    # Right arm (pulling back to neutral)
    draw.rectangle([38, 32, 44, 46], fill=ROBE_MID, outline=BLACK)
    draw.ellipse([41, 30, 47, 36], fill=SKIN, outline=BLACK)  # Hand

    # Left arm (lowering)
    draw.rectangle([15, 30, 21, 44], fill=ROBE_MID, outline=BLACK)
    draw.ellipse([12, 28, 18, 34], fill=SKIN, outline=BLACK)  # Hand

    # Staff (angled down, recovering)
    draw.line([44, 33, 48, 45], fill=STAFF_DARK, width=3)
    draw.line([44, 33, 48, 45], fill=STAFF_LIGHT, width=2)
    draw.point((48, 45), fill=STAFF_HIGHLIGHT)

    # Legs (returning to normal)
    draw.rectangle([25, 61, 31, 87], fill=ROBE_DARK, outline=BLACK)
    draw.rectangle([32, 61, 38, 87], fill=ROBE_DARK, outline=BLACK)
    # Feet
    draw.rectangle([24, 88, 32, 95], fill=STAFF_DARK, outline=BLACK)
    draw.rectangle([31, 88, 39, 95], fill=STAFF_DARK, outline=BLACK)

    img.save(f"{OUTPUT_DIR}/pilgrim_attack_4.png")
    print(f"Created {OUTPUT_DIR}/pilgrim_attack_4.png")

if __name__ == "__main__":
    print("Creating pilgrim attack animation (4 frames)...")
    print("Based on retro game attack patterns with motion smear effect")
    print()

    create_attack_frame_1()  # Anticipation
    create_attack_frame_2()  # Swing start
    create_attack_frame_3()  # Impact with smear
    create_attack_frame_4()  # Recovery

    print()
    print("Attack animation complete!")
    print("Frame breakdown:")
    print("  1. Anticipation - pulling staff back")
    print("  2. Swing - staff moving forward")
    print("  3. Impact - full swing with motion blur/smear")
    print("  4. Recovery - returning to ready")
