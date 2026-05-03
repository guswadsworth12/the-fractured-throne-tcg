# The Fracture Throne — Trading Card Game

**The Fracture Throne** is a strategic Trading Card Game (TCG) built with Godot 4, featuring deep tactical gameplay through its unique Advancement system, zone-based mechanics, and eight distinct factions.

---

## World Premise

The dimensional walls were already thinning — nobody caused it, nobody could stop it. Worlds began to overlap and bleed into one another, cultures and armies finding themselves suddenly sharing space with strangers from realities they never knew existed.

Then the vision came.

Every General, every commander, every would-be ruler across every bleeding dimension saw the same thing simultaneously — a Throne. Singular. Ancient. Burning with the energy of every dimension at once. The Fracture Throne sits at the point where all realities converge, and it promises the same thing to everyone who sees it: **sovereignty over everything that remains.**

The Bleed didn't start the war. The Throne gave everyone a reason to fight it.

---

## Game Overview

The Fracture Throne is a 1v1 competitive trading card game where two players control armies led by powerful Generals. The goal: destroy your opponent's General while protecting your own.

### Key Features

- **Advancement System** — Your General evolves through 4 Ranks by stacking unit cards. Each advancement unlocks new abilities while preserving powerful Command effects from lower Ranks.
- **Zone-Based Combat** — Units occupy Frontline (attack/defend), Backline (support/boost), or Command (General only) zones, each with distinct tactical roles.
- **Shield & Energy System** — Face-down Shields protect your General from lethal damage. When broken, they convert to spendable Energy for abilities.
- **Singularity Rule** — When your deck empties, your Remnant Zone reshuffles into a new deck. No deck-out loss exists.
- **8 Unique Factions** — Each with distinct playstyles, power curves, and faction-specific keywords.

---

## Card Types

| Type | Description |
|------|-------------|
| **Unit** | Fighters and supports with zone-dependent abilities. Each unit has different capabilities in Frontline, Backline, and Command zones. |
| **Burst** | One-time use spells played from hand. Subtypes: Cast (your turn) and Reaction (responsive). |
| **Augment** | Equipment attached to units or General. Weapons (offense), Armor (defense), and Relics (unique effects). Max 2 per unit, 3 per General. |
| **Rift** | Global battlefield modifiers placed in the shared Rift Zone. Only one active at a time — playing a new Rift destroys the old. |

---

## Factions

1. **Vampiric Hell** — High Power, Low abilities. Aggressive early game.
2. **The Rot** — Low Power, High abilities. Attrition and value.
3. **Data Kingdom** — Low Frontline, High Backline. Control-oriented.
4. **The Radiant Shelter** — Balanced Mid/ Power and abilities. Versatile.
5. **The Embercrown** — High Power at baseline. Direct pressure.
6. **Voidborn Collective** — Mid Power, High abilities. Complex interactions.
7. **The Diamond League** — Variable Power. Chain abilities.
8. **The Gilded Syndicate** — Variable Power. Energy economy focus.

---

## Zone Layout

```
┌─────────────────────────────────────────────────────────────┐
│                    OPPONENT SIDE                            │
│  ┌───────────┐  ┌─────────────────┐  ┌─────────────────┐  │
│  │  COMMAND  │  │    BACKLINE     │  │    FRONTLINE    │  │
│  │   ZONE    │  │                 │  │                 │  │
│  │ [General] │  │ [U][U][U][U]    │  │ [U][U][U][U]    │  │
│  └───────────┘  └─────────────────┘  └─────────────────┘  │
├─────────────────────────────────────────────────────────────┤
│                    YOUR SIDE                                │
│  ┌─────────────────┐  ┌─────────────────┐  ┌───────────┐  │
│  │    FRONTLINE    │  │    BACKLINE     │  │  COMMAND  │  │
│  │                 │  │                 │  │   ZONE    │  │
│  │ [U][U][U][U]    │  │ [U][U][U][U]    │  │ [General] │  │
│  └─────────────────┘  └─────────────────┘  └───────────┘  │
└─────────────────────────────────────────────────────────────┘
                    SHARED RIFT ZONE: [ RIFT ]
```

**Zone Capacities:** Command (1 General), Frontline (4 units), Backline (4 units), Rift (1 card)

---

## Turn Structure

| Phase | Action |
|-------|--------|
| **0. Untap** | Untap all tapped Backline units |
| **1. Draw** | Draw 2 cards. Trigger Singularity if deck empty |
| **2. Advance** | Optionally advance your General one Rank |
| **3. Deploy** | Deploy up to 2 cards to Frontline or Backline |
| **4. Move** | Move one unit between Frontline/Backline |
| **5A. Backline Acts** | Boost or use Backline ability per unit |
| **5B. Frontline Acts** | Attack, Defend, or use Frontline ability |
| **6. End** | Discard to 7, resolve Rift effects |

---

## Win Condition

Destroy your opponent's General when they have **0 Shields remaining**.

---

## Technical Stack

- **Engine:** Godot 4 (GDScript 4)
- **Database:** PostgreSQL
- **Project Location:** `new-game-project/`
- **Card Data:** Loaded from Postgres `cards` table
- **State Management:** Autoload singletons in `src/state/`

---

## Project Structure

```
the-fractured-throne-tcg/
├── new-game-project/          # Godot 4 project
│   ├── scenes/                # UI and battlefield scenes
│   ├── src/                   # Core game logic
│   │   ├── cards/             # Card type classes (Unit, Burst, Augment, Rift)
│   │   ├── deck/              # Deck management and validation
│   │   ├── factions/          # Faction registry
│   │   ├── keywords/          # Keyword logic and handlers
│   │   └── state/             # Game state autoloads
│   │       ├── combat_resolver.gd
│   │       ├── energy_manager.gd
│   │       ├── shield_manager.gd
│   │       ├── turn_manager.gd
│   │       └── zone_manager.gd
├── db/                        # Database layer
│   └── db_manager.gd          # PostgreSQL connection singleton
├── migrations/                # SQL schema and seed data
├── tests/                     # Unit tests
├── scenes/                    # Scene definitions
├── assets/                    # Game assets
└── TheFractureThrone_Rules_v2_5.md  # Complete rules reference
```

---

## Getting Started

### Prerequisites

- Godot 4.6+
- PostgreSQL (database: `fracture_throne`, user: `rend`)

### Setup

1. Clone the repository
2. Open `new-game-project/` in Godot 4
3. Ensure PostgreSQL is running with the `fracture_throne` database
4. Run migrations in `migrations/` to set up the schema
5. Launch the project

---

## Resources

- **Full Rules:** See `TheFractureThrone_Rules_v2_5.md` for complete game rules
- **Card Sets:** Excel exports in project root (Vampiric Hell, The Rot, Data Kingdom)