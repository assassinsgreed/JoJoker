-- This is for English (US) localization.
-- This is the default file; if other localizations do not have a key, the value from this file will be used.

return {
    descriptions = {
        Joker = {
            -- Part 1: Phantom Blood
            j_jojoker_danny = {
                name = "Danny",
                text = {
                    "Gives {C:mult}+#1#{}.",
                    "{S:1.1,C:red,E:2}Self destructs{} if score catches fire."
                }
            },
            j_jojoker_baron_zeppeli = {
                name = "Baron Zeppeli",
                text = {
                    "During final scoring, cuts scored {C:chips}chips{} in half.",
                    "Adds {C:mult}mult{} equal to {C:attention}20%{} of original chips."
                }
            },
            j_jojoker_speedwagon = {
                name = "Robert E. O. Speedwagon",
                text = {
                    "Gives {C:money}$#1#{} per used discard."
                }
            },
            j_jojoker_zombies = {
                name = "Zombies",
                text = {
                    "Gives {C:mult}#1#^[number of zombies]{} for each {C:attention}Zombie{} joker held.",
                    "Has a {C:attention}#3# in #4#{} chance to create another {C:attention}Zombie{}",
                    "at the end of small and big blinds, if there is room.",
                    "{br:2}line break",
                    "{C:inactive}Currently: {C:mult}+#2#"
                }
            },
            j_jojoker_straizo = {
                name = "Straizo",
                text = {
                    "Gives {C:chips}+#1#{} chips for each",
                    "played {C:attention}Straight{}.",
                    "Gives {C:chips}+#2#{} chips for each",
                    "played {C:attention}Straight / Royal Flush{}."
                }
            },
            j_jojoker_george_joestar = {
                name = "George Joestar",
                text = {
                    "Gives {C:money}$#1#{} per held joker",
                    "at the end of the round."
                }
            },
            j_jojoker_dario_brando = {
                name = "Dario Brando",
                text = {
                    "Steals up to {C:money}$#1#{} for each hand played into sell value.",
                    "At the end of the round, multiplies extra sell value by {C:attention}#2#{},",
                    "but has a {C:attention}#3# in #4#{} chance to be {S:1.1,C:red,E:2}destroyed{}."
                }
            },
            j_jojoker_erina = {
                name = "Erina Pendleton",
                text = {
                    "Gives {C:mult}+#1#{} for each {C:attention}Character{} joker held."
                }
            },
            j_jojoker_jonathan_joestar = {
                name = "Jonathan Joestar",
                text = {
                    "Gives {C:chips}+#1#{} for each {C:attention}unique suit{} scored."
                }
            },
            -- Part 2: Battle Tendency
            j_jojoker_joseph_joestar = {
                name = "Joseph Joestar",
                text = {
                    "When {C:attention}Blind{} is selected, picks",
                    "a random {C:attention}poker hand{}.",
                    "Levels up that hand if played.",
                    "{br:2}line break",
                    "{C:inactive}Currently: {C:attention}#1#"
                }
            },
            j_jojoker_esidisi = {
                name = "Esidisi",
                text = {
                    "Gains {X:mult,C:white} X#2# {} whenever",
                    "score catches fire before Esidisi triggers.",
                    "{br:2}line break",
                    "{C:inactive}Currently: {X:mult,C:white}X#1#{}"
                }
            },
            j_jojoker_german_engineering = {
                name = "German Engineering",
                text = {
                    "If scoring hand is a single {C:attention}9{},",
                    "adds a duplicate to the deck",
                    "and levels up {C:attention}High Card{}."
                }
            },
            j_jojoker_speedwagon_bt = {
                name = "Robert E. O. Speedwagon",
                text = {
                    "Gives {C:money}$#1#{} per played hand."
                }
            },
            j_jojoker_caesar = {
                name = "Caesar Zeppeli",
                text = {
                    "Gives each scored {C:attention}stone{} card",
                    "{X:mult,C:white} X#1# {} mult, then {S:1.1,C:red,E:2}destroys{} them."
                }
            },
            j_jojoker_kars_ultimate_lifeform = {
                name = "Kars (Ultimate Lifeform)",
                text = {
                    "Gains {X:mult,C:white} X#1# {} for each unique",
                    "planet card played this round.",
                    "Stops thinking after {C:attention}#2#{} rounds.",
                    "{br:2}line break",
                    "{C:inactive}Currently: {X:mult,C:white} X#3#",
                    "{C:attention}#4# round(s) left.",
                }
            },
            j_jojoker_kars_stopped_thinking = {
                name = "Kars (Ultimate Lifeform)",
                text = {
                    "{C:inactive}Stopped thinking{}",
                }
            },
            j_jojoker_suzi_q = {
                name = "Suzi Q",
                text = {
                    "Scored {C:attention}Queens{} are given a",
                    "{C:attention}Gold Seal{} if it has no other seals."
                }
            },
            j_jojoker_suzi_q_alt = {
                name = "Suzie Q",
                text = {
                    "Scored {C:attention}Queens{} are given a",
                    "{C:attention}Gold Seal{} if it has no other seals."
                }
            },
            j_jojoker_nypd = {
                name = "N.Y.P.D",
                text = {
                    "Each scored {C:clubs}Club{} card",
                    "gives {C:mult}+#1#{}.",
                }
            },
            -- Part 3: Stardust Crusaders
            j_jojoker_magician_red = {
                name = "Magician's Red",
                text = {
                    "Earns {C:money}$#1#{} if",
                    "score catches fire."
                }
            },
            j_jojoker_yellow_temperance = {
                name = "Yellow Temperance",
                text = {
                    "Retriggers all scored {C:attention}face{} cards."
                }
            },
            j_jojoker_ndoul = {
                name = "N'Doul",
                text = {
                    "Applies {C:attention}Smeared{}."
                }
            },
            j_jojoker_ndoul_alt = {
                name = "N'Dool",
                text = {
                    "Applies {C:attention}Smeared{}."
                }
            },
            j_jojoker_star_platinum = {
                name = "Star Platinum",
                text = {
                    "{C:attention}#1# in #2#{} chance to not consume",
                    "a hand when playing one."
                }
            },
            j_jojoker_wheel_of_fortune = {
                name = "Wheel of Fortune",
                text = {
                    "{C:attention}Wheel of Fortune{} tarot cards always trigger."
                }
            },
            j_jojoker_the_lovers = {
                name = "Lovers",
                text = {
                    "Each scored {C:hearts}Heart{} card permanently",
                    "gains {C:mult}+#1#{} after scoring."
                }
            },
            j_jojoker_old_joseph_joestar = {
                name = "Old Joseph Joestar",
                text = {
                    "Has a {C:attention}#1# in #2#{} chance to quip on discard.",
                    "Gives {X:mult,C:white} X#3# {} per quip.",
                    "{br:2}line break",
                    "{C:inactive}Currently: {X:mult,C:white} X#4#"
                }
            },
            j_jojoker_anubis = {
                name = "Anubis",
                text = {
                    "Gains {C:chips}#1#{} whenever a joker is sold.",
                    "{br:2}line break",
                    "{C:inactive}Currently: {C:chips}#2#"
                }
            },
            -- Part 4: Diamond is Unbreakable
            j_jojoker_voice_of_love = {
                name = "Voice of Love",
                text = {
                    "Each scored {C:hearts}Heart{} card",
                    "gives {C:mult}+#1#{}.",
                }
            },
            j_jojoker_shizuka = {
                name = "Shizuka Joestar",
                text = {
                    "Picks a random {C:attention}poker hand{}.",
                    "Levels up that hand {C:attention}#1# times{} if played,",
                    "then picks a new one."
                }
            },
            j_jojoker_red_hot_chili_pepper = {
                name = "Red Hot Chili Pepper",
                text = {
                    "{C:mult}+#1#{} per {C:money}$#2#{} held."
                }
            },
            j_jojoker_red_hot_chili_pepper_alt = {
                name = "Chili Pepper",
                text = {
                    "{C:mult}+#1#{} per {C:money}$#2#{} held."
                }
            },
            j_jojoker_the_hand = {
                name = "The Hand",
                text = {
                    "Picks a random {C:attention}rank{} to debuff.",
                    "The rank on either side gives {C:mult}+#1#{}.",
                    "Chosen rank changes each round.",
                    "{br:2}line break",
                    "{C:inactive}Chosen rank: {C:attention}#2#",
                    "{C:inactive}Buffed ranks: {C:attention}#3#{} and {C:attention}#4#{}"
                }
            },
            j_jojoker_superfly = {
                name = "Superfly",
                text = {
                    "When sold, disables the {C:attention}active boss blind{}.",
                    "Only works on boss blinds."
                }
            },
            j_jojoker_crazy_diamond = {
                name = "Crazy Diamond",
                text = {
                    "Each scored {C:diamonds}Diamond{} card",
                    "gives {C:mult}+#1#{}.",
                }
            },
            j_jojoker_crazy_diamond_alt = {
                name = "Shining Diamond",
                text = {
                    "Each scored {C:diamonds}Diamond{} card",
                    "gives {C:mult}+#1#{}.",
                }
            },
            j_jojoker_bad_company = {
                name = "Bad Company",
                text = {
                    "Gives {C:mult}+#1#{} for each card",
                    "over {C:attention}#2#{} in the deck.",
                }
            },
            j_jojoker_bad_company_alt = {
                name = "Worse Company",
                text = {
                    "Gives {C:mult}+#1#{} for each card",
                    "over {C:attention}#2#{} in the deck.",
                }
            },
            j_jojoker_cheap_trick = {
                name = "Cheap Trick",
                text = {
                    "Gains {X:mult,C:white} X#1# {} whenever a joker is {S:1.1,C:red,E:2}destroyed{}.",
                    "{br:2}line break",
                    "{C:inactive}Currently: {X:mult,C:white}X#2#{}"
                }
            },
            j_jojoker_cheap_trick_alt = {
                name = "Cheap Trap",
                text = {
                    "Gains {X:mult,C:white} X#1# {} whenever a joker is {S:1.1,C:red,E:2}destroyed{}.",
                    "{br:2}line break",
                    "{C:inactive}Currently: {X:mult,C:white}X#2#{}"
                }
            },
            j_jojoker_yoshikage_kira = {
                name = "Yoshikage Kira",
                text = {
                    "Gives {C:attention}+#1# hands{}.",
                }
            },
            -- Part 5: Golden Wind
            j_jojoker_sex_pistols = {
                name = "Sex Pistols",
                text = {
                    "When {C:attention}Blind{} is selected, randomly picks from",
                    "{C:attention}[Ace, 2, 3, 5, 6, 7]{}.",
                    "Increases mult by rank the first time it is scored per blind.",
                    "{br:2}line break",
                    "{C:inactive}Currently: {C:mult}+#1#",
                    "{C:inactive}Chosen rank: {C:attention}#2#",
                }
            },
            j_jojoker_sex_pistols_alt = {
                name = "Six Bullets",
                text = {
                    "When {C:attention}Blind{} is selected, randomly picks from",
                    "{C:attention}[Ace, 2, 3, 5, 6, 7]{}.",
                    "Increases mult by rank the first time it is scored per blind.",
                    "{br:2}line break",
                    "{C:inactive}Currently: {C:mult}+#1#",
                    "{C:inactive}Chosen rank: {C:attention}#2#",
                }
            },
            j_jojoker_grateful_dead = {
                name = "The Grateful Dead",
                text = {
                    "Starts with {C:mult}+#1#{}.",
                    "{C:mult}-#2#{} at the end of each blind.",
                    "{br:2}line break",
                    "{C:inactive}Remaining: {C:mult}+#3#",
                }
            },
            j_jojoker_grateful_dead_alt = {
                name = "The Thankful Dead",
                text = {
                    "Starts with {C:mult}+#1#{}.",
                    "{C:mult}-#2#{} at the end of each blind.",
                    "{br:2}line break",
                    "{C:inactive}Remaining: {C:mult}+#3#",
                }
            },
            j_jojoker_spice_girl = {
                name = "Spice Girl",
                text = {
                    "Removes scored {C:attention}stone card{}",
                    "enhancement and gains {C:chips}+#1#{}.",
                    "Removes scored {C:attention}steel card{}",
                    "enhancement and gains {X:mult,C:white} X#2# {}.",
                    "{br:2}line break",
                    "{C:inactive}Current chips: {C:chips}+#3#{}",
                    "{C:inactive}Current mult: {X:mult,C:white} X#4# {}",
                }
            },
            j_jojoker_spice_girl_alt = {
                name = "Spicy Lady",
                text = {
                    "Removes scored {C:attention}stone card{}",
                    "enhancement and gains {C:chips}+#1#{}.",
                    "Removes scored {C:attention}steel card{}",
                    "enhancement and gains {X:mult,C:white} X#2# {}.",
                    "{br:2}line break",
                    "{C:inactive}Current chips: {C:chips}+#3#{}",
                    "{C:inactive}Current mult: {X:mult,C:white} X#4# {}",
                }
            },
            j_jojoker_sticky_fingers = {
                name = "Sticky Fingers",
                text = {
                    "Applies {C:attention}Four Fingers{}."
                }
            },
            j_jojoker_sticky_fingers_alt = {
                name = "Zipper Man",
                text = {
                    "Applies {C:attention}Four Fingers{}."
                }
            },
            j_jojoker_leaky_eye_luca = {
                name = "Leaky Eye Luca",
                text = {
                    "Each scored {C:spades}Spade{} card",
                    "gives {C:mult}+#1#{}.",
                }
            },
            j_jojoker_gold_experience = {
                name = "Gold Experience",
                text = {
                    "Scored cards have a {C:attention}#1# in #2#{}",
                    "chance to become {C:dark_edition}Polychrome{} if",
                    "they do not have an edition."
                }
            },
            j_jojoker_gold_experience_alt = {
                name = "Golden Wind",
                text = {
                    "Scored cards have a {C:attention}#1# in #2#{}",
                    "chance to become {C:dark_edition}Polychrome{} if",
                    "they do not have an edition."
                }
            },
            j_jojoker_gold_experience_requiem = {
                name = "Gold Experience Requiem",
                text = {
                    "Disables all {C:attention}active boss blinds{}."
                }
            },
            j_jojoker_gold_experience_requiem_alt = {
                name = "Golden Wind Requiem",
                text = {
                    "Disables all {C:attention}active boss blinds{}."
                }
            },
            j_jojoker_king_crimson = {
                name = "King Crimson",
                text = {
                    "Gains {X:mult,C:white} X#1# {} for each skipped blind.",
                    "{br:2}line break",
                    "{C:inactive}Currently: {X:mult,C:white} X#2#",
                }
            },
            j_jojoker_king_crimson_alt = {
                name = "Emperor Crimson",
                text = {
                    "Gains {X:mult,C:white} X#1# {} for each skipped blind.",
                    "{br:2}line break",
                    "{C:inactive}Currently: {X:mult,C:white} X#2#",
                }
            },
            j_jojoker_epitaph = {
                name = "Epitaph",
                text = {
                    "Shows the next {C:attention}#1#{} cards in",
                    "the deck as a prediction, then adds their",
                    "total {C:chips}chips{} to the scoring hand.",
                }
            },
            j_jojoker_epitaph_alt = {
                name = "Eulogy",
                text = {
                    "Shows the next {C:attention}#1#{} cards in",
                    "the deck as a prediction, then adds their",
                    "total {C:chips}chips{} to the scoring hand.",
                }
            },
            j_jojoker_moody_blues = {
                name = "Moody Blues",
                text = {
                    "Scored cards have a {C:attention}#1# in #2#{}",
                    "chance to retrigger."
                }
            },
            j_jojoker_moody_blues_alt = {
                name = "Moody Jazz",
                text = {
                    "Scored cards have a {C:attention}#1# in #2#{}",
                    "chance to retrigger."
                }
            },
            -- Part 6: Stone Ocean
            j_jojoker_goo_goo_dolls = {
                name = "Goo Goo Dolls",
                text = {
                    "Each scored {C:attention}2-6{}",
                    "gives {C:mult}+#1#{}.",
                }
            },
            j_jojoker_goo_goo_dolls_alt = {
                name = "G.G. Dolls",
                text = {
                    "Each scored {C:attention}2-6{}",
                    "gives {C:mult}+#1#{}.",
                }
            },
            j_jojoker_stone_free = {
                name = "Stone Free",
                text = {
                    "Retriggers each scored",
                    "{C:attention}Stone{} card.",
                }
            },
            j_jojoker_stone_free_alt = {
                name = "Stone Ocean",
                text = {
                    "Retriggers each scored",
                    "{C:attention}Stone{} card.",
                }
            },
            j_jojoker_made_in_heaven = {
                name = "Made in Heaven",
                text = {
                    "Reduces hands to {C:attention}#1#{} and discards to {C:attention}#2#{},",
                    "increases hand size to the {C:attention}size of your deck{}.",
                    "Gains {X:mult,C:white} X#4# {} for each lost hand and discard.",
                    "{br:2}line break",
                    "{C:inactive}Currently: {X:mult,C:white} X#3#"
                }
            },
            j_jojoker_made_in_heaven_alt = {
                name = "Maiden Heaven",
                text = {
                    "Reduces hands to {C:attention}#1#{} and discards to {C:attention}#2#{},",
                    "increases hand size to the {C:attention}size of your deck{}.",
                    "Gains {X:mult,C:white} X#4# {} for each lost hand and discard.",
                    "{br:2}line break",
                    "{C:inactive}Currently: {X:mult,C:white} X#3#"
                }
            },
            j_jojoker_dragons_dream = {
                name = "Dragon's Dream",
                text = {
                    "Randomly gains or loses {C:chips}+/- #1#{}, {C:mult}+/- #2#{},",
                    "{C:money} +/- $#3#{}, or {X:mult,C:white} X#4# {} mult per played hand.",
                    "All values cannot drop below 0.",
                    "{br:2}line break",
                    "{C:inactive}Currently: {C:chips}+#5#{}, {C:mult}+#6#{}, {C:money}$#7#{}, {X:mult,C:white} X#8# {}",
                }
            },
            j_jojoker_dragons_dream_alt = {
                name = "Drake's Dream",
                text = {
                    "Randomly gains or loses {C:chips}+/- #1#{}, {C:mult}+/- #2#{},",
                    "{C:money} +/- $#3#{}, or {X:mult,C:white} X#4# {} mult per played hand.",
                    "All values cannot drop below 0.",
                    "{br:2}line break",
                    "{C:inactive}Currently: {C:chips}+#5#{}, {C:mult}+#6#{}, {C:money}$#7#{}, {X:mult,C:white} X#8# {}",
                }
            },
            j_jojoker_green_green_grass_of_home = {
                name = "Green, Green Grass of Home",
                text = {
                    "Doubles scored {C:chips}chips{} if a {C:attention}High Card{} is played.",
                }
            },
            j_jojoker_green_green_grass_of_home_alt = {
                name = "Green, Green, Green Home",
                text = {
                    "Doubles scored {C:chips}chips{} if a {C:attention}High Card{} is played.",
                }
            },
            j_jojoker_survivor = {
                name = "Survivor",
                text = {
                    "Applies {C:attention}Splash{}."
                }
            },
            j_jojoker_foo_fighters = {
                name = "Foo Fighters",
                text = {
                    "Gives {C:chips}+#1#{} for each {C:attention}unique card played{} this ante.",
                    "{br:2}line break",
                    "{C:inactive}Currently: {C:chips}#2#{}"
                }
            },
            j_jojoker_foo_fighters_alt = {
                name = "F.F.",
                text = {
                    "Gives {C:chips}+#1#{} for each {C:attention}unique card played{} this ante.",
                    "{br:2}line break",
                    "{C:inactive}Currently: {C:chips}#2#{}"
                }
            },
            j_jojoker_savage_garden = {
                name = "Savage Garden",
                text = {
                    "Gives {X:mult,C:white} X#1# {} on the {C:attention}final hand{} of round."
                }
            },
            j_jojoker_savage_garden_alt = {
                name = "Savage Guardian",
                text = {
                    "Gives {X:mult,C:white} X#1# {} on the {C:attention}final hand{} of round."
                }
            },
            j_jojoker_pucci = {
                name = "Father Pucci",
                text = {
                    "Scored cards with a {C:attention}prime rank{} are retriggered.",
                    "{C:inactive}Prime ranks: [2, 3, 5, 7, Jack, King]"
                }
            },
            j_jojoker_white_snake = {
                name = "White Snake",
                text = {
                    "Scored cards have a {C:attention}#1# in #2#{}",
                    "chance to become {C:dark_edition}Wild{} if",
                    "they do not have an enhancement."
                }
            },
            j_jojoker_white_snake_alt = {
                name = "Pale Snake",
                text = {
                    "Scored cards have a {C:attention}#1# in #2#{}",
                    "chance to become {C:dark_edition}Wild{} if",
                    "they do not have an enhancement."
                }
            },
            j_jojoker_burning_down_the_house = {
                name = "Burning Down the House",
                text = {
                    "On loss, is {S:1.1,C:red,E:2}destroyed{}, then skips",
                    "the current blind."
                }
            },
            j_jojoker_burning_down_the_house_alt = {
                name = "Burn the House Down",
                text = {
                    "On loss, is {S:1.1,C:red,E:2}destroyed{}, then skips",
                    "the current blind."
                }
            },
            -- Part 7: Steel Ball Run
            j_jojoker_mandom = {
                name = "Mandom",
                text = {
                    "Retrigger the first {C:attention}#2#{}",
                    "cards scored each round.",
                    "{br:2}line break",
                    "{C:inactive}Remaining: {C:attention}#3# {C:inactive}times{}"
                }
            },
            j_jojoker_mandom_alt = {
                name = "Mando",
                text = {
                    "Retrigger the first {C:attention}#2#{}",
                    "cards scored each round.",
                    "{br:2}line break",
                    "{C:inactive}Remaining: {C:attention}#3# {C:inactive}times{}"
                }
            },
            j_jojoker_the_fifth_lesson = {
                name = "The Fifth Lesson",
                text = {
                    "Applies {C:attention}Shortcut{}."
                }
            },
            j_jojoker_chocolate_disco = {
                name = "Chocolate Disco",
                text = {
                    "On {C:attention}odd{} antes, {C:attention}odd ranks{} give {C:chips}+25{} chips.",
                    "On {C:attention}even{} antes, {C:attention}even ranks{} give {C:mult}+5{} mult."
                }
            },
            j_jojoker_oh_lonesome_me = {
                name = "Oh! Lonesome Me",
                text = {
                    "Increases {C:attention}hand size{} by {C:attention}#1#{}.",
                    "Effect persists while debuffed."
                }
            },
            j_jojoker_hey_ya = {
                name = "Hey Ya!",
                text = {
                    "Scored cards have a {C:attention}#1# in #2#{}",
                    "chance to become {C:attention}Lucky Cards{} if",
                    "they do not have an edition.",
                    "{C:attention}Lucky Cards{} always trigger {C:mult}mult{} bonus,",
                    "and {C:money}money{} bonus becomes {C:attention}1 in 5{}."
                }
            },
            j_jojoker_tattoo_you = {
                name = "TATTOO YOU!",
                text = {
                    "Converts one scored card that is not a {C:attention}Jack{}",
                    "into a {C:attention}Jack{} after hand is scored."
                }
            },
            j_jojoker_danny_sbr = {
                name = "Danny",
                text = {
                    "When added, {S:1.1,C:red,E:2}destroys{} a {C:attention}random joker{}.",
                    "Gives {X:mult,C:white} X#1# {}.",
                }
            },
            j_jojoker_turbo_eyes = {
                name = "Turbo Eyes",
                text = {
                    "Shows the next {C:attention}#1#{} cards in",
                    "the deck as a prediction, then adds their",
                    "total {C:chips}chips{} to the scoring hand.",
                }
            },
            -- Part 8: Jojolion
            j_jojoker_soft_and_wet = {
                name = "Soft & Wet",
                text = {
                    "Removes scoring card enhancements.",
                    "Gain {C:mult}+#2#{} for each.",
                    "{br:2}line break",
                    "{C:inactive}Currently {C:mult}+#1#"
                }
            },
            j_jojoker_paper_moon_king = {
                name = "Paper Moon King",
                text = {
                    "Applies {C:attention}Pareidolia{}."
                }
            },
            j_jojoker_josuke_higashikata_jjl = {
                name = "Josuke Higashikata",
                text = {
                    "Gives {C:chips}+#1#{} if scoring hand",
                    "contains a {C:attention}Two Pair{}."
                }
            },
            j_jojoker_milagro_man = {
                name = "Milagro Man",
                text = {
                    "Doubles earned {C:attention}interest{}."
                }
            },
            j_jojoker_higashikata_house = {
                name = "Higashikata House",
                text = {
                    "Gives {C:chips}+#1#{} chips for each",
                    "played {C:attention}Full House{}."
                }
            },
            j_jojoker_higashikata_fruit_parlor = {
                name = "Higashikata Fruit Parlor",
                text = {
                    "Gives {C:money}$#1#{} for each played {C:attention}Pair{}.",
                    "Gives {C:money}$#2#{} for each played {C:attention}Two Pair{}.",
                }
            },
            j_jojoker_i_am_a_rock = {
                name = "I Am a Rock",
                text = {
                    "Converts unscored cards to {C:attention}stone{} cards.",
                }
            },
            j_jojoker_i_am_a_rock_alt = {
                name = "I, Rock",
                text = {
                    "Converts unscored cards to {C:attention}stone{} cards.",
                }
            },
            j_jojoker_california_king_bed = {
                name = "California King Bed",
                text = {
                    "Before scoring, gains {X:mult,C:white} X#1# {} for each {C:attention}unique hand type{}",
                    "played this round. Resets at the end of the round.",
                    "{br:2}line break",
                    "{C:inactive}Currently: {X:mult,C:white} X#2#"
                }
            },
            j_jojoker_california_king_bed_alt = {
                name = "King Bed",
                text = {
                    "Before scoring, gains {X:mult,C:white} X#1# {} for each {C:attention}unique hand type{}",
                    "played this round. Resets at the end of the round.",
                    "{br:2}line break",
                    "{C:inactive}Currently: {X:mult,C:white} X#2#"
                }
            },
            -- Part 9: THE JOJOLands
            j_jojoker_smooth_operator = {
                name = "Smooth Operators",
                text = {
                    "Shuffles the order of each card {C:attention}played{},",
                    "then gives {C:chips}+#1#{} chips for each {C:attention}scored{} card."
                }
            },
        },
        Other = {
            scan_cards = {
                name = "Scan",
                text = {
                    "View top cards",
                    "of your deck"
                }
            },
            jojoker_only_tooltip = {
                name = "JoJoker Only",
                text = {
                    "Only {C:attention}JoJoker{} jokers will appear"
                }
            },
            part1_tooltip = {
                name = "Phantom Blood Enabled",
                text = {
                    "{C:attention}JoJoker{} jokers from",
                    "{C:blue}Phantom Blood{} will appear"
                }
            },
            part2_tooltip = {
                name = "Battle Tendency Enabled",
                text = {
                    "{C:attention}JoJoker{} jokers from",
                    "{C:blue}Battle Tendency{} will appear"
                }
            },
            part3_tooltip = {
                name = "Stardust Crusaders Enabled",
                text = {
                    "{C:attention}JoJoker{} jokers from",
                    "{C:blue}Stardust Crusaders{} will appear"
                }
            },
            part4_tooltip = {
                name = "Diamond is Unbreakable Enabled",
                text = {
                    "{C:attention}JoJoker{} jokers from",
                    "{C:blue}Diamond is Unbreakable{} will appear"
                }
            },
            part5_tooltip = {
                name = "Golden Wind Enabled",
                text = {
                    "{C:attention}JoJoker{} jokers from",
                    "{C:blue}Golden Wind{} will appear"
                }
            },
            part6_tooltip = {
                name = "Stone Ocean Enabled",
                text = {
                    "{C:attention}JoJoker{} jokers from",
                    "{C:blue}Stone Ocean{} will appear"
                }
            },
            part7_tooltip = {
                name = "Steel Ball Run Enabled",
                text = {
                    "{C:attention}JoJoker{} jokers from",
                    "{C:blue}Steel Ball Run{} will appear"
                }
            },
            part8_tooltip = {
                name = "JoJolion Enabled",
                text = {
                    "{C:attention}JoJoker{} jokers from",
                    "{C:blue}JoJolion{} will appear"
                }
            },
            part9_tooltip = {
                name = "THE JOJOLands Enabled",
                text = {
                    "{C:attention}JoJoker{} jokers from",
                    "{C:blue}THE JOJOLands{} will appear"
                }
            },
            -- Misc No Restart Tooltips
            jojoker_only_collection_tooltip = {
                name = "JoJoker Only Collection",
                text = {
                    "Only {C:attention}JoJoker{} jokers will",
                    "appear in the collection"
                }
            },
            use_localized_names_tooltip = {
                name = "Use Localized Names",
                text = {
                    "Display joker cards with their",
                    "localized names, whenever possible."
                }
            },
        }
    },
    misc = {
        dictionary = {
            sound_pop = "Pop!",
            sound_ora = "Ora Ora Ora!", -- TODO: Use this somewhere?
            sound_yip = "Yip!",
            sound_prediction = "Your next line is...",
            sound_nice = "Naaaaiiiiiccceeee!",
            sound_mista = "Miiiistaaa!",
            sound_tick = "Tick",
            sound_hey_baby = "Hey, baby!",
            sound_gaa = "Gaa!",
            sound_time_moves = "Time has started to move...",
            sound_stopped_thinking = "Eventually Kars stopped thinking",
            sound_grr = "Grr!",
            sound_lucky = "Lucky!",
            sound_unlucky = "Unlucky...",
            sound_neutral = "I'm neutral, remember?",
            sound_retired = "Retired!",
            sound_perished = "Perished!",
            sound_joseph_quip_oh_my_god = "Oh my gawwwd!",
            sound_joseph_quip_oh_no = "Oh nooooo!",
            sound_joseph_quip_holy_shit = "Holy shiiiittt!",
            sound_joseph_quip_son_of_a_bitch = "Sonuva biiittch!",
            sound_saved_by_bdth = "This room belongs in the past...",
            
            -- Common strings
            a_hand = "a hand",
            undecided = "undecided",
            shuffled = "Shuffled!",
            chips = "chips",
            xmult = "Xmult",

            -- Joker badges
            joker_type_stand_badge = "Stand",
            joker_type_character_badge = "Character",
            joker_type_effect_badge = "Effect",

            joker_class_automatic_badge = "Automatic",
            joker_class_close_range_badge = "Close Range",
            joker_class_long_range_badge = "Long Range",

            -- Config Menu
            jojoker_settings_header_norestart = "No Restart Required:",
            jojoker_settings_jojoker_only = "JoJoker Only?",
            jojoker_settings_part_1_enabled = "Phantom Blood Enabled?",
            jojoker_settings_part_2_enabled = "Battle Tendency Enabled?",
            jojoker_settings_part_3_enabled = "Stardust Crusaders Enabled?",
            jojoker_settings_part_4_enabled = "Diamond is Unbreakable Enabled?",
            jojoker_settings_part_5_enabled = "Golden Wind Enabled?",
            jojoker_settings_part_6_enabled = "Stone Ocean Enabled?",
            jojoker_settings_part_7_enabled = "Steel Ball Run Enabled?",
            jojoker_settings_part_8_enabled = "JoJolion Enabled?",
            jojoker_settings_part_9_enabled = "THE JOJOLands Enabled?",

            -- Misc config options
            jojoker_settings_jojoker_only_collection = "Only JoJoker Jokers in Collection?",
            jojoker_settings_use_localized_names = "Use Localized Joker Names?",
        },
        quips = {
            jojoker_lose_quip1 = {"You thought you could beat me?", "Yare yare daze...",},
            jojoker_lose_quip2 = {"Is that all you've got?", "Ora ora ora!",},
            jojoker_lose_quip3 = {"Muda muda muda muda muda!",},
            jojoker_lose_quip4 = {"Another one bites the dust!",},
            jojoker_lose_quip5 = {"This must be the work of", "an enemy stand!",},
            jojoker_lose_quip6 = {"You were two steps too late.",},
            jojoker_lose_quip7 = {"Oh nooooo!",},
            jojoker_lose_quip8 = {"Oh? You're approaching me?",},
            jojoker_lose_quip9 = {"Eat shit, asshole!", "Fall off your horse!",},
            jojoker_lose_quip10 = {"No one can escape the fate", "that was chosen for them.",},
            jojoker_win_quip1 = {"Welcome to the true man's world!",},
            jojoker_win_quip2 = {"You got your negative back to zero!",},
            jojoker_win_quip3 = {"The goddess of victory is", "already riding on my saddle!",},
            jojoker_win_quip4 = {"Yours might be the", "'Righteous Path!'"},
            jojoker_win_quip5 = {"Walking the path of justice", "is true fate!",},
            jojoker_win_quip6 = {"My heart and actions are", "utterly unclouded!",},
            jojoker_win_quip7 = {"If your heart is wavering,", "don't shoot.",},
            jojoker_win_quip8 = {"Arrivederci!",},
            jojoker_win_quip9 = {"Yes, I am!",},
            jojoker_win_quip10 = {"The shortest path was a detour.",},
        },
    }
}