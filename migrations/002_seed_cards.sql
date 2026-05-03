-- ============================================================
-- SEED FILE: 002_seed_cards.sql
-- ============================================================
BEGIN;

-- ------------------------------------------------
-- INSERT CARDS (no missing keywords to add)
-- ------------------------------------------------

-- VampiricHell_CardSet_v2_1_Dextrous.xlsx::s1 row 2
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, unit_subtype, power, frontline_ability, backline_ability, command_ability, flavor_text, art_path) VALUES ('Scuttling Imp', 1, 'Unit', 1, false, 3, false, 'Imp', 300, '**Infiltrate.** When this unit destroys a Backline unit, your opponent discards 1 card at random from their hand.', NULL, NULL, 'They skitter ahead of the lords. The lords prefer it that way.', 'scuttling_imp.png');

INSERT INTO card_keywords (card_id, keyword_id, zone) VALUES (1, 6, 'frontline');

-- VampiricHell_CardSet_v2_1_Dextrous.xlsx::s1 row 3
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, unit_subtype, power, frontline_ability, backline_ability, command_ability, flavor_text, art_path) VALUES ('Thrall Hound', 1, 'Unit', 1, false, 3, false, 'Thrall', 350, '**Bloodlust** +50.', NULL, NULL, 'It doesn''t know what it wants. It only knows it hasn''t had enough.', 'thrall_hound.png');

INSERT INTO card_keywords (card_id, keyword_id, zone) VALUES (2, 10, 'frontline');

-- VampiricHell_CardSet_v2_1_Dextrous.xlsx::s1 row 4
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, unit_subtype, power, frontline_ability, backline_ability, command_ability, flavor_text, art_path) VALUES ('Sanguine Wretch', 1, 'Unit', 1, false, 3, false, 'Thrall', 250, NULL, '**Sanguine Offering** +300.', NULL, 'It offers itself before it is asked.', 'sanguine_wretch.png');

INSERT INTO card_keywords (card_id, keyword_id, zone) VALUES (3, 28, 'backline');

-- VampiricHell_CardSet_v2_1_Dextrous.xlsx::s1 row 5
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, unit_subtype, power, frontline_ability, backline_ability, command_ability, flavor_text, art_path) VALUES ('Hollowed Serf', 1, 'Unit', 1, false, 3, false, 'Thrall', 250, NULL, 'One chosen friendly Frontline unit gains **Dominion** until the start of your next Untap Phase.', '[LEGACY] Whenever a friendly unit with Dominion completes an attack this turn, gain 1 face-up Energy.', 'It serves. That is the whole of it.', 'hollowed_serf.png');

INSERT INTO card_keywords (card_id, keyword_id, zone) VALUES (4, 11, 'command');

-- VampiricHell_CardSet_v2_1_Dextrous.xlsx::s1 row 6
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, unit_subtype, power, frontline_ability, backline_ability, command_ability, flavor_text, art_path) VALUES ('Ashclaw Demon', 1, 'Unit', 2, false, 3, false, 'Demon', 550, '**Bloodlust** +50.', 'While this unit is in the Backline, when a friendly Frontline unit breaks a Shield, that unit gains +100 Power permanently.', NULL, 'The claws remember every kill. So does the Power.', 'ashclaw_demon.png');

INSERT INTO card_keywords (card_id, keyword_id, zone) VALUES (5, 10, 'frontline');

-- VampiricHell_CardSet_v2_1_Dextrous.xlsx::s1 row 7
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, unit_subtype, power, frontline_ability, backline_ability, command_ability, flavor_text, art_path) VALUES ('Vorreth the Gorger', 1, 'Unit', 2, false, 3, false, 'Demon', 500, '**Bloodlust** +50. **Dominion** [ENERGY: 1].', NULL, NULL, 'He doesn''t wait to be invited. He waits to be sated.', 'vorreth_the_gorger.png');

INSERT INTO card_keywords (card_id, keyword_id, zone) VALUES (6, 10, 'frontline');
INSERT INTO card_keywords (card_id, keyword_id, zone) VALUES (6, 27, 'frontline');

-- VampiricHell_CardSet_v2_1_Dextrous.xlsx::s1 row 8
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, unit_subtype, power, frontline_ability, backline_ability, command_ability, flavor_text, art_path) VALUES ('Pale Revenant', 1, 'Unit', 2, false, 3, false, 'Demon', 500, '**Reanimate.**', 'When this unit returns via Reanimate, it gains +200 Power until it leaves the field.', NULL, 'It does not fear death. It has met death. Death blinked.', 'pale_revenant.png');

INSERT INTO card_keywords (card_id, keyword_id, zone) VALUES (7, 9, 'backline');

-- VampiricHell_CardSet_v2_1_Dextrous.xlsx::s1 row 9
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, unit_subtype, power, frontline_ability, backline_ability, command_ability, flavor_text, art_path) VALUES ('Tithe Collector', 1, 'Unit', 2, false, 3, false, 'Demon', 500, 'When this unit breaks a Shield, that Shield is placed in your opponent''s Remnant Zone instead of their Energy Zone.', NULL, NULL, 'What you owe the throne, the throne collects.', 'tithe_collector.png');


-- VampiricHell_CardSet_v2_1_Dextrous.xlsx::s1 row 10
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, unit_subtype, power, frontline_ability, backline_ability, command_ability, flavor_text, art_path) VALUES ('Kael, the Hunger Unbound', 1, 'Unit', 3, false, 3, false, 'Devil', 850, '**Bloodlust** +50. **Dominion** [ENERGY: 1].', 'While this unit is in the Backline, all friendly Frontline units gain +100 Power.', NULL, 'Hunger is not a condition. It is a rank.', 'kael_the_hunger_unbound.png');

INSERT INTO card_keywords (card_id, keyword_id, zone) VALUES (9, 10, 'frontline');
INSERT INTO card_keywords (card_id, keyword_id, zone) VALUES (9, 27, 'frontline');

-- VampiricHell_CardSet_v2_1_Dextrous.xlsx::s1 row 11
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, unit_subtype, power, frontline_ability, backline_ability, command_ability, flavor_text, art_path) VALUES ('Serath, Duchess of Spite', 1, 'Unit', 3, false, 3, false, 'Devil', 650, '**Dominion** [ENERGY: 1]. When this unit attacks and your opponent has no face-up Energy, break one additional Shield.', 'Once per turn, one chosen friendly Frontline unit gains **Sentinel** until end of turn.', 'Friendly units enter the Frontline with +100 Power permanently.', 'She does not raise her voice. She raises the cost.', 'serath_duchess_of_spite.png');

INSERT INTO card_keywords (card_id, keyword_id, zone) VALUES (10, 27, 'frontline');
INSERT INTO card_keywords (card_id, keyword_id, zone) VALUES (10, 2, 'backline');

