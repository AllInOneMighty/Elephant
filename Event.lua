-- Returns the hexadecimal string corresponding to the color of the class of the
-- player with the given GUID, or nil if either the GUID is nil, corresponds to
-- no player, or the found class color does not exist.
local function GetClassColorByGUID(guid)
  if guid then
    local _, english_class = GetPlayerInfoByGUID(guid)
    if english_class then
      if C_ClassColor and C_ClassColor.GetClassColor then
        local class_color = C_ClassColor.GetClassColor(english_class)
        if class_color then
          return class_color:GenerateHexColor()
        end
      else
        local class_color_table = RAID_CLASS_COLORS[english_class]
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

-- Returns the channel index to be used for the given channel name. Correctly
-- detects general channels and returns an appropriate integer for them.
--
-- Returns nil if a channel cannot be found.
local function GetChannelIndexFromChannelName(channel_name)
  if channel_name == "" then
    return nil
  end

  channel_name = string.lower(channel_name)

  local channel_index = nil
  for _, general_chat_channel_tbl in
    pairs(Elephant:DefaultConfiguration().generalchatchannels)
  do
    if
      Elephant:ChannelIdPartiallyMatches(
        channel_name,
        general_chat_channel_tbl.id
      )
      or Elephant:ChannelIdPartiallyMatches(
        channel_name,
        general_chat_channel_tbl.id_alt
      )
    then
      channel_index = general_chat_channel_tbl.id
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

local function IsChannelTextEvent(event)
  return event == "CHAT_MSG_CHANNEL"
end

local function IsChannelNoticeEvent(event)
  return event == "CHAT_MSG_CHANNEL_NOTICE"
end

-- Don't mix this up with IsChannelTextEvent().
local function IsChannelEvent(event)
  return IsChannelTextEvent(event) or IsChannelNoticeEvent(event)
end

local function IsBattleNetEvent(event)
  return event == "CHAT_MSG_BN_WHISPER" or event == "CHAT_MSG_BN_WHISPER_INFORM"
end

local function IsPartyLootMethodChanged(event)
  return event == "PARTY_LOOT_METHOD_CHANGED"
end

local function HasText(event)
  -- For channel notices, Elephant generates the log content.
  return not IsChannelNoticeEvent(event)
end

local function IsOfMonsterOrigin(event)
  return event == "CHAT_MSG_MONSTER_WHISPER"
    or event == "CHAT_MSG_MONSTER_SAY"
    or event == "CHAT_MSG_MONSTER_YELL"
    or event == "CHAT_MSG_MONSTER_EMOTE"
    or event == "CHAT_MSG_RAID_BOSS_WHISPER"
    or event == "CHAT_MSG_RAID_BOSS_EMOTE"
end

local function HasPlayerName(event)
  return event == "CHAT_MSG_WHISPER"
    or event == "CHAT_MSG_WHISPER_INFORM"
    or event == "CHAT_MSG_RAID"
    or event == "CHAT_MSG_RAID_LEADER"
    or event == "CHAT_MSG_RAID_WARNING"
    or event == "CHAT_MSG_PARTY"
    or event == "CHAT_MSG_PARTY_LEADER"
    or event == "CHAT_MSG_SAY"
    or event == "CHAT_MSG_YELL"
    or event == "CHAT_MSG_OFFICER"
    or event == "CHAT_MSG_GUILD"
    or event == "CHAT_MSG_EMOTE"
    or event == "CHAT_MSG_ACHIEVEMENT"
    or event == "CHAT_MSG_GUILD_ACHIEVEMENT"
    or event == "CHAT_MSG_INSTANCE_CHAT"
    or event == "CHAT_MSG_INSTANCE_CHAT_LEADER"
    or IsChannelTextEvent(event)
    or IsOfMonsterOrigin(event)
end

local function HasClassColor(event)
  return HasPlayerName(event) or IsBattleNetEvent(event)
end

local function HasFlags(event)
  return event == "CHAT_MSG_WHISPER" or IsChannelTextEvent(event)
end

-- Method to test if any of the event data cannot be compared to an empty string
-- due to being a protected value. issecurevalue() always returns true, so we're
-- doing this instead to determine whether messages can be logged or not.
local function TestEventArgsEquality(...)
  local text, player_name, _, _, _, flags, _, _, channel_name, _, _, guid, bn_sender_id =
    ...
  -- None of those parameters should ever be equal to -1, so all of the tests
  -- below should be attempted.
  return text == -1
    or player_name == -1
    or flags == -1
    or channel_name == -1
    or guid == -1
    or bn_sender_id == -1
end

