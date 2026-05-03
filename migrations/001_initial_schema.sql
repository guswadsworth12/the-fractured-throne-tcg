-- ================================================
-- FRACTURE THRONE SCHEMA
-- ================================================


-- ------------------------------------------------
-- FACTIONS
-- ------------------------------------------------
CREATE TABLE factions (
    id          SERIAL PRIMARY KEY,
    name        TEXT NOT NULL UNIQUE,
    theme       TEXT,
    power_tendency TEXT,
    ability_tendency TEXT
);

INSERT INTO factions (name, theme, power_tendency, ability_tendency) VALUES
    ('Vampiric Hell',      'Gothic horror / blood courts',       'High — above baseline',    'Low'),
    ('The Rot',            'Undead swarm / attrition',           'Low — below baseline',     'High'),
    ('Data Kingdom',       'Digital / network constructs',       'Low Frontline',            'High Backline'),
    ('Radiant Shelter',    'Magical / light and shields',        'Mid',                      'Mid'),
    ('Embercrown',         'Dragon / volcanic',                  'High — at or above baseline', 'Mid'),
    ('Voidborn Collective','Deep space / control',               'Mid',                      'High'),
    ('Diamond League',     'Interdimensional sports',            'Variable',                 'Chain abilities'),
    ('Gilded Syndicate',   '1920s mob / casino',                 'Variable',                 'Energy economy');


-- ------------------------------------------------
-- KEYWORDS
-- ------------------------------------------------
CREATE TABLE keywords (
    id          SERIAL PRIMARY KEY,
    name        TEXT NOT NULL UNIQUE,
    scope       TEXT NOT NULL CHECK (scope IN ('universal', 'faction')),
    origin_faction_id INT REFERENCES factions(id),
    rules_text  TEXT NOT NULL,
    is_temporary BOOLEAN NOT NULL DEFAULT FALSE,
    notes       TEXT
);

INSERT INTO keywords (name, scope, rules_text, is_temporary, notes) VALUES
    ('Blitz',       'universal', 'This unit ignores Summon Delay. It may attack the turn it enters the Frontline. May also be granted temporarily by card effects.', FALSE, 'Granted Blitz lasts until end of turn unless stated'),
    ('Sentinel',    'universal', 'This unit may both Attack and Defend in the same round.', FALSE, NULL),
    ('Surge',       'universal', 'Trigger this effect when this card enters the Energy Zone face-up from the Shield Zone only.', FALSE, NULL),
    ('Aegis',       'universal', 'This unit cannot be targeted or destroyed by Burst cards.', FALSE, NULL),
    ('Pierce',      'universal', 'When this unit breaks a Shield, the defending player breaks one additional Shield.', FALSE, NULL),
    ('Infiltrate',  'universal', 'This unit may attack Backline units directly, bypassing the Frontline entirely.', FALSE, 'No Shield breaks from Infiltrate attacks'),
    ('Lifesteal',   'universal', 'When this unit breaks a Shield, move one opponent face-up Energy card to your Energy Zone.', FALSE, NULL),
    ('Anchor',      'universal', 'This unit cannot be moved from its current zone by any card effect. It may still move voluntarily.', FALSE, NULL),
    ('Reanimate',   'universal', 'When this unit is destroyed, return it to its previous zone with 100 Power. Can be permanently removed by card effects.', FALSE, NULL),
    ('Bloodlust',   'universal', 'When this unit destroys an enemy unit in combat, gain +100 Power permanently.', FALSE, 'PERMANENT — never resets'),
    ('Legacy',      'universal', 'This unit''s Command ability remains active even when buried in the Advancement stack.', FALSE, 'Applies to Command abilities ONLY'),
    ('Void Pulse',  'universal', 'Reduce target unit Power by X until start of opponent''s next turn. TEMPORARY.', TRUE,  'Originated with Voidborn Collective'),
    ('Void Lock',   'universal', 'Target card in opponent hand cannot be played until your next turn. Requires prior hand-reveal. Max 2 targets per turn.', FALSE, 'Originated with Voidborn Collective'),
    ('Overcharge',  'universal', 'This unit''s Backline Boost is doubled but it is destroyed at end of turn.', FALSE, 'Originated with Data Kingdom'),
    ('Lineup',      'universal', 'Chain: this unit''s ability triggers a bonus based on the previous Lineup ability used this turn.', FALSE, 'Originated with Diamond League'),
    ('Prophecy',    'universal', 'Look at the top 3 cards of your deck. You may reorder them in any order.', FALSE, 'Originated with Diamond League'),
    ('House Cut',   'universal', 'Gain 1 face-up Energy whenever the opponent spends Energy on an ability. Max 3 per opponent turn.', FALSE, 'Originated with Gilded Syndicate'),
    ('Sovereign''s Reign', 'universal', 'At end of turn, convert up to X face-up Energy into permanent Power bonuses distributed among friendly units.', FALSE, 'Conversion table on individual General cards'),
    ('Dragonfire',  'faction',   '[ENERGY: X] Destroy up to X enemy units in any zone. Not combat. Min cost 2 for single unit.', FALSE, NULL),
    ('Flame Prayer','faction',   'When this unit is destroyed by any means, gain 1 face-up Energy.', FALSE, NULL),
    ('Elder''s Verdict','faction','This unit''s Power cannot be reduced below its base Power by opponent effects.', FALSE, NULL),
    ('Drakesworn Bond','faction','Must be deployed as a pair. If one is destroyed, surviving partner''s Power is halved.', FALSE, NULL),
    ('Wither',      'faction',   'This unit may destroy itself during Backline Act to grant an effect to a friendly unit. Not combat.', FALSE, NULL),
    ('Sporulate',   'faction',   'May use active zone ability a second time per turn, but only after a friendly unit was destroyed.', FALSE, NULL),
    ('Devour',      'faction',   'Once per turn in Deploy Phase: destroy a friendly unit and place it below the General Advancement stack.', FALSE, 'Devoured unit''s Command ability becomes permanently active'),
    ('Bloodlust',   'faction',   'See universal Bloodlust.', FALSE, 'Listed separately for VH faction context'),
    ('Dominion',    'faction',   '[ENERGY: 1] Prevent opponent from playing Burst — Reaction cards during this attack.', FALSE, NULL),
    ('Sanguine Offering','faction','This unit may destroy itself from Backline to grant a Power bonus to a chosen Frontline unit.', FALSE, NULL),
    ('Blood Tithe', 'faction',   'General passive. Gain 1 Energy per Shield broken this turn. If no friendly Shield broke this turn, all friendly units lose 50 Power.', FALSE, NULL),
    ('Reanimate',   'faction',   'See universal Reanimate.', FALSE, 'Listed separately for Rot faction context'),
    ('Uplink',      'faction',   'This unit''s Boost is increased by X when a specified amplification condition is met.', FALSE, NULL),
    ('Radiant Barrier','faction','[ENERGY: X] Negate an attack targeting a friendly unit. X=1 negates, X=2 negates and the attacker loses 100 Power.', FALSE, NULL),
    ('Relay',       'faction',   'When this unit''s Lineup bonus activates, apply it to all friendly Frontline units simultaneously.', FALSE, '-100 Power tax from baseline'),
    ('Drunken Rage','faction',   '[ENERGY: X] One chosen Frontline unit gains +X×100 Power until end of turn. TEMPORARY. Max [ENERGY: 5].', TRUE,  NULL),
    ('Interceptor', 'faction',   'When an enemy Infiltrate attack targets a friendly Backline unit, you may deploy this unit to become the sole target.', FALSE, NULL);


