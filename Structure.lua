-- Creates a new log structure at the given index, using the given friendly name
-- if provided (otherwise creates an unamed log). It also sets the default
-- "enabled" value, based on the user preference "log new channels".
local function CreateNewLogStructure(channel_index, name)
  Elephant:LogsDb().logs[channel_index] = {}

  -- The if condition is not really necessary, but helps with readability.
  if name then
    Elephant:LogsDb().logs[channel_index].name = name
  end
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

-- Adds a header to the given log structure. Warning: should only be used if the
-- log of this chat *is* enabled.
--
-- Header may not literally add something to the log: if the last message of the
-- log was a header, then this header is modified to reflect the new date and
-- time.
local function AddHeaderToTable(log_tbl)
  -- For "easier-to-read" code
  local actual_logs_struct = log_tbl.logs

  -- If log is not empty
  if #actual_logs_struct > 0 then
    if not log_tbl.hasMessage then
      -- If the log does not have a message since the last header then simply
      -- modify the last header.
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
  if log_tbl.hasMessage or #actual_logs_struct == 0 then
    AddMsgToTable(
      actual_logs_struct,
      { type = "SYSTEM", arg1 = Elephant:GetStateChangeActionMsg(true) }
    )
  end

  -- Specify that no messages has been saved since the last header
  if log_tbl.hasMessage then
    log_tbl.hasMessage = false
  end
end

-- Checks if the log at the given index is not bigger than the maximum size
-- defined by the user. If it is, repeatedly removes the first line of the log (=
-- the oldest) until it reaches the maximum permitted size.
--
-- It then returns the number of deleted lines (may be 0).
local function CheckTableSize(log_index)
  local max_log_size = Elephant:FactionRealmDb().maxlog

  local deleted_lines = 0
  while #Elephant:LogsDb().logs[log_index].logs > max_log_size do
    table.remove(Elephant:LogsDb().logs[log_index].logs, 1)
    deleted_lines = deleted_lines + 1
  end

  return deleted_lines
end

-- Totally removes the structure of the log at the given index, and warns the
-- user of the operation.
local function DeleteLog(log_index)
  -- Print must be done *before* deleting, obviously
  Elephant:Print(
    format(
      Elephant.L["STRING_INFORM_CHAT_LOG_DELETED"],
      Elephant:GetLogName(log_index)
    )
  )
  Elephant:LogsDb().logs[log_index] = nil
end

-- Resets saved variables to the default ones defined in the core of Elephant.
-- Basically replaces the current table by a new and known one.
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

-- Returns true if the given channel ID partially corresponds to a general chat
-- channel id, e.g. "trading (services) - Orgrimmar."
local IsPartialGeneralChatChannelId(channel_id)
  for _, general_chat_channel_tbl in
    pairs(Elephant:DefaultConfiguration().generalchatchannels)
  do
    if
      Elephant:ChannelIdPartiallyMatches(
        channel_id,
        general_chat_channel_tbl.id
      )
      or Elephant:ChannelIdPartiallyMatches(
        channel_id,
        general_chat_channel_tbl.alt_id
      )
    then
      return true
    end
  end
  return false
end

-- Returns true if the given log index corresponds to a general chat channel ID.
function Elephant:IsGeneralChatLogIndex(log_index)
  for _, general_chat_channel_tbl in
    pairs(Elephant:DefaultConfiguration().generalchatchannels)
  do
    if
      log_index == general_chat_channel_tbl.id
      or log_index == general_chat_channel_tbl.id_alt
    then
      return true
    end
  end
  return false
end

