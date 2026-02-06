local function GetAndFormatBattleTagOrId(message_struct)
  if message_struct.battleTag then
    return "<" .. message_struct.battleTag .. ">"
  elseif message_struct.arg2 then
    return "[" .. Elephant.L['STRING_ID'] .. ": " .. string.sub(message_struct.arg2, 3, -3) .. "]"
  else
    -- Should never happen, but we have this for safeguard.
    return "<??????#????>"
  end
end

--[[
Returns the given sender name with a
color string built from the given class
color (if not nil). If the with_link
parameter is true, a WoW hyperlink is
also added on the player name.

This method does not add colors if the
addon "Show class colors in logs" option
is not enabled.
]]
local function GetDecoratedSender(message_struct)
  local sender = nil
  local sender_link = nil

  if message_struct.type == "BN_WHISPER_INFORM" or message_struct.type == "BN_WHISPER" then
    sender = GetAndFormatBattleTagOrId(message_struct)
  else
    sender = message_struct.arg2
    if message_struct.type ~= "EMOTE" then
      sender_link = "player:" .. sender
    end
  end

  if not sender then
    return ""
  end

  local decorated_sender = sender

  local class_color = message_struct.clColor
  if class_color and Elephant:ProfileDb().class_colors_in_log then
    decorated_sender = "|c" .. class_color .. decorated_sender .. "|r"
  end

  if sender_link then
    decorated_sender = "|H" .. sender_link .. "|h[" .. decorated_sender .. "]|h"
  end

  return decorated_sender
end

--[[
Creates a hex color string from the given decimal
red, green, blue and alpha values.

Example: if you call this method using 0.7, 0.32,
1.0 and 1.0, this method will return "ffb251ff".
]]
function Elephant:MakeTextHexColor(r, g, b, a)
  local r = string.format("%02x", r*255)
  local g = string.format("%02x", g*255)
  local b = string.format("%02x", b*255)
  local a
  if a then
    a = string.format("%02x", a*255)
  else
    a = "ff"
  end

  return (a .. r .. g .. b)
end

--[[
Returns a literal WoW string (with color codes,
...) corresponding to a message structure created
by Elephant (see HandleMessage() in Event.lua).

You have to specify whether to return timestamps
or not in the message.
]]
function Elephant:GetLiteralMessage(message_struct, use_timestamps)
  local literal_message = ""

  -- Time if needed
  if use_timestamps and message_struct.time then
    literal_message = "|cff888888" .. date("%H:%M:%S", message_struct.time) .. "|r " .. literal_message
  end

  -- Handling Prat messages
  if message_struct.prat then
    literal_message = literal_message .. message_struct.prat
  end

  -- DND/Away tags; shouldn't be there if Prat message
  if message_struct.arg6 and message_struct.arg6 ~= "" then
    literal_message = literal_message .. "<" .. message_struct.arg6 .. ">"
  end

  -- Sender name (could be monster, player, ...); shouldn't be there if Prat message
  if message_struct.arg2 or message_struct.battleTag then
    if message_struct.type == "EMOTE" then
      literal_message = literal_message .. GetDecoratedSender(message_struct) .. " "
    elseif (message_struct.type ~= "MONSTER_EMOTE" and message_struct.type ~= "ACHIEVEMENT" and
            message_struct.type ~= "GUILD_ACHIEVEMENT" and message_struct.type ~= "RAID_BOSS_EMOTE") then
      if message_struct.type == "MONSTER_SAY" then
        literal_message = literal_message .. format(Elephant.L['STRING_SPECIAL_LOG_MONSTER_SAYS'], message_struct.arg2)
      elseif message_struct.type == "MONSTER_YELL" then
        literal_message = literal_message .. format(Elephant.L['STRING_SPECIAL_LOG_MONSTER_YELLS'], message_struct.arg2)
      elseif message_struct.type == "MONSTER_WHISPER" then
        literal_message = literal_message .. message_struct.arg2
      else
        local decorated_sender = GetDecoratedSender(message_struct)

        if message_struct.type == "WHISPER_INFORM" or message_struct.type == "BN_WHISPER_INFORM" then
          literal_message = literal_message .. format(Elephant.L['STRING_SPECIAL_LOG_WHISPER_TO'], decorated_sender)
        else
          literal_message = literal_message .. decorated_sender
        end
      end

      if message_struct.type == "WHISPER" or message_struct.type == "MONSTER_WHISPER" or message_struct.type == "BN_WHISPER" then
        literal_message = format(Elephant.L['STRING_SPECIAL_LOG_WHISPER_FROM'], literal_message)
      end

      literal_message = literal_message .. ": "
    end
  end

  -- The message itself; shouldn't be there if Prat message
  if message_struct.arg1 then
    if message_struct.type == "MONSTER_EMOTE" then
      literal_message = literal_message .. format(message_struct.arg1, message_struct.arg2)
    elseif message_struct.arg2 and (message_struct.type == "ACHIEVEMENT" or message_struct.type == "GUILD_ACHIEVEMENT") then
      literal_message = literal_message .. format(message_struct.arg1, message_struct.arg2)
    else
      literal_message = literal_message .. message_struct.arg1
    end
  end

  if message_struct.type then
    -- Return line color if it is not the default
    return literal_message, ChatTypeInfo[message_struct.type].r, ChatTypeInfo[message_struct.type].g, ChatTypeInfo[message_struct.type].b
  else
    return literal_message
  end
end

--[[
Returns the default message displayed when a
log is started or stopped.
]]
function Elephant:GetStateChangeActionMsg(is_enabled)
  if is_enabled then
    local name, _ = UnitName("player")
    return format(Elephant.L['STRING_SPECIAL_LOG_LOGGING_STARTED_ON'], name, date("%m/%d/%Y"), date("%H:%M:%S"))
  else
    return Elephant.L['STRING_SPECIAL_LOG_LOGGING_STOPPED']
  end
end
