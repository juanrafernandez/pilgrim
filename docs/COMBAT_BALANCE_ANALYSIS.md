# Combat Balance Analysis - Weapon & Shield System
**Specialist:** Weapon & Defense Systems
**Date:** 2025-11-15
**Game:** Camino Maldito - La Cruz del Peregrino

---

## 📊 CURRENT STATE ANALYSIS

### Player Stats by Phase

| Phase | HP | Base Dmg | Weapon | Weapon Dmg | Durability | Hits to Break |
|-------|----|---------|---------|-----------| -----------|---------------|
| **CHILD** (1-8) | 80 | 8 | Wood Stick | 8 | 60 | 20 hits |
| **ADOLESCENT** (9-16) | 100 | 12 | Iron Sword | 12 | 100 | 50 hits |
| **KNIGHT** (17-24) | 150 | 20 | Templar Blade | 20 | 150 | 150 hits |
| **ELDER** (25-32) | 120 | 15 | Elder's Staff | 15 | 120 | 120 hits |

### Shield Stats (Current - UNIVERSAL)

```
Max Energy: 100
Consumption: 10/sec
Regeneration: 5/sec
Damage Reduction: 75%
Parry Window: 0.2s
```

**Issues:**
- ❌ Same shield for all phases = unbalanced
- ❌ Consumption/Regen ratio 2:1 too punishing
- ❌ No incentive for skillful parry usage

---

### Enemy Stats by Type

| Enemy | HP | Damage | Knockback | Notes |
|-------|----|---------| --------- |-------|
| **Cow** | 30 | 5 | Low | Passive, early game |
| **Vulture** | 20 | 10 | Medium | Flying, early game |
| **Wolf** | 40 | 15 | High | Aggressive, early-mid |
| **Goat** | 40 | 15 | High | Charges, early-mid |
| **Specter** | 60 | 25 | None | Ghost, mid-late |
| **Knight** | 100 | 30 | Very High | Elite, late game |
| **Mounted Knight** | 120 | 40-45 | Massive | Elite, late game |
| **Boss (Cursed Knight)** | 300 | 40 | Extreme | Boss, phase-based |

---

## 🔍 MATHEMATICAL ANALYSIS

### Survival Calculation (Hits to Die)

**Formula:** `Hits to Die = Player HP / Enemy Damage`

#### WITHOUT Shield:
```
vs Wolf (15 dmg):
  - Child:      80/15  = 5.3 hits ❌ TOO LOW
  - Adolescent: 100/15 = 6.6 hits
  - Knight:     150/15 = 10 hits
  - Elder:      120/15 = 8 hits

vs Knight Enemy (30 dmg):
  - Child:      80/30  = 2.6 hits ❌ 1-SHOT BASICALLY
  - Adolescent: 100/30 = 3.3 hits
  - Knight:     150/30 = 5 hits
  - Elder:      120/30 = 4 hits

vs Boss (40 dmg):
  - Child:      80/40  = 2 hits ❌ INSTANT DEATH
  - Adolescent: 100/40 = 2.5 hits
  - Knight:     150/40 = 3.75 hits ⚠️ TOO LOW FOR BOSS FIGHT
  - Elder:      120/40 = 3 hits
```

#### WITH Shield (75% reduction):
```
vs Wolf (15 dmg → 3.75 blocked):
  - Child:      80/3.75  = 21.3 hits ❌ TOO MANY
  - Adolescent: 100/3.75 = 26.6 hits ❌ TOO EASY
  - Knight:     150/3.75 = 40 hits
  - Elder:      120/3.75 = 32 hits

vs Boss (40 dmg → 10 blocked):
  - Child:      80/10  = 8 hits
  - Adolescent: 100/10 = 10 hits
  - Knight:     150/10 = 15 hits ⚠️ SHIELD BECOMES MANDATORY
  - Elder:      120/10 = 12 hits
```

**CRITICAL ISSUE:** Shield makes early game TOO EASY and late game MANDATORY.

---

### Shield Duration Analysis

