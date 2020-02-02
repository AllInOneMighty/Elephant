--[[
Called when displaying tooltip on Broker source.
]]
local function OnBrokerTooltipShow(tt)
  tt:AddLine(Elephant.L['maxlogwords'] .. ": |c" .. Elephant:MakeTextHexColor(1.0, 1.0, 1.0) .. Elephant.db.profile.maxlog .. "|r")

  if Elephant.db.profile.filters and #Elephant.db.profile.filters > 0 then
    tt:AddLine(" ")
    tt:AddLine(Elephant.L['activefilters'])

    local filter
    for _,filter in pairs(Elephant.db.profile.filters) do
      tt:AddLine("  " .. filter, 1.0, 1.0, 1.0, 1.0)
    end

  end

  tt:AddLine(" ")
  tt:AddLine(format(Elephant.L['toggletooltiphint1'], Elephant:MakeTextHexColor(0.93, 0.65, 0.37)) .. ", "
    .. format(Elephant.L['toggletooltiphint2'], Elephant:MakeTextHexColor(0.93, 0.65, 0.37)) .. ".",
    0.2, 1.0, 0.2, 1.0)
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
        InterfaceOptionsFrame_OpenToCategory("Elephant")
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

  LibDBIcon:Register("Elephant", LDBDataObject, Elephant.db.profile.minimap)
end

function Elephant:ToggleLDBIcon()
  if not Elephant:IsLDBIconAvailable() then return end

  Elephant.db.profile.minimap.hide = not Elephant.db.profile.minimap.hide
  Elephant:RefreshLDBIcon()
end

function Elephant:RefreshLDBIcon()
  if not Elephant:IsLDBIconAvailable() then return end

  if Elephant.db.profile.minimap.hide then
    LibDBIcon:Hide("Elephant")
  else
    LibDBIcon:Show("Elephant")
  end
end

function Elephant:IsLDBIconAvailable()
  return LDBDataObject and LibDBIcon
end
