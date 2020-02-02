--[[
Iterates over all custom channels joined by the user
(other than trade, worlddefense, ...) and creates a new
structure for each new one found, keeping the existing
ones intact.
]]
local function InitCustomStructures()
  local channelCustomId, channelName
  local found
  local i
  -- Max: 20 channels
  for i=1,20 do
    _,channelName = GetChannelName(i)

    if channelName ~= nil then
      channelCustomId = string.lower(channelName)

      found = false
      for k,v in pairs(Elephant.L['generalchats']) do
        if (channelCustomId == k) or string.find(channelCustomId, k .. " - ") then
          found = true
          break
        end
      end

      if not found and not Elephant:IsFiltered(channelCustomId) then
        Elephant:InitCustomStructure(string.lower(channelName), channelName)
      end
    end
  end
end

--[[
Creates a new log structure at the given index, using
the given friendly name. It also sets the default
"enabled" value, based on the user preference "log new
channels".
]]
local function CreateNewLogStructure(index, name)
  Elephant.dbpc.char.logs[index] = {}

  Elephant.dbpc.char.logs[index].name = name
  Elephant.dbpc.char.logs[index].enabled = Elephant.db.profile.defaultlog
  Elephant.dbpc.char.logs[index].logs = {}
end

--[[
Adds the given message to the given table
at (size of table)+1.
]]
local function AddMsgToTable(t, msg)
  t[#t+1] = msg
end

--[[
Saves the given message in the given table
at the specified position.
]]
local function SaveMsgToTableAtPosition(t, msg, position)
  t[position] = msg
end

--[[
Adds a header to the given log object.
Warning: should only be used if the log of
this chat *is* enabled.

Header may not literally add something to
the log: if the last message of the log was
a header, then this header is modified to
reflect the new date and time.
]]
local function AddHeaderToTable(logObject)
  -- For "easier-to-read" code
  local t = logObject.logs

  -- If log is not empty
  if #t > 0 then
    if not logObject.hasMessage then
      -- If the log does not have a message since the last header
      -- then simply modify the last header
      SaveMsgToTableAtPosition(t, { ['type'] = "SYSTEM", ['arg1'] = Elephant:GetStateChangeActionMsg(true) } , #t)
    else
      -- Otherwise add two lines
      AddMsgToTable(t, { ['arg1'] = " " } )
      AddMsgToTable(t, { ['arg1'] = " " } )
    end
  end

  -- If log did save a message since the last header
  -- or log is empty
  if logObject.hasMessage or #t == 0 then
    AddMsgToTable(t, { ['type'] = "SYSTEM", ['arg1'] = Elephant:GetStateChangeActionMsg(true) } )
  end

  -- Specify that no messages has been saved since the last header
  if logObject.hasMessage then
    logObject.hasMessage = false
  end
end

--[[
Checks if the log at the given index is not
bigger than the maximum size defined by the
user. If it is, repeatedly removes the first
line of the log (= the oldest) until it reaches
the maximum permitted size.

It then returns the number of deleted lines
(may be 0).
]]
local function CheckTableSize(index)
  local mLog
  local i=0

  mLog = Elephant.db.profile.maxlog

  while #Elephant.dbpc.char.logs[index].logs > mLog do
    table.remove(Elephant.dbpc.char.logs[index].logs, 1)
    i = i+1
  end

  return i
end

--[[
Totally removes the structure of the log
at the given index, and warns the user of
the operation.
]]
local function DeleteLog(index)
  -- Print must be done *before* deleting, obviously
  Elephant:Print( format(Elephant.L['deleteconfirm'], Elephant.dbpc.char.logs[index].name) )
  Elephant.dbpc.char.logs[index] = nil
end

--[[
Resets saved variables to the default ones
defined in the core of Elephant. Basically
replaces the current table by a new and
known one.
]]
local function ResetSavedVariables()
  for k,v in pairs(Elephant:clone(Elephant.defaultConf.savedconfdefaults)) do
    Elephant.db.profile[k] = v
  end
  for k,v in pairs(Elephant:clone(Elephant.defaultConf.savedpercharconfdefaults)) do
    Elephant.dbpc.char[k] = v
  end
end

--[[
Iterates over all Elephant default indexes (whisper, ...) and
general chats (trade, worlddefense, ...) and creates a new log
structure for them.
]]
function Elephant:InitDefaultLogStructures()
  local k,v
  for k,v in pairs(Elephant.defaultConf.defaultindexes) do
    if not Elephant.dbpc.char.logs[v] then
      CreateNewLogStructure(v, Elephant.defaultConf.defaultnames[k])
    end
  end

  for k,v in pairs(Elephant.L['generalchats']) do
    if not Elephant.dbpc.char.logs[k] then
      CreateNewLogStructure(k, v.name)
    end
  end
end

--[[
Checks if a log with the given id exists in the saved data.
- If it exists, returns immediately.
- If not, creates a new structure for that log, using the
  given name. Then, if the log is enabled (depends on the
  "log new channels" option), adds a first header to the log.
]]
function Elephant:InitCustomStructure(id, name)
  if Elephant.dbpc.char.logs[id] then
    return
  end

  CreateNewLogStructure(id, name)
  if Elephant.dbpc.char.logs[id].enabled then
    AddHeaderToTable(Elephant.dbpc.char.logs[id])
  end
end

--[[
Iterates over all the saved logs and for each
*enabled* log found:
- adds a header
- checks its size
If nonCustomChannelsOnly is true, this is done
only to channels that have not been manually
joined by the user (i.e. whisper, raid, ... and
trade, worlddefense, ...).
]]
function Elephant:AddHeaderToStructures(nonCustomChannelsOnly)
  local k, v

  for k,v in pairs(Elephant.dbpc.char.logs) do
    if v.enabled then
      if
        nonCustomChannelsOnly == nil or
        nonCustomChannelsOnly == false or (
          nonCustomChannelsOnly == true and (
            type(k) == "number" or
            Elephant.L['generalchats'][k]
          )
        )
      then
        AddHeaderToTable(v)
      end
    end
    CheckTableSize(k)
  end
end

--[[
Changes the maximum size of all logs to the
new given value. It reduces the size of each
log if required.
]]
function Elephant:ChangeMaxLog(nb)
  if (nb < Elephant.defaultConf.minlogsize) then return end
  if (nb > Elephant.defaultConf.maxlogsize) then return end

  Elephant.db.profile.maxlog = nb

  local k
  for k in pairs(Elephant.dbpc.char.logs) do
    CheckTableSize(k)
  end

  if (nb < Elephant.tempConf.currentline) then
    Elephant.tempConf.currentline = nb
  end

  Elephant:SetTitleInfoMaxLog()
  Elephant:ShowCurrentLog()
end

--[[
Empties the current log. Then, if it is enabled,
adds a brand new header to it. Also warns the
user of the operation.
]]
function Elephant:EmptyCurrentLog()
  Elephant.dbpc.char.logs[Elephant.dbpc.char.currentlogindex].logs = {}
  if Elephant.dbpc.char.logs[Elephant.dbpc.char.currentlogindex].enabled then
    AddHeaderToTable(Elephant.dbpc.char.logs[Elephant.dbpc.char.currentlogindex])
  end

  Elephant:Print( format(Elephant.L['emptyconfirm'], Elephant.dbpc.char.logs[Elephant.dbpc.char.currentlogindex].name) )

  Elephant.tempConf.currentline = #Elephant.dbpc.char.logs[Elephant.dbpc.char.currentlogindex].logs
  Elephant:ShowCurrentLog()
end

--[[
Removes all contents of all logs, and adds back
a brand new header for each log that is enabled.
Also warns the user of the operation.
]]
function Elephant:ClearAllLogs()
  local k, v
  for k,v in pairs(Elephant.dbpc.char.logs) do
    v.logs = {}
    if v.enabled then
      AddHeaderToTable(v)
    end
  end

  Elephant:Print(Elephant.L['clearallconfirm'])

  Elephant.tempConf.currentline = #Elephant.dbpc.char.logs[Elephant.dbpc.char.currentlogindex].logs
  Elephant:ShowCurrentLog()
end

--[[
Totally removes the structure of the current log.
]]
function Elephant:DeleteCurrentLog()
  DeleteLog(Elephant.dbpc.char.currentlogindex)
end

--[[
Captures the given message at the end of
the log at the given index. It also sets
the "hasMessage" value of the log.

If the affected log is the displayed one,
moves the log one line down if the last
line was displayed (otherwise, doesn't
change it).
]]
function Elephant:CaptureNewMessage(msg, index)
  table.insert(Elephant.dbpc.char.logs[index].logs, #Elephant.dbpc.char.logs[index].logs+1, msg)

  if not Elephant.dbpc.char.logs[index].hasMessage then
    Elephant.dbpc.char.logs[index].hasMessage = true
  end

  if Elephant.dbpc.char.currentlogindex == index then
    -- Moves the current line if it was at the last line
    if Elephant.tempConf.currentline == (#Elephant.dbpc.char.logs[index].logs-1) then
      Elephant.tempConf.currentline = Elephant.tempConf.currentline + 1
    end

    -- Note: in case the log is reduced, we should redisplay it
    -- if the user is displaying the begin of it, since the first
    -- of its lines disappear in the process.
    -- However, we do not do it in order to save some time and
    -- process; the display will be updated if the user moves
    -- through the log. This brings a weird behavior where lines
    -- currently seen by the user may not be found anymore
    -- after the user moves through the log, but we keep it like
    -- this since it covers most of the usage of the addon.
    Elephant.tempConf.currentline = Elephant.tempConf.currentline - CheckTableSize(index)
    if Elephant.tempConf.currentline < 1 then
      Elephant.tempConf.currentline = 1
    end

    if Elephant.tempConf.currentline == #Elephant.dbpc.char.logs[index].logs then
      -- Adds the message to the screen
      ElephantFrameScrollingMessageFrame:AddMessage(Elephant:GetLiteralMessage(msg, true))
    end
    -- Updates current line text
    Elephant:SetTitleInfoCurrentLine()
  else
    CheckTableSize(index)
  end
end

--[[
This method:
- hides the Elephant button,
- resets savec variables to default,
- sets the chat and combat log WoW logging
  to the default (false),
- recreates any structure related to
  currently custom channels joined,
- recreates all defaut structures and adds
  headers to it,
- refreshes the event registered by the
  addon in case we were using Prat formatting,
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

  Elephant:ChatLogEnable(Elephant.db.profile.chatlog)
  Elephant:CombatLogEnable(Elephant.db.profile.combatlog)

  local k, v
  local lcname
  local found
  local channelName
  local i
  for i=1,GetNumDisplayChannels() do
    _,channelName = GetChannelName(i)

    if channelName ~= nil then
      lcname = string.lower(channelName)
      found = false
      for k,v in pairs(Elephant.L['generalchats']) do
        if (lcname == k) or string.find(lcname, k .. " - ") then
          found = true
          break
        end
      end
      if not found then
        Elephant:InitCustomStructure(lcname, channelName)
        Elephant:CaptureNewMessage( { ['type'] = "SYSTEM", ['arg1'] = Elephant.L['customchat']['join'] } , lcname)
      end
    end
  end

  Elephant:InitDefaultLogStructures()
  InitCustomStructures()
  Elephant:AddHeaderToStructures(true)
  Elephant:RegisterEventsRefresh()
  Elephant:ResetPosition()
  Elephant:ChangeLog(Elephant.dbpc.char.currentlogindex)

  Elephant:RefreshLDBIcon()

  Elephant:Print(Elephant.L['resetconfirm'])

  -- Force refresh of options frame
  InterfaceOptionsFrame_OpenToCategory("Elephant")
end

--[[
Enables or disables logging of the current
log, depending on its current logging status.
Whether the logging is enabled or disabled,
a new message is added to the current log
that warns of the change.

The buttons of the current log are also
updated (enabling/disabling as needed).
]]
function Elephant:ToggleEnableCurrentLog()
  Elephant.dbpc.char.logs[Elephant.dbpc.char.currentlogindex].enabled = not Elephant.dbpc.char.logs[Elephant.dbpc.char.currentlogindex].enabled

  if Elephant.dbpc.char.logs[Elephant.dbpc.char.currentlogindex].enabled then
    Elephant:CaptureNewMessage( { ['arg1'] = " " } , Elephant.dbpc.char.currentlogindex)
    Elephant:CaptureNewMessage( { ['arg1'] = " " } , Elephant.dbpc.char.currentlogindex)
  end
  Elephant:CaptureNewMessage( { ['type'] = "SYSTEM", ['arg1'] = Elephant:GetStateChangeActionMsg(Elephant.dbpc.char.logs[Elephant.dbpc.char.currentlogindex].enabled) } , Elephant.dbpc.char.currentlogindex)

  Elephant:UpdateCurrentLogButtons()
end

--[[
Adds the new given filter to the list of
filters, if it does not already exist. A
message is displayed to the user when
it is done.

Then the list of custom channels joined
is traversed, and all channels matching
the new filter are deleted. If the current
log was deleted, changes it to the default
one.
]]
function Elephant:AddFilter(arg1)
  local v
  for _,v in pairs(Elephant.db.profile.filters) do
    if v == arg1 then
      return
    end
  end

  table.insert(Elephant.db.profile.filters, arg1)
  Elephant:Print(format(Elephant.L['filteradded'], arg1))

  local k,v
  for k,v in pairs(Elephant.dbpc.char.logs) do
    if type(k) ~= "number" and string.find(k, " ") == nil then
      if Elephant:IsFiltered(k) then
        DeleteLog(k)
        -- If displayed log has just been deleted, display the default one instead
        if Elephant.dbpc.char.currentlogindex == k then
          Elephant:ChangeLog(Elephant.defaultConf.savedpercharconfdefaults.currentlogindex)
        end
      end
    end
  end
end

--[[
Checks if the given log index is filtered on not,
based on the current saved filters. Note that
the index must be in lower case and must not
contain any special char, i.e. "-", ... However,
this should never happen since we never check
if a *general* chat is filtered.
]]
function Elephant:IsFiltered(index)
  local v
  for _,v in pairs(Elephant.db.profile.filters) do
    v = "^" .. string.gsub(string.lower(v), "%*", "%.%*") .. "$"
    if string.match(index, v) ~= nil and not Elephant.L['generalchats'][index] then
      return true
    end
  end

  return false
end

--[[
Deletes the filter at the given index. After
doing so, recreates structures for all joined
custom channels that were filtered.
]]
function Elephant:DeleteFilter(filterindex)
  if not Elephant.db.profile.filters[filterindex] then
    return
  end
  -- Must be displayed before deleting filter, obviously
  Elephant:Print(format(Elephant.L['filterdeleted'], Elephant.db.profile.filters[filterindex]))
  Elephant.db.profile.filters[filterindex] = nil

  InitCustomStructures()
end

--[[
Enables the given catcher (= name of the event)
for the channel at the given index (number or name).
]]
function Elephant:EnableCatcher(catch, channel)
  Elephant.db.profile.events[catch].channels[channel] = 1
end

--[[
Disables the given catcher (= name of the event)
for the channel at the given index (number or name).
]]
function Elephant:DisableCatcher(catch, channel)
  Elephant.db.profile.events[catch].channels[channel] = 0
end
