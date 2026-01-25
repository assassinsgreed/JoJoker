-- Config UI
local joker_pool_toggles = {
    { ref_value = "jojoker_only", label = "jojoker_settings_jojoker_only", tooltip = { set = 'Other', key = 'jojoker_only_tooltip' } },
    { ref_value = "phantom_blood", label = "jojoker_settings_part_1_enabled", tooltip = { set = 'Other', key = 'part1_tooltip' } },
    { ref_value = "battle_tendency", label = "jojoker_settings_part_2_enabled", tooltip = { set = 'Other', key = 'part2_tooltip' } },
    { ref_value = "stardust_crusaders", label = "jojoker_settings_part_3_enabled", tooltip = { set = 'Other', key = 'part3_tooltip' } },
    { ref_value = "diamond_is_unbreakable", label = "jojoker_settings_part_4_enabled", tooltip = { set = 'Other', key = 'part4_tooltip' } },
    { ref_value = "golden_wind", label = "jojoker_settings_part_5_enabled", tooltip = { set = 'Other', key = 'part5_tooltip' } },
    { ref_value = "stone_ocean", label = "jojoker_settings_part_6_enabled", tooltip = { set = 'Other', key = 'part6_tooltip' } },
    { ref_value = "steel_ball_run", label = "jojoker_settings_part_7_enabled", tooltip = { set = 'Other', key = 'part7_tooltip' } },
    { ref_value = "jojolion", label = "jojoker_settings_part_8_enabled", tooltip = { set = 'Other', key = 'part8_tooltip' } },
    { ref_value = "the_jojolands", label = "jojoker_settings_part_9_enabled", tooltip = { set = 'Other', key = 'part9_tooltip' } },
}

local misc_no_restart_toggles = {
    { ref_value = "jojoker_only_collection", label = "jojoker_settings_jojoker_only_collection", tooltip = { set = 'Other', key = 'jojoker_only_collection_tooltip' } },
}

local create_menu_toggles = function(parent, toggles)
    for k,v in ipairs(toggles) do
        parent.nodes[#parent.nodes + 1] = create_toggle({
            label = localize(v.label),
            ref_table = jojoker_config,
            ref_value = v.ref_value,
            callback = v.callback,
        })
        if v.tooltip then
            parent.nodes[#parent.nodes].config.detailed_tooltip = v.tooltip
        end
    end
end

local jojokerconfig = function()
    return {
        n = G.UIT.ROOT,
        config = {
            align = "cm",
            padding = 0.05,
            colour = G.C.CLEAR,
        },
        nodes = {
          {
            n = G.UIT.R,
            config = {
              padding = 0.25,
              align = "cm"
            },
            nodes = {
              {
                n = G.UIT.T,
                config = {
                  text = localize("jojoker_settings_header_norestart"),
                  shadow = true,
                  scale = 0.75 * 0.8,
                  colour = HEX("ED533A")
                }
              }
            },
          },
          UIBox_button({
              minw = 3.85,
              colour = HEX("7220D6"),
              button = "jojoker_joker_pool",
              label = {"Joker Pool Options"}
          }),
          UIBox_button({
              minw = 3.85,
              colour = HEX("AB1A0F"),
              button = "jojoker_misc_no_restart",
              label = {"Misc No Restart Options"}
          }),
        }
    }
end

function G.FUNCS.jojoker_joker_pool(e)
    local joker_pool_settings = {n = G.UIT.R, config = {align = "tm", padding = 0.05, scale = 0.75, colour = G.C.CLEAR}, nodes = {}}
    create_menu_toggles(joker_pool_settings, joker_pool_toggles)

    local t = create_UIBox_generic_options({
        back_func = G.ACTIVE_MOD_UI and "openModUI_"..G.ACTIVE_MOD_UI.id or 'your_collection',
        contents = {joker_pool_settings}
    })
    G.FUNCS.overlay_menu { definition = t }
end

function G.FUNCS.jojoker_misc_no_restart(e)
    local misc_no_restart_settings = {n = G.UIT.R, config = {align = "tm", padding = 0.05, scale = 0.75, colour = G.C.CLEAR}, nodes = {}}
    create_menu_toggles(misc_no_restart_settings, misc_no_restart_toggles)

    local t = create_UIBox_generic_options({
        back_func = G.ACTIVE_MOD_UI and "openModUI_"..G.ACTIVE_MOD_UI.id or 'your_collection',
        contents = {misc_no_restart_settings}
    })
    G.FUNCS.overlay_menu { definition = t }
end

SMODS.current_mod.config_tab = jojokerconfig

-- Credits
local jojoker_credits = function()
    local creditsText = {
        { "Programming", "Assassins_Greed", "PurpleHaunter" }
    }
    local content_nodes = {}

    for _, text_row in ipairs(creditsText) do
    local row_node = { n = G.UIT.R, config = { align = "cm" }, nodes = {} }
    for i, text in ipairs(text_row) do
      table.insert(row_node.nodes, {
        n = G.UIT.T,
        config = {
          text = text,
          shadow = true,
          scale = 0.6,
          colour = i == 1 and G.C.UI.TEXT_LIGHT or G.C.BLUE,
        }
      })
    end
    table.insert(content_nodes, row_node)
  end

  table.insert(content_nodes, {
    n = G.UIT.R,
    config = {
      padding = 0.2,
      align = "cm",
    },
    nodes = {
      UIBox_button({
        minw = 3.85,
        button = "jojoker_github",
        label = {"Github"}
      })
    },
  })

  return {
    label = "Credits",
    tab_definition_function = function()
      return {
        n = G.UIT.ROOT,
        config = {
          align = "cm",
          padding = 0.05,
          colour = G.C.CLEAR,
        },
        nodes = content_nodes,
      }
    end
  }
end

function G.FUNCS.jojoker_github(e)
	love.system.openURL("https://github.com/assassinsgreed/jojoker")
end

SMODS.current_mod.extra_tabs = function()
    return { jojoker_credits() }
end
