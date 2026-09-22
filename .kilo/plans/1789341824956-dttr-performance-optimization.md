# Don't Touch the Red — Performance Optimization Plan

## Context
Godot 4.7 2D survival dodging game. Current code has several hot-path inefficiencies: per-frame `queue_redraw()` on every node, expensive group lookups in tick loops, polling `get_overlapping_bodies()` instead of using signals, no object pooling, and heavy UI background drawing. Target: reduce frame time and eliminate unnecessary per-frame work.

---

## 1. Eliminate Per-Frame `queue_redraw()` Calls (Critical)

### 1a. Player.gd
- **File**: `scripts/Player.gd`
- **Problem**: `queue_redraw()` called every frame in both `_process()` (line 168) and `_physics_process()` (line 250). The `_draw()` is complex (trail circles, pulse arcs, dead arc).
- **Fix**: Track a `_dirty` flag. Set it only when trail changes, death occurs, skin changes, or pulse completes a full cycle (every ~2s). Call `queue_redraw()` from `_process()` only when `_dirty` is true. Remove `queue_redraw()` from `_physics_process()`.

### 1b. DangerZone.gd
- **File**: `scripts/DangerZone.gd`
- **Problem**: `queue_redraw()` every frame in `_physics_process()` (lines 98, 101, 106). `_draw()` does many draw calls (rects, stripes, spikes, zigzag, pinwheel, arcs).
- **Fix**: Only call `queue_redraw()` when: phase transitions (warning→active→done), size changes by >1px, activation flash is active, or moving wall position changes by >0.5px. Add a `_last_drawn_size` and `_last_drawn_phase` tracker.

### 1c. SpikeBall.gd
- **File**: `scripts/SpikeBall.gd`
- **Problem**: `queue_redraw()` every frame (lines 55, 71). `_draw()` has 8 spike polygons + glow circles.
- **Fix**: Only redraw on warning state change. Once active, the ball looks static (no pulse), so skip redraw entirely after activation.

---

## 2. Replace Polling with Signals for Collision (Critical)

### 2a. DangerZone.gd — remove `get_overlapping_bodies()` poll
- **File**: `scripts/DangerZone.gd:109`
- **Problem**: `get_overlapping_bodies()` iterates physics every frame during ACTIVE phase.
- **Fix**: Use `area_entered` / `body_entered` signal instead. Already has `body_entered` connected to `_on_body_entered` — but it only checks in `_physics_process` too. Remove the polling loop; rely solely on `body_entered` signal.

### 2b. Coin.gd and Powerup.gd — use signals, not polling
- **Files**: `scripts/Coin.gd`, `scripts/Powerup.gd`
- **Problem**: Already use `body_entered` signal but also have `_process` running every frame for bobbing.
- **Fix**: Keep body_entered signal (good). No change needed for collision.

---

## 3. Eliminate Expensive Group Lookups in Hot Paths (Critical)

### 3a. Main.gd — replace group queries with direct references
- **File**: `scripts/Main.gd`
- **Problem**: 
  - `_spawn_coin()` calls `get_tree().get_nodes_in_group("run_coins")` every spawn check (line 439) — O(n) scan.
  - `_clear_coins()` and `_clear_powerups()` use group queries.
  - `_coin_position_is_safe()` iterates `danger_manager.get_children()` + calls `is_active()` + `get_danger_rect()` + `grow()` + `has_point()` per child (lines 495-497).
- **Fix**:
  - Maintain `var _active_coins: Array = []` and `var _active_powerups: Array = []` in Main. Add/remove in `_on_coin_collected` and coin `_expire`/`_on_body_entered` callbacks.
  - Cache `danger_manager` children list or maintain a parallel array of active danger rects.
  - For `_coin_position_is_safe`, pre-compute danger rects once per frame instead of per spawn attempt.

### 3b. Main.gd — cache `current_scene` reference
- **File**: `scripts/Main.gd`
- **Problem**: `get_tree().current_scene` called multiple times per frame.
- **Fix**: Cache in a variable at game start.

---

## 4. Optimize DangerManager Pattern Fairness Check (High)

### 4a. DangerManager.gd — `_is_pattern_fair()` optimization
- **File**: `scripts/DangerManager.gd:152-176`
- **Problem**: Grid-based safe-point check (7x11 = 77 points) × hazards count, called up to 6+ times per spawn cycle. Each point checks all hazards with `grow(16).has_point()`.
- **Fix**:
  - Reduce grid resolution from 7×11 to 5×7 (35 points) — still sufficient for fairness.
  - Cache the result for one spawn cycle (store `_last_fair_check_result` and `_last_fair_check_time`, invalidate when elapsed changes enough).
  - Early-exit if player is inside any rect (already done — keep).

---

## 5. Optimize Coin and Powerup _process (Medium)

### 5a. Coin.gd — cache scene reference, reduce work
- **File**: `scripts/Coin.gd`
- **Problem**: `get_tree().current_scene` called every frame in `_process` (line 44). Magnet check does `get_node("Player")` every frame.
- **Fix**: Cache `current_scene` reference in `_ready()`. Cache player reference if magnet active.

