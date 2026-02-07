--[[
  Returns the hexadecimal string corresponding to the color of the class of the
  player with the given GUID, or nil if either the GUID is nil, corresponds to
  no player, or the found class color does not exist.
]]
local function GetClassColorByGUID(guid)
  if guid then
    local _, english_class = GetPlayerInfoByGUID(guid)
    if english_class then
      if C_ClassColor.GetClassColor then
        local class_color = C_ClassColor.GetClassColor(english_class)
        if class_color then
          return class_color:GenerateHexColor()
        end
      else
        local class_color_table = RAID_CLASS_COLORS(english_class)
        if class_color_table then
          return Elephant:MakeTextHexColor(
            class_color_table.r,
            class_color_table.g,
            class_color_table.b
          )
        end
      end
    end
  end
  return nil
end

--[[
  Returns the channel index to be used for the given channel name. Correctly
  detects general channels and returns an appropriate integer for them.

  Returns nil if a channel cannot be found.
]]
local function GetChannelIndexFromChannelName(channel_name)
  if channel_name == "" then
    return nil
  end

  channel_name = string.lower(channel_name)

  local channel_index
  for _, general_chat_channel_metadata in
    pairs(Elephant:DefaultConfiguration().generalchatchannelmetadata)
  do
    if
      Elephant:ChannelIdPartiallyMatches(
        channel_name,
        general_chat_channel_metadata.id
      )
    then
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

local function NilIfEmpty(str)
  if str == "" then
    return nil
  else
    return str
  end
end

local function IsChannelEvent(event)
  return event == "CHAT_MSG_CHANNEL" or event == "CHAT_MSG_CHANNEL_NOTICE"
end

local function IsBattleNetEvent(event)
  return event == "CHAT_MSG_BN_WHISPER" or event == "CHAT_MSG_BN_WHISPER_INFORM"
end

local function IsPartyLootMethodChanged(event)
  return event == "PARTY_LOOT_METHOD_CHANGED"
end

local function HasText(event)
  return not (IsBattleNetEvent(event) and InCombatLockdown())
end

local function HasPlayerName(event)
  return event == "CHAT_MSG_BATTLEGROUND"
    or event == "CHAT_MSG_BATTLEGROUND_LEADER"
    or event == "CHAT_MSG_WHISPER"
    or event == "CHAT_MSG_WHISPER_INFORM"
    or event == "CHAT_MSG_MONSTER_WHISPER"
    or event == "CHAT_MSG_RAID"
    or event == "CHAT_MSG_RAID_BOSS_EMOTE"
    or event == "CHAT_MSG_RAID_LEADER"
    or event == "CHAT_MSG_RAID_WARNING"
    or event == "CHAT_MSG_PARTY"
    or event == "CHAT_MSG_PARTY_LEADER"
    or event == "CHAT_MSG_SAY"
    or event == "CHAT_MSG_MONSTER_SAY"
    or event == "CHAT_MSG_YELL"
    or event == "CHAT_MSG_MONSTER_YELL"
    or event == "CHAT_MSG_OFFICER"
    or event == "CHAT_MSG_GUILD"
    or event == "CHAT_MSG_EMOTE"
    or event == "CHAT_MSG_MONSTER_EMOTE"
    or event == "CHAT_MSG_ACHIEVEMENT"
    or event == "CHAT_MSG_GUILD_ACHIEVEMENT"
    or event == "CHAT_MSG_INSTANCE_CHAT"
    or event == "CHAT_MSG_INSTANCE_CHAT_LEADER"
end

local function HasClassColor(event)
  return HasPlayerName(event)
    or (IsBattleNetEvent(event) and not InCombatLockdown())
end

local function HasFlags(event)
  return event == "CHAT_MSG_WHISPER"
end

local function Handle_CHAT_MSG_CHANNEL(
  channel_index,
  channel_name,
  prat_struct,
  ...
)
  --[[
    Fixing error where structure for channel does not exist.

    This should normally not happen, but it may be triggered if the client
    never received a CHAT_MSG_CHANNEL_NOTICE/YOU_JOINED event for that channel.
    In this case though, the client cannot be displaying that log, so we don't
    have to update the buttons like when a YOU_JOINED event happens.
  ]]
  Elephant:MaybeInitCustomStructure(channel_index, channel_name)
  if not Elephant:LogsDb().logs[channel_index].enabled then
    return
  end

  if prat_struct then
    Elephant:CaptureNewMessage({
      time = time(),
      prat = prat_struct.message,
      lineid = prat_struct.lineid,
    }, channel_index)
  else
    local message, sender, _, _, _, flags, _, _, _, _, _, guid = ...
    Elephant:CaptureNewMessage({
      time = time(),
      arg1 = message,
      arg2 = NilIfEmpty(sender),
      arg6 = NilIfEmpty(flags),
      arg9 = channel_name,
      clColor = GetClassColorByGUID(guid),
    }, channel_index)
  end
