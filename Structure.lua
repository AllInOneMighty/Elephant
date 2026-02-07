--[[
  Creates a new log structure at the given index, using the given friendly name.
  It also sets the default "enabled" value, based on the user preference "log
  new channels".
]]
local function CreateNewLogStructure(channel_index, name)
  Elephant:LogsDb().logs[channel_index] = {}

  Elephant:LogsDb().logs[channel_index].name = name
  Elephant:LogsDb().logs[channel_index].enabled =
    Elephant:ProfileDb().defaultlog
  Elephant:LogsDb().logs[channel_index].logs = {}
end

-- Adds the given message to the given table at (size of table)+1.
local function AddMsgToTable(table, message_struct)
  table[#table + 1] = message_struct
end

-- Saves the given message in the given table at the specified index.
local function SaveMessageToTableAtPosition(table, message_struct, index)
  table[index] = message_struct
end

--[[
  Adds a header to the given log structure. Warning: should only be used if the
  log of this chat *is* enabled.

  Header may not literally add something to the log: if the last message of the
  log was a header, then this header is modified to reflect the new date and
  time.
]]
local function AddHeaderToTable(log_struct)
  -- For "easier-to-read" code
  local actual_logs_struct = log_struct.logs

  -- If log is not empty
  if #actual_logs_struct > 0 then
    if not log_struct.hasMessage then
      --[[
        If the log does not have a message since the last header then simply
        modify the last header.
      ]]
      SaveMessageToTableAtPosition(
        actual_logs_struct,
        { type = "SYSTEM", arg1 = Elephant:GetStateChangeActionMsg(true) },
        #actual_logs_struct
      )
    else
      -- Otherwise add two lines
      AddMsgToTable(actual_logs_struct, { arg1 = " " })
      AddMsgToTable(actual_logs_struct, { arg1 = " " })
    end
  end

  -- If log did save a message since the last header or log is empty
  if log_struct.hasMessage or #actual_logs_struct == 0 then
    AddMsgToTable(
      actual_logs_struct,
      { type = "SYSTEM", arg1 = Elephant:GetStateChangeActionMsg(true) }
    )
  end

  -- Specify that no messages has been saved since the last header
  if log_struct.hasMessage then
    log_struct.hasMessage = false
  end
end

--[[
  Checks if the log at the given index is not bigger than the maximum size
  defined by the user. If it is, repeatedly removes the first line of the log (=
  the oldest) until it reaches the maximum permitted size.

  It then returns the number of deleted lines (may be 0).
]]
local function CheckTableSize(index)
  local max_log_size = Elephant:FactionRealmDb().maxlog

  local deleted_lines = 0
  while #Elephant:LogsDb().logs[index].logs > max_log_size do
    table.remove(Elephant:LogsDb().logs[index].logs, 1)
    deleted_lines = deleted_lines + 1
  end

  return deleted_lines
end

--[[
  Totally removes the structure of the log at the given index, and warns the
  user of the operation.
]]
local function DeleteLog(index)
  -- Print must be done *before* deleting, obviously
  Elephant:Print(
    format(
      Elephant.L["STRING_INFORM_CHAT_LOG_DELETED"],
      Elephant:LogsDb().logs[index].name
    )
  )
  Elephant:LogsDb().logs[index] = nil
end

--[[
  Resets saved variables to the default ones defined in the core of Elephant.
  Basically replaces the current table by a new and known one.
]]
local function ResetSavedVariables()
  for key, value in
    pairs(Elephant:Clone(Elephant:DefaultConfiguration().savedconfdefaults))
  do
    Elephant:ProfileDb()[key] = value
  end
  for key, value in
    pairs(
      Elephant:Clone(Elephant:DefaultConfiguration().savedpercharconfdefaults)
    )
  do
    Elephant:CharDb()[key] = value
  end
  for key, value in
    pairs(
      Elephant:Clone(
        Elephant:DefaultConfiguration().savedperfactionrealmconfdefaults
      )
    )
  do
    Elephant:FactionRealmDb()[key] = value
  end
end

--[[
  Returns true if the given ID exactly corresponds to a general chat channel ID.
  Only channel IDs known to Elephant must be given to this method, e.g. "trading
  (services)" and not "trade (services) - Orgrimmar".
]]
function Elephant:IsExactGeneralChatChannelId(channel_id)
  for _, general_chat_channel_metadata in
    pairs(Elephant:DefaultConfiguration().generalchatchannelmetadata)
  do
    if channel_id == general_chat_channel_metadata.id then
      return true
    end
  end
  return false
end

--[[
  Returns true if the channel ID partially matches the general chat channel ID.
  For example, if the parameters ("trade (services) - Orgrimmar", "trade
  (services)") are given, this method will return true.

  This method supports common separators between channel IDs and locations, such
  as "-", ":", etc.
]]
function Elephant:ChannelIdPartiallyMatches(channel_id, general_chat_channel_id)
  return (channel_id == general_chat_channel_id)
    or string.find(channel_id, general_chat_channel_id .. " - ", 1, true)
    or string.find(channel_id, general_chat_channel_id .. " – ", 1, true)
    or string.find(channel_id, general_chat_channel_id .. ": ", 1, true)
end

--[[
  Returns true if the given channel ID partially corresponds to a general chat
  channel id, e.g. "trading (services) - Orgrimmar."
]]
function Elephant:IsPartialGeneralChatChannelId(channel_id)
  for _, general_chat_channel_metadata in
    pairs(Elephant:DefaultConfiguration().generalchatchannelmetadata)
  do
    if
      Elephant:ChannelIdPartiallyMatches(
        channel_id,
        general_chat_channel_metadata.id
      )
    then
      return true
    end
  end
  return false
end

--[[
  Iterates over all Elephant default indexes (whisper, ...) and general chats
  (trade, worlddefense, ...) and creates a new log structure for them.
]]
function Elephant:MaybeInitDefaultLogStructures()
  for name_id, index in pairs(Elephant:DefaultConfiguration().defaultindexes) do
    if not Elephant:LogsDb().logs[index] then
      CreateNewLogStructure(
        index,
        Elephant:DefaultConfiguration().defaultnames[name_id]
      )
    end
  end

  for _, general_chat_channel_metadata in
    pairs(Elephant:DefaultConfiguration().generalchatchannelmetadata)
  do
    if not Elephant:LogsDb().logs[general_chat_channel_metadata.id] then
      CreateNewLogStructure(
        general_chat_channel_metadata.id,
        general_chat_channel_metadata.name
      )
    elseif
      not Elephant:LogsDb().logs[general_chat_channel_metadata.id].name
    then
      -- Fix for a bug where names would not be populated properly
      Elephant:LogsDb().logs[general_chat_channel_metadata.id].name =
        general_chat_channel_metadata.name
    end
  end
end

--[[
  Iterates over all custom channels joined by the user (other than trade,
  worlddefense, ...) and creates a new structure for each new one found, keeping
  the existing ones intact.
]]
function Elephant:MaybeInitCustomStructures()
  -- Max: 20 channels
  for channel_index = 1, 20 do
    local _, channel_name = GetChannelName(channel_index)

    if channel_name ~= nil then
      local channel_custom_id = string.lower(channel_name)

      if
        not Elephant:IsPartialGeneralChatChannelId(channel_custom_id)
        and not Elephant:IsFiltered(channel_custom_id)
      then
        Elephant:MaybeInitCustomStructure(channel_custom_id, channel_name)
      end
    end
  end
end

--[[
  Checks if a log with the given id exists in the saved data:
   - If it exists, returns immediately.
   - If not, creates a new structure for that log, using the given name. Then,
     if the log is enabled (depends on the "log new channels" option), adds a
     first header to the log.
]]
function Elephant:MaybeInitCustomStructure(id, name)
  if Elephant:LogsDb().logs[id] then
    return
  end

  CreateNewLogStructure(id, name)
  if Elephant:LogsDb().logs[id].enabled then
    AddHeaderToTable(Elephant:LogsDb().logs[id])
  end
end

--[[
  Iterates over all the saved logs and for each *enabled* log found:
   - adds a header
   - checks its size

  If non_custom_channels_only is true, this is done only to channels that have
  not been manually joined by the user (i.e. whisper, raid, ... and trade,
  worlddefense, ...).
]]
function Elephant:AddHeaderToStructures(non_custom_channels_only)
  for index_or_name_id, log_struct in pairs(Elephant:LogsDb().logs) do
    if log_struct.enabled then
      if
        non_custom_channels_only == nil
        or non_custom_channels_only == false
        or (
          non_custom_channels_only == true
          and (
            type(index_or_name_id) == "number"
            or Elephant:IsExactGeneralChatChannelId(index_or_name_id)
          )
        )
      then
        AddHeaderToTable(log_struct)
      end
    end
    CheckTableSize(index_or_name_id)
  end
end

--[[
  Changes the maximum size of all logs to the new given value. It reduces the
  size of each log if required.
]]
function Elephant:ChangeMaxLog(new_max_log)
  if new_max_log < Elephant:DefaultConfiguration().minlogsize then
    return
  end
  if new_max_log > Elephant:DefaultConfiguration().maxlogsize then
    return
  end

  Elephant:FactionRealmDb().maxlog = new_max_log

  for index_or_name_id in pairs(Elephant:LogsDb().logs) do
    CheckTableSize(index_or_name_id)
  end

  if new_max_log < Elephant:VolatileConfig().currentline then
    Elephant:VolatileConfig().currentline = new_max_log
  end

  Elephant:SetTitleInfoMaxLog()
  Elephant:ShowCurrentLog()
end

--[[
  Empties the current log. Then, if it is enabled, adds a brand new header to
  it. Also warns the user of the operation.
]]
function Elephant:EmptyCurrentLog()
  Elephant:LogsDb().logs[Elephant:CharDb().currentlogindex].logs = {}
  if Elephant:LogsDb().logs[Elephant:CharDb().currentlogindex].enabled then
    AddHeaderToTable(Elephant:LogsDb().logs[Elephant:CharDb().currentlogindex])
  end

  Elephant:Print(
    format(
      Elephant.L["STRING_INFORM_CHAT_LOG_EMPTIED"],
      Elephant:LogsDb().logs[Elephant:CharDb().currentlogindex].name
    )
  )

  Elephant:VolatileConfig().currentline =
    #Elephant:LogsDb().logs[Elephant:CharDb().currentlogindex].logs
  Elephant:ShowCurrentLog()
end

--[[
  Removes all contents of all logs, and adds back a brand new header for each
  log that is enabled. Also warns the user of the operation.
]]
function Elephant:ClearAllLogs()
  for _, log_struct in pairs(Elephant:LogsDb().logs) do
    log_struct.logs = {}
    if log_struct.enabled then
      AddHeaderToTable(log_struct)
    end
  end

  Elephant:Print(Elephant.L["STRING_INFORM_CHAT_CLEAR_LOGS_SUCCESS"])

  Elephant:VolatileConfig().currentline =
    #Elephant:LogsDb().logs[Elephant:CharDb().currentlogindex].logs
  Elephant:ShowCurrentLog()
end

-- Totally removes the structure of the current log.
function Elephant:DeleteCurrentLog()
  DeleteLog(Elephant:CharDb().currentlogindex)
end

--[[
  Captures the given message at the end of the log at the given
  index_or_name_id. It also sets the "hasMessage" value of the log.

  If the affected log is the displayed one, moves the log one line down if the
  last line was displayed (otherwise, doesn't change it).
]]
function Elephant:CaptureNewMessage(message_struct, index_or_name_id)
  if message_struct.prat ~= nil and message_struct.lineid ~= nil then
    local last_message_struct =
      Elephant:LogsDb().logs[index_or_name_id].logs[#Elephant:LogsDb().logs[index_or_name_id].logs]
    if
      message_struct.prat == last_message_struct.prat
      and message_struct.lineid == last_message_struct.lineid
    then
      -- Duplicate message, nothing to do
      return
    end
  end

  table.insert(
    Elephant:LogsDb().logs[index_or_name_id].logs,
    #Elephant:LogsDb().logs[index_or_name_id].logs + 1,
    message_struct
  )

  if not Elephant:LogsDb().logs[index_or_name_id].hasMessage then
    Elephant:LogsDb().logs[index_or_name_id].hasMessage = true
  end

  if Elephant:CharDb().currentlogindex == index_or_name_id then
    -- Moves the current line if it was at the last line
    if
      Elephant:VolatileConfig().currentline
      == (#Elephant:LogsDb().logs[index_or_name_id].logs - 1)
    then
      Elephant:VolatileConfig().currentline = Elephant:VolatileConfig().currentline
        + 1
    end

    --[[
      Note: in case the log is reduced, we should redisplay it if the user is
      displaying the begin of it, since the first of its lines disappear in the
      process. However, we do not do it in order to save some time and process;
      the display will be updated if the user moves through the log. This brings
      a weird behavior where lines currently seen by the user may not be found
      anymore after the user moves through the log, but we keep it like this
      since it covers most of the usage of the addon.
    ]]
    Elephant:VolatileConfig().currentline = Elephant:VolatileConfig().currentline
      - CheckTableSize(index_or_name_id)
    if Elephant:VolatileConfig().currentline < 1 then
      Elephant:VolatileConfig().currentline = 1
    end

    if
      Elephant:VolatileConfig().currentline
      == #Elephant:LogsDb().logs[index_or_name_id].logs
    then
      -- Adds the message to the screen
      ElephantFrameScrollingMessageFrame:AddMessage(
        Elephant:GetLiteralMessage(message_struct, true)
      )
    end
    -- Updates current line text
    Elephant:SetTitleInfoCurrentLine()
  else
    CheckTableSize(index_or_name_id)
  end
end

--[[
  This method:
   - hides the Elephant button,
   - resets savec variables to default,
   - sets the chat and combat log WoW logging to the default (false),
   - recreates any structure related to currently custom channels joined,
   - recreates all defaut structures and adds headers to it,
   - refreshes the event registered by the addon in case we were using Prat
     formatting,
   - resets the position of the main window,
   - changes the log to the default one,
   - prints a message to the user.
]]
function Elephant:Reset()
  if ElephantButtonFrame and ElephantButtonFrame:IsVisible() then
    ElephantButtonFrame:Hide()
    Elephant:ResetButtonPosition()
  end

  ResetSavedVariables()

  Elephant:ChatLogEnable(Elephant:ProfileDb().chatlog)
  Elephant:CombatLogEnable(Elephant:ProfileDb().combatlog)

  for channel_index = 1, GetNumDisplayChannels() do
    local _, channel_name = GetChannelName(channel_index)

    if channel_name ~= nil then
      local channel_name_lowercase = string.lower(channel_name)
      if not Elephant:IsPartialGeneralChatChannelId(channel_name_lowercase) then
        Elephant:MaybeInitCustomStructure(channel_name_lowercase, channel_name)
        Elephant:CaptureNewMessage({
          type = "SYSTEM",
          arg1 = Elephant.L["STRING_SPECIAL_LOG_JOINED_CHANNEL"],
        }, channel_name_lowercase)
      end
    end
  end

  Elephant:MaybeInitDefaultLogStructures()
  Elephant:MaybeInitCustomStructures()
  Elephant:AddHeaderToStructures(true)
  Elephant:RegisterEventsRefresh()
  Elephant:ResetPosition()
  Elephant:ChangeLog(Elephant:CharDb().currentlogindex)

  Elephant:RefreshLDBIcon()

  Elephant:Print(Elephant.L["STRING_INFORM_CHAT_RESET_SETTINGS_SUCCESS"])

  -- Force refresh of options frame
  LibStub("AceConfigRegistry-3.0"):NotifyChange("Elephant")
end

--[[
  Enables or disables logging of the current log, depending on its current
  logging status. Whether the logging is enabled or disabled, a new message is
  added to the current log that warns of the change.

  The buttons of the current log are also updated (enabling/disabling as
  needed).
]]
function Elephant:ToggleEnableCurrentLog()
  Elephant:LogsDb().logs[Elephant:CharDb().currentlogindex].enabled =
    not Elephant:LogsDb().logs[Elephant:CharDb().currentlogindex].enabled

  if Elephant:LogsDb().logs[Elephant:CharDb().currentlogindex].enabled then
    Elephant:CaptureNewMessage(
      { arg1 = " " },
      Elephant:CharDb().currentlogindex
    )
    Elephant:CaptureNewMessage(
      { arg1 = " " },
      Elephant:CharDb().currentlogindex
    )
  end
  Elephant:CaptureNewMessage({
    type = "SYSTEM",
    arg1 = Elephant:GetStateChangeActionMsg(
      Elephant:LogsDb().logs[Elephant:CharDb().currentlogindex].enabled
    ),
  }, Elephant:CharDb().currentlogindex)

  Elephant:UpdateCurrentLogButtons()
end

--[[
  Adds the new given filter to the list of filters, if it does not already
  exist. A message is displayed to the user when it is done.

  Then the list of custom channels joined is traversed, and all channels
  matching the new filter are deleted. If the current log was deleted, changes
  it to the default one.
]]
function Elephant:AddFilter(new_filter)
  for _, filter in pairs(Elephant:ProfileDb().filters) do
    if filter == new_filter then
      return
    end
  end

  table.insert(Elephant:ProfileDb().filters, new_filter)
  Elephant:Print(
    format(Elephant.L["STRING_INFORM_CHAT_FILTER_ADDED"], new_filter)
  )

  for index_or_name_id, _ in pairs(Elephant:LogsDb().logs) do
    if
      type(index_or_name_id) ~= "number"
      and string.find(index_or_name_id, " ") == nil
    then
      if Elephant:IsFiltered(index_or_name_id) then
        DeleteLog(index_or_name_id)
        --[[
          If displayed log has just been deleted, display the default one
          instead.
        ]]
        if Elephant:CharDb().currentlogindex == index_or_name_id then
          Elephant:ChangeLog(Elephant:DefaultConfiguration().defaultlogindex)
        end
      end
    end
  end
end

--[[
  Checks if the given log index is filtered on not, based on the current saved
  filters. Note that the index must be in lower case and must not contain any
  special char, i.e. "-", ... However, this should never happen since we never
  check if a *general* chat is filtered.
]]
function Elephant:IsFiltered(index)
  for _, filter in pairs(Elephant:ProfileDb().filters) do
    filter = "^" .. string.gsub(string.lower(filter), "%*", "%.%*") .. "$"
    if
      string.match(index, filter) ~= nil
      and not Elephant:IsExactGeneralChatChannelId(index)
    then
      return true
    end
  end

  return false
end

--[[
  Deletes the filter at the given index. After doing so, recreates structures
  for all joined custom channels that were filtered.
]]
function Elephant:DeleteFilter(filter_index)
  if not Elephant:ProfileDb().filters[filter_index] then
    return
  end
  -- Must be displayed before deleting filter, obviously
  Elephant:Print(
    format(
      Elephant.L["STRING_INFORM_CHAT_FILTER_DELETED"],
      Elephant:ProfileDb().filters[filter_index]
    )
  )
  Elephant:ProfileDb().filters[filter_index] = nil

  Elephant:MaybeInitCustomStructures()
end

--[[
  Enables the given catcher (= name of the event) for the channel at the given
  index (number or name).
]]
function Elephant:EnableCatcher(catch, channel)
  Elephant:ProfileDb().events[catch].channels[channel] = 1
end

--[[
  Disables the given catcher (= name of the event) for the channel at the given
  index (number or name).
]]
function Elephant:DisableCatcher(catch, channel)
  Elephant:ProfileDb().events[catch].channels[channel] = 0
end