-- VampiricHell_CardSet_v2_1_Dextrous.xlsx::s1 row 12
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, unit_subtype, power, frontline_ability, backline_ability, command_ability, flavor_text, art_path) VALUES ('Gravoth the Immovable', 1, 'Unit', 3, false, 3, false, 'Devil', 900, '**Anchor.** When defending, this unit cannot be destroyed and takes no Power damage regardless of combat outcome.', NULL, NULL, 'The mountain does not argue. It simply remains.', 'gravoth_the_immovable.png');

INSERT INTO card_keywords (card_id, keyword_id, zone) VALUES (11, 8, 'frontline');

-- VampiricHell_CardSet_v2_1_Dextrous.xlsx::s1 row 13
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, unit_subtype, power, frontline_ability, backline_ability, command_ability, flavor_text, art_path) VALUES ('Lord Varek, Hand of Ruin', 1, 'Unit', 4, false, 3, false, 'Vampire', 1100, '**Bloodlust** +50. **Pierce.**', 'While this unit is in the Backline, all friendly Frontline units gain +100 Power.', 'When your General Advances to Rank 4, all friendly units gain +150 Power permanently.', 'Ruin is not what he brings. Ruin is what he leaves.', 'lord_varek_hand_of_ruin.png');

INSERT INTO card_keywords (card_id, keyword_id, zone) VALUES (12, 10, 'frontline');
INSERT INTO card_keywords (card_id, keyword_id, zone) VALUES (12, 5, 'frontline');

-- VampiricHell_CardSet_v2_1_Dextrous.xlsx::s1 row 14
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, unit_subtype, power, frontline_ability, backline_ability, command_ability, flavor_text, art_path) VALUES ('Vael Morvaine, the First Hunger', 1, 'Unit', 4, true, 1, true, 'Vampire', 1000, '**Dominion** [ENERGY: 1].', '[ENERGY: 2] Once per turn: destroy up to 2 friendly units in any zone — this is not combat. One chosen friendly unit gains Power equal to the total base Power of all units destroyed this way permanently. Vael gains +100 Power permanently for each unit destroyed this way. Each unit destroyed by this ability triggers its Surge before entering the Remnant Zone.', '**Ascendant.** **Blood Tithe.**', 'The first hunger was not for blood. It was for everything.', 'vael_morvaine.png');

INSERT INTO card_keywords (card_id, keyword_id, zone) VALUES (13, 36, 'command');
INSERT INTO card_keywords (card_id, keyword_id, zone) VALUES (13, 29, 'command');
INSERT INTO card_keywords (card_id, keyword_id, zone) VALUES (13, 27, 'frontline');

-- VampiricHell_CardSet_v2_1_Dextrous.xlsx::s1 row 15
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, unit_subtype, power, frontline_ability, backline_ability, command_ability, flavor_text, art_path) VALUES ('Voidfang Colossus', 1, 'Unit', 4, false, 3, false, 'Vampire', 1200, '**Anchor. Pierce.**', NULL, '[ENERGY: 1] per unit: chosen friendly Frontline units gain **Pierce** until end of turn.', 'It does not threaten. The threat is structural.', 'voidfang_colossus.png');

INSERT INTO card_keywords (card_id, keyword_id, zone) VALUES (14, 8, 'frontline');
INSERT INTO card_keywords (card_id, keyword_id, zone) VALUES (14, 5, 'command');

-- VampiricHell_CardSet_v2_1_Dextrous.xlsx::s1 row 16
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, unit_subtype, power, frontline_ability, backline_ability, command_ability, flavor_text, art_path) VALUES ('Malachar the Undying', 1, 'Unit', 4, false, 3, false, 'Vampire', 1050, '**Bloodlust** +50. **Reanimate** — returns to Frontline at base Power +150 with **Blitz**.', 'While this unit is in the Backline, when a friendly unit with Reanimate returns from the Remnant Zone, it gains +100 Power permanently.', 'At the start of your turn, if a friendly unit was destroyed last turn, gain 1 face-up Energy.', 'It came back. It always comes back. The real question is what it comes back as.', 'malachar_the_undying.png');

INSERT INTO card_keywords (card_id, keyword_id, zone) VALUES (15, 10, 'frontline');
INSERT INTO card_keywords (card_id, keyword_id, zone) VALUES (15, 9, 'backline');

-- VampiricHell_CardSet_v2_1_Dextrous.xlsx::s2 row 2
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, burst_subtype, effect_text, flavor_text, art_path) VALUES ('Blood Frenzy', 1, 'Burst', 1, false, 3, false, 'Cast', 'Choose one friendly Frontline unit with **Bloodlust**. That unit gains +200 Power until end of turn.', 'They call it a frenzy. The survivors call it a warning.', 'blood_frenzy.png');


-- VampiricHell_CardSet_v2_1_Dextrous.xlsx::s2 row 3
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, burst_subtype, effect_text, flavor_text, art_path) VALUES ('The Feeding', 1, 'Burst', 1, false, 3, false, 'Reaction', 'TRIGGER: A friendly unit is destroyed by combat. One chosen friendly unit gains +150 Power permanently.', 'Nothing is wasted. That is the first law of the Hell.', 'the_feeding.png');


-- VampiricHell_CardSet_v2_1_Dextrous.xlsx::s2 row 4
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, burst_subtype, effect_text, flavor_text, art_path) VALUES ('Scarlet Surge', 1, 'Burst', 3, false, 3, false, 'Cast', 'All friendly Frontline units gain +150 Power until end of turn. If three or more friendly units are in the Frontline at the moment this card is played, each unit also gains **Pierce** for their attacks this turn.', 'Red is not a warning here. It is an invitation.', 'scarlet_surge.png');


-- VampiricHell_CardSet_v2_1_Dextrous.xlsx::s2 row 5
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, burst_subtype, effect_text, flavor_text, art_path) VALUES ('Null the Feed', 1, 'Burst', 2, false, 3, false, 'Reaction', 'TRIGGER: An opponent activates an [ENERGY: X] ability. Negate that ability. The Energy cost is still paid — the ability does not resolve.', 'You spent it. You just didn''t get anything for it.', 'null_the_feed.png');


-- VampiricHell_CardSet_v2_1_Dextrous.xlsx::s2 row 6
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, burst_subtype, effect_text, flavor_text, art_path) VALUES ('Blood Debt', 1, 'Burst', 3, false, 3, false, 'Cast', 'Choose one friendly unit destroyed this turn. Return it to your Frontline at its base Power with **Blitz**. Cannot target units whose Reanimate trigger is currently pending.', 'The debt is not to you. The debt is to the throne.', 'blood_debt.png');


-- VampiricHell_CardSet_v2_1_Dextrous.xlsx::s2 row 7
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, augment_subtype, effect_text, flavor_text, art_path) VALUES ('Fanged Gauntlet', 1, 'Augment', 1, false, 3, false, 'Weapon', 'The equipped unit gains **Dominion** [ENERGY: 1]. If the equipped unit already has **Dominion**, its Dominion also prevents the defending player from playing any Burst — Reaction cards during the resolution of its attack.', 'The gauntlet does not make the hand. It completes it.', 'fanged_gauntlet.png');

