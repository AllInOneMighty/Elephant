--[[
Sets the given frame color using :SetTextColor()
to the color used by the currently log displayed.
This method uses Blizzard's default chat type
colors.
]]
local function SetObjectColorWithCurrentLogColor(obj)
  local typeInfo

  if Elephant.dbpc.char.currentlogindex == Elephant.defaultConf.defaultindexes.whisper then
    typeInfo = "WHISPER"
  elseif Elephant.dbpc.char.currentlogindex == Elephant.defaultConf.defaultindexes.raid then
    typeInfo = "RAID"
  elseif Elephant.dbpc.char.currentlogindex == Elephant.defaultConf.defaultindexes.party then
    typeInfo = "PARTY"
  elseif Elephant.dbpc.char.currentlogindex == Elephant.defaultConf.defaultindexes.say then
    typeInfo = "SAY"
  elseif Elephant.dbpc.char.currentlogindex == Elephant.defaultConf.defaultindexes.yell then
    typeInfo = "YELL"
  elseif Elephant.dbpc.char.currentlogindex == Elephant.defaultConf.defaultindexes.officer then
    typeInfo = "OFFICER"
  elseif Elephant.dbpc.char.currentlogindex == Elephant.defaultConf.defaultindexes.guild then
    typeInfo = "GUILD"
  elseif Elephant.dbpc.char.currentlogindex == Elephant.defaultConf.defaultindexes.system then
    typeInfo = "SYSTEM"
  elseif Elephant.dbpc.char.currentlogindex == Elephant.defaultConf.defaultindexes.loot then
    typeInfo = "LOOT"
  elseif Elephant.dbpc.char.currentlogindex == Elephant.defaultConf.defaultindexes.instance then
    typeInfo = "INSTANCE_CHAT"
  else
    typeInfo = "CHANNEL"

    local channelId, channelName
    local i
    -- Max: 20 channels
    for i=1,20 do
      channelId,channelName = GetChannelName(i)

      if channelName ~= nil and
        string.lower(channelName) == string.lower(Elephant.dbpc.char.logs[Elephant.dbpc.char.currentlogindex].name)
      then
        typeInfo = "CHANNEL" .. channelId
        break
      end
    end
  end

  obj:SetTextColor(ChatTypeInfo[typeInfo].r, ChatTypeInfo[typeInfo].g, ChatTypeInfo[typeInfo].b, ChatTypeInfo[typeInfo].a)
end

--[[
Adds color strings to the given message in
order to fill in the gaps between already
existent color strings. After the operation,
the message will thus appear of that color,
except for parts where a color string
already existed before calling the method.

If one of the colors is missing when calling
this method, the message is immediately
returned.

Note that if an existing color string uses
the same color as the given values, it will
not be detected and will be treated like
the other ones.
]]
local function AddColorStrings(msg, r, g, b)
  if r and g and b then
    local hex = Elephant:MakeTextHexColor(r, g, b)
    msg = string.gsub(msg, "\|c(%x%x%x%x%x%x%x%x.-)\|r", "|r|c%1|r|c" .. hex)

    -- If message starts with an "end" color string, remove it
    -- Otherwise prepend the "start" color string
    if string.sub(msg, 1, 2) == "|r" then
      msg = string.sub(msg, 3)
    else
      msg = "|c" .. hex .. msg
    end

    -- If message ends with a "start" color string, remove it
    -- Otherwise append the "end" color string
    if string.sub(msg, string.len(msg)-9) == "|c" .. hex then
      msg = msg.sub(msg, 1, string.len(msg)-10)
    else
      msg = msg .. "|r"
    end
  end
  return msg
end

--[[
Removes all non visible text from the given message and returns the length of
the resulting message, thus matching the number of letters visible by the user.
]]
local function CountVisibleLetters(msg)
  msg = string.gsub(msg, "|H.-|h(.-)|h", "%1")
  msg = string.gsub(msg, "|c%x%x%x%x%x%x%x%x(.-)|r", "%1")
  return string.len(msg)
end