local function IsLockedDownDueToCombat(event, ...)
  if not InCombatLockdown() then
    return false
  end

  -- Has to be outside of the call, otherwise fails with "cannot use '...'
  -- outside a vararg function".
  local args = { ... }
  if pcall(function()
    TestEventArgsEquality(unpack(args))
  end) then
    return false
  end

  return true
end

local function GetNewMessagesFromChannelNoticeEvent(new_message, ...)
  -- Clone the parameter to avoid modifying the value given by the caller.
  local new_message_clone = Elephant:Clone(new_message)
  local extra_new_message = nil

  new_message_clone.type = "SYSTEM"

  local message = ...
  if message == "YOU_JOINED" or message == "YOU_CHANGED" then
    new_message_clone.arg1 = Elephant.L["STRING_SPECIAL_LOG_JOINED_CHANNEL"]
  elseif message == "YOU_LEFT" then
    new_message_clone.arg1 = Elephant.L["STRING_SPECIAL_LOG_LEFT_CHANNEL"]
    extra_new_message = {
      arg1 = " ",
      -- No need to add arg9 here as the one from new_message is used for
      -- extra messages.
    }
  else
    -- Message event not handled, don't log anything.
    return nil, nil
  end

  return new_message_clone, extra_new_message
end

local function GetBattleTagFromEvent(bn_sender_id)
  if bn_sender_id and C_BattleNet and C_BattleNet.GetAccountInfoByID then
    local account_info = C_BattleNet.GetAccountInfoByID(bn_sender_id)
    if account_info then
      return account_info.battleTag
    end
  end
  return nil
end

local function GetNewMessagesFromPartyLootMethodChangedEvent(event, new_message)
  local method, masterloot_party, masterloot_raid = Elephant:GetLootMethod()

  -- Build extra new message first, because it might end up being the only one.
  local extra_new_message = nil

  if masterloot_party or masterloot_raid then
    local player = nil
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

  -- Build new main message (if one exists).
  local new_message_clone = Elephant:Clone(new_message)

  if method ~= Elephant:VolatileConfig().lootmethod then
    Elephant:VolatileConfig().lootmethod = method
    new_message_clone.arg1 = Elephant.L["STRING_LOOT_METHOD__" .. method]
  else
    -- No new main message, so only log extra new message (might be nil)
    new_message_clone = extra_new_message
    extra_new_message = nil
  end

  return new_message_clone, extra_new_message
end

-- Return new messages to log from the given event as a (msg1, msg2) tuple.
-- Returns (nil, nil) if no message needs to be logged.
local function GetNewMessagesFromEvent(prat_tbl, event, ...)
  -- If it's a Prat message, we just log it and that's it. No extra message
  -- needed.
  if prat_tbl then
    local new_message = {
      time = time(),
      prat = prat_tbl.message,
      lineid = prat_tbl.lineid,
      type = Elephant:ProfileDb().events[event].type,
    }
    if IsChannelEvent(event) then
      local _, _, _, _, _, _, _, _, channel_name = ...
      new_message.arg9 = channel_name
    end
    return new_message, nil
  end

  if IsLockedDownDueToCombat(event, ...) then
    if
      Elephant:ProfileDb().skip_cannot_log_restricted_warning
      or Elephant:VolatileConfig().warned_cannot_log_some_msgs_in_combat
    then
      -- Skip if a warning has already been issued.
      return nil, nil
    end

    -- Issue warning that some messages cannot be logged while in combat
    -- lockdown.
    local warning_message =
      CreateColorFromHexString("ffff4800"):WrapTextInColorCode(
        Elephant.L["STRING_INFORM_CHAT_CANNOT_LOG_SOME_MSGS_IN_COMBAT"]
      )
    Elephant:Print(warning_message)
    -- We create a warning message.
    local new_message = {
      time = time(),
      type = Elephant:ProfileDb().events[event].type,
      arg1 = warning_message,
    }
    Elephant:VolatileConfig().warned_cannot_log_some_msgs_in_combat = true
    return new_message, nil
  end

  local new_message = {
    time = time(),
    type = Elephant:ProfileDb().events[event].type,
  }
  local extra_new_message = nil

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
    local _, _, _, _, _, _, _, _, _, _, _, _, bn_sender_id = ...
    new_message.battleTag = GetBattleTagFromEvent(bn_sender_id)
  end

  if HasFlags(event) then
    local _, _, _, _, _, flags = ...
    new_message.arg6 = NilIfEmpty(flags)
  end

  if IsChannelEvent(event) then
    local _, _, _, _, _, _, _, _, channel_name = ...
    new_message.arg9 = channel_name

    if IsChannelNoticeEvent(event) then
      new_message, extra_new_message =
        GetNewMessagesFromChannelNoticeEvent(new_message, ...)
    end
  end

  if IsPartyLootMethodChanged(event) then
    new_message, extra_new_message =
      GetNewMessagesFromPartyLootMethodChangedEvent(event, new_message)
  end

  return new_message, extra_new_message