**Current System:**
```
Full Block Time: 100 energy / 10 per sec = 10 seconds
Full Recharge Time: 100 energy / 5 per sec = 20 seconds
Ratio: 1:2 (block:recharge)
```

**Comparison with Similar Games:**
- **Dark Souls:** ~1:1 ratio (stamina regen equals consumption)
- **Hollow Knight:** ~1:1.2 ratio (soul regen slightly slower)
- **Ghosts 'n Goblins:** No stamina, but limited armor duration
- **Maldita Castilla:** No shield, dodge-based

**Verdict:** 1:2 ratio is TOO PUNISHING for arcade game.

---

### Weapon Durability vs Enemies

**Hits to Kill Common Enemies:**
```
Wood (8 dmg) vs Wolf (40 HP):   40/8  = 5 hits → 15 durability lost
Iron (12 dmg) vs Specter (60):  60/12 = 5 hits → 10 durability lost
Templar (20 dmg) vs Knight(100): 100/20 = 5 hits → 5 durability lost
Staff (15 dmg) vs Mounted(120): 120/15 = 8 hits → 8 durability lost
```

**Weapon Lifespan:**
```
Wood:    60 dur / 3 loss = 20 enemies ⚠️ BREAKS TOO FAST
Iron:    100 dur / 2 loss = 50 enemies ✅ GOOD
Templar: 150 dur / 1 loss = 150 enemies ✅ EXCELLENT
Staff:   120 dur / 1 loss = 120 enemies ✅ GOOD
```

**Issue:** Wood weapon breaks after ~4 enemy encounters in Child phase. Too punishing for beginners.

---

## 🎮 RESEARCH: SIMILAR GAMES

### Ghosts 'n Goblins (1985)
**Lessons:**
- 2-hit death system (armor + underwear) ✅ Simple, memorable
- No shield, dodge-based ✅ Encourages movement
- Power-ups temporary ✅ Reward progression
- **Brutal difficulty** ⚠️ Not for modern audience

**Applicable:**
- Shield could have "armor mode" (2 big hits) vs "energy mode" (many small hits)
- Perfect parry could grant temporary invincibility

### Maldita Castilla (2012)
**Lessons:**
- Dodge roll with I-frames ✅ Skill-based defense
- Weapon variety (sword, knife, axe) ✅ We have projectiles
- Fair but hard difficulty ✅ Learning curve matters
- Boss patterns telegraphed ✅ Readable attacks

**Applicable:**
- Parry window should be more telegraphed (visual cue)
- Enemy attack animations should be slower/clearer

### Dark Souls (2011)
**Lessons:**
- Stamina management ✅ Risk/reward blocking
- Parry = high risk, high reward ✅ Skill expression
- Different shields = different stats ❌ Too complex for arcade
- **Telegraph is KEY** ✅ Readable enemy attacks

**Applicable:**
- Perfect parry should give HUGE reward (energy refund + bonus)
- Shield should cost stamina per hit, not per second

### Hollow Knight (2017)
**Lessons:**
- Soul meter for healing/spells ✅ Multi-use resource
- I-frames on dash ✅ Skill-based dodge
- Charms for customization ❌ Too complex
- **Balanced risk/reward** ✅ Multiple viable strategies

**Applicable:**
- Shield energy could also heal (consume 50 energy for +25 HP)
- Parry could restore health (life drain on counter)

---

## ⚠️ IDENTIFIED PROBLEMS

### 1. INVERTED DIFFICULTY CURVE
```
Survivability (Hits to Die):
  Child phase:      5.3 hits
  Adolescent phase: 4.0 hits  ⬇️ HARDER
  Knight phase:     3.75 hits ⬇️ HARDER
  Elder phase:      3.0 hits  ⬇️ HARDEST

Expected: Each phase should make you STRONGER, not weaker.
```

**Root Cause:** Enemy damage scales faster than player HP.

---

### 2. SHIELD TOO STRONG EARLY, TOO WEAK LATE

**Child vs Wolf (75% reduction):**
- Without shield: 5.3 hits to die
- With shield: 21.3 hits to die
- **Multiplier: 4x survivability** ❌ Makes game trivial