-- Returns true if the channel ID partially matches the general chat channel ID.
-- For example, if the parameters ("trade (services) - Orgrimmar", "trade
-- (services)") are given, this method will return true.
--
-- This method supports common separators between channel IDs and locations,
-- such as "-", ":", etc.
function Elephant:ChannelIdPartiallyMatches(channel_id, general_chat_channel_id)
  if not general_chat_channel_id then
    return false
  end
  return (channel_id == general_chat_channel_id)
    or string.find(channel_id, general_chat_channel_id .. " - ", 1, true)
    or string.find(channel_id, general_chat_channel_id .. " – ", 1, true)
    or string.find(channel_id, general_chat_channel_id .. ": ", 1, true)
end

-- Iterates over all Elephant default indexes (whisper, ...) and general chats
-- (trade, worlddefense, ...) and creates a new log structure for them.
function Elephant:MaybeInitDefaultLogStructures()
  for name_id, log_tbl in pairs(Elephant:DefaultConfiguration().defaultlogs) do
    if not Elephant:LogsDb().logs[log_tbl.id] then
      CreateNewLogStructure(log_tbl.id)
    end
  end

  for _, general_chat_channel_tbl in
    pairs(Elephant:DefaultConfiguration().generalchatchannels)
  do
    if not Elephant:LogsDb().logs[general_chat_channel_tbl.id] then
      -- The name is only used if a client locale change is detected; in this
      -- case, the logs will not be identified as general chats anymore and will
      -- thus revert to using the names from before the locale switch.
      CreateNewLogStructure(
        general_chat_channel_tbl.id,
        general_chat_channel_tbl.localized_name
      )
    end
  end
end

-- Iterates over all custom channels joined by the user (other than trade,
-- worlddefense, ...) and creates a new structure for each new one found,
-- keeping the existing ones intact.
function Elephant:MaybeInitCustomStructures()
  -- Max: 20 channels
  for channel_index = 1, 20 do
    local _, channel_name = GetChannelName(channel_index)

    if channel_name ~= nil then
      local channel_custom_id = string.lower(channel_name)

      if
        not IsPartialGeneralChatChannelId(channel_custom_id)
        and not Elephant:IsFiltered(channel_custom_id)
      then
        Elephant:MaybeInitCustomStructure(channel_custom_id, channel_name)
      end
    end
  end
end

-- Checks if a log with the given id exists in the saved data:
--   • If it exists, returns immediately.
--   • If not, creates a new structure for that log, using the given name. Then,
--     if the log is enabled (depends on the "log new channels" option), adds a
--     first header to the log.
function Elephant:MaybeInitCustomStructure(id, name)
  if Elephant:LogsDb().logs[id] then
    return
  end

  CreateNewLogStructure(id, name)
  if Elephant:LogsDb().logs[id].enabled then
    AddHeaderToTable(Elephant:LogsDb().logs[id])
  end
end

-- Iterates over all the saved logs and for each *enabled* log found:
--   • adds a header
--   • checks its size
--
-- If non_custom_channels_only is true, this is done only to channels that have
-- not been manually joined by the user (i.e. whisper, raid, ... and trade,
-- worlddefense, ...).
function Elephant:AddHeaderToStructures(non_custom_channels_only)
  for log_index, log_tbl in pairs(Elephant:LogsDb().logs) do
    if log_tbl.enabled then
      if
        non_custom_channels_only == nil
        or non_custom_channels_only == false
        or (
          non_custom_channels_only == true
          and (
            type(log_index) == "number"
            or Elephant:IsGeneralChatLogIndex(log_index)
          )
        )
      then
        AddHeaderToTable(log_tbl)
      end
    end
    CheckTableSize(log_index)
  end
end

-- Changes the maximum size of all logs to the new given value. It reduces the
-- size of each log if required.
function Elephant:ChangeMaxLog(new_max_log)
  if new_max_log < Elephant:DefaultConfiguration().minlogsize then
    return
  end
  if new_max_log > Elephant:DefaultConfiguration().maxlogsize then
    return
  end

  Elephant:FactionRealmDb().maxlog = new_max_log

  for log_index in pairs(Elephant:LogsDb().logs) do
    CheckTableSize(log_index)
  end

  if new_max_log < Elephant:VolatileConfig().currentline then
    Elephant:VolatileConfig().currentline = new_max_log
  end

  Elephant:SetTitleInfoMaxLog()
  Elephant:ShowCurrentLog()
end

-- Empties the current log. Then, if it is enabled, adds a brand new header to
-- it. Also warns the user of the operation.
function Elephant:EmptyCurrentLog()
  local current_log_index = Elephant:CharDb().currentlogindex
  Elephant:LogsDb().logs[current_log_index].logs = {}
  if Elephant:LogsDb().logs[current_log_index].enabled then
    AddHeaderToTable(Elephant:LogsDb().logs[current_log_index])
  end

  Elephant:Print(
    format(
      Elephant.L["STRING_INFORM_CHAT_LOG_EMPTIED"],
      Elephant:GetLogName(current_log_index)
    )
  )

  Elephant:VolatileConfig().currentline =
    #Elephant:LogsDb().logs[current_log_index].logs
  Elephant:ShowCurrentLog()
end

-- Removes all contents of all logs, and adds back a brand new header for each
-- log that is enabled. Also warns the user of the operation.
function Elephant:ClearAllLogs()
  for _, log_tbl in pairs(Elephant:LogsDb().logs) do
    log_tbl.logs = {}
    if log_tbl.enabled then
      AddHeaderToTable(log_tbl)
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

-- Captures the given message at the end of the log at the given
-- log_index. It also sets the "hasMessage" value of the log.
--
-- If the affected log is the displayed one, moves the log one line down if the
-- last line was displayed (otherwise, doesn't change it).
function Elephant:CaptureNewMessage(message_struct, log_index)
  if message_struct.prat ~= nil and message_struct.lineid ~= nil then
    local last_message_struct =
      Elephant:LogsDb().logs[log_index].logs[#Elephant:LogsDb().logs[log_index].logs]
    if
      message_struct.prat == last_message_struct.prat
      and message_struct.lineid == last_message_struct.lineid
    then
      -- Duplicate message, nothing to do
      return
    end
  end

  table.insert(
    Elephant:LogsDb().logs[log_index].logs,
    #Elephant:LogsDb().logs[log_index].logs + 1,
    message_struct
  )

  if not Elephant:LogsDb().logs[log_index].hasMessage then
    Elephant:LogsDb().logs[log_index].hasMessage = true
  end

  if Elephant:CharDb().currentlogindex == log_index then
    -- Moves the current line if it was at the last line
    if
      Elephant:VolatileConfig().currentline
      == (#Elephant:LogsDb().logs[log_index].logs - 1)
    then
      Elephant:VolatileConfig().currentline = Elephant:VolatileConfig().currentline
        + 1
    end

    -- Note: in case the log is reduced, we should redisplay it if the user is
    -- displaying the begin of it, since the first of its lines disappear in the
    -- process. However, we do not do it in order to save some time and process;
    -- the display will be updated if the user moves through the log. This
    -- brings a weird behavior where lines currently seen by the user may not be
    -- found anymore after the user moves through the log, but we keep it like
    -- this since it covers most of the usage of the addon.
    Elephant:VolatileConfig().currentline = Elephant:VolatileConfig().currentline
      - CheckTableSize(log_index)
    if Elephant:VolatileConfig().currentline < 1 then
      Elephant:VolatileConfig().currentline = 1
    end

    if
      Elephant:VolatileConfig().currentline
      == #Elephant:LogsDb().logs[log_index].logs
    then
      -- Adds the message to the screen
      ElephantFrameScrollingMessageFrame:AddMessage(
        Elephant:GetLiteralMessage(message_struct, true)
      )
    end
    -- Updates current line text
    Elephant:SetTitleInfoCurrentLine()
  else
    CheckTableSize(log_index)
  end
end

-- This method:
--   • hides the Elephant button,
--   • resets savec variables to default,
--   • sets the chat and combat log WoW logging to the default (false),
--   • recreates any structure related to currently custom channels joined,
--   • recreates all defaut structures and adds headers to it,
--   • refreshes the event registered by the addon in case we were using Prat
--     formatting,
--   • resets the position of the main window,
--   • changes the log to the default one,
--   • prints a message to the user.
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
      if not IsPartialGeneralChatChannelId(channel_name_lowercase) then
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

-- Enables or disables logging of the current log, depending on its current
-- logging status. Whether the logging is enabled or disabled, a new message is
-- added to the current log that warns of the change.
--
-- The buttons of the current log are also updated (enabling/disabling as
-- needed).
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

-- Adds the new given filter to the list of filters, if it does not already
-- exist. A message is displayed to the user when it is done.
--
-- Then the list of custom channels joined is traversed, and all channels
-- matching the new filter are deleted. If the current log was deleted, changes
-- it to the default one.
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

  for log_index, _ in pairs(Elephant:LogsDb().logs) do
    if
      type(log_index) ~= "number"
      and string.find(log_index, " ") == nil
    then
      if Elephant:IsFiltered(log_index) then
        DeleteLog(log_index)
        -- If displayed log has just been deleted, display the default one
        -- instead.
        if Elephant:CharDb().currentlogindex == log_index then
          Elephant:ChangeLog(Elephant:DefaultConfiguration().defaultlogindex)
        end
      end
    end
  end
end

-- Checks if the given log index is filtered on not, based on the current saved
-- filters. Note that the index must be in lower case and must not contain any
-- special char, i.e. "-", ... However, this should never happen since we never
-- check if a *general* chat is filtered.
function Elephant:IsFiltered(index)
  for _, filter in pairs(Elephant:ProfileDb().filters) do
    filter = "^" .. string.gsub(string.lower(filter), "%*", "%.%*") .. "$"
    if
      string.match(index, filter) ~= nil
      and not Elephant:IsGeneralChatLogIndex(index)
    then
      return true
    end
  end

  return false
end

-- Deletes the filter at the given index. After doing so, recreates structures
-- for all joined custom channels that were filtered.
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

-- Enables the given catcher (= name of the event) for the channel at the given
-- index (number or name).
function Elephant:EnableCatcher(catch, channel)
  Elephant:ProfileDb().events[catch].channels[channel] = 1
end

-- Disables the given catcher (= name of the event) for the channel at the given
-- index (number or name).
function Elephant:DisableCatcher(catch, channel)
  Elephant:ProfileDb().events[catch].channels[channel] = 0
end