INSERT INTO card_keywords (card_id, keyword_id, zone) VALUES (21, 27, 'passive');

-- VampiricHell_CardSet_v2_1_Dextrous.xlsx::s2 row 8
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, augment_subtype, effect_text, flavor_text, art_path) VALUES ('Soulchain Mantle', 1, 'Augment', 1, false, 3, false, 'Armor', 'When the equipped unit would be destroyed by combat, you may destroy this Augment instead.', 'The chain holds. Until it doesn''t.', 'soulchain_mantle.png');


-- VampiricHell_CardSet_v2_1_Dextrous.xlsx::s2 row 9
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, augment_subtype, effect_text, flavor_text, art_path) VALUES ('The Marrow Crown', 1, 'Augment', 2, false, 3, false, 'Relic', 'The equipped unit gains +200 Power.', 'The crown does not sit on the head. It grows into it.', 'the_marrow_crown.png');


-- VampiricHell_CardSet_v2_1_Dextrous.xlsx::s3 row 2
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, effect_text, flavor_text, art_path) VALUES ('Crimson Cascade', 1, 'Rift', 2, false, 3, false, '[Both players] When any unit is destroyed by combat, its controller gains 1 face-up Energy.', 'It flows where the fighting is thickest. It does not distinguish.', 'crimson_cascade.png');


-- VampiricHell_CardSet_v2_1_Dextrous.xlsx::s3 row 3
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, effect_text, flavor_text, art_path) VALUES ('Blood Moon Protocol', 1, 'Rift', 2, false, 3, false, '[Both players] All units with **Bloodlust** have their kill bonus increased by +25. All units with **Reanimate** return from the Remnant Zone with +100 Power added on top of their base Power.', 'The moon does not bleed for you. You bleed for it.', 'blood_moon_protocol.png');


-- VampiricHell_CardSet_v2_1_Dextrous.xlsx::s3 row 4
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, effect_text, flavor_text, art_path) VALUES ('The Starved Dimension', 1, 'Rift', 3, false, 3, false, '[Both players] At the start of each player''s turn, if that player has no face-up Energy, one chosen unit on their side loses 100 Power until their next Untap Phase. Units reduced to 0 Power or below are immediately destroyed — this is not combat.', 'The dimension does not hate you. It is simply empty.', 'the_starved_dimension.png');


-- DataKingdom_DextrousSheet_v2_4.xlsx::s1 row 2
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, unit_subtype, power, frontline_ability, backline_ability, command_ability, flavor_text, art_path) VALUES ('Glitchling', 3, 'Unit', 1, false, 3, false, 'Feral', 300, '**Blitz.**', 'When this unit moves to the Frontline it gains +50 Power until end of turn.', NULL, 'It wasn''t supposed to survive the compile. Most things that hunger don''t.', 'glitchling.png');

INSERT INTO card_keywords (card_id, keyword_id, zone) VALUES (27, 1, 'frontline');

-- DataKingdom_DextrousSheet_v2_4.xlsx::s1 row 3
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, unit_subtype, power, frontline_ability, backline_ability, command_ability, flavor_text, art_path) VALUES ('Dataseed', 3, 'Unit', 1, false, 3, false, 'Embryonic', 250, NULL, 'Uplink +150.', '[LEGACY] Start of your turn: look at the top card of your deck. [ENERGY: 1]: place it on the bottom instead.', 'The Kingdom doesn''t conquer territory. It roots into it.', 'dataseed.png');

INSERT INTO card_keywords (card_id, keyword_id, zone) VALUES (28, 11, 'command');
INSERT INTO card_keywords (card_id, keyword_id, zone) VALUES (28, 30, 'backline');

-- DataKingdom_DextrousSheet_v2_4.xlsx::s1 row 4
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, unit_subtype, power, frontline_ability, backline_ability, command_ability, flavor_text, art_path) VALUES ('Pinglet', 3, 'Unit', 1, false, 3, false, 'Relay', 200, NULL, 'Uplink +200. When paired ally attacks this turn draw 1 card.', '[LEGACY] Start of your turn: one friendly Backline unit gains +50 Power permanently.', 'Every message it relays makes the ones behind it a little stronger. That''s not loyalty. That''s infrastructure.', 'pinglet.png');

INSERT INTO card_keywords (card_id, keyword_id, zone) VALUES (29, 11, 'command');
INSERT INTO card_keywords (card_id, keyword_id, zone) VALUES (29, 30, 'backline');

-- DataKingdom_DextrousSheet_v2_4.xlsx::s1 row 5
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, unit_subtype, power, frontline_ability, backline_ability, command_ability, flavor_text, art_path) VALUES ('Scriptling', 3, 'Unit', 1, false, 3, false, 'Scribe', 275, 'When this unit defends and survives look at the top 2 cards of your deck and rearrange in any order.', 'Uplink +100. [ENERGY: 1]: Look at the top card of your opponent''s deck. You may place it on the bottom.', NULL, 'It doesn''t fight. It reads. By the time you realize what it learned it''s already told someone.', 'scriptling.png');

INSERT INTO card_keywords (card_id, keyword_id, zone) VALUES (30, 30, 'backline');

-- DataKingdom_DextrousSheet_v2_4.xlsx::s1 row 6
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, unit_subtype, power, frontline_ability, backline_ability, command_ability, flavor_text, art_path) VALUES ('Hexwolf', 3, 'Unit', 2, false, 3, false, 'Predator', 550, '**Bloodlust** (+50).', 'Paired Frontline unit gains +50 Power while Hexwolf remains in this Backline slot.', 'Friendly Rank 1 units gain +50 Power.', 'The first kill teaches it. The second proves it. After the third it stops counting.', 'hexwolf.png');

INSERT INTO card_keywords (card_id, keyword_id, zone) VALUES (31, 10, 'frontline');

-- DataKingdom_DextrousSheet_v2_4.xlsx::s1 row 7
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, unit_subtype, power, frontline_ability, backline_ability, command_ability, flavor_text, art_path) VALUES ('Ironscale', 3, 'Unit', 2, false, 3, false, 'Wyvern', 600, '**Sentinel.**', NULL, 'Friendly Frontline units cannot be targeted by Burst — Reaction cards this turn.', 'It holds the line not because it was ordered to — but because it has calculated that nothing else will.', 'ironscale.png');

INSERT INTO card_keywords (card_id, keyword_id, zone) VALUES (32, 2, 'frontline');

-- DataKingdom_DextrousSheet_v2_4.xlsx::s1 row 8
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, unit_subtype, power, frontline_ability, backline_ability, command_ability, flavor_text, art_path) VALUES ('Relayhorn', 3, 'Unit', 2, false, 3, false, 'Amplifier', 400, NULL, 'Uplink +200. All friendly Backline units'' Boost contribution increases by +50 this turn.', '[ENERGY: 1]: All friendly Backline units'' Boost contribution increases by +100 this turn.', 'Two signals one source. The battlefield doesn''t know which one to watch.', 'relayhorn.png');

INSERT INTO card_keywords (card_id, keyword_id, zone) VALUES (33, 30, 'backline');

