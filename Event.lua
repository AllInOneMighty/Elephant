--[[
Returns the hexadecimal string corresponding
to the color of the class of the player with the
given GUID, or nil if either the GUID is nil,
corresponds to no player, or the found class
color does not exist.
]]
local function GetClassColorByGUID(guid)
  if guid and guid ~= "" then
    local _, english_class = GetPlayerInfoByGUID(guid)
    if english_class then
      local class_color_table = RAID_CLASS_COLORS[english_class];
      if class_color_table then
        return Elephant:MakeTextHexColor(class_color_table.r, class_color_table.g, class_color_table.b)
      end
    end
  end
  return nil
end

--[[
Returns the channel index to be used for the given channel name.
Correctly detects general channels and returns an appropriate
integer for them.

Returns nil if a channel cannot be found.
]]
local function GetChannelIndexFromChannelName(channel_name)
  if channel_name == "" then
    return nil
  end

  channel_name = string.lower(channel_name)

  local channel_index
  for _, general_chat_channel_metadata in pairs(Elephant:DefaultConfiguration().generalchatchannelmetadata) do
    if Elephant:ChannelIdPartiallyMatches(channel_name, general_chat_channel_metadata.id) then
      channel_index = general_chat_channel_metadata.id
      break
    end
  end
  if channel_index == nil then
    -- Custom channel name
    channel_index = channel_name
  end
  return channel_index
end

