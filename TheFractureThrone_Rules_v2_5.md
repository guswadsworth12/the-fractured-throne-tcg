# THE FRACTURE THRONE — Rules Document v2.5
> *This document reflects all locked design decisions as of Session 16. Two rule clarifications from Session 16: (A) The General is one of the Rank 1 units already in your 50-card deck — it is chosen at the start of game and removed to the Command Zone before play begins. No card is pre-selected outside the deck during deck construction. Advance targets for Rank 2, 3, and 4 are a deck-building requirement only and are never declared or revealed at game start. (B) Keyword Glossary expanded to cover all eight factions — Embercrown, Voidborn Collective, Diamond League, and Gilded Syndicate keywords added; Void Lock and House Cut promoted to the Universal section as they appear across multiple factions.*
> *This document reflects all locked design decisions as of Session 15. Six balance changes from the DK vs Rot playtest report: (1) Kaijuggernaut — one-defender clause removed. Pierce and Anchor alone define its threat. (2) Vexserpent — Power 700→650; Backline hand reveal gated [ENERGY: 1]; Command converted to [ENERGY: 2] activated faction-wide Power reduction. (3) Carrion Phoenix — return-to-hand gated [ENERGY: 1]; Command dead text replaced — Friendly units with Blitz gain +100 Power on entry. (4) Hollow Crown — Power 350→450; Command [LEGACY] Enshroud host anthem added; Legacy keyword added. (5) Spore-Drifter — Backline extended to top 2 cards; Surge reworked to mill 3. (6) Overwhelming Tide — units return to Frontline with Blitz, overflow to Backline; Reanimate consumed permanently on return. Death Rattle unchanged — Signal Spike interaction ruled intentional counter-play.*
> *Three universal rule clarifications from Session 15: (A) Legacy applies exclusively to Command abilities — Frontline and Backline abilities are zone-dependent and never persist when a card is buried. (B) Blitz may be granted temporarily by card effects — granted Blitz functions identically to printed Blitz for the duration. (C) Reanimate may be permanently removed by card effects — units that lose Reanimate this way do not trigger it on their next destruction. Simultaneous multi-unit zone entry rule added: Frontline fills first, overflow to Backline, excess units that cannot fit are not placed.*
> *Changes from v1.1 are marked with ◆◆. Changes from v1.2 are marked with ◆◆◆. Changes from v1.3 are marked with ◆◆◆◆. Changes from v1.4 are marked with ◆◆◆◆◆. Changes from v1.5 are marked with ◆◆◆◆◆◆. Changes from v1.6 are marked with ◆◆◆◆◆◆◆. Changes from v1.7 are marked with ◆◆◆◆◆◆◆◆. Changes from v1.8 are marked with ◆◆◆◆◆◆◆◆◆. Changes from v1.9 are marked with ◆◆◆◆◆◆◆◆◆◆. Changes from v2.0 are marked with ◆◆◆◆◆◆◆◆◆◆◆. Changes from v2.1 are marked with ◆◆◆◆◆◆◆◆◆◆◆◆. Changes from v2.2 are marked with ◆◆◆◆◆◆◆◆◆◆◆◆◆. Changes from v2.3 are marked with ◆◆◆◆◆◆◆◆◆◆◆◆◆◆. Changes from v2.4 are marked with ◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆*

---

## TABLE OF CONTENTS
1. World Premise
2. Win & Loss Conditions
3. Card Types
4. Card Anatomy
5. The Battlefield
6. The Advancement System
7. The Shield & Energy System
8. Combat & Power
9. Turn Structure
10. Balance Math Reference
11. Keyword Glossary
12. Faction Roster
13. Deck Construction Rules

---

## 1. WORLD PREMISE

### The Fracture Bleed

The dimensional walls were already thinning — nobody caused it, nobody could stop it. Worlds began to overlap and bleed into one another, cultures and armies finding themselves suddenly sharing space with strangers from realities they never knew existed.

Then the vision came.

Every General, every commander, every would-be ruler across every bleeding dimension saw the same thing simultaneously — a Throne. Singular. Ancient. Burning with the energy of every dimension at once. The Fracture Throne sits at the point where all realities converge, and it promises the same thing to everyone who sees it: **sovereignty over everything that remains.**

The Bleed didn't start the war. The Throne gave everyone a reason to fight it.

---

## 2. WIN & LOSS CONDITIONS

| Condition | Result |
|---|---|
| Opponent's General is destroyed with 0 Shields remaining | You **win** |
| Your General is destroyed with 0 Shields remaining | You **lose** |

### The Singularity — No Deck Out
When your deck is empty, shuffle your entire Remnant Zone into a new deck and continue playing. This is called the **Singularity.**

- Shields are **never** reshuffled into the Singularity — they remain a permanent separate zone
- ◆◆◆◆◆◆◆ Spent Energy cards that have moved to the Remnant Zone **are** reshuffled into the Singularity and re-enter the game as normal cards
- The cost of triggering the Singularity is informational — your opponent has now seen every card in your deck and knows exactly what remains

> ◆◆◆◆◆◆◆◆ If your deck empties mid-draw, draw all remaining cards in the deck first, then trigger the Singularity by shuffling your Remnant Zone into a new deck, then continue drawing any cards still owed for that turn.

---

## 3. CARD TYPES

◆◆◆◆◆ There are exactly **four card types** in The Fracture Throne: Units, Bursts, Augments, and Rifts.

### 3.1 — Units
Units are fighters, commanders, and supports. Every Unit card has up to three ability boxes — one per zone. A unit's active ability is determined solely by which zone it currently occupies.

- A **dash (—)** in a zone means no ability in that zone
- The unit is still present and functional without an ability
- When a unit moves zones its active ability changes immediately

### 3.2 — Bursts
Burst cards are one-time use cards played from hand. They resolve immediately and are sent to the Remnant Zone after resolution. Bursts are never deployed to the field.

Bursts are divided into two subtypes printed on the type line:

| Subtype | When It Can Be Played |
|---|---|
| **Burst — Cast** | During your own turn, within the Burst & Augment window (Move Phase through end of Action Phase). One per turn. |
| **Burst — Reaction** | Either player's turn, in response to a defined trigger event. One per triggering event. No chaining. |

### 3.3 — Augments
Augments are equipment cards attached to a unit or General when played. Their effect persists as long as their host remains on the field.

- Augments are **destroyed** when their host unit is destroyed — they never transfer
- ◆◆◆◆◆◆◆◆◆◆ When an Augment is destroyed, it goes to the **original owner's** Remnant Zone. For Enshrouded cards pulled from an opponent's Remnant Zone, this means they return to the opponent's Remnant Zone upon destruction — they cannot be permanently captured
- Augments **move with their host** when that unit changes zones
- A unit may hold up to **2 Augments** simultaneously
- The General may hold up to **3 Augments** simultaneously

Augments have three subtypes:

| Subtype | Focus |
|---|---|
| **Augment — Weapon** | Offensive Power effects |
| **Augment — Armor** | Defensive and survivability effects |
| **Augment — Relic** | Unique ability grants and special effects |

### ◆ 3.4 — Rifts
Rifts are global field cards placed in the shared Rift Zone. They modify the battlefield for both players simultaneously.

- Only **one Rift** may be active at a time
- Playing a new Rift **destroys** the current one — the previous Rift goes to the Remnant Zone
- Rift effects apply to **both players** unless the card states otherwise
- End-of-turn Rift effects resolve during **Phase 6**

---

## 4. CARD ANATOMY

### Unit Card
┌─────────────────────────────────┐
│ NAME                [RANK COST] │
│ Faction — Unit — Subtype        │
│─────────────────────────────────│
│           [ART]                 │
│─────────────────────────────────│
│            POWER: ###           │
│─────────────────────────────────│
│ ⚔ FRONTLINE: [Ability or —]    │
│ ◈ BACKLINE:  [Ability or —]    │
│ ★ COMMAND:   [Ability or —]    │
│─────────────────────────────────│
│ "Flavor text"                   │
└─────────────────────────────────┘

