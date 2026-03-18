local LSM = LibStub("LibSharedMedia-3.0")

local skins = {
  default = {
    name = DEFAULT,
    border = {
      texture = [[Interface\Addons\Elephant\roth.tga]],
      width = 16,
      height = 16,
      thickness = 6,
      alpha = 0.5,
    },
    background = {
      texture = [[Interface\DialogFrame\UI-DialogBox-Background]],
      width = 64,
      height = 64,
      alpha = 0.75,
    },
  },
  achievement = {
    name = Elephant.L["STRING_OPTIONS_SKIN_NAME_ACHIEVEMENT"],
    border = {
      texture = [[Interface\ACHIEVEMENTFRAME\UI-Achievement-WoodBorder]],
      width = 64,
      height = 64,
      thickness = 23,
      alpha = 1,
    },
    background = {
      texture = [[Interface\QuestionFrame\question-background]],
      width = 64,
      height = 64,
      alpha = 1,
    },
  },
  bank = {
    name = Elephant.L["STRING_OPTIONS_SKIN_NAME_BANK"],
    border = {
      texture = [[Interface\LFGFRAME\LFGBorder]],
      width = 32,
      height = 32,
      thickness = 13,
      alpha = 1,
    },
    background = {
      texture = [[Interface\BankFrame\BankFrameBackground]],
      width = 256,
      height = 256,
      alpha = 1,
    },
  },
  dialog = {
    name = Elephant.L["STRING_OPTIONS_SKIN_NAME_DIALOG"],
    border = {
      texture = [[Interface\DialogFrame\UI-DialogBox-Border]],
      width = 32,
      height = 32,
      thickness = 11,
      alpha = 1,
    },
    background = {
      texture = [[Interface\DialogFrame\UI-DialogBox-Background]],
      width = 64,
      height = 64,
      alpha = 1,
    },
  },
  dialog_gold = {
    name = Elephant.L["STRING_OPTIONS_SKIN_NAME_DIALOG_GOLD"],
    border = {
      texture = [[Interface\DialogFrame\UI-DialogBox-Gold-Border]],
      width = 32,
      height = 32,
      thickness = 11,
      alpha = 1,
    },
    background = {
      texture = [[Interface\DialogFrame\UI-DialogBox-Gold-Background]],
      width = 64,
      height = 64,
      alpha = 1,
    },
  },
  panel = {
    name = Elephant.L["STRING_OPTIONS_SKIN_NAME_PANEL"],
    border = {
      texture = [[Interface\GLUES\COMMON\TextPanel-Border]],
      width = 32,
      height = 32,
      thickness = 6,
      alpha = 1,
    },
    background = {
      texture = [[Interface\BlackMarket\BlackMarketBackground-Tile]],
      width = 256,
      height = 256,
      alpha = 1,
    },
  },
  tooltip = {
    name = Elephant.L["STRING_OPTIONS_SKIN_NAME_TOOLTIP_NORMAL"],
    border = {
      texture = [[Interface\Tooltips\UI-Tooltip-Border]],
      width = 16,
      height = 16,
      thickness = 4,
      alpha = 1,
    },
    background = {
      texture = [[Interface\DialogFrame\UI-DialogBox-Background]],
      width = 64,
      height = 64,
      alpha = 1,
    },
  },
  tooltip_azerite = {
    name = Elephant.L["STRING_OPTIONS_SKIN_NAME_TOOLTIP_AZERITE"],
    border = {
      texture = [[Interface\Tooltips\UI-Tooltip-Border-Azerite]],
      width = 16,
      height = 16,
      thickness = 4,
      alpha = 1,
    },
    background = {
      texture = [[Interface\Tooltips\UI-Tooltip-Background-Azerite]],
      width = 64,
      height = 64,
      alpha = 1,
    },
  },
  tooltip_corrupted = {
    name = Elephant.L["STRING_OPTIONS_SKIN_NAME_TOOLTIP_CORRUPTED"],
    border = {
      texture = [[Interface\Tooltips\UI-Tooltip-Border-Corrupted]],
      width = 16,
      height = 16,
      thickness = 4,
      alpha = 1,
    },
    background = {
      texture = [[Interface\Tooltips\UI-Tooltip-Background-Corrupted]],
      width = 64,
      height = 64,
      alpha = 1,
    },
  },
  tooltip_maw = {
    name = Elephant.L["STRING_OPTIONS_SKIN_NAME_TOOLTIP_MAW"],
    border = {
      texture = [[Interface\Tooltips\UI-Tooltip-Border-Maw]],
      width = 16,
      height = 16,
      thickness = 4,
      alpha = 1,
    },
    background = {
      texture = [[Interface\Tooltips\UI-Tooltip-Background-Maw]],
      width = 64,
      height = 64,
      alpha = 1,
    },
  },
}

