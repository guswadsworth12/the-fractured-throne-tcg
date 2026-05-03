# Fracture Throne — Agent Rules

## Project
Godot 4 TCG. GDScript only. No C#.

## Game State — Never Invent These
- Power values: integers only, never floats
- Energy: tracked as integer (face-up card count)
- Zones: frontline (max 4), backline (max 4), command_zone (General only),
  rift_zone (1 card), shield_zone (max 6 face-down), energy_zone, remnant_zone
- Deck size: 50 cards. Opening hand: 5. Shields: top 6 of remaining 49.
- Turn phases: untap → draw → advance → deploy → move → action → end

## Keyword Rules — Critical Distinctions
- Bloodlust: PERMANENT Power increase on kill. Never resets.
- Drunken Rage: TEMPORARY Power increase. Resets end of turn.
- Sovereign's Reign: converts Energy to permanent Power at end of turn.
- Void Pulse: TEMPORARY Power reduction until start of opponent's next turn.
- Legacy: applies to Command abilities ONLY. Never Frontline or Backline.
- Blitz: unit may move and act in same turn on entry.
- Reanimate: triggers on destruction. Can be permanently removed by card effects.

## Balance Constraints
- Rank 1 Power cap: 400
- Rank 2 Power cap: 650
- Rank 3 Power cap: 900
- Rank 4 Power cap: 1300
- General hard cap: 1000 at any Rank
- Ability tax applies — see rules doc Section 10

## Architecture
- Game state: Autoload singletons in /src/state/
- Card data: Godot Resources (.tres) in /src/data/cards/
- Scenes: /scenes/ — do not modify .tscn files directly
- Factions: 8 total (Vampiric Hell, The Rot, Data Kingdom, Radiant Shelter,
  Embercrown, Voidborn Collective, Diamond League, Gilded Syndicate)

## Agent Behaviour
- Use Sequential Thinking MCP for any rules interaction resolution
- Use SQLite MCP to verify card balance before suggesting new cards
- Use Memory MCP to store any design decisions made this session
- Always use Planning Mode for new systems. Fast Mode for isolated file edits only.
- Never modify project.godot directly
- Commit to git after any completed feature, not mid-task