-- DataKingdom_DextrousSheet_v2_4.xlsx::s1 row 9
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, unit_subtype, power, frontline_ability, backline_ability, command_ability, flavor_text, art_path) VALUES ('Phantombyte', 3, 'Unit', 2, false, 3, false, 'Specter', 500, '**Infiltrate.**', 'Uplink +150. When paired ally attacks this turn it gains Infiltrate until end of turn.', NULL, 'Your Frontline is a wall. Walls have two sides.', 'phantombyte.png');

INSERT INTO card_keywords (card_id, keyword_id, zone) VALUES (34, 6, 'backline');
INSERT INTO card_keywords (card_id, keyword_id, zone) VALUES (34, 30, 'backline');

-- DataKingdom_DextrousSheet_v2_4.xlsx::s1 row 10
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, unit_subtype, power, frontline_ability, backline_ability, command_ability, flavor_text, art_path) VALUES ('Packet', 3, 'Unit', 2, false, 3, false, 'Fragment', 400, NULL, NULL, NULL, 'Search your deck for any one card. Add it to your hand. Shuffle.', 'Fragile by design. What it carries is not.');


-- DataKingdom_DextrousSheet_v2_4.xlsx::s1 row 11
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, unit_subtype, power, frontline_ability, backline_ability, command_ability, flavor_text, art_path) VALUES ('Cache', 3, 'Unit', 2, false, 3, false, 'Reservoir', 400, NULL, 'Gain 1 Energy OR spend 1 Energy to look at the top 2 cards of your opponent''s deck.', NULL, 'Gain 2 Energy. All friendly units gain +150 Power until your next Untap Phase.', 'Every kingdom needs a treasury. The smart ones keep theirs somewhere no one thinks to look.');


-- DataKingdom_DextrousSheet_v2_4.xlsx::s1 row 12
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, unit_subtype, power, frontline_ability, backline_ability, command_ability, flavor_text, art_path) VALUES ('Sir Nullbyte', 3, 'Unit', 3, false, 3, false, 'Knight', 750, '**Sentinel.** When this unit defends and destroys the attacker draw 1 card.', 'Uplink +250. When paired ally attacks this turn it gains Sentinel until end of turn.', '[ENERGY: 2]: All friendly Frontline units gain **Sentinel** until your next Untap Phase.', 'He was a Knight before the Fracture. Now he is something closer to a theorem.', 'sir_nullbyte.png');

INSERT INTO card_keywords (card_id, keyword_id, zone) VALUES (37, 2, 'command');
INSERT INTO card_keywords (card_id, keyword_id, zone) VALUES (37, 30, 'backline');

-- DataKingdom_DextrousSheet_v2_4.xlsx::s1 row 13
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, unit_subtype, power, frontline_ability, backline_ability, command_ability, flavor_text, art_path) VALUES ('Carrion Phoenix', 3, 'Unit', 3, false, 3, false, 'Aberrant', 650, '**Blitz.** [ENERGY: 1]: When this unit is destroyed return it to your hand instead of the Remnant Zone.', 'When this unit moves to the Frontline it gains +150 Power until end of turn.', 'Friendly units with **Blitz** gain +100 Power on the turn they enter the Frontline.', 'Delete it. It will return. The Kingdom keeps backups of everything it values.', 'carrion_phoenix.png');

INSERT INTO card_keywords (card_id, keyword_id, zone) VALUES (38, 1, 'command');

-- DataKingdom_DextrousSheet_v2_4.xlsx::s1 row 14
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, unit_subtype, power, frontline_ability, backline_ability, command_ability, flavor_text, art_path) VALUES ('Grandmast', 3, 'Unit', 3, false, 3, false, 'Conductor', 600, NULL, 'Uplink +300. If paired ally has an Augment equipped its Boost receives an additional +150 this turn.', 'Friendly units may hold one additional Augment. (Units: max 3. General: max 4.)', 'He doesn''t need to fight. He needs to conduct. The difference is who comes home.', 'grandmast.png');

INSERT INTO card_keywords (card_id, keyword_id, zone) VALUES (39, 30, 'backline');

-- DataKingdom_DextrousSheet_v2_4.xlsx::s1 row 15
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, unit_subtype, power, frontline_ability, backline_ability, command_ability, flavor_text, art_path) VALUES ('Vexserpent', 3, 'Unit', 3, false, 3, false, 'Corruptor', 650, 'When this unit attacks the target loses 100 Power until your next Untap Phase. [ENERGY: 1]: the loss is permanent instead.', 'Uplink +200. [ENERGY: 1]: When paired ally attacks this turn the defending player reveals their hand before declaring defenders.', '[ENERGY: 2]: All enemy Frontline units lose 100 Power until your next Untap Phase.', 'It doesn''t steal your secrets. It just makes sure you use them at the wrong moment.', 'vexserpent.png');

INSERT INTO card_keywords (card_id, keyword_id, zone) VALUES (40, 30, 'backline');

-- DataKingdom_DextrousSheet_v2_4.xlsx::s1 row 16
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, unit_subtype, power, frontline_ability, backline_ability, command_ability, flavor_text, art_path) VALUES ('Kaijuggernaut', 3, 'Unit', 4, false, 3, false, 'Titan', 1200, '**Pierce. Anchor.**', NULL, 'Friendly Frontline units gain **Pierce**.', 'The Kingdom built it to end arguments. It has never failed to do so.', 'kaijuggernaut.png');

INSERT INTO card_keywords (card_id, keyword_id, zone) VALUES (41, 8, 'frontline');
INSERT INTO card_keywords (card_id, keyword_id, zone) VALUES (41, 5, 'command');

-- DataKingdom_DextrousSheet_v2_4.xlsx::s1 row 17
-- WARNING: General exceeds 1000 cap (Power=1100)
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, unit_subtype, power, frontline_ability, backline_ability, command_ability, flavor_text, art_path) VALUES ('REGULUS-PRIME', 3, 'Unit', 4, true, 1, true, 'Sovereign', 1100, '**Aegis.** When this unit attacks and destroys all defenders break one additional Shield.', 'Uplink +300. When paired ally attacks this turn it gains Aegis until end of turn.', '**Ascendant.** Start of your turn: draw 1 extra card.', 'There was a vote. It was unanimous. There was only one voter.', 'regulus-prime.png');

INSERT INTO card_keywords (card_id, keyword_id, zone) VALUES (42, 4, 'backline');
INSERT INTO card_keywords (card_id, keyword_id, zone) VALUES (42, 36, 'command');
INSERT INTO card_keywords (card_id, keyword_id, zone) VALUES (42, 30, 'backline');

-- DataKingdom_DextrousSheet_v2_4.xlsx::s1 row 18
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, unit_subtype, power, frontline_ability, backline_ability, command_ability, flavor_text, art_path) VALUES ('Nullgod Axiom', 3, 'Unit', 4, false, 3, false, 'Construct', 950, '[ENERGY: 2]: This turn friendly Backline units may both Boost and use their Backline ability.', 'Uplink +400. When paired ally attacks this turn it may attack a second time at half current Power.', 'Ascendant. Start of your turn: each friendly Backline unit''s Boost contribution increases by +100 permanently.', 'It does not give orders. It rewrites the conditions under which orders become unnecessary.', 'nullgod_axiom.png');