-- Sets the given frame color using :SetTextColor() to the color used by the
-- currently log displayed. This method uses Blizzard's default chat type colors.
local function SetObjectColorWithCurrentLogColor(obj)
  local current_log_index = Elephant:CharDb().currentlogindex
  local type_info = nil

  local log_tbl = nil
  -- Cannot use ipairs() if index is not an integer.
  for _, log_tbl in pairs(Elephant:DefaultConfiguration().defaultlogs) do
    if current_log_index == log_tbl.id then
      type_info = log_tbl.type_info
      break
    end
  end

  if not type_info then
    -- Find if the current log matches a general chat.
    local found_tbl, general_chat_channel_tbl = nil, nil
    for _, general_chat_channel_tbl in
      pairs(Elephant:DefaultConfiguration().generalchatchannels)
    do
      if current_log_index == general_chat_channel_tbl.id then
        found_tbl = general_chat_channel_tbl
      end
    end

    -- If so, identify its color.
    if found_tbl then
      local channel_id, channel_name, i = nil, nil, nil
      -- Max: 20 channels
      for i = 1, 20 do
        channel_id, channel_name = GetChannelName(i)

        if channel_name ~= nil then
          channel_name = string.lower(channel_name)
          if
            Elephant:ChannelIdPartiallyMatches(channel_name, found_tbl.id)
            or Elephant:ChannelIdPartiallyMatches(
              channel_name,
              found_tbl.id_alt
            )
          then
            -- channel_id is set correctly if channel_name is found and not nil
            type_info = ChatTypeInfo["CHANNEL" .. channel_id]
            break
          end
        end
      end
    end
  end

  if not type_info then
    type_info = ChatTypeInfo["CHANNEL"]
  end

  obj:SetTextColor(type_info.r, type_info.g, type_info.b, type_info.a)
end

-- Adds color strings to the given message in order to fill in the gaps between
-- already existent color strings. After the operation, the message will thus
-- appear of that color, except for parts where a color string already existed
-- before calling the method.
--
-- If one of the colors is missing when calling this method, the message is
-- immediately returned.
--
-- Note that if an existing color string uses the same color as the given
-- values, it will not be detected and will be treated like the other ones.
local function AddColorStrings(message, r, g, b)
  if r and g and b then
    local hex = Elephant:MakeTextHexColor(r, g, b)
    message =
      string.gsub(message, "|c(%x%x%x%x%x%x%x%x.-)|r", "|r|c%1|r|c" .. hex)

    -- If message starts with an "end" color string, remove it. Otherwise,
    -- prepend the "start" color string.
    if string.sub(message, 1, 2) == "|r" then
      message = string.sub(message, 3)
    else
      message = "|c" .. hex .. message
    end

    -- If message ends with a "start" color string, remove it. Otherwise, append
    -- the "end" color string.
    if string.sub(message, string.len(message) - 9) == "|c" .. hex then
      message = message.sub(message, 1, string.len(message) - 10)
    else
      message = message .. "|r"
    end
  end
  return message
end

-- Removes all non visible text from the given message and returns the length of
-- the resulting message, thus matching the number of letters visible by the
-- user.
local function CountVisibleLetters(message)
  message = string.gsub(message, "|H.-|h(.-)|h", "%1")
  message = string.gsub(message, "|c%x%x%x%x%x%x%x%x(.-)|r", "%1")
  return string.len(message)
end