### Burst Card
┌─────────────────────────────────┐
│ NAME                [RANK COST] │
│ Faction — Augment — Weapon      │
│            OR Armor / Relic     │
│─────────────────────────────────│
│           [ART]                 │
│─────────────────────────────────│
│ [Persistent Effect]             │
│─────────────────────────────────│
│ "Flavor text"                   │
└─────────────────────────────────┘
### ◆ Rift Card
┌─────────────────────────────────┐
│ NAME                [RANK COST] │
│ Faction — Rift                  │
│─────────────────────────────────│
│           [ART]                 │
│─────────────────────────────────│
│ [Global Effect — both players]  │
│─────────────────────────────────│
│ "Flavor text"                   │
└─────────────────────────────────┘

### Type Line Reference
[Faction] — Unit — [Subtype]
[Faction] — Burst — Cast
[Faction] — Burst — Reaction
[Faction] — Augment — Weapon
[Faction] — Augment — Armor
[Faction] — Augment — Relic
[Faction] — Rift

---

## 5. THE BATTLEFIELD

### Zone Layout
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
└─────────────────────────────────────────────────────────────┘◆ SHARED RIFT ZONE: [ RIFT ] — centered between both sides

### Zone Definitions

#### Command Zone
- Holds your **General exclusively** — no other units may enter
- The General **cannot attack** and does not participate in combat directly
- The General may use **Command abilities** printed in their Command box
- Only accessible through the **Advancement system**
- The General can only be targeted when **Breakthrough** conditions are met

#### Backline Zone
- Holds up to **4 units**
- Units here **cannot attack**
- Units here **cannot be targeted** by standard attacks
- Backline units pair directly with the Frontline slot immediately in front of them
- Each Backline unit may choose one action per turn — Boost or use Backline ability (not both)

#### Frontline Zone
- Holds up to **4 units**
- Units here may **Attack, Defend, or use their Frontline ability** — one action per turn
- Units here are the only valid standard attack targets while they remain

#### ◆ Rift Zone
- A shared zone visible and accessible to both players
- Holds **one active Rift card** at a time
- Playing a new Rift destroys the current one
- Rift effects apply to **both players** unless stated otherwise

#### Shield Zone
- Holds up to **6 face-down Shield cards**
- Cards here were placed from the top of your deck at game start
- When a Shield breaks it moves to the **Energy Zone** face-up — it never returns to the Shield Zone through normal means
- ◆◆◆◆◆ Some abilities may add new face-down Shields mid-game. The Shield Zone cannot exceed 6 face-down Shields at any time

#### Energy Zone
- ◆◆◆◆◆◆◆ A zone adjacent to the Shield Zone containing all available Energy
- Holds only **face-up cards** — all Energy here is available to spend
- When a card is spent as Energy it moves immediately to the **Remnant Zone** and is treated as a normal card there

SHIELD ZONE              ENERGY ZONE
[ S ][ S ][ S ][ S ]  |  [ E↑ ][ E↑ ][ E↑ ]
Face-down shields    |  All face-up, all available

#### ◆◆◆◆◆◆ Remnant Zone
- The universal zone where destroyed units, spent Bursts, destroyed Augments, destroyed Rifts, discarded cards, and spent Energy cards are placed
- Reshuffled into the deck when the Singularity triggers
- Shields are **never** part of the Remnant Zone
- Both players maintain their own Remnant Zone
- The Remnant Zone is a public zone — both players may look at its contents at any time

### Zone Capacity

| Zone | Capacity | Occupants |
|---|---|---|
| Command Zone | 1 | General only |
| Backline Zone | 4 | Any non-General unit |
| Frontline Zone | 4 | Any non-General unit |
| Rift Zone | 1 | One Rift card |
| Remnant Zone | Unlimited | Destroyed units, spent Bursts, destroyed Augments, destroyed Rifts, discarded cards, spent Energy cards |

◆◆◆◆◆◆◆◆◆◆◆◆◆◆ **Simultaneous Multi-Unit Entry:** When a card effect causes multiple units to enter the field at the same time, the controlling player fills available Frontline slots first, then fills available Backline slots with any remaining units. If both zones are full and units still cannot be placed, those excess units cannot enter — they remain in the zone they came from. This rule applies to any effect that returns or deploys multiple units simultaneously, including **Overwhelming Tide**.

### Positional Pairing

Backline slots pair directly with the Frontline slot in front of them:

FRONTLINE  [ F1 ]  [ F2 ]  [ F3 ]  [ F4 ]
↑       ↑       ↑       ↑
BACKLINE   [ B1 ]  [ B2 ]  [ B3 ]  [ B4 ]

- B1 boosts F1 only. B2 boosts F2 only. And so on.
- If the Frontline slot in front of a Backline unit is **empty**, that Backline unit cannot Boost — it may only use its Backline ability or do nothing.

### Movement Between Zones

Once per turn during the Move Phase a player may move one unit:

| Movement | Rule |
|---|---|
| Backline → Frontline | Always legal |
| Frontline → Backline | Legal — unit cannot act in Action Phase this turn |
| Any Zone → Command Zone | Never legal |
| Command Zone → Any Zone | Never legal |

A unit that retreats to the Backline is **exhausted** for that Action Phase — it cannot Boost or use its Backline ability.

◆◆◆◆◆◆◆◆◆◆ A unit deployed this turn cannot be moved during Phase 4 of the same turn. Movement is only available to units that were already on the field at the start of your turn. This applies regardless of which zone the unit was deployed to.

---

## 6. THE ADVANCEMENT SYSTEM

### The General
Any Unit card may be designated as your General before the game begins. The chosen General is placed in the Command Zone at game start.

### Advancing Your General
During your Advance Phase you may place a new unit card on top of your current General stack. This is called **Advancing.**

**To Advance your General the new card must be:**
- The **same Faction** as your current General
- Exactly **Rank + 1** above your current General's Rank

The new card is placed **face-up on top** of the General stack. The top card is always the active General. Cards beneath are inactive but visible to both players.

[RANK 3 CARD]     ← Active General
    [RANK 2 CARD]     ← Advancement
    [RANK 1 CARD]     ← Starting form (stack floor)
    [DEVOURED CARD]   ← Below the stack floor
    [DEVOURED CARD]   ← Below the stack floor
 ═══════════════════
      COMMAND ZONE
      
*Devoured cards below the stack floor may have gaps if cards have been deployed via Fragment. Remaining Devoured cards continue providing their Command ability normally.*

### Advancement Rules
- Advancement is **optional** — you are never forced to Advance
- You may only Advance **once per turn**
- The card used to Advance is removed from your hand and becomes part of the General stack
- Ranks may **not be skipped** — you must Advance through each Rank in order
- The maximum General Rank is **Rank 4**

### The Unit vs. General Decision
Every Rank 2, 3, and 4 card in your deck serves double duty:

| Use Case | Consequence |
|---|---|
| **Deployed as a Unit** | Enters a zone of your choice, fights for you |
| **Used to Advance** | Powers up your General — that card is locked beneath them |

### Legacy Keyword
Some cards have the **[LEGACY]** keyword. A Legacy ability remains active even when that card is buried beneath a higher-Ranked General in the Advancement stack.

◆◆◆◆◆◆◆◆◆◆◆◆◆◆ **Legacy applies exclusively to Command abilities.** Frontline and Backline abilities are zone-dependent — they are only active when a card occupies that zone as the active General. A buried card has no zone presence. No Frontline or Backline ability can persist via Legacy under any circumstance, regardless of how the card text is written. Only Command zone abilities may carry the Legacy keyword.

### ◆ Fragment Keyword
Some cards have the **[FRAGMENT]** keyword. A Fragment card may be deployed directly from the General's Advancement stack to the Frontline or Backline during the Deploy Phase.

- The General continues using the card above in the stack as normal
- The stack is not otherwise disrupted — cards above and below remain
- If the Fragmented card had a **[LEGACY]** ability while buried, that ability is **lost permanently** the moment it leaves the stack
- Fragment has **no usage limit** — it may be used whenever the card is legally in the Advancement stack
- ◆◆◆◆◆◆ Using Fragment occurs during the Deploy Phase and does **not** consume your Advance for the turn. You may Advance normally in Phase 2 and use Fragment in Phase 3 of the same turn
- ◆◆◆◆◆◆◆◆ A unit that enters the Frontline via Fragment **ignores Summon Delay** and may attack the turn it arrives. Fragment is a special action, not a standard deployment — the unit leaps directly from the stack into combat
- ◆◆◆◆◆◆◆◆◆ When a unit enters the Frontline or Backline via Fragment, a **Burst — Reaction** window opens before the unit enters its zone, identical to the standard deployment Reaction window
- ◆◆◆◆◆◆◆◆◆◆ A unit deployed via Fragment **cannot be moved** in Phase 4 of the same turn, consistent with the standard deployment restriction
- ◆◆◆◆◆◆◆◆◆◆◆◆ Fragment **may target Devoured cards** sitting below the Rank 1 starting card. When a Devoured card is deployed via Fragment, it immediately loses its Devoured status and its Command ability deactivates permanently. The card enters the field as a normal unit subject to all standard Fragment rules. If subsequently destroyed, it enters the Remnant Zone as a normal card and may be Devoured again in a future turn as a fresh action

