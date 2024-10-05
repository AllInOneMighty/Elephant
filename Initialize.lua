--[[
When addon is initialized. Registers database,
options, initializes the main frame, Elephant
button if required, enables/disables WoW chat
logging, and initializes other useful data.
]]
function Elephant:OnInitialize()
  -- Registering database with defaults: cloning objects to avoid problems
  Elephant.db = LibStub("AceDB-3.0"):New("ElephantDB", {
    profile = Elephant:Clone(Elephant:DefaultConfiguration().savedconfdefaults),
    char = Elephant:Clone(Elephant:DefaultConfiguration().savedpercharconfdefaults),
    factionrealm = Elephant:Clone(Elephant:DefaultConfiguration().savedperfactionrealmconfdefaults),
  })

  -- If old maxlog value exists...
  if Elephant.db.profile.maxlog ~= nil then
    -- Copy it to the factionrealm db if it is greater than the new default
    if Elephant.db.profile.maxlog > Elephant.db.factionrealm.maxlog then
      Elephant.db.factionrealm.maxlog = Elephant.db.profile.maxlog
    end
    -- Then, remove it.
    Elephant.db.profile.maxlog = nil
  end

  -- Options
  Elephant:SetupOptions()

  -- General frame
  Elephant:SetTitleInfoMaxLog()

  -- Elephant button
  if Elephant:ProfileDb().button == true then
    Elephant:CreateButton()
  end

  -- Enabling/disabling chat logging if required
  Elephant:ChatLogEnable(Elephant:ProfileDb().chatlog)
  Elephant:CombatLogEnable(Elephant:ProfileDb().combatlog)

  -- Checks & creates default log structures
  Elephant:MaybeInitDefaultLogStructures()
  Elephant:AddHeaderToStructures()

  -- Getting current loot method to avoid displaying too many times
  -- the same loot method in case of ReloadUI()
  -- Note: in case of login, a PARTY_LOOT_METHOD_CHANGED
  -- event is triggered anyway
  Elephant.volatileConfiguration.lootmethod = GetLootMethod()

  -- Minimap icon
  Elephant:RegisterLDBIcon()
end

local function SetTabButtonProperties(obj, name, typeInfo)
  obj:SetNormalFontObject(GameFontNormalSmall2)
  getglobal(obj:GetName() .. "Text"):SetPoint("CENTER", obj, "CENTER", 0, 2)
  obj:SetText(string.sub(name, 0, 1))
  obj:GetNormalTexture():SetVertexColor(
    ChatTypeInfo[typeInfo].r,
    ChatTypeInfo[typeInfo].g,
    ChatTypeInfo[typeInfo].b)
  obj:GetHighlightTexture():SetVertexColor(
    ChatTypeInfo[typeInfo].r,
    ChatTypeInfo[typeInfo].g,
    ChatTypeInfo[typeInfo].b)
end

--[[
When addon is enabled. Register events
and "displays" the current log (even if main
frame isn't shown).
]]
function Elephant:OnEnable()
  -- Registering events
  Elephant:RegisterEventsRefresh()

  -- Sets chat tab buttons color
  SetTabButtonProperties(
    ElephantFrameGuildTabButton,
    Elephant.L['STRING_CHAT_NAME_GUILD'],
    'GUILD')
  SetTabButtonProperties(
    ElephantFrameOfficerTabButton,
    Elephant.L['STRING_CHAT_NAME_OFFICER'],
    'OFFICER')
  SetTabButtonProperties(
    ElephantFrameWhisperTabButton,
    Elephant.L['STRING_CHAT_NAME_WHISPER'],
    'WHISPER')
  SetTabButtonProperties(
    ElephantFramePartyTabButton,
    Elephant.L['STRING_CHAT_NAME_PARTY'],
    'PARTY')
  SetTabButtonProperties(
    ElephantFrameRaidTabButton,
    Elephant.L['STRING_CHAT_NAME_RAID'],
    'RAID')
  SetTabButtonProperties(
    ElephantFrameInstanceTabButton,
    Elephant.L['STRING_CHAT_NAME_INSTANCE'],
    'INSTANCE_CHAT')
  SetTabButtonProperties(
    ElephantFrameSayTabButton,
    Elephant.L['STRING_CHAT_NAME_SAY'],
    'SAY')
  SetTabButtonProperties(
    ElephantFrameYellTabButton,
    Elephant.L['STRING_CHAT_NAME_YELL'],
    'YELL')

  -- Displays default log
  if not Elephant:LogsDb().logs[Elephant:CharDb().currentlogindex] then
    Elephant:CharDb().currentlogindex = Elephant:DefaultConfiguration().defaultlogindex
  end
  Elephant.volatileConfiguration.currentline = #Elephant:LogsDb().logs[Elephant:CharDb().currentlogindex].logs
  Elephant:ShowCurrentLog()
end
