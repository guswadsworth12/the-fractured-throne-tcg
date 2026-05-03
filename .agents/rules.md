# Agent Rules — The Fracture Throne (Godot 4 TCG)

## Project
- **Game:** The Fracture Throne
- **Engine:** Godot 4 (GDScript 4 only — no C#)
- **Database:** PostgreSQL local, database `fracture_throne`, user `rend`
- **Project Root:** `/home/rend/Projects/the-fractured-throne-tcg/`

---

## Zone Rules
| Zone | Max Units/Cards | Notes |
|------|-----------------|-------|
| `frontline` | 4 units | Can attack, defend, use frontline ability |
| `backline` | 4 units | Cannot attack; boosts paired frontline slot |
| `command_zone` | 1 unit (General only) | Never a deploy target |
| `rift_zone` | 1 Rift card max | Shared between both players |
| `shield_zone` | 6 face-down cards | Never reshuffled into Singularity |
| `energy_zone` | unlimited face-up | All available to spend |
| `remnant_zone` | unlimited | Destroyed units, spent cards |

---

## Keyword Rules — CRITICAL
| Keyword | Type | Effect |
|---------|------|--------|
| `Bloodlust` | **PERMANENT** | Power increase on kill. Never resets. Ever. |
| `Drunken Rage` | **TEMPORARY** | Resets end of turn. NOT Bloodlust. |
| `Void Pulse` | **TEMPORARY** | Power reduction. Resets start of opponent's next turn. |
| `Sovereign's Reign` | **PERMANENT** | Converts Energy to PERMANENT Power at end of turn. |
| `Legacy` | Command ONLY | Never Frontline or Backline. |
| `Surge` | Trigger | Triggers ONLY when entering Energy Zone from Shield Zone. |
| `Reanimate` | Trigger | Triggers on destruction. Can be permanently removed. |
| `Dragonfire` | Non-combat | Does NOT trigger Bloodlust or Reanimate. |
| `Blitz` | Property | Ignores Summon Delay. Can be granted temporarily. |
| `Sentinel` | Property | Unit may both Attack and Defend in same round. |
| `Aegis` | Property | Cannot be targeted or destroyed by Burst cards. |
| `Pierce` | Property | When breaking a Shield, defender breaks one additional. |
| `Infiltrate` | Property | May attack Backline directly, bypassing Frontline. No Shield breaks. |
| `Lifesteal` | Property | When breaking Shield, move one opponent face-up Energy to your Energy Zone. |
| `Anchor` | Property | Cannot be moved by card effects. May still move voluntarily. |

---

## Balance Constraints
| Rank | Power Range | Hard Cap |
|------|-------------|----------|
| 1 | 200–400 | 400 |
| 2 | 400–650 | 650 |
| 3 | 600–900 | 900 |
| 4 | 900–1300 | 1300 |
| **General** | — | **1000 at any Rank** |

> **Always query `balance_check` view in Postgres before proposing new or modified cards.**

---

## Turn Phases (in order)
```
0. untap
1. draw (2 cards)
2. advance
3. deploy (max 2 cards)
4. move (1 unit)
5a. backline acts
5b. frontline acts
6. end
```

---

## Factions (Set 1 — mono-faction only)
1. Vampiric Hell
2. The Rot
3. Data Kingdom
4. Radiant Shelter
5. Embercrown
6. Voidborn Collective
7. Diamond League
8. Gilded Syndicate

---

## Architecture
- **Game state:** Autoload singletons in `src/state/`
- **Card data classes:** `src/cards/`
- **Keyword logic:** `src/keywords/`
- **Scene files:** `scenes/` — agents may create stubs but NOT modify existing `.tscn`
- **DB layer:** `db/db_manager.gd` — Autoload singleton for Postgres connection
- **Never modify `project.godot` directly**
- **Never commit secrets or keys to the repository**

---

## Workflow Rules
- Commit to git after each completed feature
- Use Planning Mode for any new game system
- Use Sequential Thinking MCP for rules interaction resolution
- Query Postgres `balance_check` view before creating or modifying any card