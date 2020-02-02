--[[
Returns the hexadecimal string corresponding
to the color of the class of the player with the
given GUID, or nil if either the GUID is nil,
corresponds to no player, or the found class
color does not exist.
]]
local function GetClassColorByGUID(guid)
  if guid and guid ~= "" then
    local _, englishClass = GetPlayerInfoByGUID(guid)
    if englishClass then
      local classColorTable = RAID_CLASS_COLORS[englishClass];
      if classColorTable then
        return Elephant:MakeTextHexColor(classColorTable.r, classColorTable.g, classColorTable.b)
      end
    end
  end
  return nil
end

--[[
Returns the channel index to be used for the given channel name.
Correctly detects general channels and returns an appropriate
integer for them.
]]
local function getCIndexFromChannelName(channelName)
  channelName = string.lower(channelName)
  local cIndex
  for k, v in pairs(Elephant.L['generalchats']) do
    if (channelName == k) or string.find(channelName, k .. " - ") then
      cIndex = k
      break
    end
  end
  if cIndex == nil then
    -- Custom channel name
    cIndex = channelName
  end
  return cIndex
end

--[[
Handles messages sent by the WoW engine
as well as the ones sent by Prat.
]]
local function HandleMessage(prat_msg, event, ...)
  if not Elephant.db.profile.prat and prat_msg then
    return
  end
  if not Elephant.db.profile.events[event] then
    return
  end

  -- Getting info from event args
  local message, sender, _, _, _, flags, _, _, channelName, _, _, guid = ...
  if flags == "" then
    flags = nil
  end

  -- Sometimes we need to log two messages for the price of one.
  local msg, msg2
  -- Channels
  if event == "CHAT_MSG_CHANNEL" or event == "CHAT_MSG_CHANNEL_NOTICE" then
    cIndex = getCIndexFromChannelName(channelName)

    if Elephant:IsFiltered(cIndex) then return end

    if event == "CHAT_MSG_CHANNEL" then
      -- Fixing error where structure for channel does not exist
      -- This should normally not happen, but it may be triggered
      -- if the client never received a CHAT_MSG_CHANNEL_NOTICE/YOU_JOINED
      -- event for that channel. In this case though, the client cannot be
      -- displaying that log, so we don't have to update the buttons like
      -- when a YOU_JOINED event happens.
      Elephant:InitCustomStructure(cIndex, channelName)
      if not Elephant.dbpc.char.logs[cIndex].enabled then
        return
      end

      if prat_msg then
        msg = {
          ['time'] = time(),
          ['prat'] = prat_msg
        }
      else
        msg = {
          ['time'] = time(),
          ['arg1'] = message,
          ['arg6'] = flags,
          ['arg9'] = channelName,
          ['clColor'] = GetClassColorByGUID(guid)
        }
        if sender ~= "" then
          msg['arg2'] = sender
        end
      end
      Elephant:CaptureNewMessage(msg, cIndex)
    end

    if event == "CHAT_MSG_CHANNEL_NOTICE" then
      if message == "YOU_JOINED" or message == "YOU_CHANGED" then
        Elephant:InitCustomStructure(cIndex, channelName)
        if not Elephant.dbpc.char.logs[cIndex].enabled then
          return
        end

        Elephant:CaptureNewMessage( { ['type'] = "SYSTEM", ['arg1'] = Elephant.L['customchat']['join'] } , cIndex)
        if Elephant.dbpc.char.currentlogindex == cIndex then
          Elephant:UpdateCurrentLogButtons()
        end
      end
      if message == "YOU_LEFT" then
        if not Elephant.dbpc.char.logs[cIndex] or Elephant.dbpc.char.logs[cIndex].enabled then
          return
        end

        Elephant:CaptureNewMessage( { ['type'] = "SYSTEM", ['arg1'] = Elephant.L['customchat']['leave'] } , cIndex)
        Elephant:CaptureNewMessage( { ['arg1'] = " " } , cIndex)
        if Elephant.dbpc.char.currentlogindex == cIndex then
          Elephant:UpdateCurrentLogButtons()
          Elephant:ForceCurrentLogDeleteButtonStatus(true)
        end
      end
    end
  -- Not channel messages
  else
    if prat_msg then
      msg = {
        ['time'] = time(),
        ['prat'] = prat_msg,
        ['type'] = Elephant.db.profile.events[event].type
      }
    else
      msg = {
        ['time'] = time(),
        ['type'] = Elephant.db.profile.events[event].type,
        ['arg1'] = message
      }

      if  event == "CHAT_MSG_BATTLEGROUND" or
        event == "CHAT_MSG_BATTLEGROUND_LEADER" or
        event == "CHAT_MSG_WHISPER" or
        event == "CHAT_MSG_WHISPER_INFORM" or
        event == "CHAT_MSG_MONSTER_WHISPER" or
        event == "CHAT_MSG_RAID" or
        event == "CHAT_MSG_RAID_LEADER" or
        event == "CHAT_MSG_RAID_WARNING" or
        event == "CHAT_MSG_PARTY" or
        event == "CHAT_MSG_PARTY_LEADER" or
        event == "CHAT_MSG_SAY" or
        event == "CHAT_MSG_MONSTER_SAY" or
        event == "CHAT_MSG_YELL" or
        event == "CHAT_MSG_MONSTER_YELL" or
        event == "CHAT_MSG_OFFICER" or
        event == "CHAT_MSG_GUILD" or
        event == "CHAT_MSG_EMOTE" or
        event == "CHAT_MSG_MONSTER_EMOTE" or
        event == "CHAT_MSG_BN_WHISPER" or
        event == "CHAT_MSG_BN_WHISPER_INFORM" or
        event == "CHAT_MSG_ACHIEVEMENT" or
        event == "CHAT_MSG_GUILD_ACHIEVEMENT" or
        event == "CHAT_MSG_INSTANCE_CHAT" or
        event == "CHAT_MSG_INSTANCE_CHAT_LEADER"
      then
        msg.arg2 = sender
        msg.clColor = GetClassColorByGUID(guid)
      end

      if event == "CHAT_MSG_WHISPER" then
        msg.arg6 = flags
      end

      if event == "PARTY_LOOT_METHOD_CHANGED" then
        local method, masterloot_party, masterloot_raid = GetLootMethod()

        if masterloot_party or masterloot_raid then
          local player
          if UnitInRaid("player") then
            player = GetRaidRosterInfo(masterloot_raid)
          else
            if masterloot_party > 0 then
              player = UnitName("party" .. masterloot_party)
            else
              player = UnitName("player")
            end
          end

          msg2 = {
            ['time'] = time(),
            ['type'] = Elephant.db.profile.events[event].type
          }

          -- Name of player may be unknown here, if interface
          -- has just been loaded
          if player == "Unknown" then
            msg2.arg1 = "<" .. Elephant.L['masterlooternameunknown'] .. ">"
          elseif player ~= Elephant.tempConf.masterlooter then
            Elephant.tempConf.masterlooter = player

            msg2.arg1 =  format(Elephant.L['masterlooterchanged'], player)
          end
        else
          Elephant.tempConf.masterlooter = nil
        end

        if method ~= Elephant.tempConf.lootmethod then
          Elephant.tempConf.lootmethod = method
          msg.arg1 = Elephant.L['lootmethod'][method]
        else
          -- Warning: msg2 might also be nil
          msg = msg2
          msg2 = nil
        end
      end
    end

    -- Finally, capture the message if it is not nil
    if msg ~= nil then
      local k
      for k in pairs(Elephant.db.profile.events[event].channels) do
        if Elephant.db.profile.events[event].channels[k] ~= 0 and Elephant.dbpc.char.logs[k].enabled then
          Elephant:CaptureNewMessage(msg, k)
          if msg2 ~= nil then
            Elephant:CaptureNewMessage(msg2, k)
          end
        end
      end
    end
  end