INSERT INTO card_keywords (card_id, keyword_id, zone) VALUES (43, 36, 'command');
INSERT INTO card_keywords (card_id, keyword_id, zone) VALUES (43, 30, 'backline');

-- DataKingdom_DextrousSheet_v2_4.xlsx::s1 row 19
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, unit_subtype, power, frontline_ability, backline_ability, command_ability, flavor_text, art_path) VALUES ('Deepform Leviathan', 3, 'Unit', 4, false, 3, false, 'Leviathan', 1100, '**Anchor. Pierce.** When this unit breaks a Shield the defending player discards 1 card at random.', 'Uplink +350. If paired ally breaks a Shield this turn it gains +100 Power permanently.', 'When a friendly unit breaks a Shield draw 1 card.', 'It surfaces long enough to take what it wants. Then it goes back down.', 'deepform_leviathan.png');

INSERT INTO card_keywords (card_id, keyword_id, zone) VALUES (44, 8, 'frontline');
INSERT INTO card_keywords (card_id, keyword_id, zone) VALUES (44, 5, 'frontline');
INSERT INTO card_keywords (card_id, keyword_id, zone) VALUES (44, 30, 'backline');

-- DataKingdom_DextrousSheet_v2_4.xlsx::s2 row 2
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, burst_subtype, effect_text, flavor_text, art_path) VALUES ('Signal Spike', 3, 'Burst', 1, false, 3, false, 'Reaction', 'TRIGGER: An enemy Backline unit activates its Backline ability. Negate it. That unit is still tapped this turn.', 'Your command reached its destination. We declined the delivery.', 'signal_spike.png');


-- DataKingdom_DextrousSheet_v2_4.xlsx::s2 row 3
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, burst_subtype, effect_text, flavor_text, art_path) VALUES ('Surge Protocol', 3, 'Burst', 1, false, 3, false, 'Reaction', 'TRIGGER: A Shield is broken. Draw 2 cards then look at the top card — place it on top or bottom.', 'A broken Shield is not a setback. It is a trigger condition.', 'surge_protocol.png');


-- DataKingdom_DextrousSheet_v2_4.xlsx::s2 row 4
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, burst_subtype, effect_text, flavor_text, art_path) VALUES ('System Flush', 3, 'Burst', 2, false, 3, false, 'Cast', 'All Frontline units on both sides lose 200 Power until end of turn. Units at 0 or below cannot act this round.', 'Symmetry is a weapon when you already know which side survives the reset.', 'system_flush.png');


-- DataKingdom_DextrousSheet_v2_4.xlsx::s2 row 5
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, burst_subtype, effect_text, flavor_text, art_path) VALUES ('Emergency Patch', 3, 'Burst', 2, false, 3, false, 'Reaction', 'TRIGGER: A friendly unit would be destroyed by combat. It survives at 1 Power then is destroyed at end of turn.', 'It will not save them. It will save the next turn.', 'emergency_patch.png');


-- DataKingdom_DextrousSheet_v2_4.xlsx::s2 row 6
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, burst_subtype, effect_text, flavor_text, art_path) VALUES ('Overclock Burst', 3, 'Burst', 2, false, 3, false, 'Cast', 'Double one Backline unit''s **Uplink** value until your next Untap Phase. If the new value exceeds 400 that Frontline ally also gains **Blitz** until end of turn.', 'Rated for one cycle. The Kingdom runs it until something better breaks.', 'overclock_burst.png');


-- DataKingdom_DextrousSheet_v2_4.xlsx::s2 row 7
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, burst_subtype, effect_text, flavor_text, art_path) VALUES ('Binary Strike', 3, 'Burst', 2, false, 3, false, 'Cast', 'One Frontline ally gains +300 Power until end of turn. If it has **Blitz** or has already attacked it may immediately attack once more at base Power only.', 'One attack is a question. Two is the answer.', 'binary_strike.png');


-- DataKingdom_DextrousSheet_v2_4.xlsx::s2 row 8
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, burst_subtype, effect_text, flavor_text, art_path) VALUES ('Echo Function', 3, 'Burst', 3, false, 3, false, 'Reaction', 'TRIGGER: A friendly unit activates a zone ability. That ability resolves a second time. Cannot trigger on itself or another Echo Function.', 'The ability fired once. Then it fired again. The logs show only one event.', 'echo_function.png');


-- DataKingdom_DextrousSheet_v2_4.xlsx::s2 row 9
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, augment_subtype, effect_text, flavor_text, art_path) VALUES ('Fractal Plating', 3, 'Augment', 1, false, 3, false, 'Armor', 'The equipped unit''s Power cannot be reduced by enemy abilities or Burst cards.', 'Every layer they strip away reveals another. They designed it that way.', 'fractal_plating.png');


-- DataKingdom_DextrousSheet_v2_4.xlsx::s2 row 10
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, augment_subtype, effect_text, flavor_text, art_path) VALUES ('Adaptive Shell', 3, 'Augment', 1, false, 3, false, 'Armor', 'When an enemy ability or Burst would reduce this unit''s Power convert that reduction to a Power gain instead. Maximum +200 per turn.', 'It learned from the first hit. The second one fed it.', 'adaptive_shell.png');


-- DataKingdom_DextrousSheet_v2_4.xlsx::s2 row 11
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, augment_subtype, effect_text, flavor_text, art_path) VALUES ('Overclock Chip', 3, 'Augment', 2, false, 3, false, 'Relic', 'Overcharge. The equipped unit may use its zone ability one additional time per turn. Cannot be Overcharged more than once per turn. Subject to Zone Ability Use Cap (max 2 uses/turn).', 'Warranty voided. Performance ceiling: revised upward.', 'overclock_chip.png');

INSERT INTO card_keywords (card_id, keyword_id, zone) VALUES (54, 14, 'passive');

-- DataKingdom_DextrousSheet_v2_4.xlsx::s2 row 12
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, augment_subtype, effect_text, flavor_text, art_path) VALUES ('Phase Shifter', 3, 'Augment', 2, false, 3, false, 'Relic', 'Once per turn the equipped unit may use any ability in its zone boxes regardless of which zone it occupies. Replaces its normal ability use. Zone rules still apply.', 'It was designed for one role. It filed for the others.', 'phase_shifter.png');


-- DataKingdom_DextrousSheet_v2_4.xlsx::s3 row 2
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, effect_text, flavor_text, art_path) VALUES ('Bleed Incursion', 3, 'Rift', 2, false, 3, false, '[Both players] When a Shield is broken without a **Surge** ability its controller draws 1 card. Cards with **Surge** trigger normally.', 'The dimensional walls don''t just break here. They transmit.', 'bleed_incursion.png');