### ◆ Ascendant Keyword
Some Generals have the **[ASCENDANT]** keyword.

> ◆◆◆◆◆ While this unit is in the Command Zone as your active General, all Command abilities on every card in your Advancement stack are active, regardless of whether those cards have the [LEGACY] keyword.

| Without Ascendant | With Ascendant |
|---|---|
| Only Legacy-keyworded buried cards contribute their Command ability | All buried cards' Command abilities are active |
| Non-Legacy buried cards are dormant | No card in the stack is dormant |

### Dimensional Retreat
Once per game, if your current General would be destroyed and you have no Shields remaining, you may activate **Dimensional Retreat:**

- Remove the top card of the General stack (the destroyed General) — it goes to the Remnant Zone
- The next card placed via standard Advancement becomes your active General at full Power
- Dimensional Retreat only moves through cards placed via standard Advancement — Devoured cards sit below the Rank 1 starting card and are never reached
- ◆◆◆◆◆◆◆ If your active General is Rank 1 and no Advancement cards exist above it in the stack, Dimensional Retreat **cannot be activated** — Devoured cards below the stack floor do not satisfy the eligibility requirement. You lose. Generals at Rank 1 cannot use Dimensional Retreat under any circumstances
- ◆◆◆◆◆◆◆◆◆◆ If the card that would become the active General is currently on the field as a Fragmented unit, it is immediately **recalled** from the field to the Command Zone and becomes the active General. It does not go to the Remnant Zone. Any Augments attached to it are destroyed and returned to their original owners' Remnant Zones normally

---

## 7. THE SHIELD & ENERGY SYSTEM

### Setup
At the start of the game place the **top 6 cards** of your deck face-down in your Shield Zone. These are your Shields.

### Taking Damage — Breaking Shields
When your General takes damage that would destroy them:

1. Your General **survives**
2. Move the leftmost face-down Shield from the Shield Zone to the **Energy Zone** face-up
3. Any **[SURGE]** ability on that card triggers immediately
4. That card now sits face-up in the Energy Zone as available Energy

When you have **no face-down Shields remaining** your General can be destroyed normally — this ends the game.

### ◆◆◆◆◆ Energy Sources
Face-up cards enter the Energy Zone through multiple means:

- **Shield breaks** — the primary source. Each broken Shield enters the Energy Zone face-up
- **Card abilities** — some abilities grant face-up Energy directly
- **Keywords** — effects such as **House Cut**, **Blood Tithe**, and **Lifesteal** add face-up Energy through gameplay triggers

Regardless of source, all face-up Energy in the Energy Zone functions identically and follows the same spend rules.

### The Energy Zone
◆◆◆◆◆◆◆ The Energy Zone contains only face-up cards. All cards present are available to spend.

**Spending Energy:**
To activate an **[ENERGY: X]** ability, take X face-up Energy cards from the Energy Zone and move them to your Remnant Zone. Those cards are now normal cards in the Remnant Zone — they may be reshuffled by the Singularity and drawn again in future turns.

**Key Rules:**
- Energy may be spent at any time it is legal to activate an ability
- Spent Energy cards go directly to the Remnant Zone and are immediately treated as normal cards

### ◆◆◆◆◆◆ Shield Effect Sequencing
When multiple Shield effects would resolve simultaneously — such as a Shield break and a Shield restoration triggered by the same attack — they resolve in the following order:

1. **Shield breaks resolve first**
2. **Shield restoration effects resolve second**

This means restoration effects always check the Shield Zone state *after* any breaks are confirmed. The 6-Shield cap is checked at the moment of restoration, not before the break.

◆◆◆◆◆◆◆◆◆◆ Triggered abilities — such as **Lifesteal** and **Blood Tithe** — that fire on a Shield break resolve based on the **event of the break**, not the final state of the Shield Zone after restoration. A Shield that breaks and is subsequently restored in the same sequence still triggers these effects normally.

### Energy Zone States

| Card State | Zone | Function |
|---|---|---|
| Face-down, unbroken | Shield Zone | Protects General from destruction |
| Face-up | Energy Zone | Available to spend — moved to Remnant Zone when spent |

### Loss Condition Interaction
- General takes lethal damage + face-down Shield exists → Shield breaks, General survives
- General takes lethal damage + NO face-down Shields → General is destroyed, you lose
- Face-up Energy exists but no face-down Shields → Energy cannot block damage — one hit ends the game

---

## 8. COMBAT & POWER

### The One Number System
Every unit has exactly one stat — **Power**. All combat resolves through Power comparison.

### ◆◆◆◆◆◆◆◆◆◆ Zone Ability Use Cap
A single zone ability may never be activated more than **twice per turn** regardless of how many modifiers, keywords, or Augments would allow additional uses. Sporulate and Overcharge each grant one additional use of a zone ability — they do not stack with each other or with any other effect that would grant further uses.

### ◆◆◆◆◆ Summon Delay
Units cannot attack the turn they are deployed to the Frontline. A unit deployed directly to the Frontline must wait until your next turn before it may declare an attack. It may still Defend, use its Frontline ability, and be targeted by enemy effects on the turn it arrives.

Units deployed to the Backline are unaffected — Summon Delay only applies when entering the Frontline.

**Blitz** and **Fragment** both ignore this restriction entirely.

### Backline Boost
During the Action Phase a Backline unit may **tap** (rotate 90°) to Boost the Frontline unit directly in front of it at the moment that unit declares an attack.

- The Boost is declared when the paired Frontline unit declares its attack — before defenders are chosen
- The boosted unit's Power **increases by the full Power** of the tapping Backline unit for that attack
- ◆◆◆◆◆◆◆◆◆◆◆ If the tapping Backline unit has **Uplink**, its Boost contribution is increased by the Uplink value — a 650 Power unit with Uplink +100 contributes 750 total Power to the Boost
- A Backline unit that taps to Boost **cannot use its Backline ability** this turn
- Boosts apply only to the unit directly in front — no targeting other slots
- If the Frontline slot in front is empty, the Backline unit cannot Boost

TOTAL ATTACK POWER = Frontline Unit Power + Backline Boost (if used)
BACKLINE BOOST     = Backline Unit Power + Uplink Value (if any)

### Combat Resolution — Step by Step

**Step 1 — Declare Attacker**
The attacking player chooses one Frontline unit to attack. That unit enters **Attack Stance** and cannot Defend this round. Units affected by Summon Delay may not be declared as attackers.

**Step 2 — Declare Boost (Optional)**
◆◆◆◆◆ The attacking player may tap the Backline unit directly behind the attacker to add its full Power to this attack. The tap must occur at this step — a Backline unit cannot be tapped to Boost after defenders are declared.

**Step 3 — Declare Defenders**
The defending player chooses **any number** of their Frontline units to defend. There is no limit. All chosen defenders are committed to the outcome.

**Step 4 — Resolve**

### Combat Resolution — Step by Step

**Step 1 — Declare Attacker**
The attacking player chooses one Frontline unit to attack. That unit enters **Attack Stance** and cannot Defend this round. Units affected by Summon Delay may not be declared as attackers.

**Step 2 — Declare Boost (Optional)**
◆◆◆◆◆ The attacking player may tap the Backline unit directly behind the attacker to add its full Power to this attack. The tap must occur at this step — a Backline unit cannot be tapped to Boost after defenders are declared.

**Step 3 — Declare Defenders**
The defending player chooses **any number** of their Frontline units to defend. There is no limit. All chosen defenders are committed to the outcome.

**Step 4 — Resolve**### Combat Resolution — Step by Step

**Step 1 — Declare Attacker**
The attacking player chooses one Frontline unit to attack. That unit enters **Attack Stance** and cannot Defend this round. Units affected by Summon Delay may not be declared as attackers.