end

local function Handle_CHAT_MSG_CHANNEL_NOTICE(channel_index, channel_name, ...)
  local message = ...
  if message == "YOU_JOINED" or message == "YOU_CHANGED" then
    Elephant:MaybeInitCustomStructure(channel_index, channel_name)
    if not Elephant:LogsDb().logs[channel_index].enabled then
      return
    end

    Elephant:CaptureNewMessage({
      type = "SYSTEM",
      arg1 = Elephant.L["STRING_SPECIAL_LOG_JOINED_CHANNEL"],
    }, channel_index)
    if Elephant:CharDb().currentlogindex == channel_index then
      Elephant:UpdateCurrentLogButtons()
    end
  end
  if message == "YOU_LEFT" then
    if
      not Elephant:LogsDb().logs[channel_index]
      or not Elephant:LogsDb().logs[channel_index].enabled
    then
      return
    end

    Elephant:CaptureNewMessage(
      { type = "SYSTEM", arg1 = Elephant.L["STRING_SPECIAL_LOG_LEFT_CHANNEL"] },
      channel_index
    )
    Elephant:CaptureNewMessage({ arg1 = " " }, channel_index)
    if Elephant:CharDb().currentlogindex == channel_index then
      Elephant:UpdateCurrentLogButtons()
      Elephant:ForceCurrentLogDeleteButtonStatus(--[[is_enabled=]] true)
    end
  end
end

local function HandleChannelEvent(prat_struct, event, ...)
  local _, _, _, _, _, _, _, _, channel_name = ...
  local channel_index = GetChannelIndexFromChannelName(channel_name)

  -- channel_index == nil should never happen, but better to ignore than crash.
  if channel_index == nil or Elephant:IsFiltered(channel_index) then
    return
  end

  if event == "CHAT_MSG_CHANNEL" then
    Handle_CHAT_MSG_CHANNEL(channel_index, channel_name, prat_struct, ...)
    return
  end

  if event == "CHAT_MSG_CHANNEL_NOTICE" then
    Handle_CHAT_MSG_CHANNEL_NOTICE(channel_index, channel_name, ...)
    return
  end
end

local function UpdateWithBattleNetEvent(new_message, ...)
  local _, _, _, _, _, _, _, _, _, _, _, _, bn_sender_id = ...
  if bn_sender_id and C_BattleNet.GetAccountInfoByID then
    local account_info = C_BattleNet.GetAccountInfoByID(bn_sender_id)
    if account_info then
      new_message.battleTag = account_info.battleTag
    end
  end
end

local function UpdateWithPartyLootMethodChangedEvent(new_message)
  local method, masterloot_party, masterloot_raid = Elephant:GetLootMethod()

  local extra_new_message = nil

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

    extra_new_message = {
      time = time(),
      type = Elephant:ProfileDb().events[event].type,
    }

    -- Name of player may be unknown here, if interface has just been loaded.
    if player == "Unknown" then
      extra_new_message.arg1 = "<"
        .. Elephant.L["STRING_INFORM_CHAT_LOOT_MASTER_LOOTER_UNKNOWN"]
        .. ">"
    elseif player ~= Elephant:VolatileConfig().masterlooter then
      Elephant:VolatileConfig().masterlooter = player

      extra_new_message.arg1 = format(
        Elephant.L["STRING_INFORM_CHAT_LOOT_MASTER_LOOTER_CHANGED"],
        player
      )
    end
  else
    Elephant:VolatileConfig().masterlooter = nil
  end

  if method ~= Elephant:VolatileConfig().lootmethod then
    Elephant:VolatileConfig().lootmethod = method
    new_message.arg1 = Elephant.L["STRING_LOOT_METHOD__" .. method]
  else
    -- Warning: extra_new_message might be nil
    for key, _ in pairs(new_message) do
      new_message[key] = nil
    end
    if extra_new_message then
      for key, value in pairs(extra_new_message) do
        new_message[key] = value
      end
    end
    extra_new_message = nil
  end

  return extra_new_message
end