-- DataKingdom_DextrousSheet_v2_4.xlsx::s3 row 3
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, effect_text, flavor_text, art_path) VALUES ('The Infinite Server', 3, 'Rift', 3, false, 3, false, '[Both players] Draw 3 cards in Phase 1. Discard to 7 in Phase 6.', 'More data. Less time to hold it. The Kingdom considers this an acceptable trade.', 'the_infinite_server.png');


-- DataKingdom_DextrousSheet_v2_4.xlsx::s3 row 4
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, effect_text, flavor_text, art_path) VALUES ('Sovereign Signal', 3, 'Rift', 3, false, 3, false, '[Both players] Data Kingdom Backline units gain **Interceptor**. Non-Data Kingdom Backline units cannot use their Backline abilities.', 'Every frequency belongs to someone. The Kingdom filed the claim before the war started.', 'sovereign_signal.png');


-- TheRot_CardSet_v1_2_Dextrous.xlsx::s1 row 2
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, unit_subtype, power, frontline_ability, backline_ability, command_ability, flavor_text, art_path) VALUES ('Creeping Feral', 2, 'Unit', 1, false, 3, false, 'Feral', 200, 'Infiltrate. When this unit destroys a Backline unit via Infiltrate you may immediately attach that unit to one friendly unit as an Enshroud Augment.', 'When this unit returns via Reanimate gain 1 face-up Energy.', NULL, 'It does not stalk. It seeps.', 'creeping_feral.png');

INSERT INTO card_keywords (card_id, keyword_id, zone) VALUES (59, 6, 'frontline');
INSERT INTO card_keywords (card_id, keyword_id, zone) VALUES (59, 9, 'backline');

-- TheRot_CardSet_v1_2_Dextrous.xlsx::s1 row 3
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, unit_subtype, power, frontline_ability, backline_ability, command_ability, flavor_text, art_path) VALUES ('Rot-Touched Serf', 2, 'Unit', 1, false, 3, false, 'Blighted', 275, NULL, 'Remnant Strength. While this unit is in the Backline one chosen Frontline ally gains +50 Power for each unit card in your Remnant Zone. Maximum +200.', '[LEGACY] At the start of your turn if 3 or more unit cards are in your Remnant Zone all friendly units gain +50 Power permanently. Triggers once per turn.', 'It served before. It serves after. It will serve again.', 'rot_touched_serf.png');

INSERT INTO card_keywords (card_id, keyword_id, zone) VALUES (60, 11, 'command');

-- TheRot_CardSet_v1_2_Dextrous.xlsx::s1 row 4
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, unit_subtype, power, frontline_ability, backline_ability, command_ability, flavor_text, art_path) VALUES ('Spore-Drifter', 2, 'Unit', 1, false, 3, false, 'Feral', 225, 'When this unit is destroyed by any means the opponent discards 1 card at random from their hand.', 'Once per turn look at the top 2 cards of your opponent''s deck without revealing them. You may place one or both at the bottom of their deck in any order.', NULL, 'Send the top 3 cards of your opponent''s deck to their Remnant Zone.', 'You breathe it in before you see it.');


-- TheRot_CardSet_v1_2_Dextrous.xlsx::s1 row 5
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, unit_subtype, power, frontline_ability, backline_ability, command_ability, flavor_text, art_path) VALUES ('Hollowed Vessel', 2, 'Unit', 1, false, 3, false, 'Blighted', 300, NULL, 'Wither. Tap: Destroy this unit. One chosen friendly unit gains Reanimate until end of turn. If that unit already has Reanimate it gains +200 Power until end of turn instead.', NULL, 'It is not empty. It is waiting.', 'hollowed_vessel.png');

INSERT INTO card_keywords (card_id, keyword_id, zone) VALUES (62, 23, 'backline');

-- TheRot_CardSet_v1_2_Dextrous.xlsx::s1 row 6
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, unit_subtype, power, frontline_ability, backline_ability, command_ability, flavor_text, art_path) VALUES ('Hollow Crown', 2, 'Unit', 2, false, 3, false, 'Blighted', 450, 'Enshroud one active enemy unit onto this unit.', NULL, '[LEGACY] Friendly units carrying an Enshrouded card gain +100 Power.', 'What it wears it becomes. What it becomes it keeps.', 'hollow_crown.png');

INSERT INTO card_keywords (card_id, keyword_id, zone) VALUES (63, 35, 'command');
INSERT INTO card_keywords (card_id, keyword_id, zone) VALUES (63, 11, 'command');

-- TheRot_CardSet_v1_2_Dextrous.xlsx::s1 row 7
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, unit_subtype, power, frontline_ability, backline_ability, command_ability, flavor_text, art_path) VALUES ('Blightweaver', 2, 'Unit', 2, false, 3, false, 'Rot-Speaker', 450, 'Reanimate. When this unit returns via Reanimate it returns at its base Power.', 'When any friendly unit is destroyed this turn this unit permanently gains +50 Power.', 'At the start of your turn each friendly Reanimate unit in your Remnant Zone may pay 1 face-up Energy to return at full base Power instead of half.', 'It does not mourn the dead. It counts them.', 'blightweaver.png');

INSERT INTO card_keywords (card_id, keyword_id, zone) VALUES (64, 9, 'command');

-- TheRot_CardSet_v1_2_Dextrous.xlsx::s1 row 8
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, unit_subtype, power, frontline_ability, backline_ability, command_ability, flavor_text, art_path) VALUES ('Sap-Drinker', 2, 'Unit', 2, false, 3, false, 'Feral', 500, 'Infiltrate. When this unit destroys a Backline unit the opponent loses 1 face-up Energy (returned to supply).', 'While this unit is in the Backline all friendly Infiltrate units gain +100 Power.', NULL, 'It does not drink blood. It drinks momentum.', 'sap_drinker.png');

INSERT INTO card_keywords (card_id, keyword_id, zone) VALUES (65, 6, 'backline');

-- TheRot_CardSet_v1_2_Dextrous.xlsx::s1 row 9
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, unit_subtype, power, frontline_ability, backline_ability, command_ability, flavor_text, art_path) VALUES ('Rot-Speaker Acolyte', 2, 'Unit', 2, false, 3, false, 'Rot-Speaker', 400, 'When this unit defends and survives combat look at all cards in the opponent''s Remnant Zone without revealing them.', 'Remnant Aura. All friendly Frontline units gain +75 Power for each unit card in your Remnant Zone. Maximum +225. Resets at start of your Untap Phase.', 'All friendly Reanimate units return at 75% of their base Power rounded down instead of 50%.', 'All friendly units gain +150 Power until the start of your next Untap Phase.', 'She reads the dead to understand the living.');