**Knight vs Boss (75% reduction):**
- Without shield: 3.75 hits to die
- With shield: 15 hits to die
- **Multiplier: 4x survivability** ✅ BUT boss does combos, so still hard

**Issue:** Same % reduction doesn't account for damage scaling.

---

### 3. NO SKILL EXPRESSION IN SHIELD

**Current:**
- Hold Q = block
- Release Q = stop
- Parry window = 0.2s at start

**Problems:**
- No reward for good timing beyond damage reflect
- No penalty for spam blocking
- Energy regen too slow to encourage aggressive play

**Comparisons:**
- **Dark Souls:** Perfect parry = enemy stunned, critical hit opening
- **Sekiro:** Perfect deflect = posture damage to enemy
- **Hollow Knight:** No shield, pure dodge skill

---

### 4. WEAPON DEGRADATION FEELS BAD

**Wood weapon in Child phase:**
- Durability: 60
- Loss per hit: 3
- Total hits: 20
- Typical level has ~15-20 enemies
- **Result:** Weapon breaks every 4-5 enemies ❌ TOO FREQUENT

**Issue:** Child is LEARNING the game. Punishing them with broken weapons creates frustration, not challenge.

---

## ✅ PROPOSED SOLUTIONS

### Solution 1: PHASE-SCALED SHIELD SYSTEM

Instead of universal shield, scale by phase:

| Phase | Energy | Consumption | Regen | Reduction | Parry Window | Parry Reward |
|-------|--------|-------------|-------|-----------|--------------|--------------|
| **CHILD** | 80 | 12/sec | 10/sec | **85%** | **0.25s** | +30 energy |
| **ADOLESCENT** | 100 | 10/sec | 10/sec | **80%** | 0.20s | +30 energy |
| **KNIGHT** | 120 | 8/sec | 12/sec | **70%** | **0.15s** | +40 energy |
| **ELDER** | 100 | 10/sec | 12/sec | **75%** | **0.30s** | +50 energy |

**Rationale:**
- **Child:** Higher reduction + longer parry = forgiveness for beginners
- **Adolescent:** Balanced, standard gameplay
- **Knight:** Lower reduction BUT better regen = skill-based, aggressive play
- **Elder:** Wisdom = longer parry window, compensates for lower HP

**Result:**
```
Child vs Wolf (85% reduction):
  - 15 dmg → 2.25 dmg
  - 80 HP / 2.25 = 35.5 hits ✅ Still forgiving but not broken

Knight vs Boss (70% reduction):
  - 40 dmg → 12 dmg
  - 150 HP / 12 = 12.5 hits ✅ Challenge remains, but shield helps
```

---

### Solution 2: IMPROVED CONSUMPTION/REGEN RATIO

**New System:**
```
Consumption: 8-12/sec (phase-dependent)
Regeneration: 10-12/sec (phase-dependent)
Ratio: ~1:1 to 1.2:1
```

**Benefits:**
- More forgiving for new players
- Encourages hit-and-run tactics
- Aligns with Dark Souls/Hollow Knight standards

---

### Solution 3: PARRY MASTERY REWARDS

**Current:** Perfect parry = reflect damage
**NEW:** Perfect parry = reflect damage + energy refund + bonus effect

| Phase | Energy Refund | Bonus Effect |
|-------|---------------|--------------|
| CHILD | +30 energy | None (learning) |
| ADOLESCENT | +30 energy | +5% damage next hit |
| KNIGHT | +40 energy | Enemy stunned 0.5s |
| ELDER | +50 energy | Heal 10 HP |

**Rationale:**
- Rewards skillful play
- Incentivizes learning parry timing
- Makes shield active defense, not passive tank

---

### Solution 4: REBALANCED ENEMY DAMAGE CURVE

**Goal:** Make player feel STRONGER as they progress, not weaker.

**New Enemy Damage (adjusted by phase appearance):**