**Step 2 — Declare Boost (Optional)**
◆◆◆◆◆ The attacking player may tap the Backline unit directly behind the attacker to add its full Power to this attack. The tap must occur at this step — a Backline unit cannot be tapped to Boost after defenders are declared.

**Step 3 — Declare Defenders**
The defending player chooses **any number** of their Frontline units to defend. There is no limit. All chosen defenders are committed to the outcome.

**Step 4 — Resolve**

TOTAL ATTACK POWER vs TOTAL DEFENSE POWERAttack Power > Defense Power:
→ All Defenders DESTROYED
→ One Shield broken on defending player
→ Attacker SURVIVESAttack Power ≤ Defense Power:
→ All Defenders SURVIVE
→ Attacker DESTROYED
→ No Shield brokenChoose Zero Defenders:
→ One Shield broken automatically
→ No units destroyed on either side
→ Attacker survives

### ◆ Interceptor — Emergency Defense
A unit with the **[INTERCEPTOR]** keyword may intercept any attack targeting the General or a Frontline unit from the Backline or directly from hand.

- The Interceptor is **destroyed regardless of combat outcome** — this is an exception to the standard defender survival rule
- Combat still resolves normally — Interceptor Power is compared against attacker Power. If the attacker's Power is less than or equal to the Interceptor's Power, the attacker is destroyed
- When intercepting **from hand**, the unit is deployed directly to the field and immediately destroyed after resolution
- Deploying an Interceptor from hand **counts as one of your two deployments** for that turn
- ◆◆◆◆◆◆ A full Frontline does **not** prevent an Interceptor from hand — Interceptors bypass the slot limit because they never permanently occupy a zone. They are deployed, resolve, and are destroyed in the same action

### Breakthrough — Attacking the General
The defending player's General is exposed when:

IS THE GENERAL EXPOSED?Are there units in the Frontline?
├── YES — Are ALL of them in Attack Stance this round?
│   ├── YES → General is EXPOSED
│   └── NO  → At least one Defender remains. General is PROTECTED.
└── NO  → Frontline is empty. General is EXPOSED.
Backline units do NOT protect the General.

When the General is exposed enemy Frontline units may attack them directly. The defending player **cannot use Backline units to defend** during Breakthrough — only Interceptors may respond.

◆◆◆◆◆◆◆◆◆ The General's exposure status is evaluated at the moment each attack is declared in Phase 5B. Units that entered the Frontline earlier in the same turn — including via Fragment or standard deployment — are valid defenders and protect the General normally.

### Interception During Breakthrough

ATTACKER COUNT vs DEFENDER COUNTEqual or fewer attackers than defenders:
→ All attackers intercepted. General safe.
→ All Interceptors destroyed.More attackers than defenders:
→ Interceptors resolve one-for-one.
→ All Interceptors destroyed.
→ Excess unblocked attackers hit General.
→ Each hit breaks one Shield.

### General Power
The General has a Power value used for abilities and scaling only. The General never participates directly in attack or defense combat.

---

## 9. TURN STRUCTURE

### Full Turn Sequence

┌─────────────────────────────────────────────────────┐
│                   YOUR TURN                         │
│                                                     │
│  0. UNTAP PHASE                                     │
│     └── Untap all tapped Backline units             │
│                                                     │
│  1. DRAW PHASE                                      │
│     └── Draw 2 cards. Trigger Singularity if needed │
│                                                     │
│  2. ADVANCE PHASE                                   │
│     └── Optionally Advance your General one Rank    │
│         (occurs after Untap and Draw are resolved)  │
│                                                     │
│  3. DEPLOY PHASE                                    │
│     └── Deploy up to 2 cards to any legal zone      │
│                                                     │
│  ══ BURST — CAST & AUGMENT WINDOW OPENS ══          │
│                                                     │
│  4. MOVE PHASE                                      │
│     └── Move one unit between zones                 │
│         (not available to units deployed this turn) │
│                                                     │
│  5. ACTION PHASE                                    │
│     ├── 5A. Backline Units Act                      │
│     │       └── Boost (on attack) or Backline ability│
│     └── 5B. Frontline Units Act                     │
│             └── Attack, Defend, or use ability      │
│                                                     │
│  ══ BURST — CAST & AUGMENT WINDOW CLOSES ══         │
│                                                     │
│  6. END PHASE                                       │
│     ├── Discard to 7 card hand limit                │
│     └── Resolve end-of-turn Rift effects            │
│                                                     │
└─────────────────────────────────────────────────────┘

### Phase Descriptions

**Phase 0 — Untap**
Untap all tapped Backline units by rotating them upright. This happens before anything else. Units remain tapped during your opponent's entire turn — a tapped Backline unit cannot respond to any Reaction windows during the opponent's turn. Only untapped Backline units may use Reaction-triggered Backline abilities.

**Phase 1 — Draw**
◆◆◆◆◆◆◆◆ Draw 2 cards from your deck. If your deck empties mid-draw, draw all remaining cards in the deck first, then trigger the Singularity by shuffling your Remnant Zone into a new deck, then continue drawing any cards still owed for that turn. Shields are never drawn from directly.

**Phase 2 — Advance**
◆◆◆◆◆◆ The Advance Phase occurs after the Untap and Draw Phases are fully resolved. You may not Advance before drawing your cards for the turn. You may Advance your General once — place a legal Advance card from your hand on top of the General stack. Optional — never mandatory.

**Phase 3 — Deploy**
◆◆◆◆◆ Deploy up to 2 cards from your hand. Each card must have a Rank Cost equal to or less than your General's current Rank. Choose the destination zone freely — Frontline or Backline. The Command Zone is never a legal deploy destination. Only the General may occupy it, and only through the Advancement system.

- **Augments** are deployed by attaching them to a unit already on the field
- **Rifts** are deployed to the shared Rift Zone — the previous Rift is destroyed
- **Fragment** deployments from the Advancement stack occur during this phase, do not consume your Advance for the turn, ignore Summon Delay, open a Burst — Reaction window before the unit enters its zone, and cannot be moved in Phase 4 of the same turn
- ◆◆◆◆◆◆ **Devour** activates during this phase and does not consume your Advance for the turn. Devour does **not** open a Burst — Reaction window — it is an internal sacrifice action, not a field deployment

**Phase 4 — Move**
Move one unit between Frontline and Backline. A unit that retreats to the Backline is exhausted and cannot act in Phase 5.

◆◆◆◆◆◆◆◆◆◆ Units deployed this turn — whether from hand or via Fragment — may **not** be moved in Phase 4. Only units already on the field at the start of your turn are eligible for movement.

**Phase 5A — Backline Acts**
◆◆◆◆◆ Each untapped Backline unit chooses one:
- **Tap to Boost** — when the Frontline unit directly in front declares an attack, tap this unit to add its full Power to that attack. The tap occurs at the moment of attack declaration in Phase 5B, before defenders are chosen
- **Use Backline Ability** — resolve the ability in the Backline box
- **Do Nothing** — unit remains untapped

**Phase 5B — Frontline Acts**
Each Frontline unit chooses one:
- **Attack** — declare a target, optionally trigger Boost from paired Backline unit, opponent declares defenders, resolve combat
- **Defend** — hold position, available to intercept
- **Use Frontline Ability** — resolve ability, unit defaults to Defend Stance

Multiple attackers resolve one at a time in the attacking player's chosen order.

**Phase 6 — End**
1. Discard down to 7 cards if over hand limit — excess cards go to the Remnant Zone
2. Resolve any end-of-turn Rift effects
3. Pass turn to opponent

### Burst — Reaction Timing Windows
Burst — Reaction cards may be played by either player at these moments:

| Trigger | Window |
|---|---|
| An attack is declared | Before defenders are chosen |
| Defenders are declared | Before Power comparison resolves |
| A Backline ability activates | Before it resolves |
| A Cast Burst is played | Before it resolves |
| A unit is deployed or enters a zone via Fragment | Before it enters its zone |

One Reaction per trigger. Reactions cannot be chained to the same event.

> ◆◆◆◆◆◆◆◆◆ Devour does not open a Burst — Reaction window. It is an internal sacrifice action and resolves without opponent response.

