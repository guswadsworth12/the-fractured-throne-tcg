import os

base_dir = '/home/rend/Projects/the-fractured-throne-tcg'

dirs = [
    '.agents',
    'migrations',
    'db',
    'src/state',
    'src/cards',
    'src/keywords',
    'src/factions',
    'src/deck',
    'scenes/battlefield/zones',
    'scenes/cards',
    'scenes/ui',
    'assets/art/cards',
    'assets/art/ui',
    'assets/fonts',
    'tests'
]

for d in dirs:
    os.makedirs(os.path.join(base_dir, d), exist_ok=True)

def to_pascal_case(snake_str):
    return "".join(x.title() for x in snake_str.split("_"))

gd_stubs = [
    ('db/db_manager.gd', True, 'Node', 'Autoload singleton for Postgres connection'),
    ('src/state/turn_manager.gd', True, 'Node', 'Autoload, manages turn phases'),
    ('src/state/zone_manager.gd', True, 'Node', 'Autoload, manages all zone state'),
    ('src/state/energy_manager.gd', True, 'Node', 'Autoload, tracks Energy zone'),
    ('src/state/combat_resolver.gd', True, 'Node', 'Autoload, resolves attacks and Power comparison'),
    ('src/state/shield_manager.gd', True, 'Node', 'Autoload, tracks Shield zone and breaks'),
    ('src/cards/card.gd', False, 'Resource', 'base Card class'),
    ('src/cards/unit_card.gd', False, 'Card', 'extends Card'),
    ('src/cards/burst_card.gd', False, 'Card', 'extends Card'),
    ('src/cards/augment_card.gd', False, 'Card', 'extends Card'),
    ('src/cards/rift_card.gd', False, 'Card', 'extends Card'),
    ('src/keywords/keyword_handler.gd', False, 'Node', 'resolves keyword effects'),
    ('src/keywords/keyword_registry.gd', False, 'Node', 'maps keyword names to handlers'),
    ('src/factions/faction_registry.gd', False, 'Node', 'faction data lookup'),
    ('src/deck/deck.gd', False, 'Node', 'deck object, shuffle, draw'),
    ('src/deck/deck_validator.gd', False, 'Node', 'validates deck against construction rules'),
    ('scenes/battlefield/battlefield.gd', False, 'Node', 'stub script'),
    ('tests/test_combat_resolver.gd', False, 'Node', 'stub: unit tests for combat resolution')
]

for filepath, is_autoload, extends_class, todo in gd_stubs:
    filename = os.path.basename(filepath)
    class_name = to_pascal_case(filename.replace('.gd', ''))
    content = f"class_name {class_name}\nextends {extends_class}\n\n# TODO: {todo}\n"
    if is_autoload:
        content += "\nfunc _ready() -> void:\n\tpass\n"
    
    with open(os.path.join(base_dir, filepath), 'w') as f:
        f.write(content)

tscn_stubs = [
    'scenes/battlefield/battlefield.tscn',
    'scenes/battlefield/zones/frontline_zone.tscn',
    'scenes/battlefield/zones/backline_zone.tscn',
    'scenes/battlefield/zones/command_zone.tscn',
    'scenes/battlefield/zones/rift_zone.tscn',
    'scenes/battlefield/zones/shield_zone.tscn',
    'scenes/battlefield/zones/energy_zone.tscn',
    'scenes/battlefield/card_slot.tscn',
    'scenes/cards/card_3d.tscn',
    'scenes/cards/card_ui.tscn',
    'scenes/ui/hud.tscn',
    'scenes/ui/hand.tscn',
    'scenes/main.tscn'
]

for filepath in tscn_stubs:
    filename = os.path.basename(filepath)
    node_name = to_pascal_case(filename.replace('.tscn', ''))
    content = f'[gd_scene format=3]\n\n[node name="{node_name}" type="Node"]\n'
    with open(os.path.join(base_dir, filepath), 'w') as f:
        f.write(content)

rules_md_content = """Game: The Fracture Throne — Godot 4 TCG
Language: GDScript 4 only. No C#.
DB: PostgreSQL local, database fracture_throne, user rend

ZONE RULES:
- frontline: max 4 units, can attack/defend/use frontline ability
- backline: max 4 units, cannot attack, boosts paired frontline slot
- command_zone: General only, 1 unit max, never a deploy target
- rift_zone: 1 Rift card max, shared between both players
- shield_zone: max 6 face-down cards, never reshuffled into Singularity
- energy_zone: face-up cards only, all available to spend
- remnant_zone: destroyed units, spent cards, unlimited

KEYWORD RULES — CRITICAL:
- Bloodlust: PERMANENT Power increase on kill. Never resets. Ever.
- Drunken Rage: TEMPORARY. Resets end of turn. Not Bloodlust.
- Void Pulse: TEMPORARY Power reduction. Resets start of opponent next turn.
- Sovereign's Reign: converts Energy to PERMANENT Power at end of turn.
- Legacy: Command abilities ONLY. Never Frontline or Backline.
- Surge: triggers ONLY when entering Energy Zone from Shield Zone.
- Reanimate: triggers on destruction. Can be permanently removed.
- Dragonfire: NOT combat. Does not trigger Bloodlust or Reanimate.
- Blitz: ignores Summon Delay. Can be granted temporarily.

BALANCE CONSTRAINTS:
- Rank 1: 200–400 Power, hard cap 400
- Rank 2: 400–650 Power, hard cap 650
- Rank 3: 600–900 Power, hard cap 900
- Rank 4: 900–1300 Power, hard cap 1300
- General hard cap: 1000 at any Rank
- Always query balance_check view before proposing new cards

TURN PHASES (in order):
0. untap → 1. draw (2 cards) → 2. advance → 3. deploy (max 2 cards) → 
4. move (1 unit) → 5a. backline acts → 5b. frontline acts → 6. end

ARCHITECTURE RULES:
- Game state: Autoload singletons in src/state/
- Card data classes: src/cards/
- Keyword logic: src/keywords/
- Scene files: scenes/ — agents may create stubs but not modify existing tscn
- Never modify project.godot directly
- Commit to git after each completed feature
- Use Planning Mode for any new game system
- Use Sequential Thinking MCP for rules interaction resolution
- Query Postgres balance_check view before creating or modifying any card

FACTIONS (8 total, Set 1 mono-faction only):
Vampiric Hell, The Rot, Data Kingdom, Radiant Shelter,
Embercrown, Voidborn Collective, Diamond League, Gilded Syndicate
"""

with open(os.path.join(base_dir, '.agents/rules.md'), 'w') as f:
    f.write(rules_md_content)

print("Project structure created successfully.")