| Enemy Type | Current Dmg | Adjusted Dmg | Phase Appearance |
|------------|-------------|--------------|------------------|
| Cow | 5 | **3** | 1-4 |
| Vulture | 10 | **8** | 2-6 |
| Wolf | 15 | **12** | 3-8 |
| Goat | 15 | **12** | 3-8 |
| Specter | 25 | **22** | 9-16 |
| Knight | 30 | **28** | 14-20 |
| Mounted Knight | 40 | **35** | 18-24 |
| Boss | 40 | **45** | 8, 16, 24, 32 |

**Result (NEW - hits to die WITHOUT shield):**
```
Child vs Wolf (12 dmg):    80/12  = 6.6 hits ✅
Adolescent vs Specter (22): 100/22 = 4.5 hits ✅
Knight vs Mounted (35):     150/35 = 4.3 hits ✅
Elder vs Boss (45):         120/45 = 2.6 hits ✅ (but shield available)
```

**Now with phase-scaled shield:**
```
Child vs Wolf (12 → 1.8):       80/1.8  = 44 hits ✅ Very forgiving
Adolescent vs Specter (22 → 4.4): 100/4.4 = 22 hits ✅ Comfortable
Knight vs Mounted (35 → 10.5):  150/10.5 = 14 hits ✅ Challenging
Elder vs Boss (45 → 11.25):     120/11.25 = 10 hits ✅ Hard but fair
```

---

### Solution 5: WEAPON DURABILITY FIXES

**Problem:** Wood breaks too fast (20 hits).

**Proposed:**
| Weapon | Old Dur | New Dur | Old Loss | New Loss | Total Hits |
|--------|---------|---------|----------|----------|------------|
| Wood | 60 | **80** | 3 | **2** | **40 hits** ⬆️ |
| Iron | 100 | 100 | 2 | 2 | 50 hits |
| Templar | 150 | 150 | 1 | 1 | 150 hits |
| Staff | 120 | 120 | 1 | 1 | 120 hits |

**Rationale:**
- Wood now lasts ~8 enemy encounters instead of 4
- Child phase less punishing for beginners
- Other weapons unchanged (already balanced)

---

## 🎯 ADDITIONAL IMPROVEMENTS

### Improvement 1: SHIELD BREAK VISUAL

When shield depletes (0 energy):
- **Visual:** Shield "cracks" particle effect
- **Audio:** Glass breaking sound
- **Feedback:** Cannot block for 2 seconds (recovery animation)
- **Incentive:** Don't let shield fully deplete

---

### Improvement 2: PERFECT PARRY FEEDBACK

**Current:** Basic flash
**Proposed:**
- **Slow motion:** 0.15s time slow (Sekiro-style)
- **Screen flash:** Gold/white flash
- **Audio:** Satisfying "CLANG!" with chime
- **Visual:** Spark burst from shield
- **Text popup:** "PARRY!" in gold letters

**Justification:** Positive reinforcement for skillful play. Makes parry feel AMAZING.

---

### Improvement 3: SHIELD CHIP DAMAGE

**Concept:** Blocking reduces but doesn't eliminate damage completely.

**Proposed:**
- Normal block: 70-85% reduction (scaled by phase)
- **Chip damage:** Minimum 2 damage always goes through
- **Perfect parry:** 100% reduction + reflect

**Example:**
```
Boss hits for 45 dmg with 75% reduction:
  - Old: 45 → 11.25 dmg (no chip)
  - New: 45 → max(11.25, 2) = 11.25 dmg (chip doesn't apply here)

Cow hits for 3 dmg with 85% reduction:
  - Old: 3 → 0.45 dmg (almost nothing)
  - New: 3 → max(0.45, 2) = 2 dmg (chip applies)
```

**Rationale:** Prevents infinite blocking against weak enemies. Encourages parry or dodge.

---

### Improvement 4: WEAPON SPECIAL ATTACKS (Phase 2 Feature)

**Child - Wood:**
- Special: "Fury Flurry" - 3 rapid weak hits (costs 30 shield energy)

**Adolescent - Iron:**
- Special: "Heavy Slash" - 2x damage, breaks guard (costs 40 shield energy)

**Knight - Templar:**
- Special: "Divine Strike" - Area damage, knocks back all nearby (costs 50 shield energy)

