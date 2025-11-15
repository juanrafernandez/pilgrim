# Weapon & Shield System - Production Roadmap 🎮⚔️🛡️

**Document Purpose:** Comprehensive task list to bring the weapon & shield combat system to AAA indie production quality for a retro arcade pixel art game.

**Specialist:** Combat Balance Specialist (Weapons, Shields, Damage Systems)
**Game:** Camino Maldito - La Cruz del Peregrino
**Style:** Ghosts 'n Goblins meets Dark Souls
**Last Updated:** 2025-11-15

---

## 📋 COMPLETED WORK (Phases 1-2.5)

### Phase 1: Foundation ✅
- [x] Shield resource system with energy management
- [x] Block state with damage reduction
- [x] Perfect parry mechanics (timing window)
- [x] Phase-scaled shield stats (Child: 85% → Knight: 70% reduction)
- [x] Energy consumption/regeneration balance (1:1 to 1.2:1 ratio)
- [x] Perfect parry energy refund system (30-50 energy)
- [x] Shield HUD with color-coded energy bar
- [x] Parry window indicator (flashing gold)
- [x] Wood weapon durability buff (60→80, loss 3→2)

### Phase 2: Balance & Feedback ✅
- [x] Enemy damage rebalance across all 9 enemy types
- [x] Boss damage scaling (3 phases: 45→55→65 dmg)
- [x] Shield break visual/audio feedback (camera shake, flashes)
- [x] Shield recharge positive feedback (gentle pulse, cyan flash)
- [x] Perfect parry slow-motion effect (0.25x speed, 0.15s)
- [x] Enhanced screenshake hierarchy (0.2-0.6 trauma)

### Phase 2.5: Contact Damage ✅
- [x] Contact damage separation (70% of attack damage)
- [x] Dynamic cooldown scaling (0.75s early → 0.5s late)
- [x] Reduced contact knockback (250/-350 vs 350/-450)
- [x] Distinct visual feedback (0.2 trauma vs 0.5)
- [x] Comprehensive balance documentation
- [x] Updated COMBAT_BALANCE_ANALYSIS.md

---

## 🎯 PHASE 3: CORE GAMEPLAY POLISH (HIGH PRIORITY)

### 3.1 Chip Damage System ⚡ CRITICAL
**Purpose:** Prevent 100% shield camping, encourage aggressive play

- [ ] Implement minimum damage bypass (2-5 dmg always passes through)
- [ ] Scale chip damage by phase (Child: 2 dmg → Knight: 5 dmg)
- [ ] Perfect parry blocks chip damage (reward skill)
- [ ] Add chip damage visual indicator (small red flash through shield)
- [ ] Balance chip damage so blocking is still viable but not infinite
- [ ] Test with boss fights (should force occasional retreat)

**Priority:** CRITICAL - Without this, players can block forever
**Estimated Time:** 2-3 hours
**Files:** `scripts/weapons/shield.gd`, `scripts/player/player.gd`

### 3.2 Shield Stamina/Guard Break System 💪 HIGH
**Purpose:** Add depth to blocking, punish spam blocking

- [ ] Implement "shield stamina" separate from energy
- [ ] Heavy hits drain more stamina (boss attacks = 40 stamina)
- [ ] Stamina regenerates faster than energy (2x rate)
- [ ] Guard break at 0 stamina (stun for 0.5s)
- [ ] Visual: Shield flashes yellow at <25% stamina
- [ ] Audio: Shield creak/strain sounds at low stamina
- [ ] Balance: 100 stamina, heavy hit = 40, light = 10

**Priority:** HIGH - Adds skill ceiling and strategic depth
**Estimated Time:** 4-5 hours
**Files:** `scripts/weapons/shield.gd`, `scripts/ui/shield_bar.gd`

### 3.3 Weapon Special Attacks 🗡️ HIGH
**Purpose:** Give offense/defense trade-off, resource management

**Special Attacks per Weapon:**
- [ ] **Wood Stick**: "Desperate Swing" - Costs 30 shield energy, 2x damage AOE
- [ ] **Iron Sword**: "Charged Slash" - Costs 40 energy, piercing line attack
- [ ] **Staff**: "Holy Burst" - Costs 50 energy, AOE knockback + damage
- [ ] **Templar Sword**: "Virtue Strike" - Costs energy OR virtue, deals holy damage