end

--[[
Unregisters all events from Elephant, and then
registers back either:
- Only one Prat event if the "Prat formatting"
  option is enabled.
- All WoW events defined in Core.lua

This method displays a message if the "Prat
formatting" option is checked but Prat is not
loaded.
]]
function Elephant:RegisterEventsRefresh()
  Elephant:UnregisterAllEvents()

  local event
  if Prat  and Elephant.db.profile.prat then
    Prat.RegisterChatEvent(Elephant, Prat.Events.POST_ADDMESSAGE)

    -- Registering additional events not handled by Prat
    for event,v in pairs(Elephant.db.profile.events) do
      if v.register_with_prat then
        Elephant:RegisterEvent(event, HandleMessage, nil)
      end
    end
  else
    if not Prat and Elephant.db.profile.prat then
      Elephant:Print("|cffff0000" .. Elephant.L['noprat'] .. "|r")
    end

    for event,v in pairs(Elephant.db.profile.events) do
      Elephant:RegisterEvent(event, HandleMessage, nil)
    end
  end
end

--[[
Method pre-handling messages sent by Prat before
sending them to HandleMessage()
]]
-- Cannot be local
function Elephant:Prat_PostAddMessage(_, message, _, event, text)
  HandleMessage(text, event, message.ORG.MESSAGE, _, _, _, _, _, _, _, message.ORG.CHANNEL)
end