> ◆◆◆◆◆◆◆◆◆◆◆◆◆◆ **Death Rattle ruling:** A Burst — Reaction card whose trigger condition is "a zone ability activates" (such as Signal Spike) may legally target an ability activated via Death Rattle, provided the activated ability matches the Reaction's trigger condition. Death Rattle grants the use of a zone ability but does not grant that ability immunity from negation. This interaction is intentional counter-play. A Death Rattle activation on a Frontline ability cannot be targeted by Signal Spike, since Signal Spike specifically triggers on Backline ability activations.

### Burst — Cast & Augment Window
Burst — Cast cards and Augments may be played at any point during Phases 4 and 5. Limited to one Burst — Cast and one Augment per turn regardless of timing.

### First Turn Rule
The player going first **skips their Draw Phase on Turn 1 only.**

### Phase Reference Table

| Phase | Action | Optional? |
|---|---|---|
| **0. Untap** | Untap all tapped Backline units | No |
| **1. Draw** | Draw 2 cards. Draw remaining, then Singularity, then continue if deck empties mid-draw | No |
| **2. Advance** | Advance General one Rank — after Untap and Draw only | Yes |
| **3. Deploy** | Play up to 2 cards to Frontline or Backline | Yes |
| **4. Move** | Move one unit between zones — not available to units deployed this turn | Yes |
| **5A. Backline Acts** | Boost on paired attack or Backline ability per unit | Yes per unit |
| **5B. Frontline Acts** | Attack, Defend, or Frontline ability per unit | Yes per unit |
| **6. End** | Discard to hand limit. Rift effects | No |

---

## 10. BALANCE MATH REFERENCE

### Power Curve by Rank

| Rank | Baseline Power | Range | Hard Cap |
|---|---|---|---|
| **Rank 1** | 300 | 200 — 400 | 400 |
| **Rank 2** | 500 | 400 — 650 | 650 |
| **Rank 3** | 750 | 600 — 900 | 900 |
| **Rank 4** | 1100 | 900 — 1300 | 1300 |

### General Power by Rank

| General Rank | Power |
|---|---|
| Rank 1 | 250 |
| Rank 2 | 450 |
| Rank 3 | 700 |
| Rank 4 | 1000 (hard cap) |

### Ability Tax — Power Reduction from Baseline

| Ability Complexity | Power Reduction |
|---|---|
| One minor ability (one zone, simple effect) | −50 |
| One strong ability (one zone, impactful effect) | −100 |
| Two abilities (two zones filled) | −150 |
| Three abilities (all zones filled) | −200 |
| Keyword only (single keyword) | −50 |
| Legacy keyword (additional) | −75 |
| ◆◆◆◆◆◆◆◆◆◆◆◆◆◆ Energy-gated ability (any zone, requires [ENERGY: X] to activate) | −25 per zone |

> *Energy-gated abilities carry a reduced Power tax because the Energy cost is the primary tax — the card's Power stat is the secondary lever. A card with three Energy-gated abilities across all zones takes a −75 total tax rather than the standard −200. A card that mixes free and Energy-gated abilities taxes each zone individually at its applicable rate.*

### Boost Math Reference

| Frontline Power | Backline Boost | Total | Effective Rank |
|---|---|---|---|
| 300 (R1) | 300 (R1) | 600 | ≈ Rank 2+ |
| 500 (R2) | 300 (R1) | 800 | ≈ Rank 3 |
| 500 (R2) | 500 (R2) | 1000 | ≈ Rank 4 |
| 750 (R3) | 500 (R2) | 1250 | ≈ Rank 4+ |
| 1100 (R4) | 500 (R2) | 1600 | Exceptional |

### Faction Power Identity

| Faction | Power Tendency | Ability Tendency |
|---|---|---|
| Vampiric Hell | High — above baseline | Low |
| The Rot | Low — below baseline | High |
| Data Kingdom | Low Frontline | High Backline |
| The Radiant Shelter | Mid | Mid |
| The Embercrown | High — at or above baseline | Mid |
| Voidborn Collective | Mid | High |
| The Diamond League | Variable | Chain abilities |
| The Gilded Syndicate | Variable | Energy economy |

### ◆◆◆◆◆◆◆◆◆ Dragonfire Calibration Note
Because spent Energy cards cycle through the Remnant Zone and can return to play via the Singularity, Dragonfire's [ENERGY: X] cost must be set high enough that repeated use is not trivially achievable in the same game. Recommended minimum X cost for destroying a single unit is 2. Board-wide or multi-target Dragonfire effects should scale steeply — an X value that lets a player clear 3 or more units in a single activation should require investment that prevents the ability from being repeated without significant setup.

---

## 11. KEYWORD GLOSSARY
◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆ *Glossary covers all keywords active across all eight factions. Keywords are grouped by origin: Universal (active across all factions) and Faction-Specific. Faction-specific keywords may appear on cards from other factions in future sets. Keywords that originate with one faction but appear on multiple factions' cards are listed in the Universal section.*

### Universal Keywords