**Implementation:**
- [ ] Add special attack input (Hold Attack + Block = Special)
- [ ] Consume shield energy on activation
- [ ] Add visual effects (glowing weapon, trail particles)
- [ ] Add audio cues (charging sound, release sound)
- [ ] Balance: Should feel powerful but costly
- [ ] Add cooldown (3-5 seconds) to prevent spam

**Priority:** HIGH - Adds offensive depth to defensive system
**Estimated Time:** 6-8 hours
**Files:** `scripts/weapons/*.gd`, `scripts/player/states/*.gd`

### 3.4 Enhanced Combat Feedback 🎨 MEDIUM
**Purpose:** Make every action feel impactful and satisfying

**Block Feedback:**
- [ ] Add spark particle effect on successful block (blue sparks)
- [ ] Add metallic clang sound (pitch varies by enemy attack strength)
- [ ] Add brief white flash on player sprite
- [ ] Add shield icon "bounce" animation in HUD

**Parry Feedback (Already has slowmo, enhance further):**
- [ ] Add golden explosion particle effect
- [ ] Add high-pitched "TING!" sound
- [ ] Add rainbow trail on reflected projectile
- [ ] Add "PERFECT!" text popup (arcade style)
- [ ] Consider brief invincibility frames (0.1s)

**Contact Damage Feedback:**
- [ ] Add subtle red outline on player sprite
- [ ] Add "bump" sound (lower pitched than attack hit)
- [ ] Add dust particle effect at contact point
- [ ] Consider vibration feedback (if controller support)

**Priority:** MEDIUM - Enhances feel but not critical for balance
**Estimated Time:** 5-6 hours
**Files:** Multiple (particles, audio, player.gd)

---

## 🎵 PHASE 4: AUDIO & JUICE (MEDIUM PRIORITY)

### 4.1 Shield Audio System 🔊 MEDIUM
**Purpose:** Audio clarity for all shield states

**Required Sound Effects:**
- [ ] Shield equip/unequip sound (metallic slide)
- [ ] Block start sound (shield raise, wood creak)
- [ ] Block loop sound (quiet hum while blocking)
- [ ] Block hit sound (impact, varies by enemy attack)
- [ ] Perfect parry sound (high "TING!", glass break reverb)
- [ ] Shield break sound (wood splinter, metal clang)
- [ ] Shield recharge sound (magical shimmer, wind-up)
- [ ] Low energy warning sound (beeping at <20% energy)

**Implementation:**
- [ ] Create/source placeholder sounds from freesound.org
- [ ] Add AudioStreamPlayer nodes to shield system
- [ ] Hook up signals to play sounds
- [ ] Add volume ducking for important sounds (parry > block > contact)
- [ ] Test audio mix with music and enemy sounds

**Priority:** MEDIUM - Audio is 50% of game feel
**Estimated Time:** 4-5 hours
**Files:** `scripts/weapons/shield.gd`, asset management

### 4.2 Weapon Audio Enhancement 🎶 MEDIUM
**Purpose:** Each weapon feels distinct via audio

- [ ] Wood: Hollow "thunk" on hit, light whoosh on swing
- [ ] Iron: Metallic "clang" on hit, sharp whoosh on swing
- [ ] Staff: Magical "whump" on hit, mystical hum on swing
- [ ] Templar: Holy "BOOM" on hit, angelic choir on swing
- [ ] Special attacks: Unique charging + release sounds
- [ ] Weapon break: Specific sounds per weapon type

**Priority:** MEDIUM - Enhances weapon identity
**Estimated Time:** 3-4 hours

---

## 🎨 PHASE 5: VISUAL EFFECTS (MEDIUM-LOW PRIORITY)

### 5.1 Shield Particle Effects 💫 MEDIUM
**Purpose:** Visual clarity and satisfaction

**Particle Effects Needed:**
- [ ] **Block Sparks**: Blue/white sparks flying off shield (direction-based)
- [ ] **Perfect Parry**: Golden explosion burst (screen center)
- [ ] **Shield Break**: Wood splinters + metal shards flying out
- [ ] **Shield Recharge**: Cyan/blue shimmer particles swirling in
- [ ] **Low Energy**: Orange flame-like flicker around shield edge
- [ ] **Parry Window**: Subtle golden glow on player sprite