-- TheRot_CardSet_v1_2_Dextrous.xlsx::s1 row 10
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, unit_subtype, power, frontline_ability, backline_ability, command_ability, flavor_text, art_path) VALUES ('The Grove-Speaker', 2, 'Unit', 3, false, 3, false, 'Grove-Speaker', 650, '[ENERGY: 1] All friendly units gain Power equal to the number of unit cards in your Remnant Zone × 50 until end of turn. Maximum +300.', 'Mycelial Web. Once per turn one chosen Backline unit may Boost any Frontline unit ignoring positional pairing. This Boost uses that Backline unit''s full Power and follows all standard Boost rules.', 'Ascendant. At the start of your turn look at the top 2 cards of your deck. For each unit with Reanimate among them place it in your Remnant Zone — it immediately returns to your Backline at half Power. Draw any remaining cards.', 'The grove does not speak to you. It speaks through you.', 'the_grove_speaker.png');

INSERT INTO card_keywords (card_id, keyword_id, zone) VALUES (67, 36, 'command');

-- TheRot_CardSet_v1_2_Dextrous.xlsx::s1 row 11
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, unit_subtype, power, frontline_ability, backline_ability, command_ability, flavor_text, art_path) VALUES ('Putrefact the Unmooring', 2, 'Unit', 3, false, 3, false, 'Hollowed', 800, 'Reanimate. When this unit returns via Reanimate it may return to the Frontline instead of the Backline at half Power. If it does it may immediately declare one attack as if it had Blitz.', 'When any friendly Reanimate unit returns from the Remnant Zone this turn all friendly units gain +100 Power until the start of your next Untap Phase.', 'All friendly Reanimate units in the Frontline cannot be targeted by Burst — Reaction cards during the resolution of their attacks.', 'It came back wrong. It came back better.', 'putrefact_the_unmooring.png');

INSERT INTO card_keywords (card_id, keyword_id, zone) VALUES (68, 9, 'command');

-- TheRot_CardSet_v1_2_Dextrous.xlsx::s1 row 12
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, unit_subtype, power, frontline_ability, backline_ability, command_ability, flavor_text, art_path) VALUES ('Mycelium Titan', 2, 'Unit', 3, false, 3, false, 'Aberrant', 800, 'Anchor. When this unit would be destroyed by combat it instead survives and loses all Power bonuses applied since your last Untap Phase resetting to base Power for this round. This effect triggers once per round.', 'While this unit is in the Backline all friendly Reanimate units return at 75% of their base Power instead of 50%.', NULL, 'Place the top 2 cards of your deck in your Remnant Zone. Gain 1 face-up Energy for each unit with Reanimate among them.', 'It has been here longer than the war. It will be here after.');


-- TheRot_CardSet_v1_2_Dextrous.xlsx::s1 row 13
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, unit_subtype, power, frontline_ability, backline_ability, command_ability, flavor_text, art_path) VALUES ('Pale Hunger', 2, 'Unit', 3, false, 3, false, 'Rot-Speaker', 600, 'Reanimate. When this unit returns via Reanimate one chosen enemy unit loses 150 Power permanently.', 'Once per turn when an enemy unit uses any zone ability tap this unit to reduce that unit''s Power by 100 until your next Untap Phase.', 'Enemy units entering the Frontline enter with −100 Power permanently. This reduction applies before any Power-granting effects that trigger on entry.', 'It does not hate you. It is simply always hungry.', 'pale_hunger.png');

INSERT INTO card_keywords (card_id, keyword_id, zone) VALUES (70, 9, 'frontline');

-- TheRot_CardSet_v1_2_Dextrous.xlsx::s1 row 14
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, unit_subtype, power, frontline_ability, backline_ability, command_ability, flavor_text, art_path) VALUES ('The Grove-Speaker Ascendant', 2, 'Unit', 4, false, 3, false, 'Grove-Speaker', 1000, NULL, 'Mycelial Lattice. All friendly Backline units may Boost any Frontline unit this turn ignoring positional pairing. When a Backline unit Boosts this way it may also use its Backline ability in the same turn without tapping.', 'Ascendant. Network Harvest. At the start of your turn look at the top 3 cards of your deck. Place any units with Reanimate among them in your Remnant Zone — they immediately return to your Backline at full base Power. Place remaining cards back in any order.', 'The grove no longer needs to speak. It simply is.', 'grove_speaker_ascendant.png');

INSERT INTO card_keywords (card_id, keyword_id, zone) VALUES (71, 36, 'command');

-- TheRot_CardSet_v1_2_Dextrous.xlsx::s1 row 15
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, unit_subtype, power, frontline_ability, backline_ability, command_ability, flavor_text, art_path) VALUES ('The Unmoored', 2, 'Unit', 4, false, 3, false, 'Hollowed', 1150, 'Reanimate. Pierce. When this unit returns via Reanimate it returns to the Frontline at its base Power. It may immediately declare one attack as if it had Blitz.', 'When any friendly unit is destroyed this turn this unit permanently gains +100 Power.', 'When your General Advances to a new Rank all friendly units gain +100 Power permanently.', 'There is no version of this that ends with it staying dead.', 'the_unmoored.png');

INSERT INTO card_keywords (card_id, keyword_id, zone) VALUES (72, 5, 'frontline');
INSERT INTO card_keywords (card_id, keyword_id, zone) VALUES (72, 9, 'frontline');

-- TheRot_CardSet_v1_2_Dextrous.xlsx::s1 row 16
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, unit_subtype, power, frontline_ability, backline_ability, command_ability, flavor_text, art_path) VALUES ('Vel the Devouring Canopy', 2, 'Unit', 4, false, 3, false, 'Aberrant', 900, 'When this unit destroys a defending unit this unit gains +100 Power permanently.', NULL, 'Ascendant. [ENERGY: 2] One chosen friendly unit gains +100 Power for each Devoured card currently beneath your Advancement stack until end of turn.', NULL, 'It does not grow. It absorbs.');

INSERT INTO card_keywords (card_id, keyword_id, zone) VALUES (73, 36, 'command');

-- TheRot_CardSet_v1_2_Dextrous.xlsx::s1 row 17
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, unit_subtype, power, frontline_ability, backline_ability, command_ability, flavor_text, art_path) VALUES ('The Charnel Conductor', 2, 'Unit', 4, false, 3, false, 'Speaker', 850, 'Once per turn Enshroud one unit from either player''s Remnant Zone onto this unit.', 'Once per turn Devour one card from either player''s Remnant Zone. That card gains Fragment while in your Advancement stack.', 'Once per turn Enshroud one unit from either player''s Remnant Zone onto one friendly unit. You may spend [ENERGY: 1] to double the Power gained from this Enshroud until end of turn.', NULL, 'What the ground remembers it puts to work.');

INSERT INTO card_keywords (card_id, keyword_id, zone) VALUES (74, 35, 'command');

-- TheRot_CardSet_v1_2_Dextrous.xlsx::s2 row 2
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, burst_subtype, effect_text, flavor_text, art_path) VALUES ('Spore Cloud', 2, 'Burst', 1, false, 3, false, 'Cast', 'All enemy Frontline units lose 100 Power until end of turn. Units reduced to 0 Power or below cannot attack or defend this round.', 'You don''t see the spore. You see what it left behind.', 'spore_cloud.png');


