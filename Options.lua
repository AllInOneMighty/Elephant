local LSM = LibStub("LibSharedMedia-3.0")

local function ToggleUseFactionRealmDb()
  Elephant:ProfileDb().use_factionrealm_db =
    not Elephant:ProfileDb().use_factionrealm_db
  Elephant:MaybeInitDefaultLogStructures()
  Elephant:MaybeInitCustomStructures()
  Elephant:AddHeaderToStructures(true)
  Elephant:ChangeLog(Elephant:CharDb().currentlogindex)
end

-- Registers the options of the addon and sets up any configuration window or
-- slash command giving access to them.
function Elephant:SetupOptions()
  local color_green = CreateColor(0.2, 1.0, 0.2)
  local color_red = CreateColor(1.0, 0.2, 0.2)

  -- First, registering options
  LibStub("AceConfig-3.0"):RegisterOptionsTable("Elephant", {
    type = "group",
    childGroups = "tab",
    args = {
      optionsareperprofile = {
        type = "description",
        order = 0,
        name = Elephant.L["STRING_OPTIONS_ARE_PER_PROFILE_DESC"],
        fontSize = "medium",
      },
      toggleicon = {
        type = "toggle",
        order = 1,
        name = Elephant.L["STRING_OPTIONS_MINIMAP_ICON"],
        desc = Elephant.L["STRING_OPTIONS_MINIMAP_ICON_DESC"],
        get = function()
          return not Elephant:ProfileDb().minimap.hide
        end,
        set = Elephant.ToggleLDBIcon,
        hidden = function()
          return not Elephant:IsLDBIconAvailable()
        end,
      },
      togglebutton = {
        type = "toggle",
        order = 2,
        name = Elephant.L["STRING_OPTIONS_SHOW_CHAT_BUTTON"],
        desc = Elephant.L["STRING_OPTIONS_SHOW_CHAT_BUTTON_DESC"],
        get = function()
          return Elephant:ProfileDb().button
        end,
        set = Elephant.ToggleButton,
      },
      log = {
        type = "group",
        order = 3,
        name = Elephant.L["STRING_OPTIONS_LOGS_TAB"],
        desc = Elephant.L["STRING_OPTIONS_LOGS_TAB_DESC"],
        args = {
          use_factionrealm_db = {
            type = "toggle",
            order = 1,
            name = Elephant.L["STRING_OPTIONS_SHARE_LOGS_WITH_ALTS"],
            desc = Elephant.L["STRING_OPTIONS_SHARE_LOGS_WITH_ALTS_DESC_1"]
              .. "\n\n"
              .. color_green:WrapTextInColorCode(
                Elephant.L["STRING_OPTIONS_SHARE_LOGS_WITH_ALTS_DESC_2"]
              ),
            get = function()
              return Elephant:ProfileDb().use_factionrealm_db
            end,
            set = ToggleUseFactionRealmDb,
          },
          default = {
            type = "toggle",
            order = 2,
            name = Elephant.L["STRING_OPTIONS_LOG_NEW_CHANNELS"],
            desc = Elephant.L["STRING_OPTIONS_LOG_NEW_CHANNELS_DESC"],
            get = function()
              return Elephant:ProfileDb().defaultlog
            end,
            set = function(_, isEnabled)
              Elephant:ProfileDb().defaultlog = isEnabled
            end,
          },
          classColors = {
            type = "toggle",
            order = 3,
            name = Elephant.L["STRING_OPTIONS_USE_CLASS_COLORS"],
            desc = Elephant.L["STRING_OPTIONS_USE_CLASS_COLORS_DESC_1"]
              .. "\n\n"
              .. color_green:WrapTextInColorCode(
                Elephant.L["STRING_OPTIONS_USE_CLASS_COLORS_DESC_2"]
              ),
            get = function()
              return Elephant:ProfileDb().class_colors_in_log
            end,
            set = function(_, isEnabled)
              Elephant:ProfileDb().class_colors_in_log = isEnabled
              Elephant:ShowCurrentLog()
            end,
          },
          skip_cannot_log_restricted_warning = {
            type = "toggle",
            order = 4,
            width = "full",
            name = Elephant.L["STRING_OPTIONS_SKIP_CANNOT_LOG_RESTRICTED_WARNING"],
            desc = Elephant.L["STRING_OPTIONS_SKIP_CANNOT_LOG_RESTRICTED_WARNING_DESC_1"],
            get = function()
              return Elephant:ProfileDb().skip_cannot_log_restricted_warning
            end,
            set = function()
              Elephant:ProfileDb().skip_cannot_log_restricted_warning =
                not Elephant:ProfileDb().skip_cannot_log_restricted_warning
            end,
          },
          max = {
            type = "range",
            order = 5,
            name = Elephant.L["STRING_OPTIONS_MAX_LOG_LINES"],
            desc = Elephant.L["STRING_OPTIONS_MAX_LOG_LINES_DESC_1"]
              .. "\n\n"
              .. color_green:WrapTextInColorCode(
                Elephant.L["STRING_OPTIONS_MAX_LOG_LINES_DESC_2"]
              )
              .. "\n\n"
              .. color_red:WrapTextInColorCode(
                Elephant.L["STRING_OPTIONS_MAX_LOG_LINES_DESC_3"]
              ),
            min = Elephant:DefaultConfiguration().minlogsize,
            max = Elephant:DefaultConfiguration().maxlogsize,
            step = 1,
            get = function()
              return Elephant:FactionRealmDb().maxlog
            end,
            set = function(_, nb)
              Elephant:ChangeMaxLog(nb)
            end,
          },
          maxcopycharacters = {
            type = "range",
            order = 6,
            name = Elephant.L["STRING_OPTIONS_MAX_COPY_CHARACTERS"],
            desc = Elephant.L["STRING_OPTIONS_MAX_COPY_CHARACTERS_DESC_1"]
              .. "\n\n"
              .. color_red:WrapTextInColorCode(
                Elephant.L["STRING_OPTIONS_MAX_COPY_CHARACTERS_DESC_2"]
              ),
            min = Elephant:DefaultConfiguration().copywindowminletters,
            max = Elephant:DefaultConfiguration().copywindowmaxletters,
            step = 1000,
            get = function()
              return Elephant:ProfileDb().maxcopyletters
            end,
            set = function(_, v)
              Elephant:ProfileDb().maxcopyletters = v
            end,
          },
          prat_opt = {
            type = "group",
            name = Elephant.L["STRING_OPTIONS_PRAT_INTEGRATION_GROUP"],
            order = 7,
            inline = true,
            args = {
              prat = {
                type = "toggle",
                order = 1,
                name = Elephant.L["STRING_OPTIONS_PRAT_FORMATTING"],
                desc = Elephant.L["STRING_OPTIONS_PRAT_FORMATTING_DESC_1"]
                  .. "\n\n"
                  .. Elephant.L["STRING_OPTIONS_PRAT_FORMATTING_DESC_2"]
                  .. "\n\n"
                  .. color_green:WrapTextInColorCode(
                    Elephant.L["STRING_OPTIONS_PRAT_FORMATTING_DESC_3"]
                  ),
                get = function()
                  return Elephant:ProfileDb().prat
                end,
                set = function(_, v)
                  Elephant:ProfileDb().prat = v
                  Elephant:RegisterEventsRefresh()
                end,
              },
            },
          },
          files = {
            type = "group",
            order = 8,
            name = Elephant.L["STRING_OPTIONS_FILE_LOGGING_GROUP"],
            desc = Elephant.L["STRING_OPTIONS_FILE_LOGGING_GROUP_DESC"],
            inline = true,
            args = {
              activate = {
                type = "toggle",
                order = 1,
                name = Elephant.L["STRING_OPTIONS_FILE_LOGGING_ACTIVATE"],
                desc = Elephant.L["STRING_OPTIONS_FILE_LOGGING_ACTIVATE_DESC_1"]
                  .. "\n\n"
                  .. color_red:WrapTextInColorCode(
                    Elephant.L["STRING_OPTIONS_FILE_LOGGING_ACTIVATE_DESC_2"]
                  ),
                get = function()
                  return Elephant:ProfileDb().activate_log
                end,
                set = function(_, nv)
                  Elephant:ProfileDb().activate_log = nv
                  Elephant:ChatLogEnable(Elephant:ProfileDb().chatlog)
                  Elephant:CombatLogEnable(Elephant:ProfileDb().combatlog)
                end,
              },
              chatlog_limitation = {
                type = "description",
                name = Elephant.L["STRING_OPTIONS_FILE_LOGGING_LIMITATIONS"],
                order = 2,
                hidden = function()
                  return not Elephant:ProfileDb().activate_log
                end,
                fontSize = "medium",
              },
              chat = {
                type = "toggle",
                order = 3,
                name = Elephant.L["STRING_OPTIONS_FILE_LOGGING_CHAT"],
                desc = Elephant.L["STRING_OPTIONS_FILE_LOGGING_CHAT_DESC_1"]
                  .. "\n\n"
                  .. color_green:WrapTextInColorCode(
                    Elephant.L["STRING_OPTIONS_FILE_LOGGING_CHAT_DESC_2"]
                  ),
                get = function()
                  return Elephant:ProfileDb().chatlog
                end,
                set = function(_, isEnabled)
                  Elephant:ProfileDb().chatlog = isEnabled
                  Elephant:ChatLogEnable(isEnabled)
                end,
                hidden = function()
                  return not Elephant:ProfileDb().activate_log
                end,
              },
              combat = {
                type = "toggle",
                order = 4,
                name = Elephant.L["STRING_OPTIONS_FILE_LOGGING_COMBAT"],
                desc = Elephant.L["STRING_OPTIONS_FILE_LOGGING_COMBAT_DESC_1"]
                  .. "\n\n"
                  .. color_green:WrapTextInColorCode(
                    Elephant.L["STRING_OPTIONS_FILE_LOGGING_COMBAT_DESC_2"]
                  ),
                get = function()
                  return Elephant:ProfileDb().combatlog
                end,
                set = function(_, isEnabled)
                  Elephant:ProfileDb().combatlog = isEnabled
                  Elephant:CombatLogEnable(isEnabled)
                end,
                hidden = function()
                  return not Elephant:ProfileDb().activate_log
                end,
              },
            },
          },
          clearall = {
            type = "execute",
            order = 9,
            name = Elephant.L["STRING_OPTIONS_CLEAR_LOGS"],
            desc = Elephant.L["STRING_OPTIONS_CLEAR_LOGS_DESC"],
            func = function()
              StaticPopup_Show("ELEPHANT_CLEARALL")
            end,
          },
        },
      },
      filters = {
        type = "group",
        order = 4,
        name = Elephant.L["STRING_FILTERS"],
        desc = Elephant.L["STRING_OPTIONS_FILTERS_TAB_DESC"],
        args = {
          desc = {
            type = "description",
            order = 0,
            name = Elephant.L["STRING_OPTIONS_FILTERS_TAB_HEADER_1"]
              .. "\n\n"
              .. format(
                Elephant.L["STRING_OPTIONS_FILTERS_TAB_HEADER_2"],
                Elephant:MakeTextHexColor(0.2, 1.0, 0.2)
              )
              .. "\n\n"
              .. format(
                Elephant.L["STRING_OPTIONS_FILTERS_TAB_HEADER_3"],
                Elephant:MakeTextHexColor(0.2, 1.0, 0.2)
              )
              .. "\n\n"
              .. Elephant.L["STRING_OPTIONS_FILTERS_TAB_HEADER_4"],
            fontSize = "medium",
          },
          add = {
            type = "input",
            order = 1,
            name = Elephant.L["STRING_NEW"],
            desc = Elephant.L["STRING_OPTIONS_FILTER_NEW_DESC_1"],
            get = false,
            set = function(_, input)
              if
                string.match(
                  input,
                  Elephant.L["STRING_FILTER_VALIDATION_REGEXP"]
                ) == nil
              then
                Elephant:Print(
                  format(Elephant.L["STRING_INFORM_CHAT_FILTER_INVALID"], input)
                )
              else
                Elephant:AddFilter(input)
              end
            end,
            usage = Elephant.L["STRING_OPTIONS_FILTER_NEW_DESC_2"],
          },
          delete = {
            type = "select",
            order = 2,
            name = DELETE,
            desc = Elephant.L["STRING_OPTIONS_FILTER_DELETE_DESC"],
            set = function(_, filterindex)
              Elephant:DeleteFilter(filterindex)
            end,
            values = function()
              return Elephant:ProfileDb().filters
            end,
            hidden = function()
              return not Elephant:ProfileDb().filters
                or (#Elephant:ProfileDb().filters == 0)
            end,
          },
        },
      },
      skins = {
        type = "group",
        order = 5,
        name = Elephant.L["STRING_OPTIONS_SKINS"],
        desc = Elephant.L["STRING_OPTIONS_SKINS_DESC"],
        args = {
          font = {
            type = "select",
            order = 1,
            name = Elephant.L["STRING_OPTIONS_LOG_FONT"],
            style = "dropdown",
            width = "double",
            values = function()
              local values = {}
              for _, v in ipairs(LSM:List("font")) do
                values[v] = v
              end
              return values
            end,
            get = function()
              return Elephant:ProfileDb().log_font_id
            end,
            set = function(_, font_id)
              Elephant:ProfileDb().log_font_id = font_id
              Elephant:UpdateSkin()
            end,
          },
          font_size = {
            type = "select",
            order = 2,
            name = Elephant.L["STRING_OPTIONS_LOG_FONT_SIZE"],
            style = "dropdown",
            width = "half",
            values = function()
              return {
                [12] = 12,
                [14] = 14,
                [16] = 16,
                [18] = 18,
                [20] = 20,
                [24] = 24,
                [27] = 27,
              }
            end,
            get = function()
              return Elephant:ProfileDb().log_font_size
            end,
            set = function(_, font_size)
              Elephant:ProfileDb().log_font_size = font_size
              Elephant:UpdateSkin()
            end,
          },
          skin = {
            type = "select",
            order = 3,
            name = Elephant.L["STRING_OPTIONS_SKIN"],
            style = "radio",
            values = function()
              return Elephant:GetSkinNames()
            end,
            get = function()
              return Elephant:ProfileDb().skin_id
            end,
            set = function(_, skin_id)
              Elephant:ProfileDb().skin_id = skin_id
              Elephant:UpdateSkin()
            end,
          },
        },
      },
      reset = {
        type = "group",
        order = 6,
        name = Elephant.L["STRING_RESET"],
        desc = Elephant.L["STRING_OPTIONS_RESET_TAB_DESC"],
        args = {
          desc = {
            type = "description",
            order = 0,
            name = Elephant.L["STRING_OPTIONS_RESET_TAB_HEADER_1"]
              .. "\n\n"
              .. Elephant.L["STRING_OPTIONS_RESET_TAB_HEADER_2"]
              .. "\n\n"
              .. color_red:WrapTextInColorCode(
                Elephant.L["STRING_OPTIONS_RESET_TAB_HEADER_3"]
              ),
            fontSize = "medium",
          },
          resetall = {
            type = "execute",
            order = 2,
            name = Elephant.L["STRING_SETTINGS"],
            desc = Elephant.L["STRING_OPTIONS_RESET_SETTINGS_DESC"],
            func = function()
              StaticPopup_Show("ELEPHANT_RESET")
            end,
          },
          resetposition = {
            type = "execute",
            order = 1,
            name = Elephant.L["STRING_POSITION"],
            desc = Elephant.L["STRING_OPTIONS_RESET_POSITION_DESC"],
            func = function()
              Elephant:ResetPosition()
              Elephant:ResetButtonPosition()
            end,
          },
        },
      },
    },
  })

  -- Adding options to blizzard frame
  _, Elephant:VolatileConfig().categoryId =
    LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Elephant")

  -- Adding slash command to access options
  Elephant:RegisterChatCommand("elephant", function()
    Elephant:OpenOptions()
  end)
end
