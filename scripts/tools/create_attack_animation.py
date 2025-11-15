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

def draw_staff(draw, x1, y1, x2, y2, width=6):
    """Draw a visible staff/weapon as a thick object with volume"""
    import math

    # Calculate perpendicular offset for width
    dx = x2 - x1
    dy = y2 - y1
    length = math.sqrt(dx*dx + dy*dy)
    if length == 0:
        return

    # Perpendicular unit vector
    px = -dy / length * (width / 2)
    py = dx / length * (width / 2)

    # Four corners of the staff rectangle
    corners = [
        (int(x1 + px), int(y1 + py)),
        (int(x2 + px), int(y2 + py)),
        (int(x2 - px), int(y2 - py)),
        (int(x1 - px), int(y1 - py))
    ]

    # Draw staff body
    draw.polygon(corners, fill=STAFF_DARK, outline=BLACK)

    # Add highlight on one side
    highlight_corners = [
        (int(x1 + px*0.5), int(y1 + py*0.5)),
        (int(x2 + px*0.5), int(y2 + py*0.5)),
        (int(x2 + px*0.2), int(y2 + py*0.2)),
        (int(x1 + px*0.2), int(y1 + py*0.2))
    ]
    draw.polygon(highlight_corners, fill=STAFF_LIGHT, outline=None)

def create_attack_frame_1():
    """Frame 1: Anticipation - staff raised high and back"""
    img = Image.new('RGBA', (64, 96), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)

    draw_pilgrim_base(draw)

    # STAFF FIRST (behind character) - raised diagonally back-high
    # From lower-right to upper-right, angled back
    draw_staff(draw, 46, 32, 58, 8, width=7)

    # Right arm (holding staff high)
    draw.rectangle([42, 26, 48, 40], fill=ROBE_MID, outline=BLACK)
    draw.ellipse([43, 28, 51, 36], fill=SKIN, outline=BLACK)  # Hand gripping

    # Left arm (supporting low on staff)
    draw.rectangle([15, 30, 21, 44], fill=ROBE_MID, outline=BLACK)
    draw.ellipse([12, 32, 20, 40], fill=SKIN, outline=BLACK)  # Hand

    # Legs
    draw.rectangle([24, 61, 30, 87], fill=ROBE_DARK, outline=BLACK)
    draw.rectangle([33, 61, 39, 87], fill=ROBE_DARK, outline=BLACK)
    # Feet
    draw.rectangle([23, 88, 31, 95], fill=STAFF_DARK, outline=BLACK)
    draw.rectangle([32, 88, 40, 95], fill=STAFF_DARK, outline=BLACK)

    img.save(f"{OUTPUT_DIR}/pilgrim_attack_1.png")
    print(f"Created {OUTPUT_DIR}/pilgrim_attack_1.png")

def create_attack_frame_2():
    """Frame 2: Swing start - staff rotating downward"""
    img = Image.new('RGBA', (64, 96), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)

    draw_pilgrim_base(draw)

    # STAFF - rotating down from high to diagonal
    # Now at 45-degree angle, swinging forward
    draw_staff(draw, 38, 22, 55, 12, width=7)

    # Right arm (pushing staff forward)
    draw.rectangle([36, 18, 42, 32], fill=ROBE_MID, outline=BLACK)
    draw.ellipse([35, 20, 43, 28], fill=SKIN, outline=BLACK)  # Hand

    # Left arm (guiding staff)
    draw.rectangle([20, 24, 26, 38], fill=ROBE_MID, outline=BLACK)
    draw.ellipse([17, 22, 25, 30], fill=SKIN, outline=BLACK)  # Hand

    # Legs (wider stance)
    draw.rectangle([22, 61, 28, 87], fill=ROBE_DARK, outline=BLACK)
    draw.rectangle([35, 61, 41, 87], fill=ROBE_DARK, outline=BLACK)
    # Feet
    draw.rectangle([21, 88, 29, 95], fill=STAFF_DARK, outline=BLACK)
    draw.rectangle([34, 88, 42, 95], fill=STAFF_DARK, outline=BLACK)

    img.save(f"{OUTPUT_DIR}/pilgrim_attack_2.png")
    print(f"Created {OUTPUT_DIR}/pilgrim_attack_2.png")