| Keyword | Rules Text | Status |
|---|---|---|
| **Blitz** | This unit ignores Summon Delay. It may attack the turn it enters the Frontline. ◆◆◆◆◆◆◆◆◆◆◆◆◆◆ Blitz may also be granted temporarily by card effects or abilities. Granted Blitz functions identically to printed Blitz for the duration specified. If no duration is stated, it lasts until end of turn | ✅ Defined |
| **Sentinel** | This unit may both Attack and Defend in the same round | ✅ Defined |
| **Surge** | Trigger this effect when this card enters the Energy Zone face-up from the Shield Zone. Surge does not trigger if a card enters the Energy Zone by any other means | ✅ Defined |
| **Aegis** | This unit cannot be targeted or destroyed by Burst cards | ✅ Defined |
| **Pierce** | When this unit's attack breaks a Shield, the defending player breaks one additional Shield | ✅ Defined |
| **Infiltrate** | This unit may attack Backline units directly. Infiltrate bypasses the Frontline entirely for targeting and defense — the presence or absence of Frontline units has no bearing on whether an Infiltrate attack is legal. Breakthrough conditions apply only to attacks targeting the General and do not affect Infiltrate. When an Infiltrate attack targets a Backline unit: the defending player may not use Frontline units to defend; the defending player may deploy an Interceptor to respond — if they do, the Interceptor becomes the sole target of the attack, the original Backline unit is unaffected regardless of outcome, and Power comparison resolves normally between the Infiltrator and Interceptor (if the Infiltrator's Power is less than or equal to the Interceptor's Power, the Infiltrator is destroyed); if no Interceptor is deployed and the attack wins, the targeted Backline unit is destroyed and no Shield breaks; if no Interceptor is deployed and the attack loses, the attacker is destroyed and no Shield breaks. No Shield breaks from an Infiltrate attack under any circumstances. Infiltrate attacks cannot target an empty Backline slot | ✅ Defined |
| **Lifesteal** | When this unit's attack breaks a Shield — including Shields broken when the defending player chooses zero defenders — move one opponent face-up Energy card to your Energy Zone. This trigger fires on the break event and is not affected by subsequent Shield restoration effects. Maximum one trigger per round. Cannot reduce opponent Energy below 1 | ✅ Defined |
| **Bloodlust** | Each time this unit destroys a defending unit, gain +50 Power permanently. This increase persists for the rest of the game | ✅ Defined |
| **◆◆◆◆◆◆◆◆◆◆◆◆◆ Reanimate** | When this unit is destroyed, its Reanimate trigger is registered immediately. At the start of your next turn, if the card is still in your Remnant Zone, return it to your Backline at its base Power. If the card is no longer in your Remnant Zone at that moment — because the Singularity reshuffled it, an ability moved it, or any other reason — the Reanimate trigger is cancelled and the card is not returned. ◆◆◆◆◆◆◆◆◆◆◆◆◆◆ Reanimate may be permanently removed from a unit by card effects. A unit that loses Reanimate this way no longer has the keyword — it will not trigger Reanimate on its next destruction or any subsequent destruction. This is distinct from the Reanimate trigger being cancelled mid-resolution | ✅ Defined |
| **Anchor** | This unit cannot be moved or retreated by any card effect | ✅ Defined |
| **Legacy** | This ability remains active while this card is buried beneath your General in the Advancement stack. Legacy applies exclusively to Command abilities — Frontline and Backline abilities are zone-dependent and never persist when a card is buried | ✅ Defined |
| **◆ Fragment** | This card may be deployed from your General's Advancement stack to your Frontline or Backline during your Deploy Phase. The General stack is otherwise undisrupted. Any Legacy ability this card provided is permanently lost upon departure. Using Fragment does not consume your Advance for the turn. A unit entering the Frontline via Fragment ignores Summon Delay and may attack the turn it arrives. Fragment opens a Burst — Reaction window before the unit enters its zone. A unit deployed via Fragment cannot be moved in Phase 4 of the same turn. Fragment may also target Devoured cards below the Rank 1 starting card — when a Devoured card departs, it immediately loses Devoured status and its Command ability deactivates permanently | ✅ Defined |
| **◆ Ascendant** | While this unit is in the Command Zone as your active General, all Command abilities on every card in your Advancement stack are active regardless of whether those cards have the Legacy keyword | ✅ Defined |
| **◆ Interceptor** | This unit may intercept any attack from the Backline or from hand. It is destroyed regardless of combat outcome — this is an exception to the standard defender survival rule. Power comparison still resolves normally — if the attacker's Power is less than or equal to the Interceptor's Power, the attacker is destroyed. When intercepting from hand, the unit is immediately deployed then destroyed. A full Frontline does not prevent this — Interceptors bypass the slot limit because they never permanently occupy a zone. Counts as one deployment for the turn | ✅ Defined |
| **Void Pulse** | Reduce the Power of one target enemy unit by X until the start of your next turn. Units reduced to 0 Power or below cannot attack or defend this round | ✅ Defined |
| **Lineup** | When this ability is activated after another friendly unit already acted this turn, gain the bonus Lineup effect in addition to the base effect | ✅ Defined |
| **Prophecy** | Name a card type (Unit, Burst, or Augment). Reveal the top card of your deck. If it matches, trigger this ability's Prophecy Effect. Either way that card goes to your hand | ✅ Defined |
| **Uplink** | ◆◆◆◆◆◆◆◆◆◆◆ While this unit is in the Backline, when it taps to Boost a paired Frontline ally, its Boost value is increased by +X. A unit with 650 Power and Uplink +100 contributes 750 total Power to the Boost. Uplink only applies when this unit taps to Boost — it has no effect if this unit uses its Backline ability or does nothing | ✅ Defined |
| **Radiant Barrier** | [ENERGY: X] Negate one attack targeting your General or a chosen friendly unit. X=1 negates the attack. X=2 negates the attack and returns the attacking unit to its controller's hand. Radiant Barrier is a Burst — Reaction card and cannot be played during an attack in which the attacker has paid the Dominion cost | ✅ Defined |
| **Shield Burn** | [ENERGY: X] Spend X Energy to activate this effect | ✅ Defined |
| **◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆ House Cut** | When an opponent spends Energy to activate an ability, gain 1 face-up Energy. Maximum 3 House Cut triggers per turn regardless of sources. Originated with the Gilded Syndicate. Used by the Voidborn Collective and Data Kingdom | ✅ Defined |
| **◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆ Void Lock** | The target card in the opponent's hand cannot be played until the start of the opponent's next turn. The card remains in hand — it is not discarded or destroyed. Void Lock requires a prior hand-reveal effect in the same turn to be legal — Blind Void Lock (locking a card you have not seen) is not a legal ability. Maximum 2 Void Lock targets per turn regardless of how many Void Lock sources are in play. Duration is always until the start of the opponent's next turn | ✅ Defined |
| **◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆ Sovereign's Reign** | This General's abilities gain bonus effects based on the number of face-up unspent Energy cards in your Energy Zone at the moment of activation. Spending Energy to pay the ability cost happens first — the remaining Energy count determines the bonus. Threshold: 1–2 Energy = baseline ability only; 3 Energy = minor bonus; 4 Energy = moderate bonus; 5+ Energy = full bonus. Exact bonus effects are printed on each General's card. Originated with the Gilded Syndicate. Also used by the Voidborn Collective | ✅ Defined |
| **◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆ Overcharge** | The equipped unit may use its zone ability one additional time per turn. This second use may occur at any legal moment within the same phase. Subject to the Zone Ability Use Cap — a zone ability may never be activated more than twice per turn regardless of modifiers | ✅ Defined |

---

### Faction Keywords — Vampiric Hell

| Keyword | Rules Text | Status |
|---|---|---|
| **◆◆◆◆◆◆◆◆◆◆◆◆◆◆ Dominion** | [ENERGY: 1] During the resolution of this unit's attack, the defending player cannot spend Energy on abilities or play Burst — Reaction cards. If this unit also has a Fanged Gauntlet equipped, this extends to fully preventing the defending player from playing any Burst — Reaction cards during that attack regardless of Energy cost. Dominion must be paid at the moment of attack declaration — a unit with printed Dominion still requires 1 Energy to engage it. If the controlling player cannot pay [ENERGY: 1], Dominion cannot be activated | ✅ Defined |
| **◆◆◆ Sanguine Offering** | This unit may destroy itself during the Backline Act phase to grant one chosen friendly Frontline unit a Power bonus. The Backline slot is immediately vacated. This is not combat and does not trigger combat keywords | ✅ Defined |
| **◆◆◆ Blood Tithe** | General-exclusive passive. At the end of your turn, gain 1 face-up Energy for each Shield broken during your attacking units' attacks this turn, including Shields broken when the defending player chose zero defenders. This trigger fires on the break event and is not affected by subsequent Shield restoration effects. Shields broken by opponent effects or abilities do not count. At the end of your opponent's turn, if no friendly Shield was broken this turn, all friendly units lose 50 Power until your next Untap Phase. Once per turn, units sacrificed by this General's abilities trigger their Surge ability before leaving the field | ✅ Defined |

---

### Faction Keywords — The Radiant Shelter

| Keyword | Rules Text | Status |
|---|---|---|
| **◆◆◆ Shelter** | Once per turn, the unit with this ability may prevent up to X Power of damage to one friendly Frontline unit during the current attack. The attacker's Power is not reduced — only the damage outcome changes. If this negates enough damage to save the unit, it survives at 1 Power. X is defined on the card. Only one Shelter activation may target a single friendly unit per attack | ✅ Defined |
| **◆◆◆ Radiant Shell** | This unit is immune to Power reduction effects from enemy Burst cards. Its Power may still be reduced by unit abilities and combat outcomes | ✅ Defined |
| **◆◆◆ Elemental Triad** | Once per turn, choose one mode — Fire: this unit gains +200 Power until end of turn. Wind: one friendly unit gains +150 Power until end of turn. Tide: prevent the next Shield break this turn. Each mode may only be chosen once per turn unless modified by an Augment | ✅ Defined |
| **◆◆◆ Prismatic Nova** | Once per turn, choose up to two modes — Fire: this unit gains +300 Power until end of turn. Wind: one friendly unit gains +250 Power until end of turn. Tide: restore one broken Shield from your Energy Zone to your Shield Zone face-down. Shield breaks resolve before this restoration — the 6-Shield cap is checked after any breaks that turn | ✅ Defined |
| **◆◆◆ Prismatic Vow** | Whenever a Shield would be broken, you may spend 1 face-up Energy to prevent it. This includes Shields broken when the defending player chooses zero defenders and Shields broken by Pierce. The prevented Shield does not enter the Energy Zone — it remains face-down in the Shield Zone. Surge abilities on the prevented Shield card still trigger normally | ✅ Defined |
| **◆◆◆ Oathstrike** | When this unit attacks and one or more defenders were declared and this unit's attack Power exceeds the total defense Power, place the top card of your deck face-down into your Shield Zone. Oathstrike does not trigger when the defending player chooses zero defenders. The Shield Zone cannot exceed 6 face-down Shields — if already at 6, Oathstrike does not trigger | ✅ Defined |
| **◆◆◆ Warden's Light** | All friendly Frontline units cannot have their Power reduced below 100 by enemy abilities this turn. Units already below 100 are unaffected | ✅ Defined |
| **◆◆◆ Radiant Lattice** | All friendly Frontline units gain +100 Power for each face-down Shield in your Shield Zone. Maximum +400 from this effect. Bonus resets at the start of your Untap Phase | ✅ Defined |
| **◆◆◆ Tidal Veil** | [ENERGY: 1] Once per turn when this unit is targeted by an enemy attack or ability, you may redirect that effect to one other friendly unit of your choice. The redirected effect resolves normally on the new target | ✅ Defined |
| **◆◆◆ Upwelling** | Once per turn, if a friendly Shield was broken this turn, one chosen friendly Frontline unit gains +200 Power until end of turn | ✅ Defined |

