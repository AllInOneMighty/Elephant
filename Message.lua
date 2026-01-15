--[[
Returns the given sender name with a
color string built from the given class
color (if not nil). If the withLink
parameter is true, a WoW hyperlink is
also added on the player name.

This method does not add colors if the
addon "Show class colors in logs" option
is not enabled.
]]
local function GetSenderWithClassColor(sender, classColor, withLink)
  if sender and classColor and Elephant.db.profile.class_colors_in_log then
    if withLink then
      return "|Hplayer:" .. sender .. "|h[|c" .. classColor .. sender .. "|r]|h"
    else
      return "|c" .. classColor .. sender .. "|r"
    end
  else
    if withLink then
      return "|Hplayer:" .. sender .. "|h[" .. sender .. "]|h"
    else
      return sender
    end
  end
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
function Elephant:GetLiteralMessage(mStruct, useTimestamps)
  local msg = ""

  -- Time if needed
  if useTimestamps and mStruct['time'] then
    msg = "|cff888888" .. date("%H:%M:%S", mStruct['time']) .. "|r " .. msg
  end

  -- Handling Prat messages
  if mStruct['prat'] then
    msg = msg .. mStruct['prat']
  end

  -- DND/Away tags; shouldn't be there if Prat message
  if mStruct['arg6'] and mStruct['arg6'] ~= "" then
    msg = msg .. "<" .. mStruct['arg6'] .. ">"
  end

  -- Sender name (could be monster, player, ...); shouldn't be there if Prat message
  if mStruct['arg2'] then
    if mStruct['type'] == "EMOTE" then
      msg = msg .. GetSenderWithClassColor(mStruct['arg2'], mStruct['clColor']) .. " "
    elseif mStruct['type'] ~= "MONSTER_EMOTE" and mStruct['type'] ~= "ACHIEVEMENT" and mStruct['type'] ~= "GUILD_ACHIEVEMENT" then
      if mStruct['type'] == "MONSTER_SAY" then
        msg = msg .. format(Elephant.L['monstersay'], mStruct['arg2'])
      elseif mStruct['type'] == "MONSTER_YELL" then
        msg = msg .. format(Elephant.L['monsteryell'], mStruct['arg2'])
      elseif mStruct['type'] == "MONSTER_WHISPER" then
        msg = msg .. mStruct['arg2']
      else
        local pLink = GetSenderWithClassColor(mStruct['arg2'], mStruct['clColor'], true)

        if mStruct['type'] == "WHISPER_INFORM" or mStruct['type'] == "BN_WHISPER_INFORM" then
          msg = msg .. format(Elephant.L['whisperto'], pLink)
        else
          msg = msg .. pLink
        end
      end

      if mStruct['type'] == "WHISPER" or mStruct['type'] == "MONSTER_WHISPER" or mStruct['type'] == "BN_WHISPER" then
        msg = format(Elephant.L['whisperfrom'], msg)
      end

      msg = msg .. ": "
    end
  end

  -- The message itself; shouldn't be there if Prat message
  if mStruct['arg1'] then
    if mStruct['type'] == "MONSTER_EMOTE" then
      msg = msg .. format(mStruct['arg1'], mStruct['arg2'])
    elseif mStruct['arg2'] and (mStruct['type'] == "ACHIEVEMENT" or mStruct['type'] == "GUILD_ACHIEVEMENT") then
      msg = msg .. format(mStruct['arg1'], mStruct['arg2'])
    else
      msg = msg .. mStruct['arg1']
    end
  end

  if mStruct['type'] then
    -- Return line color if it is not the default
    return msg, ChatTypeInfo[mStruct['type']].r, ChatTypeInfo[mStruct['type']].g, ChatTypeInfo[mStruct['type']].b
  else
    return msg
  end
end

--[[
Returns the default message displayed when a
log is started or stopped.
]]
function Elephant:GetStateChangeActionMsg(isEnabled)
  if isEnabled then
    return format(Elephant.L['logstartedon'], date("%m/%d/%Y"), date("%H:%M:%S"))
  else
    return Elephant.L['logstopped']
  end
end