--[[
Handles messages sent by the WoW engine
as well as the ones sent by Prat.
]]
local function HandleMessage(prat_struct, event, ...)
  if not Elephant:ProfileDb().prat and prat_struct then
    return
  end
  if not Elephant:ProfileDb().events[event] then
    return
  end

  -- Getting info from event args
  local message, sender, _, _, _, flags, _, _, channel_name, _, _, guid = ...
  if flags == "" then
    flags = nil
  end

  -- Sometimes we need to log two messages for the price of one.
  local new_message_struct, new_message_struct_2
  -- Channels
  if event == "CHAT_MSG_CHANNEL" or event == "CHAT_MSG_CHANNEL_NOTICE" then
    local channel_index = GetChannelIndexFromChannelName(channel_name)

    -- channel_index == nil should never happen, but better to ignore than crash.
    if channel_index == nil or Elephant:IsFiltered(channel_index) then return end

    if event == "CHAT_MSG_CHANNEL" then
      -- Fixing error where structure for channel does not exist
      -- This should normally not happen, but it may be triggered
      -- if the client never received a CHAT_MSG_CHANNEL_NOTICE/YOU_JOINED
      -- event for that channel. In this case though, the client cannot be
      -- displaying that log, so we don't have to update the buttons like
      -- when a YOU_JOINED event happens.
      Elephant:MaybeInitCustomStructure(channel_index, channel_name)
      if not Elephant:LogsDb().logs[channel_index].enabled then
        return
      end

      if prat_struct then
        new_message_struct = {
          time = time(),
          prat = prat_struct.message,
          lineid = prat_struct.lineid,
        }
      else
        new_message_struct = {
          time = time(),
          arg1 = message,
          arg6 = flags,
          arg9 = channel_name,
          clColor = GetClassColorByGUID(guid)
        }
        if sender ~= "" then
          new_message_struct.arg2 = sender
        end
      end
      Elephant:CaptureNewMessage(new_message_struct, channel_index)
    end

    if event == "CHAT_MSG_CHANNEL_NOTICE" then
      if message == "YOU_JOINED" or message == "YOU_CHANGED" then
        Elephant:MaybeInitCustomStructure(channel_index, channel_name)
        if not Elephant:LogsDb().logs[channel_index].enabled then
          return
        end

        Elephant:CaptureNewMessage( { type = "SYSTEM", arg1 = Elephant.L['STRING_SPECIAL_LOG_JOINED_CHANNEL'] } , channel_index)
        if Elephant:CharDb().currentlogindex == channel_index then
          Elephant:UpdateCurrentLogButtons()
        end
      end
      if message == "YOU_LEFT" then
        if not Elephant:LogsDb().logs[channel_index] or not Elephant:LogsDb().logs[channel_index].enabled then
          return
        end

        Elephant:CaptureNewMessage( { type = "SYSTEM", arg1 = Elephant.L['STRING_SPECIAL_LOG_LEFT_CHANNEL'] } , channel_index)
        Elephant:CaptureNewMessage( { arg1 = " " } , channel_index)
        if Elephant:CharDb().currentlogindex == channel_index then
          Elephant:UpdateCurrentLogButtons()
          Elephant:ForceCurrentLogDeleteButtonStatus(--[[is_enabled=]]true)
        end
      end
    end
  else
    -- Not channel messages
    if prat_struct then
      new_message_struct = {
        time = time(),
        prat = prat_struct.message,
        lineid = prat_struct.lineid,
        type = Elephant:ProfileDb().events[event].type,
      }
    else
      new_message_struct = {
        time = time(),
        type = Elephant:ProfileDb().events[event].type,
        arg1 = message,
      }

      if event == "CHAT_MSG_BATTLEGROUND" or
        event == "CHAT_MSG_BATTLEGROUND_LEADER" or
        event == "CHAT_MSG_WHISPER" or
        event == "CHAT_MSG_WHISPER_INFORM" or
        event == "CHAT_MSG_MONSTER_WHISPER" or
        event == "CHAT_MSG_RAID" or
        event == "CHAT_MSG_RAID_BOSS_EMOTE" or
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
        new_message_struct.arg2 = sender
        new_message_struct.clColor = GetClassColorByGUID(guid)
      end

      if event == "CHAT_MSG_WHISPER" then
        new_message_struct.arg6 = flags
      end

      if event == "PARTY_LOOT_METHOD_CHANGED" then
        local method, masterloot_party, masterloot_raid = Elephant:GetLootMethod()

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

          new_message_struct_2 = {
            time = time(),
            type = Elephant:ProfileDb().events[event].type
          }

          -- Name of player may be unknown here, if interface
          -- has just been loaded
          if player == "Unknown" then
            new_message_struct_2.arg1 = "<" .. Elephant.L['STRING_INFORM_CHAT_LOOT_MASTER_LOOTER_UNKNOWN'] .. ">"
          elseif player ~= Elephant.volatileConfiguration.masterlooter then
            Elephant.volatileConfiguration.masterlooter = player

            new_message_struct_2.arg1 =  format(Elephant.L['STRING_INFORM_CHAT_LOOT_MASTER_LOOTER_CHANGED'], player)
          end
        else
          Elephant.volatileConfiguration.masterlooter = nil
        end

        if method ~= Elephant.volatileConfiguration.lootmethod then
          Elephant.volatileConfiguration.lootmethod = method
          new_message_struct.arg1 = Elephant.L['STRING_LOOT_METHOD__' .. method]
        else
          -- Warning: new_message_struct_2 might also be nil
          new_message_struct = new_message_struct_2
          new_message_struct_2 = nil
        end
      end
    end

    -- Finally, capture the message if it is not nil
    if new_message_struct ~= nil then
      local channel_index
      for channel_index in pairs(Elephant:ProfileDb().events[event].channels) do
        if Elephant:ProfileDb().events[event].channels[channel_index] ~= 0 and Elephant:LogsDb().logs[channel_index].enabled then
          Elephant:CaptureNewMessage(new_message_struct, channel_index)
          if new_message_struct_2 ~= nil then
            Elephant:CaptureNewMessage(new_message_struct_2, channel_index)
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

  local event_type
  if Prat and Elephant:ProfileDb().prat then
    Prat.RegisterChatEvent(Elephant, Prat.Events.POST_ADDMESSAGE)

    -- Registering additional events not handled by Prat
    for event_type, event_struct in pairs(Elephant:ProfileDb().events) do
      if event_struct.register_with_prat then
        Elephant:RegisterEvent(event_type, HandleMessage, nil)
      end
    end
  else
    if not Prat and Elephant:ProfileDb().prat then
      Elephant:Print("|cffff0000" .. Elephant.L['STRING_INFORM_CHAT_PRAT_WITHOUT_PRAT'] .. "|r")
    end

    for event_type, event_struct in pairs(Elephant:ProfileDb().events) do
      Elephant:RegisterEvent(event_type, HandleMessage, nil)
    end
  end
end

--[[
Method pre-handling messages sent by Prat before
sending them to HandleMessage()
]]
-- Cannot be local
function Elephant:Prat_PostAddMessage(_, message, _, event, text)
  prat_struct = {
    message = text,
    lineid = message.ORG.LINE_ID
  }
  HandleMessage(prat_struct, event, message.ORG.MESSAGE, _, _, _, _, _, _, _, message.ORG.CHANNEL)
end