---

### Faction Keywords — Data Kingdom

| Keyword | Rules Text | Status |
|---|---|---|
| **◆◆◆ Overcharge** | See Universal Keywords. Originated with the Data Kingdom | ✅ Defined — see Universal |

---

### Faction Keywords — The Rot

| Keyword | Rules Text | Status |
|---|---|---|
| **◆◆◆◆ Wither** | This unit may destroy itself during the Backline Act phase to grant an effect to one chosen friendly unit. This is not combat and does not trigger combat keywords. The Backline slot is immediately vacated upon use. Wither destruction triggers Sporulate and Blightweaver's Power growth. Wither does not trigger Reanimate on the withering unit — self-destruction bypasses Reanimate's trigger condition | ✅ Defined |
| **◆◆◆◆ Sporulate** | This unit may use its active zone ability a second time per turn, but only after a friendly unit has been destroyed that turn. Cannot Sporulate more than once per turn regardless of how many friendly units were destroyed. Subject to the Zone Ability Use Cap — a zone ability may never be activated more than twice per turn regardless of modifiers | ✅ Defined |
| **◆◆◆◆ Devour** | Once per turn during your Deploy Phase, destroy one friendly unit in any zone and place it face-up below the Rank 1 starting card of your General's Advancement stack. Devour does not open a Burst — Reaction window. Devoured cards are never part of the Advancement stack proper and cannot become the active General under any circumstance. Using Devour does not consume your Advance for the turn — you may Advance in Phase 2 and Devour in Phase 3 of the same turn. While a Devoured card remains below the stack, its Command ability is permanently active. Devoured cards are visible to both players. Devoured units lose Reanimate. If Dimensional Retreat is activated, Devoured cards remain below the stack and continue providing their Command ability to the new active General — they are never removed by Retreat. ◆◆◆◆◆◆◆◆◆◆◆◆ Devoured cards may be targeted by Fragment. When a Devoured card is deployed via Fragment, it immediately loses its Devoured status and its Command ability deactivates permanently — power is tied to physical presence in the stack. The card enters the field as a normal unit under all standard Fragment rules. If subsequently destroyed it enters the Remnant Zone as a normal card and may be Devoured again as a fresh action in a future turn. *Designer's Note: Devour is a power engine, not a defensive tool. Placing cards below the stack grows your General's passive Command ability network but provides zero Dimensional Retreat protection. A Rank 1 General with five Devoured cards beneath them has no Retreat option whatsoever — their only protection is their Shields. Players building around Devour should plan their Advancement strategy deliberately. Fragment from below the stack is a powerful release valve — the General spends stored power to put a body on the field, but permanently gives up that card's Command contribution in doing so.* | ✅ Defined |
| **◆◆◆◆◆◆◆◆◆◆◆◆◆ Enshroud** | Attach one target unit to one friendly unit as a special Augment. The host gains Power equal to half the attached card's base Power rounded down. If the attached card belongs to The Rot faction, the host may also use one chosen zone ability from that card once per turn. Enshrouded cards follow all standard Augment rules. The source zone is specified on the card — Enshroud may target units in either player's Remnant Zone or active enemy units on the field, depending on the card. When an Enshrouded card pulled from an opponent's Remnant Zone or taken from the field is destroyed, it returns to its original owner's Remnant Zone | ✅ Defined |
| **◆◆◆◆ Consumption Rite** | [ENERGY: 1 optional] Sacrifice one friendly non-Reanimate unit. Distribute that unit's current Power equally among all other friendly units. Cannot target Reanimate units — this restriction is absolute. The optional [ENERGY: 1] payment triggers the sacrificed unit's Surge ability before it enters the Remnant Zone | ✅ Defined |

---

### Faction Keywords — The Embercrown

| Keyword | Rules Text | Status |
|---|---|---|
| **◆ Dragonfire** | [ENERGY: X] Destroy up to X target enemy units in any zone regardless of their Power. This is not combat — does not trigger combat keywords on either side, including Reanimate and Bloodlust. Minimum [ENERGY: 2] to destroy a single unit. Multi-target scaling: [ENERGY: 3] for two units, [ENERGY: 5] for three, [ENERGY: 8] for four. See Section 10 calibration note | ✅ Defined |
| **◆ Flame Prayer** | When this unit is destroyed by any means, gain 1 face-up Energy. Triggers before the General Power-growth passive. Stacks — multiple Flame Prayer units destroyed in the same turn each generate 1 Energy | ✅ Defined |
| **◆ Elder's Verdict** | This unit's Power cannot be reduced below its base Power by opponent effects. Power increases above base are unaffected and protected at their new value. Elder's Verdict does not prevent combat destruction, Pierce Shield breaks, or Power reduction that operates through combat resolution | ✅ Defined |
| **◆ Drakesworn Bond** | This unit is always deployed as a pair with its bonded partner. Both cards must be played simultaneously from hand, occupying adjacent Frontline or Backline slots. If only one card is in hand, neither may be deployed. When one bonded unit is destroyed, the surviving partner's Power is immediately halved | ✅ Defined |

---

### Faction Keywords — Voidborn Collective

| Keyword | Rules Text | Status |
|---|---|---|
| **◆ Void Pulse** | See Universal Keywords. Originated with the Voidborn Collective | ✅ Defined — see Universal |
| **◆ Void Lock** | See Universal Keywords. Originated with the Voidborn Collective | ✅ Defined — see Universal |
| **◆ Sovereign's Reign** | See Universal Keywords. The Voidborn Collective's Admiral Seyrath uses Sovereign's Reign with threshold values calibrated to his specific abilities — exact bonuses are printed on Seyrath's card | ✅ Defined — see Universal |

---

### Faction Keywords — The Diamond League

| Keyword | Rules Text | Status |
|---|---|---|
| **◆ Lineup** | See Universal Keywords. Originated with the Diamond League | ✅ Defined — see Universal |
| **◆ Prophecy** | See Universal Keywords. Originated with the Diamond League | ✅ Defined — see Universal |
| **◆ Relay** | When this unit's Lineup bonus activates, apply the bonus to all friendly Frontline units simultaneously rather than one chosen target. Relay units carry a −100 Power tax from baseline | ✅ Defined |

---

### Faction Keywords — The Gilded Syndicate

| Keyword | Rules Text | Status |
|---|---|---|
| **◆ Drunken Rage** | [ENERGY: X] Once per turn, one chosen Frontline unit gains +X×100 Power until end of turn. Maximum single activation: [ENERGY: 5] for +500 Power. Drunken Rage Power is temporary — it expires at end of turn and is not preserved by Sovereign's Reign conversion. Does not appear on General units | ✅ Defined |
| **◆ House Cut** | See Universal Keywords. Originated with the Gilded Syndicate | ✅ Defined — see Universal |
| **◆ Sovereign's Reign** | See Universal Keywords. The Gilded Syndicate's Don uses Sovereign's Reign to convert accumulated Energy into permanent Power bonuses at end of turn. Conversion rate and per-unit cap (+400 maximum per unit) are printed on the Don's card | ✅ Defined — see Universal |

### The Remnant Zone

◆◆◆◆◆◆ The **Remnant Zone** is the universal zone used by all factions. The following cards enter the Remnant Zone: destroyed units, spent Bursts, destroyed Augments, destroyed Rifts, discarded cards, and spent Energy cards. The Remnant Zone is reshuffled into the deck when the Singularity triggers. Shields are never part of the Remnant Zone.

- Both players maintain their own Remnant Zone
- Some abilities — including The Rot's Enshroud — may pull cards from **either player's** Remnant Zone
- The Remnant Zone is a public zone — both players may look at its contents at any time
- ◆◆◆◆◆◆◆◆◆◆ Destroyed Augments always return to their **original owner's** Remnant Zone, regardless of who controlled the host unit
- ◆◆◆◆◆◆◆◆◆◆◆◆◆ **Cross-pile destruction rule:** When a card pulled from an opponent's Remnant Zone — or taken directly from the opponent's field via Enshroud — is destroyed while under your control, it returns to its **original owner's** Remnant Zone. This applies regardless of how the card entered your control and regardless of what destroyed it. The card is never permanently captured

---

## 12. FACTION ROSTER

