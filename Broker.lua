--[[
Called when displaying tooltip on Broker source.
]]
local function OnBrokerTooltipShow(tt)
  tt:AddLine(Elephant.L['STRING_OPTIONS_MAX_LOG_LINES'] .. ": |c" .. Elephant:MakeTextHexColor(1.0, 1.0, 1.0) .. Elephant:FactionRealmDb().maxlog .. "|r")

  if Elephant:ProfileDb().filters and #Elephant:ProfileDb().filters > 0 then
    tt:AddLine(" ")
    tt:AddLine(Elephant.L['STRING_MINIMAP_TOOLTIP_ACTIVE_FILTERS'])

    local filter
    for _, filter in pairs(Elephant:ProfileDb().filters) do
      tt:AddLine("  " .. filter, 1.0, 1.0, 1.0, 1.0)
    end
    tt:AddLine(" ")
  end

  tt:AddLine(format(Elephant.L['STRING_MINIMAP_TOOLTIP_HINT_TOGGLE'], Elephant:MakeTextHexColor(0.93, 0.65, 0.37)) .. ".", 0.2, 1.0, 0.2, 1.0)
  tt:AddLine(format(Elephant.L['STRING_MINIMAP_TOOLTIP_HINT_SETTINGS'], Elephant:MakeTextHexColor(0.93, 0.65, 0.37)) .. ".", 0.2, 1.0, 0.2, 1.0)
end

--[[ Broker source ]]
local LDB = LibStub:GetLibrary("LibDataBroker-1.1")
local LDBDataObject
if LDB then
  LDBDataObject = LDB:NewDataObject("Elephant", {
    type = "data source",
    icon = "Interface\\AddOns\\Elephant\\icon.tga",
    OnClick = function(self, button)
      if button == "RightButton" then
        if Settings and Settings.OpenToCategory then
          Settings.OpenToCategory("Elephant")
        elseif InterfaceOptionsFrame_OpenToCategory then
          InterfaceOptionsFrame_OpenToCategory("Elephant")
        end
      else
        Elephant:Toggle()
      end
    end,
    OnTooltipShow = OnBrokerTooltipShow
  })
end

--[[ Broker icon ]]
local LibDBIcon = LibStub("LibDBIcon-1.0")

function Elephant:RegisterLDBIcon()
  -- A data object must exist and LibDBIcon must be enabled
  if not Elephant:IsLDBIconAvailable() then
    return
  end

  LibDBIcon:Register("Elephant", LDBDataObject, Elephant:ProfileDb().minimap)
end

function Elephant:ToggleLDBIcon()
  if not Elephant:IsLDBIconAvailable() then return end

  Elephant:ProfileDb().minimap.hide = not Elephant:ProfileDb().minimap.hide
  Elephant:RefreshLDBIcon()
end

function Elephant:RefreshLDBIcon()
  if not Elephant:IsLDBIconAvailable() then return end

  if Elephant:ProfileDb().minimap.hide then
    LibDBIcon:Hide("Elephant")
  else
    LibDBIcon:Show("Elephant")
  end
end

function Elephant:IsLDBIconAvailable()
  return LDBDataObject and LibDBIcon
end