--[[
Empties the copy window edit box, then sets
its color to the current log one, fills it with
the current line of the current log and the
"n" lines preceding it; "n" is defined in the
default configuration of the addon.

All Battle.net messages are ignored, since it
is not possible to correcly get the name of
the friends when copying (and it's also cool
to protect the privacy of the user).

If BBCode is currently activated in the addon,
when filling the edit box, this method
automatically replaces the following
elements to their corresponding BBCode:
- Links to items, using a localized site to
  point at.
- Colors, used anywhere in the text,
  including item links.
]]
local function FillCopyWindow()
  ElephantCopyFrameScrollFrameEditBox:SetText("")
  ElephantCopyFrameScrollFrameEditBox:SetMaxLetters(
    Elephant.db.profile.maxcopyletters)
  ElephantCopyFrameTitleInfoFrameLogLengthFontString:SetText(
    format(
      Elephant.L['copywindowloglength'],
      Elephant.db.profile.maxcopyletters))

  if not Elephant.tempConf.is_copywindow_bbcode then
    ElephantCopyFrameTitleInfoFrameCopyLogDisplayed:SetText(Elephant.L['copywindowplaintext'])

    -- Normal text
    SetObjectColorWithCurrentLogColor(ElephantCopyFrameScrollFrameEditBox)
    local msg
    local totalChars = 0
    for i = Elephant.tempConf.currentline, 0, -1 do
      msg = Elephant.dbpc.char.logs[Elephant.dbpc.char.currentlogindex].logs[i]
      -- Ignoring Battle.net messages
      if msg and msg.type ~= "BN_WHISPER_INFORM" and msg.type ~= "BN_WHISPER" then
        msg = AddColorStrings(
          Elephant:GetLiteralMessage(
            msg, Elephant.db.profile.timestamps_in_copywindow))
        msg = msg .. "\n"

        totalChars = totalChars + CountVisibleLetters(msg)
        if totalChars > Elephant.db.profile.maxcopyletters then
          break
        end

        ElephantCopyFrameScrollFrameEditBox:SetCursorPosition(0)
        ElephantCopyFrameScrollFrameEditBox:Insert(msg)
      end
    end
  else
    -- BBCode
    ElephantCopyFrameTitleInfoFrameCopyLogDisplayed:SetText(
      Elephant.L['copywindowbbcode'])

    ElephantCopyFrameScrollFrameEditBox:SetTextColor(0.75, 0.75, 0.75, 1.0)
    local i, msg
    local itemLinkSite = Elephant.L['itemLinkSite']
    local totalChars = 0
    for i = Elephant.tempConf.currentline, 0, -1 do
      msg = Elephant.dbpc.char.logs[Elephant.dbpc.char.currentlogindex].logs[i]
      -- Ignoring Battle.net messages
      if msg and msg.type ~= "BN_WHISPER_INFORM" and msg.type ~= "BN_WHISPER" then
        msg = AddColorStrings(
          Elephant:GetLiteralMessage(
            msg,
            Elephant.db.profile.timestamps_in_copywindow))

        -- Create BBCode item links
        msg = string.gsub(
          msg,
          "|c%x%x(%x%x%x%x%x%x)|Hitem:(%d-):.-|h(.-)|h|r",
          "[url=" .. itemLinkSite .. "%2][color=#%1]%3[/color][/url]")
        -- Create BBCode colors
        msg = string.gsub(
          msg, "|c%x%x(%x%x%x%x%x%x)(.-)|r", "[color=#%1]%2[/color]")
        msg = msg .. "\n"

        totalChars = totalChars + CountVisibleLetters(msg)
        if totalChars > Elephant.db.profile.maxcopyletters then
          break
        end

        ElephantCopyFrameScrollFrameEditBox:SetCursorPosition(0)
        ElephantCopyFrameScrollFrameEditBox:Insert(msg)
      end
    end
  end

  -- Cleanup spaces and EOL at the beginning of the edit box.
  ElephantCopyFrameScrollFrameEditBox:SetText(
    string.gsub(ElephantCopyFrameScrollFrameEditBox:GetText(),
    "^([ \n]+)",
    ""))
end

