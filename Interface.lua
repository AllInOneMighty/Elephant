--[[
Sets the given frame color using :SetTextColor()
to the color used by the currently log displayed.
This method uses Blizzard's default chat type
colors.
]]
local function SetObjectColorWithCurrentLogColor(obj)
  local type_info

  if Elephant:CharDb().currentlogindex == Elephant:DefaultConfiguration().defaultindexes.whisper then
    type_info = "WHISPER"
  elseif Elephant:CharDb().currentlogindex == Elephant:DefaultConfiguration().defaultindexes.raid then
    type_info = "RAID"
  elseif Elephant:CharDb().currentlogindex == Elephant:DefaultConfiguration().defaultindexes.party then
    type_info = "PARTY"
  elseif Elephant:CharDb().currentlogindex == Elephant:DefaultConfiguration().defaultindexes.say then
    type_info = "SAY"
  elseif Elephant:CharDb().currentlogindex == Elephant:DefaultConfiguration().defaultindexes.yell then
    type_info = "YELL"
  elseif Elephant:CharDb().currentlogindex == Elephant:DefaultConfiguration().defaultindexes.officer then
    type_info = "OFFICER"
  elseif Elephant:CharDb().currentlogindex == Elephant:DefaultConfiguration().defaultindexes.guild then
    type_info = "GUILD"
  elseif Elephant:CharDb().currentlogindex == Elephant:DefaultConfiguration().defaultindexes.system then
    type_info = "SYSTEM"
  elseif Elephant:CharDb().currentlogindex == Elephant:DefaultConfiguration().defaultindexes.loot then
    type_info = "LOOT"
  elseif Elephant:CharDb().currentlogindex == Elephant:DefaultConfiguration().defaultindexes.instance then
    type_info = "INSTANCE_CHAT"
  else
    type_info = "CHANNEL"

    local channelId, channelName
    -- Max: 20 channels
    for i=1, 20 do
      channelId,channelName = GetChannelName(i)

      if channelName ~= nil and
        string.lower(channelName) == string.lower(Elephant:LogsDb().logs[Elephant:CharDb().currentlogindex].name)
      then
        type_info = "CHANNEL" .. channelId
        break
      end
    end
  end

  obj:SetTextColor(ChatTypeInfo[type_info].r, ChatTypeInfo[type_info].g, ChatTypeInfo[type_info].b, ChatTypeInfo[type_info].a)
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
local function AddColorStrings(message, r, g, b)
  if r and g and b then
    local hex = Elephant:MakeTextHexColor(r, g, b)
    message = string.gsub(message, "\|c(%x%x%x%x%x%x%x%x.-)\|r", "|r|c%1|r|c" .. hex)

    -- If message starts with an "end" color string, remove it
    -- Otherwise prepend the "start" color string
    if string.sub(message, 1, 2) == "|r" then
      message = string.sub(message, 3)
    else
      message = "|c" .. hex .. message
    end

    -- If message ends with a "start" color string, remove it
    -- Otherwise append the "end" color string
    if string.sub(message, string.len(message)-9) == "|c" .. hex then
      message = message.sub(message, 1, string.len(message)-10)
    else
      message = message .. "|r"
    end
  end
  return message
end