**Implementation:**
- [ ] Create GPUParticles2D scenes for each effect
- [ ] Match pixel art aesthetic (chunky, low-res particles)
- [ ] Optimize particle count for mobile (max 50 particles)
- [ ] Add to appropriate signal callbacks
- [ ] Test performance on target device (iOS)

**Priority:** MEDIUM - Important for feel but not gameplay
**Estimated Time:** 6-8 hours

### 5.2 Shield Visual States 🎭 LOW
**Purpose:** Visual feedback of shield condition

- [ ] Shield sprite changes color based on energy (<25% = red tint)
- [ ] Shield cracks appear at <50% energy (2 states: cracked, very cracked)
- [ ] Shield glows during parry window (golden outline)
- [ ] Shield pulses when blocking (subtle scale animation)
- [ ] Shield "shatters" on break (sprite breaks into pieces)
- [ ] Shield "reforms" on recharge (pieces fly back together)

**Priority:** LOW - Nice to have, placeholder working fine
**Estimated Time:** 4-5 hours (requires sprite art)

---

## 📊 PHASE 6: BALANCE REFINEMENT (ONGOING)

### 6.1 Playtesting & Data Collection 📈 CRITICAL
**Purpose:** Validate all balance decisions with real data

**Metrics to Track:**
- [ ] Setup analytics logging for combat events
- [ ] Track shield usage % per level (target: 50-70%)
- [ ] Track perfect parry success % (target: 5-10% beginner, 15-20% skilled)
- [ ] Track deaths per level (should increase gradually)
- [ ] Track shield breaks per level (target: 1-2 times)
- [ ] Track weapon breaks per level (target: 1-2 times, 3-4 for bosses)
- [ ] Track damage sources (attack vs contact split)