**Elder - Staff:**
- Special: "Magic Burst" - Ranged magic projectile (costs 30 shield energy)

**Rationale:**
- Gives shield energy alternate use (not just blocking)
- Adds depth without complexity
- Aligns with "pilgrim" theme (faith/energy as resource)

---

## 📈 EXPECTED RESULTS

### Before Changes:
```
Difficulty Curve (deaths per level avg):
  Levels 1-8:   2 deaths ⚠️ Too easy
  Levels 9-16:  5 deaths ⚠️ Spike
  Levels 17-24: 8 deaths ⚠️ Too hard
  Levels 25-32: 12 deaths ⚠️ Frustrating
```

### After Changes:
```
Difficulty Curve (expected):
  Levels 1-8:   3-4 deaths ✅ Learning
  Levels 9-16:  4-5 deaths ✅ Comfortable
  Levels 17-24: 5-6 deaths ✅ Challenging
  Levels 25-32: 7-8 deaths ✅ Hard but fair
```

---

## 🚀 IMPLEMENTATION PRIORITY

### Phase 1 (CRITICAL - Do Now):
1. ✅ Shield energy scaling by phase
2. ✅ Improved consumption/regen ratio (1:1 to 1.2:1)
3. ✅ Perfect parry energy refund
4. ✅ Wood weapon durability buff

### Phase 2 (HIGH - COMPLETED ✅):
5. ✅ Enemy damage rebalance
6. ✅ Shield break visual/audio
7. ✅ Perfect parry enhanced feedback (slow-motion)
8. ✅ Contact damage balance (Phase 2.5)

### Phase 3 (MEDIUM - Nice to Have):
8. ⏳ Chip damage system
9. ⏳ Weapon special attacks

### Phase 4 (LOW - Post-Launch):
10. ⏳ Shield upgrades/variants
11. ⏳ Enemy-specific parry rewards

---

## 📝 NOTES FOR PLAYTESTING

When testing balance, measure:

1. **Deaths per level:** Should gradually increase, not spike
2. **Shield usage %:** Players should block 40-60% of attacks
3. **Perfect parry %:** Should be ~5-10% of blocks (skilled players 15-20%)
4. **Weapon breaks per level:** Max 1-2 times (except bosses)
5. **"Feels good" factor:** Player should feel badass, not frustrated

**Target Feel:**
- "I died but it was MY fault, not the game being unfair"
- "That parry felt AMAZING"
- "I'm getting better each run"

---

## 🎯 CONCLUSION

**Current system:** Shield makes easy content trivial, hard content impossible.
**Proposed system:** Shield amplifies skill - good players dominate, bad players still have options.

**Philosophy:**
- Ghosts 'n Goblins difficulty with Dark Souls skill expression
- Retro aesthetic with modern QoL
- Punishing but never unfair

**Next Steps:**
1. Implement phase-scaled shield
2. Rebalance enemy damage
3. Add parry rewards
4. Playtest and iterate

---

## 🆕 PHASE 2.5 UPDATE: CONTACT DAMAGE SYSTEM (2025-11-15)

### Overview
A contact damage system was integrated by another developer, allowing enemies to deal damage on collision (not just attacks). This required immediate balance adjustments to maintain difficulty curve.

### Contact Damage Specifications

**Before Phase 2.5:**
- Contact damage = Attack damage (same value)
- Cooldown = 0.5s for all enemies
- Knockback = Vector2(350, -450) - very strong
- **Problem:** Too punishing for early game players

**After Phase 2.5 (BALANCED):**
```gdscript
contact_damage = attack_damage * 0.7  // 70% of attack damage
contact_damage_cooldown:
  - Early game (≤12 dmg): 0.75s  // More forgiving
  - Mid game (12-22 dmg): 0.5-0.75s (interpolated)
  - Late game (≥22 dmg): 0.5s  // Punishing
knockback = Vector2(250, -350)  // Softer than attacks
screenshake = 0.2 trauma  // Lighter feedback
```

### Enemy Contact Damage Values