--[[
Removes all non visible text from the given message and returns the length of
the resulting message, thus matching the number of letters visible by the user.
]]
local function CountVisibleLetters(message)
  message = string.gsub(message, "|H.-|h(.-)|h", "%1")
  message = string.gsub(message, "|c%x%x%x%x%x%x%x%x(.-)|r", "%1")
  return string.len(message)
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
    Elephant:ProfileDb().maxcopyletters)
  ElephantCopyFrameTitleInfoFrameLogLengthFontString:SetText(
    format(
      Elephant.L['STRING_COPY_WINDOW_MAX_CHARACTERS'],
      Elephant:ProfileDb().maxcopyletters))

  if not Elephant._volatileConfiguration.is_copywindow_bbcode then
    ElephantCopyFrameTitleInfoFrameCopyLogDisplayed:SetText(Elephant.L['STRING_COPY_WINDOW_PLAIN_TEXT'])

    -- Normal text
    SetObjectColorWithCurrentLogColor(ElephantCopyFrameScrollFrameEditBox)
    local total_chars = 0
    for i = Elephant._volatileConfiguration.currentline, 0, -1 do
      local message_struct = Elephant:LogsDb().logs[Elephant:CharDb().currentlogindex].logs[i]
      -- Ignoring Battle.net messages
      if message_struct and message_struct.type ~= "BN_WHISPER_INFORM" and message_struct.type ~= "BN_WHISPER" then
        local message_text = AddColorStrings(
          Elephant:GetLiteralMessage(
            message_struct, Elephant:ProfileDb().timestamps_in_copywindow))
        message_text = message_text .. "\n"

        total_chars = total_chars + CountVisibleLetters(message_text)
        if total_chars > Elephant:ProfileDb().maxcopyletters then
          break
        end

        ElephantCopyFrameScrollFrameEditBox:SetCursorPosition(0)
        ElephantCopyFrameScrollFrameEditBox:Insert(message_text)
      end
    end
  else
    -- BBCode
    ElephantCopyFrameTitleInfoFrameCopyLogDisplayed:SetText(
      Elephant.L['STRING_COPY_WINDOW_BB_CODE'])

    ElephantCopyFrameScrollFrameEditBox:SetTextColor(0.75, 0.75, 0.75, 1.0)
    local item_link_site = Elephant.L['URL_ITEM_LINK']
    local total_chars = 0
    for line_index = Elephant._volatileConfiguration.currentline, 0, -1 do
      local message_struct = Elephant:LogsDb().logs[Elephant:CharDb().currentlogindex].logs[line_index]
      -- Ignoring Battle.net messages
      if message_struct and message_struct.type ~= "BN_WHISPER_INFORM" and message_struct.type ~= "BN_WHISPER" then
        local message_text = AddColorStrings(
          Elephant:GetLiteralMessage(
            message_struct,
            Elephant:ProfileDb().timestamps_in_copywindow))

        -- Create BBCode item links
        message_text = string.gsub(
          message_text,
          "|c%x%x(%x%x%x%x%x%x)|Hitem:(%d-):.-|h(.-)|h|r",
          "[url=" .. item_link_site .. "%2][color=#%1]%3[/color][/url]")
        -- Create BBCode colors
        message_text = string.gsub(
          message_text, "|c%x%x(%x%x%x%x%x%x)(.-)|r", "[color=#%1]%2[/color]")
        message_text = message_text .. "\n"

        total_chars = total_chars + CountVisibleLetters(message_text)
        if total_chars > Elephant:ProfileDb().maxcopyletters then
          break
        end

        ElephantCopyFrameScrollFrameEditBox:SetCursorPosition(0)
        ElephantCopyFrameScrollFrameEditBox:Insert(message_text)
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
local function PlaceTooltip(frame, message_struct, position)
  if not (type(message_struct) == "table") then
    return
  end

  GameTooltip:SetOwner(frame, position)
  local line, text, r, g, b
  for index, line in ipairs(message_struct) do
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
function Elephant:ChangeLog(channel_index)
  Elephant:CharDb().currentlogindex = channel_index
  Elephant._volatileConfiguration.currentline = #Elephant:LogsDb().logs[channel_index].logs
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
  ElephantFrameTitleInfoFrameTabFontString:SetText("< " .. Elephant:LogsDb().logs[Elephant:CharDb().currentlogindex].name .. " >")
  Elephant:SetTitleInfoCurrentLine()
  Elephant:UpdateCurrentLogButtons()

  -- Populate the scrolling message frame
  for line_index = Elephant._volatileConfiguration.currentline-Elephant:DefaultConfiguration().scrollmaxlines, Elephant._volatileConfiguration.currentline do
    if Elephant:LogsDb().logs[Elephant:CharDb().currentlogindex].logs[line_index] then
      ElephantFrameScrollingMessageFrame:AddMessage(Elephant:GetLiteralMessage(Elephant:LogsDb().logs[Elephant:CharDb().currentlogindex].logs[line_index], true))
    end
  end

  -- Updating message catchers button
  for _, event_struct in pairs(Elephant:ProfileDb().events) do
    if event_struct.channels and event_struct.channels[Elephant:CharDb().currentlogindex] then
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
  ElephantFrameTitleInfoFrameCurrentLineFontString:SetText(Elephant._volatileConfiguration.currentline .. " / " .. #Elephant:LogsDb().logs[Elephant:CharDb().currentlogindex].logs)
end

--[[
Updates the maximum log count information of the current log.
]]
function Elephant:SetTitleInfoMaxLog()
  ElephantFrameTitleInfoFrameMaxLogFontString:SetText(format(Elephant.L['STRING_MAIN_WINDOW_MAX_LOG'], Elephant:GlobalDb().maxlog))
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
  Elephant._volatileConfiguration.is_copywindow_bbcode = not Elephant._volatileConfiguration.is_copywindow_bbcode

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
  if Elephant:LogsDb().logs[Elephant:CharDb().currentlogindex].enabled then
    ElephantFrameEnableButton:GetFontString():SetText(Elephant.L['STRING_DISABLE'])
  else
    ElephantFrameEnableButton:GetFontString():SetText(Elephant.L['STRING_ENABLE'])
  end
  if #Elephant:LogsDb().logs[Elephant:CharDb().currentlogindex].logs > 0 then
    ElephantFrameCopyButton:Enable()
  else
    ElephantFrameCopyButton:Disable()
  end
  if Elephant:IsExactGeneralChatChannelId(Elephant:CharDb().currentlogindex) or (type(Elephant:CharDb().currentlogindex) == "number") then
    ElephantFrameDeleteButton:Disable()
  elseif GetChannelName(Elephant:LogsDb().logs[Elephant:CharDb().currentlogindex].name) > 0 then
    ElephantFrameDeleteButton:Disable()
  else
    ElephantFrameDeleteButton:Enable()
  end
end

--[[
Forces the enabled/disabled state of the
delete log button to the given one.
]]
function Elephant:ForceCurrentLogDeleteButtonStatus(is_enabled)
  if is_enabled then
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
function Elephant:Scroll(lines_count)
  local old_index = Elephant._volatileConfiguration.currentline

  Elephant._volatileConfiguration.currentline = Elephant._volatileConfiguration.currentline + lines_count
  if Elephant._volatileConfiguration.currentline < 1 then
    Elephant._volatileConfiguration.currentline = 1
  end
  if Elephant._volatileConfiguration.currentline > #Elephant:LogsDb().logs[Elephant:CharDb().currentlogindex].logs then
    Elephant._volatileConfiguration.currentline = #Elephant:LogsDb().logs[Elephant:CharDb().currentlogindex].logs
  end

  -- Prevent too much processing
  if old_index ~= Elephant._volatileConfiguration.currentline then
    Elephant:ShowCurrentLog()
  end
end

--[[
Scrolls the current log to its last line.
]]
function Elephant:ScrollBottom()
  Elephant._volatileConfiguration.currentline = #Elephant:LogsDb().logs[Elephant:CharDb().currentlogindex].logs
  Elephant:ShowCurrentLog()
end

--[[
Scrolls the current log to its first line.
]]
function Elephant:ScrollTop()
  Elephant._volatileConfiguration.currentline = #Elephant:LogsDb().logs[Elephant:CharDb().currentlogindex].logs
  if Elephant._volatileConfiguration.currentline > 1 then
    Elephant._volatileConfiguration.currentline = 1
  end
  Elephant:ShowCurrentLog()
end

--[[
Places a tooltip containing the given message
on the given frame, using ANCHOR_RIGHT.
]]
function Elephant:SetTooltip(frame, message_struct, anchor)
  if anchor == nil then
    anchor = "ANCHOR_RIGHT"
  end
  PlaceTooltip(frame, message_struct, anchor)
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
  ElephantFrame:SetPoint("TOP", Elephant:DefaultConfiguration().position.x, Elephant:DefaultConfiguration().position.y)
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
function Elephant:ChatLogEnable(enabled_status)
  if not Elephant:ProfileDb().activate_log then
    return
  end

  if not (LoggingChat() == enabled_status) then
    LoggingChat(enabled_status)
  end
end

--[[
Enables or disables WoW combat logging
depending on the value of the given
parameter. However, if Elephant's
"activate log" option is not enabled,
this method does nothing.
]]
function Elephant:CombatLogEnable(enabled_status)
  if not Elephant:ProfileDb().activate_log then
    return
  end

  if not (LoggingCombat() == enabled_status) then
    LoggingCombat(enabled_status)
  end
end

--[[
Updates the current state of the "Use timestamps in
copy window" option. Also refreshes the copy window
if it is currently displayed.
]]
function Elephant:ToggleUseTimestampsInCopyWindow(enabled_status)
  Elephant:ProfileDb().timestamps_in_copywindow = enabled_status
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
  button:SetChecked(Elephant:ProfileDb().timestamps_in_copywindow)
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
    Elephant:ProfileDb().button = true
  else
    if ElephantButtonFrame:IsVisible() then
      ElephantButtonFrame:Hide()
      Elephant:ProfileDb().button = false
    else
      ElephantButtonFrame:Show()
      Elephant:ProfileDb().button = true
    end
  end
end

--[[
Returns the localized "Enabled" or "Disabled"
message, depending on the value of the given
parameter.
]]
function Elephant:GetStateMsg(is_enabled)
  if is_enabled then
    return Elephant.L['STRING_ENABLED']
  else
    return Elephant.L['STRING_DISABLED']
  end
end

--[[
Returns color value to use when something
is enabled or disabled. When calling this
method, you need to specify which color
you wish to get the value: "r", "g" or "b".
]]
function Elephant:GetStateColor(is_enabled, color)
  if is_enabled then
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