end

-- Logs new messages to Elephant. The first message must always be present. A
-- second message can be logged, and is ignored if nil.
local function LogNewMessages(event, new_message, extra_new_message)
  if IsChannelEvent(event) then
    local channel_index = GetChannelIndexFromChannelName(new_message.arg9)

    -- channel_index == nil should never happen, but better to ignore than
    -- crash.
    if channel_index == nil or Elephant:IsFiltered(channel_index) then
      return
    end

    -- Fixing error where table for channel does not exist.
    --
    -- This may be triggered if the client never received a
    -- CHAT_MSG_CHANNEL_NOTICE/YOU_JOINED event for that channel. In this case
    -- though, the client would not be displaying that log,  so we don't have to
    -- update the buttons like when a YOU_JOINED event happens.
    --
    -- Note that this would create a new structure if the user joined a channel,
    -- never received a joined notice, and immediately leaves without receiving
    -- any other message. But it's such a rare event that it's okay to create a
    -- structure in this case, even if the user has to delete it afterwards.
    Elephant:MaybeInitCustomChannelLogTable(channel_index, channel_name)
    if not Elephant:LogsDb().logs[channel_index].enabled then
      return
    end

    Elephant:CaptureNewMessage(new_message, channel_index)
    if extra_new_message ~= nil then
      Elephant:CaptureNewMessage(extra_new_message, channel_index)
    end

    return
  end

  local channel_index = nil
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

local function MaybeUpdateCurrentLogButtons(event, ...)
  if not IsChannelNoticeEvent(event) then
    return
  end

  local message, _, _, _, _, _, _, _, channel_name = ...
  local channel_index = GetChannelIndexFromChannelName(channel_name)

  if Elephant:CharDb().currentlogindex == channel_index then
    if message == "YOU_JOINED" or message == "YOU_CHANGED" then
      Elephant:UpdateCurrentLogButtons()
    elseif message == "YOU_LEFT" then
      Elephant:UpdateCurrentLogButtons()
      -- Prevent being able to delete general chat logs.
      if not Elephant:IsGeneralChatLogIndex(channel_index) then
        Elephant:ForceCurrentLogDeleteButtonStatus(--[[is_enabled=]] true)
      end
    end
  end
end

-- Handles messages sent by the WoW engine as well as the ones sent by Prat. The
-- prat_tbl parameter is only set when Prat logging is enabled.
local function HandleEvent(prat_tbl, event, ...)
  if not Elephant:ProfileDb().prat and prat_tbl then
    -- We received a message sent by Prat but Prat logging is not enabled, so
    -- let's ignore this message. Should generally never happen, but here as a
    -- safeguard.
    return
  end
  if not Elephant:ProfileDb().events[event] then
    -- Event received but not handled by Elephant, ignore. Relevant for Prat as
    -- there is no way to filter which events Prat sends to Elephant.
    return
  end

  -- Retrieve message(s) to log.
  local new_message, extra_new_message =
    GetNewMessagesFromEvent(prat_tbl, event, ...)

  -- Log message(s).
  if new_message then
    LogNewMessages(event, new_message, extra_new_message)
  end

  MaybeUpdateCurrentLogButtons(event, ...)
end

-- Unregisters all events from Elephant, and then registers back either:
--   • Only one Prat event if the "Prat formatting" option is enabled.
--   • All WoW events defined in Core.lua
--
-- This method displays a message if the "Prat formatting" option is checked but
-- Prat is not loaded.
function Elephant:RegisterEventsRefresh()
  Elephant:UnregisterAllEvents()

  local event_type
  if Prat and Elephant:ProfileDb().prat then
    Prat.RegisterChatEvent(Elephant, Prat.Events.POST_ADDMESSAGE)

    -- Registering additional events not handled by Prat
    for event_type, event_tbl in pairs(Elephant:ProfileDb().events) do
      if event_tbl.register_with_prat then
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

    for event_type, event_tbl in pairs(Elephant:ProfileDb().events) do
      Elephant:RegisterEvent(event_type, HandleEvent, nil)
    end
  end
end

-- Method pre-handling messages sent by Prat before sending them to
-- HandleEvent(). Cannot be local.
function Elephant:Prat_PostAddMessage(_, message, _, event, text)
  local prat_tbl = {
    message = text,
    lineid = message.ORG.LINE_ID,
  }
  HandleEvent(
    prat_tbl,
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