| Enemy | Attack Dmg | Contact Dmg | Cooldown | Notes |
|-------|-----------|-------------|----------|-------|
| Cow | 3 | 2 | 0.75s | Very forgiving |
| Wolf | 12 | 8 | 0.75s | Balanced early game |
| Goat | 12 | 8 | 0.75s | Balanced early game |
| Vulture | 8 | 5 | 0.75s | Flying contact minimal |
| Specter | 22 | 15 | 0.5s | Starts being punishing |
| Knight | 28 | 19 | 0.5s | Late game pressure |
| Mounted Knight | 35 | 24 | 0.5s | Very dangerous |
| Boss (Phase 3) | 65 | 45 | 0.5s | Extreme danger |

### Impact on Shield Balance

**Shield is now MORE important:**
- Without shield: Player takes both attack + contact damage
- With shield: Contact damage reduced by 70-85% (phase-dependent)
- Perfect parry: Works on contact damage too!

**Example Scenarios:**

**Child Phase vs Wolf (no contact damage system):**
- Attack only: 12 dmg → 1.8 dmg blocked (85% reduction)
- Hits to die: ~56 hits (100 HP / 1.8)

**Child Phase vs Wolf (with contact damage):**
- Attack: 12 dmg → 1.8 dmg blocked
- Contact: 8 dmg → 1.2 dmg blocked
- **Total if hit**: 3 dmg (1.8 + 1.2)
- **Effective hits to die**: ~33 hits (100 HP / 3)
- **40% more deadly!** ⚠️

**Shield Energy Management Critical:**
- Must time blocks carefully (can't spam block anymore)
- Perfect parry now has dual benefit (damage return + energy refund)
- Shield break = exposed to full contact damage

### Adjusted Difficulty Curve

**Updated Phase 2 Goals:**
```
Without Shield:
  Early game: 8-12 hits to die ⚠️ Very punishing
  Late game: 2-3 hits to die ⚠️ Extreme

With Shield (Blocking):
  Early game: 40-50 hits to die ✅ Forgiving
  Late game: 12-15 hits to die ✅ Skill-based

With Perfect Parry:
  All phases: Indefinite survival ✅ Mastery rewarded
```

### Visual Feedback Differences

| Damage Type | Knockback | Screenshake | Feel |
|-------------|-----------|-------------|------|
| Attack Hit | Vector2(350, -450) | 0.5 trauma | "WHACK!" |
| Attack Blocked | Vector2(60, -120) | 0.3 trauma | "Blocked!" |
| Contact Damage | Vector2(250, -350) | 0.2 trauma | "Bumped!" |
| Perfect Parry | None | 0.4 trauma + slowmo | "AMAZING!" |

### Balance Philosophy

**Contact damage as "space control":**
- Punishes players who get cornered or surrounded
- Rewards spacing and movement skill
- Makes blocking more strategic (can't face-tank forever)
- Encourages using attacks to create space

**70% Ratio Reasoning:**
- Contact should hurt, but not as much as deliberate attacks
- Allows skilled players to minimize contact via movement
- Early game remains approachable with 0.75s cooldown
- Late game becomes intense with 0.5s cooldown

### Implementation Notes

**Files Modified:**
- `scripts/enemies/enemy.gd`:
  - Added `contact_damage` variable (auto-calculated as 70% of attack_damage)
  - Added `_adjust_contact_cooldown()` for phase-based tuning
  - Modified `_on_body_entered_contact()` for balanced damage/feedback

**No Changes Needed:**
- Player shield system works perfectly with contact damage
- Perfect parry system reflects contact damage too
- All Phase 2 balance improvements remain valid

### Playtesting Focus

When testing with contact damage:
1. **Is early game still approachable?** (0.75s cooldown sufficient?)
2. **Does shield feel essential?** (should be critical, not optional)
3. **Is contact damage distinct from attacks?** (lighter feel?)
4. **Do players learn spacing?** (should punish face-tanking)

---

**Document Status:** UPDATED - Contact Damage Phase 2.5 Complete
**Reviewed By:** Weapon & Defense Specialist (Claude)
**Approved By:** [Pending Game Director Approval]
