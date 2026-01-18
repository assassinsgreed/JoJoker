-- This is for English (US) localization.
-- This is the default file; if other localizations do not have a key, the value from this file will be used.

return {
    descriptions = {
        Joker = {
            -- Part 1: Phantom Blood
            j_jojoker_danny = {
                name = "Danny (Pt 1)",
                text = {
                    "Gives {C:mult}+#1#{} mult.",
                    "{S:1.1,C:red,E:2}Self destructs{} if score catches fire."
                }
            },
            -- Part 2: Battle Tendency
            j_jojoker_joseph_joestar = {
                name = "Joseph Joestar",
                text = {
                    "When {C:attention}Blind{} is selected, picks",
                    "a random {C:attention}poker hand{}.",
                    "Levels up that hand if played.",
                    "Currently: {C:green}#1#{}"
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
            -- Part 4: Diamond is Unbreakable
            j_jojoker_voice_of_love = {
                name = "Voice of Love",
                text = {
                    "Each scored {C:mult}Heart{} card",
                    "gives {C:mult}+#1#{} mult.",
                }
            },
            -- Part 5: Golden Wind
            j_jojoker_sex_pistols = {
                name = "Sex Pistols",
                text = {
                    "When {C:attention}Blind{} is selected, randomly picks from",
                    "{C:attention}[Ace, 2, 3, 5, 6, 7]{}.",
                    "Increases mult by rank the first time it is scored per blind.",
                    "Currently: {C:mult}+#1# mult{}",
                    "Chosen rank: {C:green}#2#{}",
                }
            },
            -- Part 6: Stone Ocean
            j_jojoker_goo_goo_dolls = {
                name = "Goo Goo Dolls",
                text = {
                    "Each rank 2-6 card scored",
                    "gives {C:mult}+#1#{} mult.",
                }
            },
            j_jojoker_stone_free = {
                name = "Stone Free",
                text = {
                    "Retriggers each scored",
                    "{C:attention}Stone{} card.",
                }
            },
            -- Part 7: Steel Ball Run
            -- Part 8: Jojolion
            j_jojoker_soft_and_wet = {
                name = "Soft & Wet",
                text = {
                    "Removes scoring card enhancements.",
                    "Gain {C:mult}+#2#{} mult for each.",
                    "{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)"
                }
            }
            -- Part 9: The Jojolands
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
                name = "The JoJoLands Enabled",
                text = {
                    "{C:attention}JoJoker{} jokers from",
                    "{C:blue}The JoJoLands{} will appear"
                }
            },
        }
    },
    misc = {
        dictionary = {
            sound_ora = "Ora Ora Ora!", -- TODO: Use this somewhere?
            sound_yip = "Yip!",
            sound_prediction = "Your next line is...",
            sound_nice = "Naaaaiiiiiccceeee!",
            sound_mista = "Miiiistaaa!",

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
            jojoker_settings_part_9_enabled = "The JoJoLands Enabled?",
        },
        quips = {
            lose_quip1 = {"You thought you could beat me? Yare yare daze...",},
            lose_quip2 = {"Is that all you've got? Ora ora ora!",},
            lose_quip3 = {"Muda muda muda muda muda!",},
            lose_quip4 = {"Another one bites the dust!",},
            lose_quip5 = {"This must be the work of an enemy stand!",},
            lose_quip6 = {"You were two steps too late.",},
            lose_quip7 = {"Oh nooooo!",},
            lose_quip8 = {"Oh? You're approaching me?",},
            lose_quip9 = {"Eat shit, asshole! Fall off your horse!",},
            lose_quip10 = {"No one can escape the fate that was chosen for them.",},
            win_quip1 = {"Welcome to the true man's world!",},
            win_quip2 = {"You got your negative back to zero!",},
            win_quip3 = {"The goddess of victory is already riding on my saddle!",},
            win_quip4 = {"Yours might be the 'Righteous Path!'"},
            win_quip5 = {"Walking the path of justice is true fate!",},
            win_quip6 = {"My heart and actions are utterly unclouded!",},
            win_quip7 = {"If your heart is wavering, don't shoot.",},
            win_quip8 = {"Arrivederci!",},
            win_quip9 = {"Yes, I am!",},
            win_quip10 = {"The shortest path was a detour.",},
        },
    }
}