-- ------------------------------------------------
-- CARDS (core table)
-- ------------------------------------------------
CREATE TYPE card_type AS ENUM ('Unit', 'Burst', 'Augment', 'Rift');
CREATE TYPE burst_subtype AS ENUM ('Cast', 'Reaction');
CREATE TYPE augment_subtype AS ENUM ('Weapon', 'Armor', 'Relic');

CREATE TABLE cards (
    id                  SERIAL PRIMARY KEY,
    name                TEXT NOT NULL,
    faction_id          INT NOT NULL REFERENCES factions(id),
    card_type           card_type NOT NULL,

    -- Subtype fields (null when not applicable)
    unit_subtype        TEXT,           -- e.g. Vampire, Demon, Imp, Construct, Warden etc.
    burst_subtype       burst_subtype,  -- Cast or Reaction (Units/Augments/Rifts = null)
    augment_subtype     augment_subtype,-- Weapon, Armor, Relic (non-Augments = null)

    rank_cost           INT CHECK (rank_cost BETWEEN 1 AND 4),
    is_unique           BOOLEAN NOT NULL DEFAULT FALSE,
    copy_limit          INT NOT NULL DEFAULT 3 CHECK (copy_limit IN (1, 3)),

    -- Unit-only fields
    power               INT CHECK (power BETWEEN 0 AND 1300),
    is_general_eligible BOOLEAN NOT NULL DEFAULT FALSE,

    -- Zone abilities (Units only — null for non-Units)
    frontline_ability   TEXT,
    backline_ability    TEXT,
    command_ability     TEXT,

    -- Non-unit ability text (Bursts, Augments, Rifts)
    effect_text         TEXT,

    flavor_text         TEXT,
    set_code            TEXT NOT NULL DEFAULT 'SET1',
    art_path            TEXT,          -- relative path to art asset
    notes               TEXT,          -- designer notes

    -- Balance validation (computed/checked at insert)
    power_cap_ok        BOOLEAN GENERATED ALWAYS AS (
        CASE
            WHEN card_type != 'Unit' THEN TRUE
            WHEN rank_cost = 1 AND power <= 400 THEN TRUE
            WHEN rank_cost = 2 AND power <= 650 THEN TRUE
            WHEN rank_cost = 3 AND power <= 900 THEN TRUE
            WHEN rank_cost = 4 AND power <= 1300 THEN TRUE
            ELSE FALSE
        END
    ) STORED,

    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Auto-update updated_at
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER cards_updated_at
    BEFORE UPDATE ON cards
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();


-- ------------------------------------------------
-- CARD KEYWORDS (junction table)
-- ------------------------------------------------
CREATE TABLE card_keywords (
    card_id     INT NOT NULL REFERENCES cards(id) ON DELETE CASCADE,
    keyword_id  INT NOT NULL REFERENCES keywords(id),
    zone        TEXT CHECK (zone IN ('frontline', 'backline', 'command', 'any', 'passive')),
    energy_cost INT,    -- null if free, integer if [ENERGY: X]
    notes       TEXT,
    PRIMARY KEY (card_id, keyword_id, zone)
);


-- ------------------------------------------------
-- ABILITY TAX REFERENCE (read-only lookup)
-- ------------------------------------------------
CREATE TABLE ability_tax (
    id          SERIAL PRIMARY KEY,
    condition   TEXT NOT NULL,
    power_reduction INT NOT NULL
);

INSERT INTO ability_tax (condition, power_reduction) VALUES
    ('One minor ability (one zone, simple effect)',          50),
    ('One strong ability (one zone, impactful effect)',     100),
    ('Two abilities (two zones filled)',                    150),
    ('Three abilities (all zones filled)',                  200),
    ('Keyword only (single keyword)',                        50),
    ('Legacy keyword (additional)',                          75),
    ('Energy-gated ability (per zone)',                      25);


-- ------------------------------------------------
-- POWER CAPS (read-only reference)
-- ------------------------------------------------
CREATE TABLE power_caps (
    rank            INT PRIMARY KEY,
    baseline        INT NOT NULL,
    range_min       INT NOT NULL,
    range_max       INT NOT NULL,
    hard_cap        INT NOT NULL,
    general_power   INT NOT NULL
);

INSERT INTO power_caps VALUES
    (1,  300, 200,  400,  400,  250),
    (2,  500, 400,  650,  650,  450),
    (3,  750, 600,  900,  900,  700),
    (4, 1100, 900, 1300, 1300, 1000);


-- ------------------------------------------------
-- BALANCE CHECK VIEW
-- Agents query this to flag out-of-spec cards
-- ------------------------------------------------
CREATE VIEW balance_check AS
SELECT
    c.id,
    c.name,
    f.name AS faction,
    c.rank_cost,
    c.power,
    pc.hard_cap,
    c.power_cap_ok,
    CASE WHEN c.power > pc.hard_cap THEN 'OVER CAP'
         WHEN c.power < pc.range_min THEN 'UNDER RANGE'
         ELSE 'OK'
    END AS status
FROM cards c
JOIN factions f ON c.faction_id = f.id
JOIN power_caps pc ON c.rank_cost = pc.rank
WHERE c.card_type = 'Unit';


-- ------------------------------------------------
-- DECK CONSTRUCTION TABLES
-- (for future multiplayer — ready now)
-- ------------------------------------------------
CREATE TABLE players (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    username    TEXT NOT NULL UNIQUE,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE decks (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    player_id   UUID NOT NULL REFERENCES players(id),
    name        TEXT NOT NULL,
    faction_id  INT NOT NULL REFERENCES factions(id),
    is_valid    BOOLEAN NOT NULL DEFAULT FALSE,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE deck_cards (
    deck_id     UUID NOT NULL REFERENCES decks(id) ON DELETE CASCADE,
    card_id     INT NOT NULL REFERENCES cards(id),
    quantity    INT NOT NULL CHECK (quantity BETWEEN 1 AND 3),
    PRIMARY KEY (deck_id, card_id)
);

-- Deck validation view
CREATE VIEW deck_validation AS
SELECT
    d.id AS deck_id,
    d.name AS deck_name,
    SUM(dc.quantity) AS total_cards,
    COUNT(CASE WHEN c.card_type = 'Rift' THEN 1 END) AS rift_count,
    BOOL_AND(c.faction_id = d.faction_id) AS mono_faction,
    BOOL_AND(dc.quantity <= c.copy_limit) AS copy_limits_ok,
    SUM(dc.quantity) = 50 AS correct_size,
    COUNT(CASE WHEN c.card_type = 'Rift' THEN 1 END) <= 3 AS rift_limit_ok
FROM decks d
JOIN deck_cards dc ON d.id = dc.deck_id
JOIN cards c ON dc.card_id = c.id
GROUP BY d.id, d.name;
