local function GetAndFormatBattleTagOrId(message_tbl)
  if message_tbl.battleTag then
    return "<" .. message_tbl.battleTag .. ">"
  elseif message_tbl.arg2 then
    return "["
      .. Elephant.L["STRING_ID"]
      .. ": "
      .. string.sub(message_tbl.arg2, 3, -3)
      .. "]"
  else
    -- Should never happen, but we have this for safeguard.
    return "<??????#????>"
  end
end

-- Returns the given sender name with a color string built from the given class
-- color (if not nil). If the with_link parameter is true, a WoW hyperlink is
-- also added on the player name.
--
-- This method does not add colors if the addon "Show class colors in logs"
-- option is not enabled.
local function GetDecoratedSender(message_tbl)
  local sender = nil
  local sender_link = nil

  if
    message_tbl.type == "BN_WHISPER_INFORM"
    or message_tbl.type == "BN_WHISPER"
  then
    sender = GetAndFormatBattleTagOrId(message_tbl)
  else
    sender = message_tbl.arg2
    if message_tbl.type ~= "EMOTE" then
      sender_link = "player:" .. sender
    end
  end

  if not sender then
    return ""
  end

  local decorated_sender = sender

  local class_color = message_tbl.clColor
  if class_color and Elephant:ProfileDb().class_colors_in_log then
    decorated_sender = "|c" .. class_color .. decorated_sender .. "|r"
  end

  if sender_link then
    decorated_sender = "|H" .. sender_link .. "|h[" .. decorated_sender .. "]|h"
  end

  return decorated_sender
end

-- Creates a hex color string from the given decimal red, green, blue and alpha
-- values.
--
-- Example: if you call this method using 0.7, 0.32, 1.0 and 1.0, this method
-- will return "ffb251ff".
function Elephant:MakeTextHexColor(r, g, b, a)
  local color = CreateColor(r, g, b, a)
  return color:GenerateHexColor()
end

-- Returns a literal WoW string (with color codes, ...) corresponding to a
-- message table created by Elephant (see HandleEvent() in Event.lua).
--
-- You have to specify whether to return timestamps or not in the message.
function Elephant:GetLiteralMessage(message_tbl, use_timestamps)
  local literal_message = ""

  -- Time if needed
  if use_timestamps and message_tbl.time then
    literal_message = "|cff888888"
      .. date("%H:%M:%S", message_tbl.time)
      .. "|r "
  end

  -- Handling Prat messages
  if message_tbl.prat then
    literal_message = literal_message .. message_tbl.prat
  end

  if message_tbl.ellipsis then
    literal_message = literal_message .. Elephant.L["STRING_ELLIPSIS"]
  end

  -- DND/Away tags; shouldn't be there if Prat message
  if message_tbl.arg6 and message_tbl.arg6 ~= "" then
    literal_message = literal_message .. "<" .. message_tbl.arg6 .. ">"
  end

  -- Sender name (could be monster, player, ...); shouldn't be there if Prat
  -- message.
  if message_tbl.arg2 or message_tbl.battleTag then
    if message_tbl.type == "EMOTE" then
      literal_message = literal_message
        .. GetDecoratedSender(message_tbl)
        .. " "
    elseif
      message_tbl.type ~= "MONSTER_EMOTE"
      and message_tbl.type ~= "ACHIEVEMENT"
      and message_tbl.type ~= "GUILD_ACHIEVEMENT"
      and message_tbl.type ~= "RAID_BOSS_EMOTE"
    then
      if message_tbl.type == "MONSTER_SAY" then
        literal_message = literal_message
          .. format(
            Elephant.L["STRING_SPECIAL_LOG_MONSTER_SAYS"],
            message_tbl.arg2
          )
      elseif message_tbl.type == "MONSTER_YELL" then
        literal_message = literal_message
          .. format(
            Elephant.L["STRING_SPECIAL_LOG_MONSTER_YELLS"],
            message_tbl.arg2
          )
      elseif message_tbl.type == "MONSTER_WHISPER" then
        literal_message = literal_message .. message_tbl.arg2
      else
        local decorated_sender = GetDecoratedSender(message_tbl)

        if
          message_tbl.type == "WHISPER_INFORM"
          or message_tbl.type == "BN_WHISPER_INFORM"
        then
          literal_message = literal_message
            .. format(
              Elephant.L["STRING_SPECIAL_LOG_WHISPER_TO"],
              decorated_sender
            )
        else
          literal_message = literal_message .. decorated_sender
        end
      end

      if
        message_tbl.type == "WHISPER"
        or message_tbl.type == "MONSTER_WHISPER"
        or message_tbl.type == "BN_WHISPER"
      then
        literal_message =
          format(Elephant.L["STRING_SPECIAL_LOG_WHISPER_FROM"], literal_message)
      end

      literal_message = literal_message .. ": "
    end
  end

  -- The message itself; shouldn't be there if Prat message
  if message_tbl.arg1 then
    if
      message_tbl.type == "MONSTER_EMOTE"
      or message_tbl.type == "RAID_BOSS_EMOTE"
    then
      literal_message = literal_message
        .. format(message_tbl.arg1, message_tbl.arg2)
    elseif
      message_tbl.arg2
      and (
        message_tbl.type == "ACHIEVEMENT"
        or message_tbl.type == "GUILD_ACHIEVEMENT"
      )
    then
      literal_message = literal_message
        .. format(message_tbl.arg1, message_tbl.arg2)
    else
      literal_message = literal_message .. message_tbl.arg1
    end
  end

  -- Ignore channel messages type so that they are displayed in the right color
  -- rather than a generic "channel" color. Join/Leave notices are also
  -- displayed in the chat color.
  if
    message_tbl.type
    and message_tbl.type ~= "CHANNEL"
    and message_tbl.type ~= "CHANNEL_NOTICE"
  then
    -- Return line color if it is not the default
    return literal_message,
      ChatTypeInfo[message_tbl.type].r,
      ChatTypeInfo[message_tbl.type].g,
      ChatTypeInfo[message_tbl.type].b
  else
    return literal_message
  end
end

-- Returns the default message displayed when a log is started or stopped.
function Elephant:GetStateChangeActionMsg(is_enabled)
  if is_enabled then
    local name, _ = UnitName("player")
    return format(
      Elephant.L["STRING_SPECIAL_LOG_LOGGING_STARTED_ON"],
      name,
      date("%m/%d/%Y"),
      date("%H:%M:%S")
    )
  else
    return Elephant.L["STRING_SPECIAL_LOG_LOGGING_STOPPED"]
  end
end