### 5b. Powerup.gd — same optimization
- **File**: `scripts/Powerup.gd`
- **Fix**: Same as Coin — cache scene reference in `_ready()`.

---

## 6. Optimize UIManager Animated Background (Medium)

### 6a. UIManager.gd — `_AnimatedBackground`
- **File**: `scripts/UIManager.gd` (inner class at line 3201)
- **Problem**: 55 particles + 4 atmospheric circles + 8 diagonal lines + 2 scan lines + 3 rotating arcs + 2 red arcs + central pulse = ~75+ draw calls every frame. Runs even when menu is hidden.
- **Fix**:
  - Reduce particle count from 55 to 30.
  - Add `visible` check: if parent menu is hidden, set `processing = false`.
  - Consider drawing static elements (atmospheric circles) once to a `Image` and using `draw_texture_rect()` instead of redrawing every frame.

---

## 7. Object Pooling for Coins (Medium)

### 7a. Main.gd / Coin.gd — implement coin pooling
- **Problem**: Coins are `instantiate()`'d and `queue_free()`'d frequently during gameplay.
- **Fix**: Create a simple pool array in Main. Pre-instantiate 5-8 coin nodes at game start. On spawn, reuse from pool instead of instantiating. On collect/expire, reset and return to pool instead of `queue_free()`.

### 7b. Same for Powerups
- **Fix**: Pool of 2-3 powerup nodes (max 1 active at a time, so simpler).

---

## 8. Batch Config Saves (Low)

### 8a. Main.gd — debounce saves
- **File**: `scripts/Main.gd`
- **Problem**: `_save_progress()` writes config file every time coins change, skin changes, or items are used. Multiple saves per game session.
- **Fix**: Set a `_save_pending` flag and batch saves into a single `_save_if_pending()` call at end of frame or on timer.

---

## 9. Remove Dead Code and Nodes (Low)

### 9a. SpikeBall.tscn — remove unused Polygon2D
- **File**: `scenes/spike_ball.tscn`
- **Fix**: Remove the unused `Polygon2D` child node.

### 9b. Player.gd — commented-out draw code
- **File**: `scripts/Player.gd:572-650`
- **Fix**: Remove all commented-out drawing code from `_draw()`. This is dead weight in the file (not runtime, but reduces parse/load time).

### 9c. Main.tscn — remove unused AudioStreamPlayer nodes
- **File**: `scenes/Main.tscn`
- **Fix**: Verify all AudioStreamPlayers are used. Remove any unused ones (check if `resume_background_music()` / `resume_gameplay_music()` target nodes that may not exist).

---

## 10. Rendering/Display Optimizations (Low)

### 10a. Project settings — enable texture streaming
- **File**: `project.godot`
- **Fix**: Add `textures/texture_debug/stop_texture_editor=true` (minor). More importantly, ensure SVG textures are pre-imported as PNG (they already are — `.import` files exist).

### 10b. Player collision — use `KinematicBody2D`/`CharacterBody2D` collision layers properly
- **File**: `scripts/Player.gd`, `scenes/Player.tscn`
- **Fix**: Already uses CharacterBody2D correctly. No change.

### 10c. DangerZone — disable collision monitoring when done
- **File**: `scripts/DangerZone.gd`
- **Fix**: In `_finish()`, set `monitoring = false` immediately in addition to disabling collider, so `body_entered` won't fire after death state.

---

## 11. Audio Optimizations (Low)

### 11a. AudioManager — pause unused players
- **File**: `scripts/AudioManager.gd`
- **Fix**: When music is disabled, ensure all music players are stopped and `stream_paused = true`. Already partially handled — verify.

---

## Implementation Order

| Priority | Task | Impact |
|----------|------|--------|
| P0 | 1a, 1b, 1c — Redraw optimization | Highest FPS gain |
| P0 | 2a — Signal-based collision | Removes physics polling |
| P0 | 3a, 3b — Group lookup elimination | Removes O(n) scans from hot path |
| P1 | 4 — Pattern fairness optimization | Reduces spawn delay |
| P1 | 5 — Coin/Powerup caching | Minor per-frame savings |
| P1 | 7 — Object pooling | Reduces GC spikes |
| P2 | 6 — UI background optimization | Menu FPS improvement |
| P2 | 8 — Batched saves | I/O reduction |
| P3 | 9 — Dead code removal | Cleanliness |
| P3 | 10, 11 — Settings/display | Marginal gains |

---

## Validation

1. **Before/after benchmark**: Run game for 60 seconds, record FPS via Performance Monitor before and after each change.
2. **Playtest**: Verify no regression in gameplay — danger still kills player, coins still collect, powerups still work.
3. **Check redraw correctness**: After removing per-frame redraw, verify pulsing, trails, and animations still work by checking flags.
4. **Memory check**: Monitor node count — should stay stable (no leaks from pool nodes not returning).
5. **Object pool verification**: Verify pool doesn't grow unbounded; coins returned to pool after expire.