**Playtesting Sessions:**
- [ ] 5 beginners (never played action games)
- [ ] 5 intermediate (played some action games)
- [ ] 5 experts (Souls/Ghosts 'n Goblins veterans)
- [ ] Record sessions, watch for frustration points
- [ ] Survey: "Did you feel deaths were fair?" (target: >80% yes)

**Priority:** CRITICAL - Data drives all balance decisions
**Estimated Time:** Ongoing (10+ hours testing)

### 6.2 Phase-Specific Balance Tuning 🎚️ HIGH
**Purpose:** Each player phase should feel distinct

**Child Phase (Levels 1-8):**
- [ ] Verify shield reduction (85%) feels forgiving
- [ ] Verify contact cooldown (0.75s) allows learning
- [ ] Verify wood weapon lasts 2-3 encounters
- [ ] Verify deaths average 3-4 per level

**Adolescent Phase (Levels 9-16):**
- [ ] Verify shield reduction (80%) feels balanced
- [ ] Verify iron weapon durability matches content
- [ ] Verify deaths average 4-5 per level
- [ ] Verify parry window (0.20s) is learnable

**Knight Phase (Levels 17-24):**
- [ ] Verify shield reduction (70%) rewards skill
- [ ] Verify contact cooldown (0.5s) feels punishing
- [ ] Verify templar weapon feels powerful
- [ ] Verify deaths average 5-6 per level
- [ ] Verify parry window (0.15s) requires mastery

**Elder Phase (Levels 25-32):**
- [ ] Verify shield reduction (75%) helps fragility
- [ ] Verify staff special attacks feel impactful
- [ ] Verify deaths average 7-8 per level
- [ ] Verify parry window (0.25s) compensates for lower stats

**Priority:** HIGH - Core game balance
**Estimated Time:** 5-8 hours per phase (20-32 hours total)

### 6.3 Enemy-Specific Balance 🐺 MEDIUM
**Purpose:** Each enemy should have unique counter-strategy

- [ ] **Cow**: Verify contact damage (2) is beginner-friendly
- [ ] **Wolf**: Verify pack tactics don't overwhelm (test 3+ wolves)
- [ ] **Goat**: Verify charge attack telegraphing is clear
- [ ] **Vulture**: Verify aerial attacks can be parried
- [ ] **Specter**: Verify phase-through doesn't break shield timing
- [ ] **Knight**: Verify sword clash feels fair
- [ ] **Mounted Knight**: Verify charge can be perfect-parried
- [ ] **Thief**: Verify projectile parry returns damage correctly
- [ ] **Boss**: Verify 3 phases escalate difficulty smoothly

**For Each Enemy:**
- [ ] Test shield effectiveness vs all attack types
- [ ] Test perfect parry window clarity
- [ ] Test contact damage frequency/fairness
- [ ] Adjust if any enemy feels "unfair" vs "hard"

**Priority:** MEDIUM - Variety prevents monotony
**Estimated Time:** 1-2 hours per enemy (9-18 hours)

---

## 🚀 PHASE 7: ADVANCED FEATURES (LOW PRIORITY / POST-LAUNCH)

### 7.1 Shield Upgrade System 🛡️ LOW
**Purpose:** Progression system for shields

**Shield Variants per Phase:**
- [ ] **Child**: Wooden Shield (default) vs Toy Shield (faster energy regen)
- [ ] **Adolescent**: Iron Shield (default) vs Buckler (better parry window)
- [ ] **Knight**: Templar Shield (default) vs Crusader Shield (chip damage immunity)
- [ ] **Elder**: Pilgrim Shield (default) vs Holy Shield (energy regen while attacking)

**Implementation:**
- [ ] Create shield variant resources
- [ ] Add shop/upgrade system (costs gold/virtue)
- [ ] Add visual variants (recolor sprites)
- [ ] Balance variants (no strict "best" choice)
- [ ] Save/load shield selection

**Priority:** LOW - Base system must be perfect first
**Estimated Time:** 8-10 hours

### 7.2 Enemy-Specific Parry Rewards 🎁 LOW
**Purpose:** Encourage learning enemy patterns

- [ ] **Wolf**: Parry grants brief speed boost (thematic: wolf speed)
- [ ] **Goat**: Parry stuns enemy briefly (thematic: headbutt redirected)
- [ ] **Specter**: Parry grants 1s invincibility (thematic: phase shift)
- [ ] **Knight**: Parry restores extra energy +10 (thematic: honor duel)
- [ ] **Boss**: Parry breaks boss armor/phase (thematic: critical strike)

**Implementation:**
- [ ] Add parry bonus system to shield.gd
- [ ] Add enemy type detection on parry
- [ ] Add visual indicator for active bonus
- [ ] Balance bonuses to not be mandatory

**Priority:** LOW - Fun but not essential
**Estimated Time:** 5-7 hours

### 7.3 Advanced Parry Techniques 🥋 LOW
**Purpose:** Skill ceiling for mastery players

- [ ] **Chain Parry**: Parry 3+ attacks in 2s = extended slowmo
- [ ] **Multi-Parry**: Parry 2 enemies simultaneously = AOE knockback
- [ ] **Perfect Block**: Block (not parry) with >90% energy = half cost
- [ ] **Last Stand**: Parry with <10 HP = full energy refund + brief invincibility
- [ ] **Virtue Parry**: Parry while at max virtue = 2x damage reflection

**Implementation:**
- [ ] Add combo/streak tracking
- [ ] Add special particle effects for advanced parries
- [ ] Add achievement tracking
- [ ] Balance to feel amazing but not required

**Priority:** LOW - For mastery players only
**Estimated Time:** 6-8 hours

---

## 🧪 PHASE 8: TESTING & OPTIMIZATION (CRITICAL FOR LAUNCH)

### 8.1 Performance Optimization ⚡ CRITICAL
**Purpose:** 60 FPS on target iOS devices

- [ ] Profile shield system performance (should be <1ms)
- [ ] Optimize particle effects (max 50 particles total)
- [ ] Test with 10+ enemies on screen
- [ ] Test slow-motion performance (ensure stable)
- [ ] Test on oldest target device (iPhone X or equivalent)
- [ ] Optimize signal emissions (use call_deferred if needed)
- [ ] Profile memory usage (shield should be <1MB)

**Priority:** CRITICAL - Game must run smoothly
**Estimated Time:** 4-6 hours

### 8.2 Edge Case Testing 🐛 HIGH
**Purpose:** Eliminate all edge case bugs

**Test Scenarios:**
- [ ] Parry while shield breaks (should fail gracefully)
- [ ] Block while being knocked back (should cancel knockback)
- [ ] Parry two attacks in same frame (should reflect both)
- [ ] Shield recharge during death animation (should cancel)
- [ ] Energy at exactly 0 (should deplete, not negative)
- [ ] Perfect parry with no attacker reference (should not crash)
- [ ] Spam block button (should not flicker)
- [ ] Block while underwater (if water levels exist)
- [ ] Block while on ladder (if ladders exist)
- [ ] Shield during cutscene (should disable)

**Priority:** HIGH - Polish prevents frustration
**Estimated Time:** 3-5 hours

### 8.3 Accessibility Features ♿ MEDIUM
**Purpose:** Make game accessible to more players

**Shield Accessibility Options:**
- [ ] "Easy Parry" mode: 0.3s window instead of 0.15-0.25s
- [ ] "Auto-Block" mode: Automatically blocks when enemy attacks (still costs energy)
- [ ] "Visual Parry Indicator": Larger/brighter parry window flash
- [ ] "Parry Sound Cue": Distinct audio cue 0.1s before attack lands
- [ ] Color-blind mode for shield bar (patterns instead of colors)

**Implementation:**
- [ ] Add accessibility settings menu
- [ ] Save settings to player profile
- [ ] Test with accessibility testers
- [ ] Do NOT shame players for using assists (no achievements locked)

**Priority:** MEDIUM - Expands audience
**Estimated Time:** 4-6 hours

---

## 📝 PHASE 9: DOCUMENTATION & TUTORIALS (LAUNCH READY)

### 9.1 In-Game Tutorial 📖 CRITICAL
**Purpose:** Teach shield mechanics without text walls

**Tutorial Moments (Integrated into Level 1):**
- [ ] First enemy: "Press Q to Block" prompt
- [ ] After blocking: "Hold Block to reduce damage" explanation
- [ ] After taking 3 hits: "Watch the shield energy bar!" indicator
- [ ] Wooden dummy: "Block RIGHT when attack hits = Perfect Parry!"
- [ ] After first parry: "Perfect Parry reflects damage!" celebration
- [ ] First shield break: "Shield Depleted! Wait for recharge!"
- [ ] After recharge: "Shield Ready!" positive reinforcement

**Implementation:**
- [ ] Add tutorial triggers to Level 1
- [ ] Add UI popup system (arcade style, minimal text)
- [ ] Add skip tutorial option (for veterans)
- [ ] Test with non-gamer testers (must understand in <2 minutes)

**Priority:** CRITICAL - Players must understand system
**Estimated Time:** 5-7 hours

### 9.2 Developer Documentation 📚 MEDIUM
**Purpose:** Future developers can maintain/extend system

- [ ] Document all shield variables and their purpose
- [ ] Document phase-scaling formulas with examples
- [ ] Document signal flow (what connects to what)
- [ ] Create "How to Add New Shield Type" guide
- [ ] Create "How to Balance New Enemy" guide
- [ ] Add inline code comments for complex formulas
- [ ] Create UML diagram of shield system architecture

**Priority:** MEDIUM - Helps long-term maintenance
**Estimated Time:** 3-4 hours

---

## 🏆 PHASE 10: POLISH & FINAL TOUCHES (LAUNCH READY)

### 10.1 Achievements & Progression 🎖️ LOW
**Purpose:** Long-term engagement and mastery goals

**Shield-Related Achievements:**
- [ ] "First Defense" - Block 1 attack
- [ ] "Shield Mastery" - Block 100 attacks in single run
- [ ] "Perfection" - Perform 10 perfect parries in single level
- [ ] "Unbreakable" - Complete level without shield breaking
- [ ] "Reflector" - Kill enemy with reflected damage only
- [ ] "Iron Wall" - Block 50 attacks without taking damage
- [ ] "Last Second" - Parry with <5% shield energy remaining
- [ ] "Unstoppable" - Maintain shield for entire boss fight

**Priority:** LOW - Nice to have but not core
**Estimated Time:** 2-3 hours

### 10.2 Replay Value Features 🔄 LOW
**Purpose:** Keep players engaged post-completion

- [ ] **Hard Mode**: Shield energy 50% max, all enemies have chip damage
- [ ] **No Shield Challenge**: Disable shield entirely, bragging rights
- [ ] **Perfect Run**: Must parry every attack, never block
- [ ] **Speedrun Mode**: Shield energy regens 2x faster
- [ ] **Boss Rush**: Fight all bosses with limited shield energy

**Priority:** LOW - For dedicated fans
**Estimated Time:** 4-6 hours

### 10.3 Final QA Pass ✅ CRITICAL
**Purpose:** Zero critical bugs at launch

- [ ] Full playthrough without shield bugs
- [ ] Full playthrough using only shield (no attacks)
- [ ] Full playthrough never using shield
- [ ] Test all 32 levels for shield balance
- [ ] Test all 4 phases for shield scaling
- [ ] Test all 9 enemies for shield interactions
- [ ] Test all boss fights for shield viability
- [ ] Load test (100 parries in quick succession)
- [ ] Stress test (10 enemies attacking simultaneously)

**Priority:** CRITICAL - Launch quality
**Estimated Time:** 8-12 hours

---

## 📊 SUMMARY: TASK PRIORITIZATION

### Immediate (Before Next Playtest):
1. ⚡ Chip damage system (3h)
2. 📈 Playtesting data collection (2h setup)
3. 📖 Basic tutorial integration (5h)
4. 🐛 Edge case testing (4h)

**Total: ~14 hours**

### Short-Term (Next 2 Weeks):
1. 💪 Shield stamina system (5h)
2. 🗡️ Weapon special attacks (8h)
3. 🔊 Shield audio system (5h)
4. 🎨 Block/parry particle effects (6h)
5. 🎚️ Phase-specific balance tuning (8h)

**Total: ~32 hours**

### Medium-Term (Before Launch):
1. 📊 Full playtesting campaign (10h)
2. 🎨 Shield visual states (5h)
3. ⚡ Performance optimization (5h)
4. ♿ Accessibility features (5h)
5. 📚 Developer documentation (4h)
6. ✅ Final QA pass (10h)

**Total: ~39 hours**

### Long-Term (Post-Launch / Optional):
1. 🛡️ Shield upgrade system (10h)
2. 🎁 Enemy-specific parry rewards (7h)
3. 🥋 Advanced parry techniques (8h)
4. 🏆 Achievements (3h)
5. 🔄 Replay value features (6h)

**Total: ~34 hours**

---

## 🎮 ESTIMATED TOTAL TIME TO PRODUCTION QUALITY

- **Immediate + Short-Term:** ~46 hours (1-2 weeks full-time)
- **+ Medium-Term:** ~85 hours (2-3 weeks full-time)
- **+ Long-Term (optional):** ~119 hours (3-4 weeks full-time)

**Minimum Viable Launch:** 85 hours
**Complete Feature-Rich Launch:** 119 hours

---

## 🎯 SUCCESS CRITERIA

The weapon & shield system is production-ready when:

### Functional Criteria:
- [x] Shield blocks damage based on phase (70-85% reduction)
- [x] Perfect parry reflects damage with tight timing
- [x] Shield energy management creates strategic decisions
- [ ] Chip damage prevents infinite blocking
- [ ] All visual/audio feedback is polished
- [ ] Tutorial teaches mechanics in <2 minutes
- [ ] No critical bugs in 3 full playthroughs

### Feel Criteria:
- [ ] Blocking feels powerful but not invincible
- [ ] Perfect parry feels AMAZING (slow-mo + particles + audio)
- [ ] Shield break feels punishing but fair
- [ ] Energy management creates tension (not frustration)
- [ ] Players feel "I'm getting better" each run

### Balance Criteria:
- [ ] Shield usage: 50-70% of encounters
- [ ] Perfect parry rate: 5-10% beginners, 15-20% skilled
- [ ] Deaths per level scale gradually (3→8 across 32 levels)
- [ ] Survey: >80% players say deaths felt fair
- [ ] No single strategy dominates all situations

### Performance Criteria:
- [ ] Shield system <1ms CPU per frame
- [ ] 60 FPS maintained on iPhone X (oldest target)
- [ ] No memory leaks in 1-hour session
- [ ] Particle effects capped at 50 concurrent

---

**Document Status:** LIVING DOCUMENT - Update as tasks complete
**Owner:** Combat Balance Specialist (Claude)
**Review Frequency:** Weekly during development
**Last Review:** 2025-11-15
