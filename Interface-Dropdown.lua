--[[
Utility method to sort the dropdowns menu
choices alphabetically.
]]
local function SortTable(arg1, arg2)
  local i=1
  local j

  repeat
    j = string.byte(arg1.desc, i) - string.byte(arg2.desc, i)

    if j == 0 then
      i = i+1
    elseif j<0 then
      return true
    else
      return false
    end
  until string.byte(arg1.desc, i) == nil or string.byte(arg2.desc, i) == nil

  if string.byte(arg1.desc, i) == nil then
    return true
  else
    return false
  end
end

--[[ Dropdowns ]]
-- See below local functions declaration for dropdown
-- creation function associations

local function DropdownCustomChatsInitialize()
  local info = {}
  info.text = Elephant.L['chatnames']['custom']
  info.isTitle = true
  UIDropDownMenu_AddButton(info, 1)

  local index, tindex, k, v
  for index, tindex in pairs(Elephant.dbpc.char.logs) do
    if not (type(index) == "number") then
      if not Elephant.L['generalchats'][index] then
        info = {}
        info.text = tindex.name
        info.func = Elephant.ChangeLog
        info.arg1 = index
        info.checked = GetChannelName(tindex.name) ~= 0
        if not tindex.enabled then
          info.colorCode = "|c" .. Elephant:MakeTextHexColor(1.0, 0.2, 0.2)
          info.text = info.text .. " (" .. Elephant.L['disabled'] .. ")"
        end
        UIDropDownMenu_AddButton(info)
      end
    end
  end
end

local function DropdownGeneralChatsInitialize()
  local info

  info = UIDropDownMenu_CreateInfo()
  info.text = Elephant.L['chatnames']['general']
  info.isTitle = true
  info.notCheckable = true
  UIDropDownMenu_AddButton(info)

  local index, tindex
  for index, tindex in pairs(Elephant.dbpc.char.logs) do
    if type(index) == "string" then
      if Elephant.L['generalchats'][index] then
        info = UIDropDownMenu_CreateInfo()
        info.notCheckable = true
        info.text = tindex.name
        info.func = Elephant.ChangeLog
        info.arg1 = index
        if not tindex.enabled then
          info.colorCode = "|c" .. Elephant:MakeTextHexColor(1.0, 0.2, 0.2)
          info.text = info.text .. " (" .. Elephant.L['disabled'] .. ")"
        end
        UIDropDownMenu_AddButton(info)
      end
    end
  end
end

local function DropdownMiscChatsInitialize()
  local info

  info = UIDropDownMenu_CreateInfo()
  info.text = Elephant.L['chatnames']['misc']
  info.isTitle = true
  info.notCheckable = true
  UIDropDownMenu_AddButton(info)

  info = UIDropDownMenu_CreateInfo()
  info.notCheckable = true
  info.text = Elephant.L['chatnames']['achievement']
  info.func = Elephant.ChangeLog
  info.arg1 = Elephant.defaultConf.defaultindexes.achievement
  if not Elephant.dbpc.char.logs[Elephant.defaultConf.defaultindexes.achievement].enabled then
    info.colorCode = "|c" .. Elephant:MakeTextHexColor(1.0, 0.2, 0.2)
    info.text = info.text .. " (" .. Elephant.L['disabled'] .. ")"
  end
  UIDropDownMenu_AddButton(info)

  info = UIDropDownMenu_CreateInfo()
  info.notCheckable = true
  info.text = Elephant.L['chatnames']['loot']
  info.func = Elephant.ChangeLog
  info.arg1 = Elephant.defaultConf.defaultindexes.loot
  if not Elephant.dbpc.char.logs[Elephant.defaultConf.defaultindexes.loot].enabled then
    info.colorCode = "|c" .. Elephant:MakeTextHexColor(1.0, 0.2, 0.2)
    info.text = info.text .. " (" .. Elephant.L['disabled'] .. ")"
  end
  UIDropDownMenu_AddButton(info)

  info = UIDropDownMenu_CreateInfo()
  info.notCheckable = true
  info.text = Elephant.L['chatnames']['system']
  info.func = Elephant.ChangeLog
  info.arg1 = Elephant.defaultConf.defaultindexes.system
  if not Elephant.dbpc.char.logs[Elephant.defaultConf.defaultindexes.system].enabled then
    info.colorCode = "|c" .. Elephant:MakeTextHexColor(1.0, 0.2, 0.2)
    info.text = info.text .. " (" .. Elephant.L['disabled'] .. ")"
  end
  UIDropDownMenu_AddButton(info)
end

local function DropdownCatchOptionsInitialize(frame, level)
  local menu = {}

  -- Getting events for current log
  local eventKey, eventTable, catcherValue
  for eventID, eventTable in pairs(Elephant.db.profile.events) do
    if eventTable.channels and eventTable.desc then
      catcherValue = eventTable.channels[Elephant.dbpc.char.currentlogindex]
      if catcherValue then
        table.insert(menu, {
          desc = eventTable.desc,
          key = eventID,
          option = catcherValue
        })
      end
    end
  end

  table.sort(menu, SortTable)

  local catcher, info
  for _, catcher in pairs(menu) do
    if catcher.option == -1 then
      -- On first display, seems to be buggy: some of these
      -- entries are displayed in white even if they are not
      -- clickable. If you find a fix, congrats!
      info = UIDropDownMenu_CreateInfo()
      info.text = catcher.desc
      info.checked = true
      info.isNotRadio = true
      info.disabled = true
      UIDropDownMenu_AddButton(info)
    elseif catcher.option == 0 then
      info = UIDropDownMenu_CreateInfo()
      info.text = catcher.desc
      info.checked = false
      info.func = Elephant.EnableCatcher
      info.arg1 = catcher.key
      info.arg2 = Elephant.dbpc.char.currentlogindex
      info.isNotRadio = true
      info.keepShownOnClick = 1
      UIDropDownMenu_AddButton(info)
    elseif catcher.option == 1 then
      info = UIDropDownMenu_CreateInfo()
      info.text = catcher.desc
      info.checked = true
      info.func = Elephant.DisableCatcher
      info.arg1 = catcher.key
      info.arg2 = Elephant.dbpc.char.currentlogindex
      info.isNotRadio = true
      info.keepShownOnClick = 1
      UIDropDownMenu_AddButton(info)
    end
  end
end

-- Doing that way avoids calling each drop down
-- initialization function at startup
Elephant.dropdowns = {}
Elephant.dropdowns.customChats = CreateFrame("Frame", "ElephantDropdown", UIParent, "UIDropDownMenuTemplate")
Elephant.dropdowns.customChats.displayMode = "MENU"
Elephant.dropdowns.customChats.initialize = DropdownCustomChatsInitialize
Elephant.dropdowns.generalChats = CreateFrame("Frame", "ElephantDropdown", UIParent, "UIDropDownMenuTemplate")
Elephant.dropdowns.generalChats.displayMode = "MENU"
Elephant.dropdowns.generalChats.initialize = DropdownGeneralChatsInitialize
Elephant.dropdowns.miscChats = CreateFrame("Frame", "ElephantDropdown", UIParent, "UIDropDownMenuTemplate")
Elephant.dropdowns.miscChats.displayMode = "MENU"
Elephant.dropdowns.miscChats.initialize = DropdownMiscChatsInitialize
Elephant.dropdowns.catchOptions = CreateFrame("Frame", "ElephantDropdown", UIParent, "UIDropDownMenuTemplate")
Elephant.dropdowns.catchOptions.displayMode = "MENU"
Elephant.dropdowns.catchOptions.initialize = DropdownCatchOptionsInitialize