-- Handles messages sent by the WoW engine as well as the ones sent by Prat.
local function HandleEvent(prat_struct, event, ...)
  if not Elephant:ProfileDb().prat and prat_struct then
    return
  end
  if not Elephant:ProfileDb().events[event] then
    return
  end

  -- Channel events
  if IsChannelEvent(event) then
    HandleChannelEvent(prat_struct, event, ...)
    return
  end

  -- Other events

  -- Sometimes we need to log two messages for the price of one.
  local new_message, extra_new_message = nil, nil
  if prat_struct then
    new_message = {
      time = time(),
      prat = prat_struct.message,
      lineid = prat_struct.lineid,
      type = Elephant:ProfileDb().events[event].type,
    }
  else
    new_message = {
      time = time(),
      type = Elephant:ProfileDb().events[event].type,
    }

    if HasText(event) then
      local text = ...
      new_message.arg1 = text
    end

    if HasPlayerName(event) then
      local _, player_name = ...
      new_message.arg2 = player_name
    end

    if HasClassColor(event) then
      local _, _, _, _, _, _, _, _, _, _, _, guid = ...
      new_message.clColor = GetClassColorByGUID(guid)
    end

    if IsBattleNetEvent(event) then
      if InCombatLockdown() then
        if Elephant:VolatileConfig().warned_cannot_log_bn_chat_in_combat then
          --[[
            No Battle.net message can be logged during combat lockdown as all
            values are secret, so we skip it if a warning has already been
            issued.
          ]]
          return
        end

        --[[
          Issue warning that Battle.net messages cannot be logged while in
          combat lockdown.
        ]]
        local warning_message = "|cffff4800"
          .. Elephant.L["STRING_INFORM_CHAT_CANNOT_LOG_BN_CHAT_IN_COMBAT"]
          .. "|r"
        Elephant:Print(warning_message)
        --[[
          We replace the message, which is a secure value, with a warning
          message.
        ]]
        new_message.arg1 = warning_message
        Elephant:VolatileConfig().warned_cannot_log_bn_chat_in_combat = true
      else
        UpdateWithBattleNetEvent(new_message, ...)
      end
    end

    if HasFlags(event) then
      local _, _, _, _, _, flags = ...
      new_message.arg6 = NilIfEmpty(flags)
    end

    if IsPartyLootMethodChanged(event) then
      extra_new_message = UpdateWithPartyLootMethodChangedEvent(new_message)
    end
  end

  -- Finally, capture the message if it is not nil
  if new_message ~= nil then
    local channel_index
    for channel_index in pairs(Elephant:ProfileDb().events[event].channels) do
      if
        Elephant:ProfileDb().events[event].channels[channel_index] ~= 0
        and Elephant:LogsDb().logs[channel_index].enabled
      then
        Elephant:CaptureNewMessage(new_message, channel_index)
        if extra_new_message ~= nil then
          Elephant:CaptureNewMessage(extra_new_message, channel_index)
        end
      end
    end
  end
end

--[[
  Unregisters all events from Elephant, and then registers back either:
   - Only one Prat event if the "Prat formatting"
     option is enabled.
   - All WoW events defined in Core.lua

  This method displays a message if the "Prat formatting" option is checked but
  Prat is not loaded.
]]
function Elephant:RegisterEventsRefresh()
  Elephant:UnregisterAllEvents()

  local event_type
  if Prat and Elephant:ProfileDb().prat then
    Prat.RegisterChatEvent(Elephant, Prat.Events.POST_ADDMESSAGE)

    -- Registering additional events not handled by Prat
    for event_type, event_struct in pairs(Elephant:ProfileDb().events) do
      if event_struct.register_with_prat then
        Elephant:RegisterEvent(event_type, HandleEvent, nil)
      end
    end
  else
    if not Prat and Elephant:ProfileDb().prat then
      Elephant:Print(
        "|cffff0000"
          .. Elephant.L["STRING_INFORM_CHAT_PRAT_WITHOUT_PRAT"]
          .. "|r"
      )
    end

    for event_type, event_struct in pairs(Elephant:ProfileDb().events) do
      Elephant:RegisterEvent(event_type, HandleEvent, nil)
    end
  end
end

--[[
  Method pre-handling messages sent by Prat before sending them to
  HandleEvent(). Cannot be local.
]]
function Elephant:Prat_PostAddMessage(_, message, _, event, text)
  prat_struct = {
    message = text,
    lineid = message.ORG.LINE_ID,
  }
  HandleEvent(
    prat_struct,
    event,
    message.ORG.MESSAGE,
    _,
    _,
    _,
    _,
    _,
    _,
    _,
    message.ORG.CHANNEL
  )
end