-- Empties the copy window edit box, then sets its color to the current log one,
-- fills it with the current line of the current log and the "n" lines preceding
-- it; "n" is defined in the default configuration of the addon.
--
-- If BBCode is currently activated in the addon, when filling the edit box,
-- this method automatically replaces the following elements to their
-- corresponding BBCode:
--   • Links to items, using a localized site to point at.
--   • Colors, used anywhere in the text, including item links.
local function FillCopyWindow()
  ElephantCopyFrameScrollFrameEditBox:SetText("")
  ElephantCopyFrameScrollFrameEditBox:SetMaxLetters(
    Elephant:ProfileDb().maxcopyletters
  )
  ElephantCopyFrameTitleInfoFrameLogLengthFontString:SetText(
    format(
      Elephant.L["STRING_COPY_WINDOW_MAX_CHARACTERS"],
      Elephant:ProfileDb().maxcopyletters
    )
  )

  if not Elephant:VolatileConfig().is_copywindow_bbcode then
    ElephantCopyFrameTitleInfoFrameCopyLogDisplayed:SetText(
      Elephant.L["STRING_COPY_WINDOW_PLAIN_TEXT"]
    )

    -- Normal text
    SetObjectColorWithCurrentLogColor(ElephantCopyFrameScrollFrameEditBox)
    local total_chars = 0
    for i = Elephant:VolatileConfig().currentline, 0, -1 do
      local message_tbl =
        Elephant:LogsDb().logs[Elephant:CharDb().currentlogindex].logs[i]
      if message_tbl then
        local message_text = AddColorStrings(
          Elephant:GetLiteralMessage(
            message_tbl,
            Elephant:ProfileDb().timestamps_in_copywindow
          )
        )
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
      Elephant.L["STRING_COPY_WINDOW_BB_CODE"]
    )

    ElephantCopyFrameScrollFrameEditBox:SetTextColor(0.75, 0.75, 0.75, 1.0)
    local item_link_site = Elephant.L["URL_ITEM_LINK"]
    local total_chars = 0
    for line_index = Elephant:VolatileConfig().currentline, 0, -1 do
      local message_tbl =
        Elephant:LogsDb().logs[Elephant:CharDb().currentlogindex].logs[line_index]
      if message_tbl then
        local message_text = AddColorStrings(
          Elephant:GetLiteralMessage(
            message_tbl,
            Elephant:ProfileDb().timestamps_in_copywindow
          )
        )

        -- Create BBCode item links
        message_text = string.gsub(
          message_text,
          "|c%x%x(%x%x%x%x%x%x)|Hitem:(%d-):.-|h(.-)|h|r",
          "[url=" .. item_link_site .. "%2][color=#%1]%3[/color][/url]"
        )
        -- Create BBCode colors
        message_text = string.gsub(
          message_text,
          "|c%x%x(%x%x%x%x%x%x)(.-)|r",
          "[color=#%1]%2[/color]"
        )
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
    string.gsub(ElephantCopyFrameScrollFrameEditBox:GetText(), "^([ \n]+)", "")
  )
end

-- Places a tooltip at the given position on the given frame, using the given
-- message.
--
-- The message must be a table of one or more strings, where the first string
-- will be used as title and the others as content.
local function PlaceTooltip(frame, message_tbl, position)
  if not (type(message_tbl) == "table") then
    return
  end

  GameTooltip:SetOwner(frame, position)
  local line, text, r, g, b
  for index, line in ipairs(message_tbl) do
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

