--[[
Registers the options of the addon and sets up
any configuration window or slash command
giving access to them.
]]
function Elephant:SetupOptions()
  -- First, registering options
  LibStub("AceConfig-3.0"):RegisterOptionsTable("Elephant", {
    type = 'group',
    childGroups = "tab",
    args = {
      togglebutton = {
        type = 'toggle',
        order = 2,
        name = Elephant.L['showbutton'],
        desc = Elephant.L['showbutton_desc'],
        get = function()
          return Elephant.db.profile.button
        end,
        set = Elephant.ToggleButton
      },
      toggleicon = {
        type = 'toggle',
        order = 1,
        name = Elephant.L['minimapicon'],
        desc = Elephant.L['minimapicon_desc'],
        get = function()
          return not Elephant.db.profile.minimap.hide
        end,
        set = Elephant.ToggleLDBIcon,
        hidden = function()
          return not Elephant:IsLDBIconAvailable()
        end
      },
      filters = {
        type = 'group',
        order = 4,
        name = Elephant.L['Filters'],
        desc = Elephant.L['Filters_desc'],
        args = {
          desc = {
            type = 'description',
            order = 0,
            name = Elephant.L['filters_header'][1] .. "\n\n" ..
              format(Elephant.L['filters_header'][2], Elephant:MakeTextHexColor(0.2, 1.0, 0.2)) .. "\n\n" ..
              format(Elephant.L['filters_header'][3], Elephant:MakeTextHexColor(0.2, 1.0, 0.2)) .. "\n\n" ..
              Elephant.L['filters_header'][4],
          },
          add = {
            type = 'input',
            order = 1,
            name = Elephant.L['filternew'],
            desc = Elephant.L['newfilter_desc'],
            get = false,
            set = function(_, input)
              if string.match(input, Elephant.L['filterregex']) == nil then
                Elephant:Print(format(Elephant.L['filtererror'], input))
              else
                Elephant:AddFilter(input)
              end
            end,
            usage = Elephant.L['filterusage'],
          },
          delete = {
            type = 'select',
            order = 2,
            name = DELETE,
            desc = Elephant.L['deletefilter_desc'],
            set = function(_,filterindex)
              Elephant:DeleteFilter(filterindex)
            end,
            values = function()
              return   Elephant.db.profile.filters
            end,
            hidden = function()
              return (not Elephant.db.profile.filters) or
                (#Elephant.db.profile.filters == 0)
            end
          }
        },
      },
      log = {
        type = 'group',
        order = 3,
        name = Elephant.L['logs'],
        desc = Elephant.L['logs_desc'],
        args = {
          default = {
            type = 'toggle',
            order = 1,
            name = Elephant.L['enableddefault'],
            desc = Elephant.L['enableddefault_desc'],
            get = function()
              return Elephant.db.profile.defaultlog
            end,
            set = function(_, isEnabled)
              Elephant.db.profile.defaultlog = isEnabled
            end
          },
          max = {
            type = 'range',
            order = 2,
            name = Elephant.L['maxlogwords'],
            desc = Elephant.L['maxlogwords_desc'] ..
                  "\n\n|c" .. Elephant:MakeTextHexColor(1.0, 0.2, 0.2) .. Elephant.L['maxlogwords_desc_warning'] .. "|r",
            min = Elephant.defaultConf.minlogsize,
            max = Elephant.defaultConf.maxlogsize,
            step = 1,
            get = function()
              return Elephant.db.profile.maxlog
            end,
            set = function(_, nb)
              Elephant:ChangeMaxLog(nb)
            end,
          },
          maxcopycharacters = {
            type = 'range',
            order = 3,
            name = Elephant.L['maxcopycharacters'],
            desc = Elephant.L['maxcopycharacters_desc'] .. "\n\n|c" ..
              Elephant:MakeTextHexColor(1.0, 0.2, 0.2) .. Elephant.L['maxcopycharacters_desc_warning'] .. "|r",
            min = Elephant.defaultConf.copywindowminletters,
            max = Elephant.defaultConf.copywindowmaxletters,
            step = 1000,
            get = function()
              return Elephant.db.profile.maxcopyletters
            end,
            set = function(_, v)
              Elephant.db.profile.maxcopyletters = v
            end
          },
          classColors = {
            type = 'toggle',
            order = 4,
            name = Elephant.L['classcolors'],
            desc = Elephant.L['classcolors_desc'] .. "\n\n|c" ..
              Elephant:MakeTextHexColor(0.2, 1.0, 0.2) .. Elephant.L['classcolors_desc2'] .. "|r",
            get = function()
              return Elephant.db.profile.class_colors_in_log
            end,
            set = function(_, isEnabled)
              Elephant.db.profile.class_colors_in_log = isEnabled
              Elephant:ShowCurrentLog()
            end
          },
          clearall = {
            type = 'execute',
            order = 5,
            name = Elephant.L['clearallhelp'],
            desc = Elephant.L['clearallhelp_desc'],
            func = function()
              StaticPopup_Show("ELEPHANT_CLEARALL")
            end,
          },
          prat_opt = {
            type = 'group',
            name = Elephant.L['prat_integration'],
            order = 6,
            inline = true,
            args = {
              prat = {
                type = 'toggle',
                order = 1,
                name = Elephant.L['prat'],
                desc = Elephant.L['prat2_desc'] .. "\n\n" ..
                  Elephant.L['prat2_desc2'] .. "\n\n|c" ..
                  Elephant:MakeTextHexColor(0.2, 1.0, 0.2) .. Elephant.L['prat2_desc22'] .. "|r",
                get = function()
                  return Elephant.db.profile.prat
                end,
                set = function(_, v)
                  Elephant.db.profile.prat = v
                  Elephant:RegisterEventsRefresh()
                end
              }
            }
          },
          files = {
            type = 'group',
            order = 7,
            name = Elephant.L['files'],
            desc = Elephant.L['files_desc'],
            inline = true,
            args = {
              activate = {
                type = 'toggle',
                order = 1,
                name = Elephant.L['activate'],
                desc = Elephant.L['activate_desc2'] ..
                  "\n\n|c" .. Elephant:MakeTextHexColor(1.0, 0.2, 0.2) .. Elephant.L['activate_desc22'] .. "|r",
                get = function()
                  return Elephant.db.profile.activate_log
                end,
                set = function(_, nv)
                  Elephant.db.profile.activate_log = nv
                  Elephant:ChatLogEnable(Elephant.db.profile.chatlog)
                  Elephant:CombatLogEnable(Elephant.db.profile.combatlog)
                end,
              },
              chatlog_limitation = {
                type = 'description',
                name = Elephant.L['chatlog_limitation'],
                order = 2,
                hidden = function()
                  return not Elephant.db.profile.activate_log
                end
              },
              chat = {
                type = 'toggle',
                order = 3,
                name = Elephant.L['chatlog'],
                desc = Elephant.L['chatlog2_desc'] .. "\n\n|c" ..
                  Elephant:MakeTextHexColor(0.2, 1.0, 0.2) .. Elephant.L['chatlog2_desc2'] .. "|r",
                get = function()
                  return Elephant.db.profile.chatlog
                end,
                set = function(_, isEnabled)
                  Elephant.db.profile.chatlog = isEnabled
                  Elephant:ChatLogEnable(isEnabled)
                end,
                hidden = function()
                  return not Elephant.db.profile.activate_log
                end,
              },
              combat = {
                type = 'toggle',
                order = 4,
                name = Elephant.L['combatlog'],
                desc = Elephant.L['combatlog2_desc'] .. "\n\n|c" ..
                  Elephant:MakeTextHexColor(0.2, 1.0, 0.2) .. Elephant.L['combatlog2_desc2'] .. "|r",
                get = function()
                  return Elephant.db.profile.combatlog
                end,
                set = function(_, isEnabled)
                  Elephant.db.profile.combatlog = isEnabled
                  Elephant:CombatLogEnable(isEnabled)
                end,
                hidden = function()
                  return not Elephant.db.profile.activate_log
                end,
              },
            }
          },
        },
      },
      reset = {
        type = 'group',
        order = 5,
        name = Elephant.L['reset'],
        desc = Elephant.L['reset_desc'],
        args = {
          desc = {
            type = 'description',
            order = 0,
            name = Elephant.L['reset_header'][1] .. "\n\n" .. Elephant.L['reset_header'][2],
          },
          resetall = {
            type = 'execute',
            order = 2,
            name = Elephant.L['resethelp'],
            desc = Elephant.L['resethelp_desc'],
            func = function()
              StaticPopup_Show("ELEPHANT_RESET")
            end,
          },
          resetposition = {
            type = 'execute',
            order = 1,
            name = Elephant.L['resetloc'],
            desc = Elephant.L['resetloc_desc2'],
            func = function()
              Elephant:ResetPosition()
              Elephant:ResetButtonPosition()
            end,
          },
        },
      },
    }
  })

  -- Adding options to blizzard frame
  LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Elephant")

  -- Adding slash command to access options
  Elephant:RegisterChatCommand("elephant", function()
    InterfaceOptionsFrame_OpenToCategory("Elephant")
  end)
end
