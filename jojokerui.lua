-- Config UI
local github_url = SMODS.current_mod.github

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
    { ref_value = "use_localized_names", label = "jojoker_settings_use_localized_names", tooltip = { set = 'Other', key = 'use_localized_names_tooltip' } },
}

local misc_restart_toggles = {
    { ref_value = "custom_title_screen", label = "jojoker_settings_custom_title_screen", tooltip = { set = 'Other', key = 'custom_title_screen_tooltip' } },
}

local developer_toggles = {
    { ref_value = "developer_mode", label = "jojoker_settings_developer_mode", tooltip = { set = 'Other', key = 'developer_mode_tooltip' } },
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

local settings_header = function(key)
    return {
        n = G.UIT.R,
        config = { padding = 0.25, align = "cm" },
        nodes = {{ n = G.UIT.T, config = { text = localize(key), shadow = true, scale = 0.75 * 0.8, colour = HEX("ED533A") } }}
    }
end

local settings_text_row = function(text, colour)
    return {
        n = G.UIT.R,
        config = { align = "cm", padding = 0.05 },
        nodes = {{ n = G.UIT.T, config = { text = text, shadow = true, scale = 0.4, colour = colour or G.C.UI.TEXT_LIGHT } }}
    }
end

local LATEST_VERSION_TEXT = {
    idle = "jojoker_update_checking",
    checking = "jojoker_update_checking",
    none = "jojoker_update_no_release",
    unreachable = "jojoker_update_unreachable",
}

local UPDATABLE_STATES = { available = true, downloading = true, failed = true }

local version_section = function()
    local updater = jojoker.updater
    local latest_key = LATEST_VERSION_TEXT[updater.state]
    local nodes = {
        settings_text_row(localize("jojoker_update_installed") .. " " .. updater.installed),
        settings_text_row(latest_key and localize(latest_key)
            or localize({ type = "variable", key = "jojoker_update_latest", vars = { updater.release } })),
    }
    if UPDATABLE_STATES[updater.state] then
        local enabled = not jojoker_config.developer_mode and updater.state ~= "downloading"
        nodes[#nodes + 1] = UIBox_button({
            minw = 3.85,
            colour = enabled and G.C.GREEN or G.C.UI.BACKGROUND_INACTIVE,
            button = "jojoker_update",
            label = { updater.state == "downloading" and localize("jojoker_update_downloading")
                or localize({ type = "variable", key = "jojoker_update_to_release", vars = { updater.release } }) },
        })
        if updater.state == "failed" then
            nodes[#nodes + 1] = settings_text_row(localize("jojoker_update_failed"), G.C.RED)
        end
        if jojoker_config.developer_mode then
            nodes[#nodes + 1] = settings_text_row(localize("jojoker_update_developer_mode"), G.C.UI.TEXT_INACTIVE)
        end
    end
    return { n = G.UIT.ROOT, config = { align = "cm", colour = G.C.CLEAR }, nodes = nodes }
end

jojoker.updater.on_change = function()
    local slot = G.OVERLAY_MENU and G.OVERLAY_MENU:get_UIE_by_ID("jojoker_version_section")
    if not slot then return end
    slot.config.object:remove()
    slot.config.object = UIBox({ definition = version_section(), config = { parent = slot, type = "cm" } })
    slot.UIBox:recalculate()
    G.OVERLAY_MENU:recalculate()
end

function G.FUNCS.jojoker_update(e)
    if not jojoker_config.developer_mode then jojoker.updater.update() end
end

local jojokerconfig = function()
    jojoker.updater.check()
    return {
        n = G.UIT.ROOT,
        config = {
            align = "cm",
            padding = 0.05,
            colour = G.C.CLEAR,
        },
        nodes = {
          settings_header("jojoker_settings_header_norestart"),
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
          UIBox_button({
              minw = 3.85,
              colour = HEX("3A7D44"),
              button = "jojoker_developer",
              label = {"Developer Options"}
          }),
          settings_header("jojoker_settings_header_restart"),
          UIBox_button({
              minw = 3.85,
              colour = HEX("AB1A0F"),
              button = "jojoker_misc_restart",
              label = {"Misc Restart Options"}
          }),
          settings_header("jojoker_settings_header_version"),
          {
            n = G.UIT.R,
            config = { align = "cm" },
            nodes = {{ n = G.UIT.O, config = { id = "jojoker_version_section", object = UIBox({ definition = version_section(), config = { type = "cm" } }) } }}
          },
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

function G.FUNCS.jojoker_misc_restart(e)
    local misc_restart_settings = {n = G.UIT.R, config = {align = "tm", padding = 0.05, scale = 0.75, colour = G.C.CLEAR}, nodes = {}}
    create_menu_toggles(misc_restart_settings, misc_restart_toggles)

    local t = create_UIBox_generic_options({
        back_func = G.ACTIVE_MOD_UI and "openModUI_"..G.ACTIVE_MOD_UI.id or 'your_collection',
        contents = {misc_restart_settings}
    })
    G.FUNCS.overlay_menu { definition = t }
end

function G.FUNCS.jojoker_developer(e)
    local developer_settings = {n = G.UIT.R, config = {align = "tm", padding = 0.05, scale = 0.75, colour = G.C.CLEAR}, nodes = {}}
    create_menu_toggles(developer_settings, developer_toggles)

    local t = create_UIBox_generic_options({
        back_func = G.ACTIVE_MOD_UI and "openModUI_"..G.ACTIVE_MOD_UI.id or 'your_collection',
        contents = {developer_settings}
    })
    G.FUNCS.overlay_menu { definition = t }
end

SMODS.current_mod.config_tab = jojokerconfig

-- Credits
local jojoker_credits = function()
    local creditsText = {
        { "Programming ", "Assassins_Greed ", "PurpleHaunter" }
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
	love.system.openURL(github_url)
end

SMODS.current_mod.extra_tabs = function()
    return { jojoker_credits() }
end