-- Changes the border of the given frame, expecting a single texture containing
-- 8 parts of identical dimensions glued together from left to right, each one
-- representing the following, in order:
--   • Left side
--   • Right side
--   • Top side (rotated 90 degrees counter-clockwise)
--   • Bottom side (rotated 90 degrees counter-clockwise)
--   • Top left corner
--   • Top right corner
--   • Bottom left corner
--   • Bottom right corner
--
-- The border is added around the frame and not inside the frame, allowing its
-- full height and width to be used for content. The "thickness" parameter sets
-- that number for proper display.
--
-- Currently only supports one thickness that is consistent all around the
-- frame.
local function ChangeBorder(
  frame,
  texture,
  border_width,
  border_height,
  thickness,
  alpha
)
  -- Remove all borders
  local regions = { frame:GetRegions() }
  for _, region in ipairs(regions) do
    if region:IsObjectType("Texture") and region:GetDrawLayer() == "BORDER" then
      region:SetTexture(nil)
    end
  end

  local _, _, frame_width, frame_height = frame:GetRect()
  -- Part of ther border that is "inside" the frame. Used for proper positioning
  -- of other elements, such as left, bottom, right and top sides.
  local width_thickness_remainder = border_width - thickness
  local height_thickness_remainder = border_height - thickness
  -- Number of times the border should be repeated at the top and bottom of the
  -- frame.
  local width_border_repeat_count = (
    frame_width - width_thickness_remainder * 2
  ) / border_width

  -- Set borders
  local top_left = frame:CreateTexture()
  top_left:SetDrawLayer("BORDER")
  top_left:SetTexture(texture)
  top_left:SetAlpha(alpha)
  top_left:SetTexCoord(0.5, 0.625, 0, 1)
  top_left:SetSize(border_width, border_height)
  top_left:SetPoint("TOPLEFT", -thickness, thickness)

  local left = frame:CreateTexture()
  left:SetDrawLayer("BORDER")
  left:SetTexture(texture, "CLAMP", "REPEAT")
  left:SetAlpha(alpha)
  left:SetTexCoord(0, 0.125, 0, 1)
  left:SetSize(border_width, frame_height - height_thickness_remainder * 2)
  left:SetVertTile(true)
  left:SetPoint("TOPLEFT", -thickness, -height_thickness_remainder)

  local bottom_left = frame:CreateTexture()
  bottom_left:SetDrawLayer("BORDER")
  bottom_left:SetTexture(texture)
  bottom_left:SetAlpha(alpha)
  bottom_left:SetTexCoord(0.75, 0.875, 0, 1)
  bottom_left:SetSize(border_width, border_height)
  bottom_left:SetPoint("BOTTOMLEFT", -thickness, -thickness)

  -- The way this works is by setting the texture to repeat vertically, then by
  -- using SetTexCoord() and select coordinates to map points of the image
  -- to coordinates on the Texture while rotating it by 90 degrees.
  --
  -- In other words, we map the following image -> Texture points (remember that
  -- the Texture has a size extending from one side to the other horizontally:
  --   • (0.375, width_border_repeat_count) -> (0, 0) Top left
  --   • (0.5, width_border_repeat_count) -> (0, 1) Bottom left
  --   • (0.375, 0) -> (0, 1) Top right
  --   • (0.5, 0) -> (1, 1) Bottom right
  --
  -- We cannot use horizontal expansion with SetTexCoord() as this would fill
  -- with the other 'sides' of the border, thus why this madness is used here.
  -- You shoudl NOT call setVertTile() or setHorizTile() as those screw up the
  -- display. They do not do what you think they do.
  --
  -- The same applies to the top, just with different numbers.
  local bottom = frame:CreateTexture()
  bottom:SetDrawLayer("BORDER")
  bottom:SetTexture(texture, "CLAMP", "REPEAT")
  bottom:SetAlpha(alpha)
  bottom:SetTexCoord(
    0.375,
    width_border_repeat_count,
    0.5,
    width_border_repeat_count,
    0.375,
    0,
    0.5,
    0
  )
  bottom:SetSize(frame_width - width_thickness_remainder * 2, border_height)
  bottom:SetPoint("BOTTOMLEFT", width_thickness_remainder, -thickness)

  local bottom_right = frame:CreateTexture()
  bottom_right:SetDrawLayer("BORDER")
  bottom_right:SetTexture(texture)
  bottom_right:SetAlpha(alpha)
  bottom_right:SetTexCoord(0.875, 1, 0, 1)
  bottom_right:SetSize(border_width, border_height)
  bottom_right:SetPoint("BOTTOMRIGHT", thickness, -thickness)

  local right = frame:CreateTexture()
  right:SetDrawLayer("BORDER")
  right:SetTexture(texture, "CLAMP", "REPEAT")
  right:SetAlpha(alpha)
  right:SetTexCoord(0.125, 0.25, 0, 1)
  right:SetSize(border_width, frame_height - height_thickness_remainder * 2)
  right:SetVertTile(true)
  right:SetPoint("TOPRIGHT", thickness, -height_thickness_remainder)

  local top_right = frame:CreateTexture()
  top_right:SetDrawLayer("BORDER")
  top_right:SetTexture(texture)
  top_right:SetAlpha(alpha)
  top_right:SetTexCoord(0.625, 0.75, 0, 1)
  top_right:SetSize(border_width, border_height)
  top_right:SetPoint("TOPRIGHT", thickness, thickness)

  local top = frame:CreateTexture()
  top:SetDrawLayer("BORDER")
  top:SetTexture(texture, "CLAMP", "REPEAT")
  top:SetAlpha(alpha)
  top:SetTexCoord(
    0.250,
    width_border_repeat_count,
    0.375,
    width_border_repeat_count,
    0.250,
    0,
    0.375,
    0
  )
  top:SetSize(frame_width - width_thickness_remainder * 2, border_height)
  top:SetPoint("TOPLEFT", width_thickness_remainder, thickness)
end

local function ChangeBackground(frame, texture, width, height, alpha)
  -- Remove all backgrounds (there should only be one)
  local regions = { frame:GetRegions() }
  for _, region in ipairs(regions) do
    if
      region:IsObjectType("Texture") and region:GetDrawLayer() == "BACKGROUND"
    then
      region:SetTexture(nil)
    end
  end

  -- Set background
  local background = frame:CreateTexture()
  background:SetDrawLayer("BACKGROUND")
  background:SetTexture(texture, "REPEAT", "REPEAT")
  background:SetHorizTile(true)
  background:SetVertTile(true)
  background:SetSize(width, height)
  background:SetAlpha(alpha)
  background:SetAllPoints()
end

local function ChangeFont(frame)
  -- Default font that was always used by Elephant.
  local font_file = [[Fonts\ARIALN.TTF]]
  if Elephant:ProfileDb().log_font_id then
    -- If user has selected a new font, use that one instead. Reverts to
    -- LibSharedMedia's default if the font does not exist.
    font_file = LSM:Fetch("font", Elephant:ProfileDb().log_font_id)
  end
  frame:SetFont(font_file, Elephant:ProfileDb().log_font_size, "")
end

-- Changes Elephant's skin.
local function ChangeSkin(skin_id)
  local skin_tbl = skins["default"]

  local id = nil
  local tbl = nil
  for id, tbl in pairs(skins) do
    if id == skin_id then
      skin_tbl = tbl
      break
    end
  end

  ChangeBorder(
    ElephantFrame,
    skin_tbl.border.texture,
    skin_tbl.border.width,
    skin_tbl.border.height,
    skin_tbl.border.thickness,
    skin_tbl.border.alpha
  )
  ChangeBackground(
    ElephantFrame,
    skin_tbl.background.texture,
    skin_tbl.background.width,
    skin_tbl.background.height,
    skin_tbl.background.alpha
  )
  ChangeFont(ElephantFrameScrollingMessageFrame)

  if ElephantCopyFrame then
    ChangeBorder(
      ElephantCopyFrame,
      skin_tbl.border.texture,
      skin_tbl.border.width,
      skin_tbl.border.height,
      skin_tbl.border.thickness,
      skin_tbl.border.alpha
    )
    ChangeBackground(
      ElephantCopyFrame,
      skin_tbl.background.texture,
      skin_tbl.background.width,
      skin_tbl.background.height,
      skin_tbl.background.alpha
    )
    ChangeFont(ElephantCopyFrameScrollFrameEditBox)
  end
end

-- Changes the display of the current log to the one at the given index.
--
-- Changes the value of the current log index to the new one, changes the
-- current line to the last one of the log, and finally shows the log.
function Elephant:ChangeLog(channel_index)
  Elephant:CharDb().currentlogindex = channel_index
  Elephant:VolatileConfig().currentline =
    #Elephant:LogsDb().logs[channel_index].logs
  Elephant:ShowCurrentLog()
end

-- Returns the best name for the given log. Prioritizes localized names if it
-- can, otherwise uses the log's name.
function Elephant:GetLogName(log_index)
  if type(log_index) == "number" then
    for _, default_log_tbl in pairs(Elephant:DefaultConfiguration().defaultlogs) do
      if log_index == default_log_tbl.id then
        return default_log_tbl.localized_name
      end
    end
  end

  for _, general_chat_channel_tbl in
    ipairs(Elephant:DefaultConfiguration().generalchatchannels)
  do
    if log_index == general_chat_channel_tbl.id then
      return general_chat_channel_tbl.localized_name
    end
  end

  return Elephant:LogsDb().logs[log_index].name
end

-- Shows a log, based on the current selected one.
--
-- First clears the main scrolling message frame, then sets the color of the
-- title, the current line and the frame itself to the new log color, changes
-- the name of log text, updates the current line information, and updates the
-- status of log buttons.
--
-- Finally, populates the frame and updates the status of the catchers button.
function Elephant:ShowCurrentLog()
  local current_log_index = Elephant:CharDb().currentlogindex

  ElephantFrameScrollingMessageFrame:Clear()

  SetObjectColorWithCurrentLogColor(ElephantFrameTitleInfoFrameTabFontString)
  SetObjectColorWithCurrentLogColor(
    ElephantFrameTitleInfoFrameCurrentLineFontString
  )
  SetObjectColorWithCurrentLogColor(ElephantFrameScrollingMessageFrame)
  ElephantFrameTitleInfoFrameTabFontString:SetText(
    "< " .. Elephant:GetLogName(current_log_index) .. " >"
  )
  Elephant:SetTitleInfoCurrentLine()
  Elephant:UpdateCurrentLogButtons()

  -- Populate the scrolling message frame
  for line_index = Elephant:VolatileConfig().currentline - Elephant:DefaultConfiguration().scrollmaxlines, Elephant:VolatileConfig().currentline do
    if Elephant:LogsDb().logs[current_log_index].logs[line_index] then
      ElephantFrameScrollingMessageFrame:AddMessage(
        Elephant:GetLiteralMessage(
          Elephant:LogsDb().logs[current_log_index].logs[line_index],
          --[[use_timestamps=]]
          true
        )
      )
    end
  end

  -- Updating message catchers button
  for _, event_tbl in pairs(Elephant:ProfileDb().events) do
    if event_tbl.channels and event_tbl.channels[current_log_index] then
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

-- Updates the current line information of the current log.
function Elephant:SetTitleInfoCurrentLine()
  ElephantFrameTitleInfoFrameCurrentLineFontString:SetText(
    Elephant:VolatileConfig().currentline
      .. " / "
      .. #Elephant:LogsDb().logs[Elephant:CharDb().currentlogindex].logs
  )
end

-- Updates the maximum log count information of the current log.
function Elephant:SetTitleInfoMaxLog()
  ElephantFrameTitleInfoFrameMaxLogFontString:SetText(
    format(
      Elephant.L["STRING_MAIN_WINDOW_MAX_LOG"],
      Elephant:FactionRealmDb().maxlog
    )
  )
end

-- Shows the copy window, making sure the main frame is hidden before that.
--
-- This method creates the copy window if it never has been created, then fills
-- it with the current log data and shows it.
function Elephant:ShowCopyWindow()
  ElephantFrame:Hide()

  -- Create copy window only when needed to save memory
  if not ElephantCopyFrame then
    CreateFrame(
      "Frame",
      "ElephantCopyFrame",
      UIParent,
      "ElephantCopyFrameTemplate"
    )
    Elephant:UpdateSkin()
  end

  FillCopyWindow()

  ElephantCopyFrame:Show()
end

-- Toggles the mode of the copy window between normal text and BBCode. This
-- method then triggers a refill of the copy window.
function Elephant:ToggleBetweenNormalTextAndBBCode()
  Elephant:VolatileConfig().is_copywindow_bbcode =
    not Elephant:VolatileConfig().is_copywindow_bbcode

  if ElephantCopyFrame:IsVisible() then
    FillCopyWindow()
  end
end

-- Updates the enabled/disabled state of buttons displayed under the displayed
-- log, depending on its status. It also updates their text if required. The
-- buttons are:
--   • Enable/Disable
--   • Copy
--   • Delete
function Elephant:UpdateCurrentLogButtons()
  local current_log_index = Elephant:CharDb().currentlogindex
  local current_log_tbl = Elephant:LogsDb().logs[current_log_index]

  if current_log_tbl.enabled then
    ElephantFrameEnableButton:GetFontString()
      :SetText(Elephant.L["STRING_DISABLE"])
  else
    ElephantFrameEnableButton:GetFontString()
      :SetText(Elephant.L["STRING_ENABLE"])
  end

  if #current_log_tbl.logs > 0 then
    ElephantFrameCopyButton:Enable()
  else
    ElephantFrameCopyButton:Disable()
  end

  if
    type(current_log_index) == "number"
    or Elephant:IsGeneralChatLogIndex(current_log_index)
  then
    ElephantFrameDeleteButton:Disable()
  elseif GetChannelName(current_log_tbl.name) > 0 then
    ElephantFrameDeleteButton:Disable()
  else
    ElephantFrameDeleteButton:Enable()
  end
end

-- Forces the enabled/disabled state of the delete log button to the given one.
function Elephant:ForceCurrentLogDeleteButtonStatus(is_enabled)
  if is_enabled then
    ElephantFrameDeleteButton:Enable()
  else
    ElephantFrameDeleteButton:Disable()
  end
end

-- Scrolls the current log of the given number of lines, that may be negative if
-- you wish to scroll up in the log. This method checks if doing so gets the
-- user out of the current log (before first line or after last line), and in
-- that case forces him/her back to the corresponding limit, so you don't have
-- to do it yourself.
function Elephant:Scroll(lines_count)
  local old_index = Elephant:VolatileConfig().currentline

  Elephant:VolatileConfig().currentline = Elephant:VolatileConfig().currentline
    + lines_count
  if Elephant:VolatileConfig().currentline < 1 then
    Elephant:VolatileConfig().currentline = 1
  end
  if
    Elephant:VolatileConfig().currentline
    > #Elephant:LogsDb().logs[Elephant:CharDb().currentlogindex].logs
  then
    Elephant:VolatileConfig().currentline =
      #Elephant:LogsDb().logs[Elephant:CharDb().currentlogindex].logs
  end

  -- Prevent too much processing
  if old_index ~= Elephant:VolatileConfig().currentline then
    Elephant:ShowCurrentLog()
  end
end

-- Scrolls the current log to its last line.
function Elephant:ScrollBottom()
  Elephant:VolatileConfig().currentline =
    #Elephant:LogsDb().logs[Elephant:CharDb().currentlogindex].logs
  Elephant:ShowCurrentLog()
end

-- Scrolls the current log to its first line.
function Elephant:ScrollTop()
  Elephant:VolatileConfig().currentline =
    #Elephant:LogsDb().logs[Elephant:CharDb().currentlogindex].logs
  if Elephant:VolatileConfig().currentline > 1 then
    Elephant:VolatileConfig().currentline = 1
  end
  Elephant:ShowCurrentLog()
end

-- Places a tooltip containing the given message on the given frame, using
-- ANCHOR_RIGHT.
function Elephant:SetTooltip(frame, message_tbl, anchor)
  if anchor == nil then
    anchor = "ANCHOR_RIGHT"
  end
  PlaceTooltip(frame, message_tbl, anchor)
end

function Elephant:SetDefaultTabButtonTooltip(frame, default_log_tbl)
  local is_enabled = Elephant:LogsDb().logs[default_log_tbl.id].enabled
  Elephant:SetTooltip(frame, {
    default_log_tbl.localized_name,
    {
      text = Elephant:GetStateMsg(is_enabled),
      r = Elephant:GetStateColor(is_enabled, "r"),
      g = Elephant:GetStateColor(is_enabled, "g"),
      b = Elephant:GetStateColor(is_enabled, "b"),
    },
    format(
      Elephant.L["STRING_MAIN_WINDOW_CHAT_BUTTONS_LINES"],
      #Elephant:LogsDb().logs[default_log_tbl.id].logs
    ),
  })
end

-- Displays or hides the main frame depending on its current state.
function Elephant:Toggle()
  if ElephantFrame:IsVisible() then
    ElephantFrame:Hide()
  else
    ElephantFrame:Show()
  end
end

-- Resets the position of the main frame.
function Elephant:ResetPosition()
  ElephantFrame:ClearAllPoints()
  ElephantFrame:SetPoint(
    "TOP",
    Elephant:DefaultConfiguration().position.x,
    Elephant:DefaultConfiguration().position.y
  )
end

-- Hides the tooltip if it is displayed.
function Elephant:UnsetTooltip()
  if GameTooltip:IsVisible() then
    GameTooltip:Hide()
  end
end

-- Enables or disables WoW chat logging depending on the value of the given
-- parameter. However, if Elephant's "activate log" option is not enabled, this
-- method does nothing.
function Elephant:ChatLogEnable(enabled_status)
  if not Elephant:ProfileDb().activate_log then
    return
  end

  if not (LoggingChat() == enabled_status) then
    LoggingChat(enabled_status)
  end
end

-- Enables or disables WoW combat logging depending on the value of the given
-- parameter. However, if Elephant's "activate log" option is not enabled, this
-- method does nothing.
function Elephant:CombatLogEnable(enabled_status)
  if not Elephant:ProfileDb().activate_log then
    return
  end

  if not (LoggingCombat() == enabled_status) then
    LoggingCombat(enabled_status)
  end
end

-- Updates the current state of the "Use timestamps in copy window" option. Also
-- refreshes the copy window if it is currently displayed.
function Elephant:ToggleUseTimestampsInCopyWindow(enabled_status)
  Elephant:ProfileDb().timestamps_in_copywindow = enabled_status
  if ElephantCopyFrame:IsVisible() then
    FillCopyWindow()
  end
end

-- Updates the checked status of the given button to the current state of the
-- "Use timestamps in copy window" option. Useful to call on the appropriate
-- button when the option is changed.
function Elephant:UpdateButtonWithUseTimestampsInCopyWindow(button)
  button:SetChecked(Elephant:ProfileDb().timestamps_in_copywindow)
end

-- Sets the Elephant button to its correct position. If the user moved it, it
-- will be where the user last moved it.
function Elephant:SetButtonPosition()
  if QuickJoinToastButton then
    ElephantButtonFrame:SetPoint("BOTTOM", QuickJoinToastButton, "TOP")
  else
    ElephantButtonFrame:SetPoint("BOTTOM", FriendsMicroButton, "TOP")
  end
end

-- Forcibly resets the Elephant button to its initial button, even if the user
-- previously moved it. If the frame of the button is not found, this method
-- does nothing.
function Elephant:ResetButtonPosition()
  if ElephantButtonFrame then
    ElephantButtonFrame:ClearAllPoints()
    Elephant:SetButtonPosition()
  end
end

-- Creates the Elephant button. This method does *not* check if the button was
-- previously created before creating the new frame; this is the job of the
-- calling methods.
function Elephant:CreateButton()
  CreateFrame(
    "Button",
    "ElephantButtonFrame",
    UIParent,
    "ElephantButtonTemplate"
  )
end

-- Displays or hides the Elephant button, depending on its current status. If
-- the button is not created yet, creates it.
--
-- This method updates the "Show button" option of the addon when displaying or
-- hiding the button.
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

-- Returns the localized "Enabled" or "Disabled" message, depending on the value
-- of the given parameter.
function Elephant:GetStateMsg(is_enabled)
  if is_enabled then
    return Elephant.L["STRING_ENABLED"]
  else
    return Elephant.L["STRING_DISABLED"]
  end
end

-- Returns color value to use when something is enabled or disabled. When
-- calling this method, you need to specify which color you wish to get the
-- value: "r", "g" or "b".
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

-- Opens the options pane of Elephant.
function Elephant:OpenOptions()
  if Settings and Settings.OpenToCategory then
    Settings.OpenToCategory(Elephant:VolatileConfig().categoryId)
  elseif InterfaceOptionsFrame_OpenToCategory then
    InterfaceOptionsFrame_OpenToCategory("Elephant")
  end
end

-- Returns all skins available.
function Elephant:GetSkinNames()
  local skin_names = {}
  for skin_id, skin_tbl in pairs(skins) do
    skin_names[skin_id] = skin_tbl.name
  end
  return skin_names
end

-- Update Elephant's skin to the one saved in the config.
function Elephant:UpdateSkin()
  ChangeSkin(Elephant:ProfileDb().skin_id)
end