| Faction | Theme | Playstyle | Signature Keyword | General Archetype | Status |
|---|---|---|---|---|---|
| **Vampiric Hell** | Demonic | Aggressive. Attack buffs, defend decay | Bloodlust | TBD | Concept locked |
| **The Rot** | Undead | Swarm and resource denial. Attrition | Reanimate | Grove-Speaker | Concept locked |
| **Data Kingdom** | Digital | Backline support and information control | Uplink | TBD | Concept locked |
| **The Radiant Shelter** | Magical | Energy-to-Shield conversion and negation | Radiant Barrier | TBD | Concept locked |
| **◆ The Embercrown** | Dragon / Volcanic | Frontline dominance. Solo champion combat | Dragonfire | The Warlord — gains Power per friendly unit destroyed | ✅ Mechanics defined |
| **◆ Voidborn Collective** | Deep space | Control and denial. Power reduction | Void Pulse | The Admiral — hand control and targeting | ✅ Mechanics defined |
| **◆ The Diamond League** | Interdimensional sports | Ability chaining and momentum building | Lineup | The Ace — doubles last used friendly ability at half value | ✅ Mechanics defined |
| **◆ The Gilded Syndicate** | 1920s mob / casino | Energy gambling and Lifesteal aggression | Drunken Rage / House Cut | The Don — Sovereign's Reign, converts Energy to end-of-turn Power | ✅ Mechanics defined |

---

## 13. ◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆ DECK CONSTRUCTION RULES

### Overview

```
DECK SIZE:         50 cards total — your complete deck including your General
GENERAL:           1 Rank 1 unit included in your 50 cards.
                   One of the Rank 1 units in your deck is chosen at the start of
                   game and placed in the Command Zone before play begins.
SHIELDS:           Top 6 cards of your remaining 49 cards placed face-down
OPENING HAND:      5 cards drawn after Shields are placed
COPY LIMIT:        3 copies maximum per standard card
UNIQUE CARDS:      1 copy maximum (marked [UNIQUE])
FACTION:           Mono-faction only (Set 1)
ADVANCE TARGETS:   Minimum 2 per Rank you intend to reach — deck-building
                   requirement only, never declared or revealed at game start
RIFT CARDS:        Maximum 3 total in your 50 cards
```

---

### Game Setup Order

**STEP 1 — Choose General**
Choose one of the Rank 1 units already in your 50-card deck to be your General. Remove it from the deck and place it face-up in the Command Zone. You now have 49 cards remaining. No other card is chosen, declared, or removed at this step.

**STEP 2 — Shuffle**
Shuffle your remaining 49 cards into a face-down deck.

**STEP 3 — Place Shields**
Take the top 6 cards of your shuffled deck and place them face-down in your Shield Zone. You now have 43 cards remaining.

**STEP 4 — Draw Opening Hand**
Draw 5 cards from your deck. You now have 38 cards remaining.

**STEP 5 — Mulligan (Optional)**
Each player may take one full mulligan: shuffle all 5 cards back into your 49-card deck and redraw 5 new cards. The second hand is kept regardless of its contents. Only one mulligan is permitted per game.

**STEP 6 — Game Begins**
Determine first player and begin.

### Zone Counts at Game Start

| Zone | Cards |
|---|---|
| Command Zone | 1 (General) |
| Shield Zone | 6 (face-down) |
| Opening Hand | 5 |
| Deck | 38 |
| All other zones | 0 |
| **Total** | **50** |

---

### The General

- Your General is one of the **Rank 1 units** already in your 50-card deck, chosen at the start of game and placed in the Command Zone before play begins
- **No other card is ever pre-selected, declared, or removed from the deck at setup.** All Rank 2, 3, and 4 cards remain in your 49-card deck and enter play only by being drawn, deployed, or Advanced during the game
- Once removed to the Command Zone, the General is never shuffled into the remaining 49 cards, never drawn, and never placed in the Shield Zone
- Your 49-card deck must contain at least **2 legal Advance targets per Rank** you intend to reach — this is a deck-building requirement only. These cards are never revealed or designated at game start
- The label "Advancement Line" describes the intended function of those cards in deck-building guides — not a separate zone or a pre-game declaration. All cards in the deck are shuffled together. Advancement Line cards are indistinguishable from the rest of the deck until drawn

**Recommended Advance targets by intended max Rank:**

| Target Max Rank | Minimum Advance Cards in Deck |
|---|---|
| Rank 2 only | 2× same-faction Rank 2 units |
| Rank 3 | 2× Rank 2 + 2× Rank 3 same-faction units |
| Rank 4 | 2× Rank 2 + 2× Rank 3 + 2× Rank 4 same-faction units |

---

### Copy Limits

- **Standard cards:** Maximum **3 copies** per card in your 50-card deck
- **[UNIQUE] cards:** Maximum **1 copy** per card in your 50-card deck
  - The [UNIQUE] tag appears on the type line
  - Reserved for the most powerful Rank 4 units, legendary effects, and game-defining Rifts

---

### Faction Rules — Set 1

All 50 cards in your deck must belong to the **same faction**. No cross-faction cards are permitted in Set 1.

---

### Rift Cards

- Maximum **3 Rift cards** total in your 50-card deck
- All Rift cards must belong to your chosen faction

---

### Sample Deck Skeleton — 50 Cards

The following is an example structure for a well-built Embercrown deck. The General is listed separately only to show its role — all 50 cards are part of one unified deck before the game begins.

```
YOUR 50-CARD DECK:

General — chosen at game start, removed to Command Zone (1 card):
  1× Rank 1 Embercrown unit  ← one copy chosen from your Rank 1 pool

Advancement Line — remain in deck, drawn and used during play (6 cards):
  3× Rank 2 Embercrown unit   ← Advance targets
  3× Rank 3 Embercrown unit   ← Advance targets

Rank 4 Units (3 cards):
  3× Rank 4 Embercrown unit

Rank 3 Units — deployed (6 cards):
  3× Rank 3 Embercrown unit A
  3× Rank 3 Embercrown unit B

Rank 2 Units — deployed (6 cards):
  3× Rank 2 Embercrown unit A
  3× Rank 2 Embercrown unit B

Rank 1 Units — early game (9 cards):
  3× Rank 1 Embercrown unit A  ← one of these three chosen as General at game start;
                                   the remaining two stay in the deck as normal cards
  3× Rank 1 Embercrown unit B
  3× Rank 1 Embercrown unit C

Burst Cards (9 cards):
  3× Burst — Cast A
  3× Burst — Cast B
  3× Burst — Reaction A

Augments (6 cards):
  3× Augment — Weapon A
  3× Augment — Relic A

Rift Cards (3 cards):
  3× Embercrown Rift

DECK TOTAL: 1+6+3+6+6+9+9+6+3 = 49 + 1 flex card = 50 ✅
```

> **Note:** The Rank 1 unit chosen as General at game start is one card removed from the deck's Rank 1 pool. The remaining copies of that unit stay in the deck as normal cards — they may be drawn, deployed to the field, and Advanced normally. They do not become Generals.

---

### Mulligan Rule

Each player may take **one full mulligan** before the game begins.

- After drawing your opening hand of 5, you may choose to shuffle all 5 cards back into your 49-card deck and redraw 5 new cards
- The second hand is kept regardless of its contents
- Only one mulligan is permitted per game

---

*The Fracture Throne — Rules Document v2.5*
*◆ marks changes from v1.0. ◆◆ marks changes from v1.1. ◆◆◆ marks changes from v1.2. ◆◆◆◆ marks changes from v1.3. ◆◆◆◆◆ marks changes from v1.4. ◆◆◆◆◆◆ marks changes from v1.5. ◆◆◆◆◆◆◆ marks changes from v1.6. ◆◆◆◆◆◆◆◆ marks changes from v1.7. ◆◆◆◆◆◆◆◆◆ marks changes from v1.8. ◆◆◆◆◆◆◆◆◆◆ marks changes from v1.9. ◆◆◆◆◆◆◆◆◆◆◆ marks changes from v2.0. ◆◆◆◆◆◆◆◆◆◆◆◆ marks changes from v2.1. ◆◆◆◆◆◆◆◆◆◆◆◆◆ marks changes from v2.2. ◆◆◆◆◆◆◆◆◆◆◆◆◆◆ marks changes from v2.3. ◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆ marks changes from v2.4.*
*Next session: Card set design for Embercrown, Voidborn Collective, Diamond League, and Gilded Syndicate.*