def create_attack_frame_3():
    """Frame 3: Impact - full horizontal swing with motion smear on WEAPON"""
    img = Image.new('RGBA', (64, 96), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)

    draw_pilgrim_base(draw, x_offset=-2)  # Body leans forward

    # MOTION BLUR STAFFS (behind) - the smear effect on the WEAPON itself
    # Multiple semi-transparent copies showing the arc of movement
    for i, offset in enumerate([(-3, -4), (-2, -2), (-1, -1)]):
        alpha = 40 + i * 20  # Increasing opacity
        blur_img = Image.new('RGBA', (64, 96), (0, 0, 0, 0))
        blur_draw = ImageDraw.Draw(blur_img)

        # Draw semi-transparent staff at different positions
        x_off, y_off = offset
        draw_staff(blur_draw, 28+x_off, 28+y_off, 60+x_off, 28+y_off, width=6)

        # Apply transparency
        blur_img.putalpha(alpha)
        img.paste(blur_img, (0, 0), blur_img)

    # MAIN STAFF (horizontal - the actual impact position)
    draw_staff(draw, 28, 28, 62, 28, width=7)

    # Impact flash at the tip
    draw.ellipse([59, 24, 64, 32], fill=(255, 255, 200, 180), outline=None)
    draw.ellipse([60, 25, 63, 31], fill=(255, 255, 255, 220), outline=None)

    # Right arm (fully extended)
    draw.rectangle([20, 24, 26, 38], fill=ROBE_MID, outline=BLACK)
    draw.ellipse([17, 26, 25, 34], fill=SKIN, outline=BLACK)  # Hand gripping

    # Left arm (pulled back after release)
    draw.rectangle([8, 20, 14, 34], fill=ROBE_MID, outline=BLACK)
    draw.ellipse([5, 18, 13, 26], fill=SKIN, outline=BLACK)  # Hand

    # Legs (forward lunge stance)
    draw.rectangle([18, 61, 24, 87], fill=ROBE_DARK, outline=BLACK)
    draw.rectangle([39, 61, 45, 87], fill=ROBE_DARK, outline=BLACK)
    # Feet
    draw.rectangle([17, 88, 25, 95], fill=STAFF_DARK, outline=BLACK)
    draw.rectangle([38, 88, 46, 95], fill=STAFF_DARK, outline=BLACK)

    img.save(f"{OUTPUT_DIR}/pilgrim_attack_3.png")
    print(f"Created {OUTPUT_DIR}/pilgrim_attack_3.png (with weapon smear effect)")

def create_attack_frame_4():
    """Frame 4: Recovery - staff lowering, returning to guard"""
    img = Image.new('RGBA', (64, 96), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)

    draw_pilgrim_base(draw)

    # STAFF - angled down after follow-through
    # From mid-left to lower-right, recovering
    draw_staff(draw, 22, 38, 46, 52, width=7)

    # Right arm (lowering after swing)
    draw.rectangle([30, 36, 36, 50], fill=ROBE_MID, outline=BLACK)
    draw.ellipse([28, 34, 36, 42], fill=SKIN, outline=BLACK)  # Hand

    # Left arm (relaxing)
    draw.rectangle([16, 34, 22, 48], fill=ROBE_MID, outline=BLACK)
    draw.ellipse([13, 36, 21, 44], fill=SKIN, outline=BLACK)  # Hand

    # Legs (returning to normal stance)
    draw.rectangle([25, 61, 31, 87], fill=ROBE_DARK, outline=BLACK)
    draw.rectangle([32, 61, 38, 87], fill=ROBE_DARK, outline=BLACK)
    # Feet
    draw.rectangle([24, 88, 32, 95], fill=STAFF_DARK, outline=BLACK)
    draw.rectangle([31, 88, 39, 95], fill=STAFF_DARK, outline=BLACK)

    img.save(f"{OUTPUT_DIR}/pilgrim_attack_4.png")
    print(f"Created {OUTPUT_DIR}/pilgrim_attack_4.png")

if __name__ == "__main__":
    print("Creating pilgrim attack animation (4 frames)...")
    print("Based on retro game attack patterns with VISIBLE WEAPON SWING")
    print("Staff is drawn as a thick, rotating object throughout the attack")
    print()

    create_attack_frame_1()  # Anticipation
    create_attack_frame_2()  # Swing start
    create_attack_frame_3()  # Impact with smear
    create_attack_frame_4()  # Recovery

    print()
    print("Attack animation complete!")
    print("Frame breakdown:")
    print("  1. Anticipation - staff raised high and back (visible weapon)")
    print("  2. Swing - staff rotating downward at 45° (visible weapon)")
    print("  3. Impact - staff horizontal with motion smear ON THE WEAPON")
    print("  4. Recovery - staff lowering after follow-through (visible weapon)")
    print()
    print("Key improvement: Staff drawn as thick 7px object with volume,")
    print("                 not thin lines. Motion blur shows multiple weapon")
    print("                 positions during impact frame.")
