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
local function GetSenderWithClassColor(sender, class_color, with_link)
  if sender and class_color and Elephant:ProfileDb().class_colors_in_log then
    if with_link then
      return "|Hplayer:" .. sender .. "|h[|c" .. class_color .. sender .. "|r]|h"
    else
      return "|c" .. class_color .. sender .. "|r"
    end
  else
    if with_link then
      return "|Hplayer:" .. sender .. "|h[" .. sender .. "]|h"
    else
      return sender
    end
  end
end

local function GetBattleNetId(sender)
  return string.sub(sender, 3, -3)
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
  if use_timestamps and message_struct['time'] then
    literal_message = "|cff888888" .. date("%H:%M:%S", message_struct['time']) .. "|r " .. literal_message
  end

  -- Handling Prat messages
  if message_struct['prat'] then
    literal_message = literal_message .. message_struct['prat']
  end

  -- DND/Away tags; shouldn't be there if Prat message
  if message_struct['arg6'] and message_struct['arg6'] ~= "" then
    literal_message = literal_message .. "<" .. message_struct['arg6'] .. ">"
  end

  -- Sender name (could be monster, player, ...); shouldn't be there if Prat message
  if message_struct['arg2'] then
    if message_struct['type'] == "EMOTE" then
      literal_message = literal_message .. GetSenderWithClassColor(message_struct['arg2'], message_struct['clColor']) .. " "
    elseif (message_struct['type'] ~= "MONSTER_EMOTE" and message_struct['type'] ~= "ACHIEVEMENT" and
            message_struct['type'] ~= "GUILD_ACHIEVEMENT") then
      if message_struct['type'] == "MONSTER_SAY" then
        literal_message = literal_message .. format(Elephant.L['monstersay'], message_struct['arg2'])
      elseif message_struct['type'] == "MONSTER_YELL" then
        literal_message = literal_message .. format(Elephant.L['monsteryell'], message_struct['arg2'])
      elseif message_struct['type'] == "MONSTER_WHISPER" then
        literal_message = literal_message .. message_struct['arg2']
      else
        local with_link = true
        local sender = message_struct['arg2']

        if message_struct['type'] == "BN_WHISPER_INFORM" or message_struct['type'] == "BN_WHISPER" then
          -- We can't track Battle.net names due to privacy reasons, so we remove links and name resolution.
          with_link = false
          sender = "[" .. Elephant.L['id'] .. ": " .. GetBattleNetId(message_struct['arg2']) .. "]"
        end

        local player_link = GetSenderWithClassColor(sender, message_struct['clColor'], with_link)

        if message_struct['type'] == "WHISPER_INFORM" or message_struct['type'] == "BN_WHISPER_INFORM" then
          literal_message = literal_message .. format(Elephant.L['whisperto'], player_link)
        else
          literal_message = literal_message .. player_link
        end
      end

      if message_struct['type'] == "WHISPER" or message_struct['type'] == "MONSTER_WHISPER" or message_struct['type'] == "BN_WHISPER" then
        literal_message = format(Elephant.L['whisperfrom'], literal_message)
      end

      literal_message = literal_message .. ": "
    end
  end

  -- The message itself; shouldn't be there if Prat message
  if message_struct['arg1'] then
    if message_struct['type'] == "MONSTER_EMOTE" then
      literal_message = literal_message .. format(message_struct['arg1'], message_struct['arg2'])
    elseif message_struct['arg2'] and (message_struct['type'] == "ACHIEVEMENT" or message_struct['type'] == "GUILD_ACHIEVEMENT") then
      literal_message = literal_message .. format(message_struct['arg1'], message_struct['arg2'])
    else
      literal_message = literal_message .. message_struct['arg1']
    end
  end

  if message_struct['type'] then
    -- Return line color if it is not the default
    return literal_message, ChatTypeInfo[message_struct['type']].r, ChatTypeInfo[message_struct['type']].g, ChatTypeInfo[message_struct['type']].b
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
    return format(Elephant.L['logstartedon'], name, date("%m/%d/%Y"), date("%H:%M:%S"))
  else
    return Elephant.L['logstopped']
  end
end