-- TheRot_CardSet_v1_2_Dextrous.xlsx::s2 row 3
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, burst_subtype, effect_text, flavor_text, art_path) VALUES ('Death Rattle', 2, 'Burst', 1, false, 3, false, 'Reaction', 'TRIGGER: A friendly unit is destroyed by combat or card effect. Before it enters the Remnant Zone it may activate any one zone ability it has as if it were still in that zone. Tap requirements are waived for this activation.', 'Last words are louder than first ones.', 'death_rattle.png');


-- TheRot_CardSet_v1_2_Dextrous.xlsx::s2 row 4
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, burst_subtype, effect_text, flavor_text, art_path) VALUES ('Overwhelming Tide', 2, 'Burst', 2, false, 3, false, 'Cast', 'All friendly unit cards with Reanimate currently in your Remnant Zone return to your Frontline simultaneously with Blitz. If the Frontline cannot accommodate all returning units remaining units fill available Backline slots. Units returned this way lose Reanimate permanently.', 'The dead do not wait for permission.', 'overwhelming_tide.png');


-- TheRot_CardSet_v1_2_Dextrous.xlsx::s2 row 5
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, burst_subtype, effect_text, flavor_text, art_path) VALUES ('Mycelial Rejection', 2, 'Burst', 2, false, 3, false, 'Reaction', 'TRIGGER: A friendly unit would be destroyed by combat or a card effect. That unit is instead placed in your Remnant Zone at its current Power. If it has Reanimate it immediately returns to your Backline at its base Power. This placement counts as a destruction for Sporulate and all other ''when a friendly unit is destroyed'' triggers.', 'The network decides what it keeps.', 'mycelial_rejection.png');


-- TheRot_CardSet_v1_2_Dextrous.xlsx::s2 row 6
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, burst_subtype, effect_text, flavor_text, art_path) VALUES ('Consumption Rite', 2, 'Burst', 3, false, 3, false, 'Cast', 'Choose one friendly unit. Destroy it. All other friendly units permanently gain Power equal to the destroyed unit''s current Power. [ENERGY: 1] If you pay 1 Energy when playing this card the destroyed unit''s Surge ability (if any) triggers before it enters the Remnant Zone. Cannot target units with Reanimate.', 'The strongest thing you can do with something you love is feed it to something hungrier.', 'consumption_rite.png');


-- TheRot_CardSet_v1_2_Dextrous.xlsx::s2 row 7
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, burst_subtype, effect_text, flavor_text, art_path) VALUES ('The Long Patience of the Ground', 2, 'Burst', 3, false, 3, false, 'Cast', 'Return all unit cards currently in your Remnant Zone to your hand. For each unit returned this way all friendly units gain +50 Power permanently.', 'The ground is not patient. It simply has nowhere to be.', 'long_patience_of_the_ground.png');


-- TheRot_CardSet_v1_2_Dextrous.xlsx::s2 row 8
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, augment_subtype, effect_text, flavor_text, art_path) VALUES ('Rotbound Carapace', 2, 'Augment', 1, false, 3, false, 'Armor', 'The equipped unit gains +100 Power. When the equipped unit would be destroyed by combat it instead enters your Remnant Zone at its full current Power — its accumulated Power is preserved for Reanimate calculation or Conductor pulls. Reanimate still triggers normally if applicable.', 'It grows on the wound. That is the point.', 'rotbound_carapace.png');


-- TheRot_CardSet_v1_2_Dextrous.xlsx::s2 row 9
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, augment_subtype, effect_text, flavor_text, art_path) VALUES ('Decay Spike', 2, 'Augment', 1, false, 3, false, 'Weapon', 'The equipped unit gains +150 Power when attacking. When the equipped unit''s attack breaks a Shield place the top card of the defending player''s deck face-up in their Remnant Zone.', 'It does not kill cleanly. That is also the point.', 'decay_spike.png');


-- TheRot_CardSet_v1_2_Dextrous.xlsx::s2 row 10
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, augment_subtype, effect_text, flavor_text, art_path) VALUES ('Corpse-Bloom Lattice', 2, 'Augment', 2, false, 3, false, 'Relic', 'Sporulate. The equipped unit may use its active zone ability a second time per turn but only after a friendly unit has been destroyed that turn. Cannot Sporulate more than once per turn.', 'The bloom does not mourn the body it grows from.', 'corpse_bloom_lattice.png');

INSERT INTO card_keywords (card_id, keyword_id, zone) VALUES (83, 24, 'passive');

-- TheRot_CardSet_v1_2_Dextrous.xlsx::s2 row 11
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, augment_subtype, effect_text, flavor_text, art_path) VALUES ('The Ossuary Crown', 2, 'Augment', 2, false, 3, false, 'Relic', '[ENERGY: 1] Once per turn during your Deploy Phase Devour one friendly unit.', 'It does not crown you. It consumes you into royalty.', 'the_ossuary_crown.png');

INSERT INTO card_keywords (card_id, keyword_id, zone) VALUES (84, 25, 'passive');

-- TheRot_CardSet_v1_2_Dextrous.xlsx::s3 row 2
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, effect_text, flavor_text, art_path) VALUES ('The Spreading Spore', 2, 'Rift', 1, false, 3, false, '[Both players] When any unit is destroyed by either player its controller may look at the top card of the opponent''s deck without revealing it.', 'It does not spread through air. It spreads through loss.', 'the_spreading_spore.png');


-- TheRot_CardSet_v1_2_Dextrous.xlsx::s3 row 3
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, effect_text, flavor_text, art_path) VALUES ('The Remnant Rising', 2, 'Rift', 2, false, 3, false, '[Both players] At the start of each player''s turn if that player has 3 or more unit cards in their Remnant Zone one chosen friendly unit gains +100 Power permanently.', 'What rots does not disappear. It remembers.', 'the_remnant_rising.png');


-- TheRot_CardSet_v1_2_Dextrous.xlsx::s3 row 4
INSERT INTO cards (name, faction_id, card_type, rank_cost, is_unique, copy_limit, is_general_eligible, effect_text, flavor_text, art_path) VALUES ('Total Reclamation', 2, 'Rift', 3, false, 3, false, '[Both players] All units destroyed by combat enter their controller''s Remnant Zone at their full Power value at time of destruction. Reanimate triggers use this preserved Power for their return calculation. Non-Rot Reanimate returns: at half their base Power only — preserved combat Power does not apply to non-Rot units.', 'The ground takes everything back. Especially what you thought you spent.', 'total_reclamation.png');


COMMIT;

-- VERIFICATION
SELECT f.name, COUNT(*) as card_count FROM cards c JOIN factions f ON c.faction_id = f.id GROUP BY f.name ORDER BY f.name;
SELECT name, rank_cost, power, power_cap_ok FROM cards WHERE card_type = 'Unit' ORDER BY rank_cost, power DESC;
SELECT * FROM balance_check WHERE status != 'OK';
SELECT c.name, ck.keyword_id FROM card_keywords ck JOIN cards c ON ck.card_id = c.id LEFT JOIN keywords k ON ck.keyword_id = k.id WHERE k.id IS NULL;