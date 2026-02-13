-- This is for English (US) localization.
-- This is the default file; if other localizations do not have a key, the value from this file will be used.

return {
    descriptions = {
        Joker = {
            -- Part 1: Phantom Blood
            j_jojoker_danny = {
                name = "Danny (Pt 1)",
                text = {
                    "Gives {C:mult}+#1#{}.",
                    "{S:1.1,C:red,E:2}Self destructs{} if score catches fire."
                }
            },
            j_jojoker_baron_zeppeli = {
                name = "Baron Zeppeli",
                text = {
                    "Cuts scored {C:chips}chips{} in half when scored.",
                    "Adds {C:mult}mult{} equal to {C:attention}10%{} of original chips."
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
                    "score catches fire.",
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
                    "{X:mult,C:white} X#1# {} mult, then destroyes them."
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
            j_jojoker_star_platinum = {
                name = "Star Platinum",
                text = {
                    "{C:attention}#1# in #2#{} chance to not consume",
                    "a hand when playing one."
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
                name = "Shizuka",
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
            j_jojoker_grateful_dead = {
                name = "Grateful Dead",
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
            j_jojoker_sticky_fingers = {
                name = "Sticky Fingers",
                text = {
                    "Applies {C:attention}Four Fingers{}."
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
            j_jojoker_stone_free = {
                name = "Stone Free",
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
            -- Part 9: THE JOJOLands
            j_jojoker_smooth_operator = {
                name = "Smooth Operator",
                text = {
                    "Relocates itself at the start of",
                    "each blind. If not manually relocated,",
                    "gains {C:mult}mult{} equal to the",
                    "number of held jokers.",
                    "{br:2}line break",
                    "{C:inactive}Currently {C:mult}+#1#"
                }
            },
        },
        Other = {
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
            
            -- Common strings
            a_hand = "a hand",
            undecided = "undecided",

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