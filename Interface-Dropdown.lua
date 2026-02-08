-- Utility method to sort the dropdowns menu choices alphabetically.
local function SortTable(arg1, arg2)
  local i = 1
  local j

  repeat
    j = string.byte(arg1.desc, i) - string.byte(arg2.desc, i)

    if j == 0 then
      i = i + 1
    elseif j < 0 then
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

--[[
  Dropdowns

  See below local functions declaration for dropdown creation function
  associations.
]]

local function DropdownCustomChatsInitialize()
  local info = {}
  info.text = Elephant.L["STRING_CHAT_NAME_CUSTOM"]
  info.isTitle = true
  UIDropDownMenu_AddButton(info, 1)

  local index, tindex, k, v
  for index, tindex in pairs(Elephant:LogsDb().logs) do
    if
      not (type(index) == "number")
      and not Elephant:IsExactGeneralChatChannelId(index)
    then
      info = {}
      info.text = tindex.name
      info.func = Elephant.ChangeLog
      info.arg1 = index
      info.checked = GetChannelName(tindex.name) ~= 0
      if not tindex.enabled then
        info.colorCode = "|c" .. Elephant:MakeTextHexColor(1.0, 0.2, 0.2)
        info.text = info.text .. " (" .. Elephant.L["STRING_DISABLED"] .. ")"
      end
      UIDropDownMenu_AddButton(info)
    end
  end
end

local function DropdownGeneralChatsInitialize()
  local info

  info = UIDropDownMenu_CreateInfo()
  info.text = Elephant.L["STRING_CHAT_NAME_GENERAL"]
  info.isTitle = true
  info.notCheckable = true
  UIDropDownMenu_AddButton(info)

  local general_chat_channel_metadata
  for _, general_chat_channel_metadata in
    ipairs(Elephant:DefaultConfiguration().generalchatchannelmetadata)
  do
    if Elephant:LogsDb().logs[general_chat_channel_metadata.id] then
      info = UIDropDownMenu_CreateInfo()
      info.notCheckable = true
      info.text = general_chat_channel_metadata.name
      info.func = Elephant.ChangeLog
      info.arg1 = general_chat_channel_metadata.id
      if
        not Elephant:LogsDb().logs[general_chat_channel_metadata.id].enabled
      then
        info.colorCode = "|c" .. Elephant:MakeTextHexColor(1.0, 0.2, 0.2)
        info.text = info.text .. " (" .. Elephant.L["STRING_DISABLED"] .. ")"
      end
      UIDropDownMenu_AddButton(info)
    end
  end
end

local function DropdownMiscChatsInitialize()
  local info

  info = UIDropDownMenu_CreateInfo()
  info.text = Elephant.L["STRING_CHAT_NAME_MISC"]
  info.isTitle = true
  info.notCheckable = true
  UIDropDownMenu_AddButton(info)

  info = UIDropDownMenu_CreateInfo()
  info.notCheckable = true
  info.text = Elephant.L["STRING_CHAT_NAME_ACHIEVEMENT"]
  info.func = Elephant.ChangeLog
  info.arg1 = Elephant:DefaultConfiguration().defaultindexes.achievement
  if
    not Elephant:LogsDb().logs[Elephant:DefaultConfiguration().defaultindexes.achievement].enabled
  then
    info.colorCode = "|c" .. Elephant:MakeTextHexColor(1.0, 0.2, 0.2)
    info.text = info.text .. " (" .. Elephant.L["STRING_DISABLED"] .. ")"
  end
  UIDropDownMenu_AddButton(info)

  info = UIDropDownMenu_CreateInfo()
  info.notCheckable = true
  info.text = Elephant.L["STRING_CHAT_NAME_LOOT"]
  info.func = Elephant.ChangeLog
  info.arg1 = Elephant:DefaultConfiguration().defaultindexes.loot
  if
    not Elephant:LogsDb().logs[Elephant:DefaultConfiguration().defaultindexes.loot].enabled
  then
    info.colorCode = "|c" .. Elephant:MakeTextHexColor(1.0, 0.2, 0.2)
    info.text = info.text .. " (" .. Elephant.L["STRING_DISABLED"] .. ")"
  end
  UIDropDownMenu_AddButton(info)

  info = UIDropDownMenu_CreateInfo()
  info.notCheckable = true
  info.text = Elephant.L["STRING_CHAT_NAME_SYSTEM"]
  info.func = Elephant.ChangeLog
  info.arg1 = Elephant:DefaultConfiguration().defaultindexes.system
  if
    not Elephant:LogsDb().logs[Elephant:DefaultConfiguration().defaultindexes.system].enabled
  then
    info.colorCode = "|c" .. Elephant:MakeTextHexColor(1.0, 0.2, 0.2)
    info.text = info.text .. " (" .. Elephant.L["STRING_DISABLED"] .. ")"
  end
  UIDropDownMenu_AddButton(info)
end

local function DropdownCatchOptionsInitialize(frame, level)
  local menu = {}

  -- Getting events for current log
  local eventKey, eventTable, catcherValue
  for eventID, eventTable in pairs(Elephant:ProfileDb().events) do
    if eventTable.channels and eventTable.desc then
      catcherValue = eventTable.channels[Elephant:CharDb().currentlogindex]
      if catcherValue then
        table.insert(menu, {
          desc = eventTable.desc,
          key = eventID,
          option = catcherValue,
        })
      end
    end
  end

  table.sort(menu, SortTable)

  local catcher, info
  for _, catcher in pairs(menu) do
    if catcher.option == -1 then
      --[[
        On first display, seems to be buggy: some of these entries are displayed
        in white even if they are not clickable. If you find a fix, congrats!
      ]]
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
      info.arg2 = Elephant:CharDb().currentlogindex
      info.isNotRadio = true
      info.keepShownOnClick = 1
      UIDropDownMenu_AddButton(info)
    elseif catcher.option == 1 then
      info = UIDropDownMenu_CreateInfo()
      info.text = catcher.desc
      info.checked = true
      info.func = Elephant.DisableCatcher
      info.arg1 = catcher.key
      info.arg2 = Elephant:CharDb().currentlogindex
      info.isNotRadio = true
      info.keepShownOnClick = 1
      UIDropDownMenu_AddButton(info)
    end
  end
end

--[[
  Doing that way avoids calling each drop down initialization function at
  startup.
]]
Elephant.dropdowns = {}
Elephant.dropdowns.customChats =
  CreateFrame("Frame", "ElephantDropdown", UIParent, "UIDropDownMenuTemplate")
Elephant.dropdowns.customChats.displayMode = "MENU"
Elephant.dropdowns.customChats.initialize = DropdownCustomChatsInitialize
Elephant.dropdowns.generalChats =
  CreateFrame("Frame", "ElephantDropdown", UIParent, "UIDropDownMenuTemplate")
Elephant.dropdowns.generalChats.displayMode = "MENU"
Elephant.dropdowns.generalChats.initialize = DropdownGeneralChatsInitialize
Elephant.dropdowns.miscChats =
  CreateFrame("Frame", "ElephantDropdown", UIParent, "UIDropDownMenuTemplate")
Elephant.dropdowns.miscChats.displayMode = "MENU"
Elephant.dropdowns.miscChats.initialize = DropdownMiscChatsInitialize
Elephant.dropdowns.catchOptions =
  CreateFrame("Frame", "ElephantDropdown", UIParent, "UIDropDownMenuTemplate")
Elephant.dropdowns.catchOptions.displayMode = "MENU"
Elephant.dropdowns.catchOptions.initialize = DropdownCatchOptionsInitialize