--[[
Places a tooltip at the given position on the
given frame, using the given message.

The message must be a table of one or more
strings, where the first string will be used
as title and the others as content.
]]
local function PlaceTooltip(frame, msg, position)
  if not (type(msg) == "table") then
    return
  end

  GameTooltip:SetOwner(frame, position)
  local index, line, text, r, g, b
  for index, line in ipairs(msg) do
    if index == 1 then
      -- Title color cannot be changed
      GameTooltip:SetText(line)
    else
      if type(line) == "table" then
        text = line.text
        r = line.r
        g = line.g
        b = line.b
      else
        text = line
        r = 1.0
        g = 1.0
        b = 1.0
      end
      GameTooltip:AddLine(text, r, g, b, true)
    end
  end
  GameTooltip:Show()
end

--[[
Changes the display of the current log to the
one at the given index.

Changes the value of the current log index to
the new one, changes the current line to the
last one of the log, and finally shows the log.
]]
function Elephant:ChangeLog(index)
  Elephant.dbpc.char.currentlogindex = index
  Elephant.tempConf.currentline = #Elephant.dbpc.char.logs[index].logs
  Elephant:ShowCurrentLog()
end

--[[
Shows a log, based on the current selected one.

First clears the main scrolling message frame,
then sets the color of the title, the current line
and the frame itself to the new log color, changes
the name of log text, updates the current line
information, and updates the status of log buttons.

Finally, populates the frame and updates the
status of the catchers button.
]]
function Elephant:ShowCurrentLog()  
  ElephantFrameScrollingMessageFrame:Clear()

  SetObjectColorWithCurrentLogColor(ElephantFrameTitleInfoFrameTabFontString)
  SetObjectColorWithCurrentLogColor(ElephantFrameTitleInfoFrameCurrentLineFontString)
  SetObjectColorWithCurrentLogColor(ElephantFrameScrollingMessageFrame)
  ElephantFrameTitleInfoFrameTabFontString:SetText("< " .. Elephant.dbpc.char.logs[Elephant.dbpc.char.currentlogindex].name .. " >")
  Elephant:SetTitleInfoCurrentLine()
  Elephant:UpdateCurrentLogButtons()

  -- Populate the scrolling message frame
  local i
  for i = Elephant.tempConf.currentline-Elephant.defaultConf.scrollmaxlines, Elephant.tempConf.currentline do
    if Elephant.dbpc.char.logs[Elephant.dbpc.char.currentlogindex].logs[i] then
      ElephantFrameScrollingMessageFrame:AddMessage(Elephant:GetLiteralMessage(Elephant.dbpc.char.logs[Elephant.dbpc.char.currentlogindex].logs[i], true))
    end
  end

  -- Updating message catchers button
  for _,v in pairs(Elephant.db.profile.events) do
    if v.channels and v.channels[Elephant.dbpc.char.currentlogindex] then
      if not ElephantFrameCatchOptionsButton:IsEnabled() then
        ElephantFrameCatchOptionsButton:Enable()
      end
      return
    end
  end

  -- Only done if loop above doesn't do anything
  if ElephantFrameCatchOptionsButton:IsEnabled() then
    ElephantFrameCatchOptionsButton:Disable()
  end
end

--[[
Updates the current line information of the current log.
]]
function Elephant:SetTitleInfoCurrentLine()
  ElephantFrameTitleInfoFrameCurrentLineFontString:SetText(Elephant.tempConf.currentline .. " / " .. #Elephant.dbpc.char.logs[Elephant.dbpc.char.currentlogindex].logs)
end

--[[
Updates the maximum log count information of the current log.
]]
function Elephant:SetTitleInfoMaxLog()
  ElephantFrameTitleInfoFrameMaxLogFontString:SetText(format(Elephant.L['maxlog'], Elephant.db.profile.maxlog))
end

--[[
Shows the copy window, making sure the main
frame is hidden before that.

This method creates the copy window if it
never has been created, then fills it with
the current log data and shows it.
]]
function Elephant:ShowCopyWindow()
  ElephantFrame:Hide()

  -- Create copy window only when needed to save memory
  if not ElephantCopyFrame then
    CreateFrame(
      "Frame", "ElephantCopyFrame", UIParent, "ElephantCopyFrameTemplate")
  end

  FillCopyWindow()

  ElephantCopyFrame:Show()
end

--[[
Toggles the mode of the copy window between
normal text and BBCode. This method then
triggers a refill of the copy window.
]]
function Elephant:ToggleBetweenNormalTextAndBBCode()
  Elephant.tempConf.is_copywindow_bbcode = not Elephant.tempConf.is_copywindow_bbcode

  if ElephantCopyFrame:IsVisible() then
    FillCopyWindow()
  end
end

--[[
Updates the enabled/disabled state of buttons
displayed under the displayed log, depending on
its status. It also updates their text if
required. The buttons are:
- Enable/Disable
- Copy
- Delete
]]
function Elephant:UpdateCurrentLogButtons()
  if Elephant.dbpc.char.logs[Elephant.dbpc.char.currentlogindex].enabled then
    ElephantFrameEnableButton:GetFontString():SetText(Elephant.L['Disable'])
  else
    ElephantFrameEnableButton:GetFontString():SetText(Elephant.L['Enable'])
  end
  if #Elephant.dbpc.char.logs[Elephant.dbpc.char.currentlogindex].logs > 0 then
    ElephantFrameCopyButton:Enable()
  else
    ElephantFrameCopyButton:Disable()
  end
  if Elephant.L['generalchats'][Elephant.dbpc.char.currentlogindex] or (type(Elephant.dbpc.char.currentlogindex) == "number") then
    ElephantFrameDeleteButton:Disable()
  elseif GetChannelName(Elephant.dbpc.char.logs[Elephant.dbpc.char.currentlogindex].name) > 0 then
    ElephantFrameDeleteButton:Disable()
  else
    ElephantFrameDeleteButton:Enable()
  end
end

--[[
Forces the enabled/disabled state of the
delete log button to the given one.
]]
function Elephant:ForceCurrentLogDeleteButtonStatus(isEnabled)
  if isEnabled then
    ElephantFrameDeleteButton:Enable()
  else
    ElephantFrameDeleteButton:Disable()
  end
end

--[[
Scrolls the current log of the given number
of lines, that may be negative if you wish
to scroll up in the log. This method checks
if doing so gets the user out of the current
log (before first line or after last line), and
in that case forces him/her back to the
corresponding limit, so you don't have to do
it yourself.
]]
function Elephant:Scroll(n)
  local oldIndex = Elephant.tempConf.currentline

  Elephant.tempConf.currentline = Elephant.tempConf.currentline + n
  if Elephant.tempConf.currentline < 1 then
    Elephant.tempConf.currentline = 1
  end
  if Elephant.tempConf.currentline > #Elephant.dbpc.char.logs[Elephant.dbpc.char.currentlogindex].logs then
    Elephant.tempConf.currentline = #Elephant.dbpc.char.logs[Elephant.dbpc.char.currentlogindex].logs
  end

  -- Prevent too much processing
  if oldIndex ~= Elephant.tempConf.currentline then
    Elephant:ShowCurrentLog()
  end
end

--[[
Scrolls the current log to its last line.
]]
function Elephant:ScrollBottom()
  Elephant.tempConf.currentline = #Elephant.dbpc.char.logs[Elephant.dbpc.char.currentlogindex].logs
  Elephant:ShowCurrentLog()
end

--[[
Scrolls the current log to its first line.
]]
function Elephant:ScrollTop()
  Elephant.tempConf.currentline = #Elephant.dbpc.char.logs[Elephant.dbpc.char.currentlogindex].logs
  if Elephant.tempConf.currentline > 1 then
    Elephant.tempConf.currentline = 1
  end
  Elephant:ShowCurrentLog()
end

--[[
Places a tooltip containing the given message
on the given frame, using ANCHOR_RIGHT.
]]
function Elephant:SetTooltip(frame, msg, anchor)
  if anchor == nil then
    anchor = "ANCHOR_RIGHT"
  end
  PlaceTooltip(frame, msg, anchor)
end

--[[
Displays or hides the main frame depending
on its current state.
]]
function Elephant:Toggle()
  if ElephantFrame:IsVisible() then
    ElephantFrame:Hide()
  else
    ElephantFrame:Show()
  end
end

--[[
Resets the position of the main frame.
]]
function Elephant:ResetPosition()
  ElephantFrame:ClearAllPoints()
  ElephantFrame:SetPoint("TOP", Elephant.defaultConf.position.x, Elephant.defaultConf.position.y)
end

--[[
Hides the tooltip if it is displayed.
]]
function Elephant:UnsetTooltip()
  if GameTooltip:IsVisible() then
    GameTooltip:Hide()
  end
end

--[[
Enables or disables WoW chat logging
depending on the value of the given
parameter. However, if Elephant's
"activate log" option is not enabled,
this method does nothing.
]]
function Elephant:ChatLogEnable(enabledStatus)
  if not Elephant.db.profile.activate_log then
    return
  end

  if not (LoggingChat() == enabledStatus) then
    LoggingChat(enabledStatus)
  end
end

--[[
Enables or disables WoW combat logging
depending on the value of the given
parameter. However, if Elephant's
"activate log" option is not enabled,
this method does nothing.
]]
function Elephant:CombatLogEnable(enabledStatus)
  if not Elephant.db.profile.activate_log then
    return
  end

  if not (LoggingCombat() == enabledStatus) then
    LoggingCombat(enabledStatus)
  end
end

--[[
Updates the current state of the "Use timestamps in
copy window" option. Also refreshes the copy window
if it is currently displayed.
]]
function Elephant:ToggleUseTimestampsInCopyWindow(enabledStatus)
  Elephant.db.profile.timestamps_in_copywindow = enabledStatus
  if ElephantCopyFrame:IsVisible() then
    FillCopyWindow()
  end
end

--[[
Updates the checked status of the given button
to the current state of the "Use timestamps in
copy window" option. Useful to call on the
appropriate button when the option is changed.
]]
function Elephant:UpdateButtonWithUseTimestampsInCopyWindow(button)
  button:SetChecked(Elephant.db.profile.timestamps_in_copywindow)
end

--[[
Resets the Elephant button to its
initial button. If the frame of the
button is not foundable at that time,
this method does nothing.
]]
function Elephant:ResetButtonPosition()
  if ElephantButtonFrame then
    ElephantButtonFrame:ClearAllPoints()
    ElephantButtonFrame:SetPoint("BOTTOM", QuickJoinToastButton, "TOP")
  end
end

--[[
Creates the Elephant button. This method
does *not* check if the button was previously
created before creating the new frame; this
is the job of the calling methods.
]]
function Elephant:CreateButton()
  CreateFrame("Button", "ElephantButtonFrame", UIParent, "ElephantButtonTemplate")
end

--[[
Displays or hides the Elephant button,
depending on its current status. If the
button is not created yet, creates it.

This method updates the "Show button"
option of the addon when displaying or
hiding the button.
]]
function Elephant:ToggleButton()
  if not ElephantButtonFrame then
    Elephant:CreateButton()
    Elephant.db.profile.button = true
  else
    if ElephantButtonFrame:IsVisible() then
      ElephantButtonFrame:Hide()
      Elephant.db.profile.button = false
    else
      ElephantButtonFrame:Show()
      Elephant.db.profile.button = true
    end
  end
end

--[[
Returns the localized "Enabled" or "Disabled"
message, depending on the value of the given
parameter.
]]
function Elephant:GetStateMsg(isEnabled)
  if isEnabled then
    return Elephant.L['enabled']
  else
    return Elephant.L['disabled']
  end
end

--[[
Returns color value to use when something
is enabled or disabled. When calling this
method, you need to specify which color
you wish to get the value: "r", "g" or "b".
]]
function Elephant:GetStateColor(isEnabled, color)
  if isEnabled then
    if color == "r" then
      return 0.2
    elseif color == "g" then
      return 1.0
    elseif color == "b" then
      return 0.2
    end
  else
    if color == "r" then
      return 1.0
    elseif color == "g" then
      return 0.2
    elseif color == "b" then
      return 0.2
    end
  end
end
