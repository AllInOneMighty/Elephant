-- When addon is initialized. Registers database, options, initializes the main
-- frame, Elephant button if required, enables/disables WoW chat logging, and
-- initializes other useful data.
function Elephant:OnInitialize()
  -- Registering database with defaults: cloning objects to avoid problems
  Elephant._db = LibStub("AceDB-3.0"):New("ElephantDB", {
    profile = Elephant:Clone(Elephant:DefaultConfiguration().savedconfdefaults),
    char = Elephant:Clone(
      Elephant:DefaultConfiguration().savedpercharconfdefaults
    ),
    factionrealm = Elephant:Clone(
      Elephant:DefaultConfiguration().savedperfactionrealmconfdefaults
    ),
  })

  -- Now the Elephant._db is initialized, we can use the quick db access
  -- methods.

  -- If old maxlog value exists...
  if Elephant:ProfileDb().maxlog ~= nil then
    -- Copy it to the factionrealm db if it is greater than the new default
    if Elephant:ProfileDb().maxlog > Elephant:FactionRealmDb().maxlog then
      Elephant:FactionRealmDb().maxlog = Elephant:ProfileDb().maxlog
    end
    -- Then, remove it.
    Elephant:ProfileDb().maxlog = nil
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

  -- Checks & creates default log tables
  Elephant:MaybeInitDefaultLogTables()
  Elephant:AddHeaderToLogTables()

  -- Getting current loot method to avoid displaying too many times the same
  -- loot method in case of ReloadUI() or login.
  Elephant:VolatileConfig().lootmethod = Elephant:GetLootMethod()

  -- Minimap icon
  Elephant:RegisterLDBIcon()
end

local function SetTabButtonProperties(obj, typeInfo)
  obj:SetNormalFontObject(GameFontNormalSmall2)
  getglobal(obj:GetName() .. "Text"):SetPoint("CENTER", obj, "CENTER", 0, 2)
  local single_letter = nil
  for k, v in pairs(Elephant.L) do
    if k == "STRING_CHAT_NAME_SINGLE_LETTER_" .. typeInfo then
      single_letter = v
      break
    end
  end
  if not single_letter then
    single_letter =
      string.sub(Elephant.L["STRING_CHAT_NAME_" .. typeInfo], 0, 1)
  end
  obj:SetText(single_letter)
  obj:GetNormalTexture():SetVertexColor(
    ChatTypeInfo[typeInfo].r,
    ChatTypeInfo[typeInfo].g,
    ChatTypeInfo[typeInfo].b
  )
  obj:GetHighlightTexture():SetVertexColor(
    ChatTypeInfo[typeInfo].r,
    ChatTypeInfo[typeInfo].g,
    ChatTypeInfo[typeInfo].b
  )
end

-- When addon is enabled. Register events and "displays" the current log (even
-- if main frame isn't shown).
function Elephant:OnEnable()
  -- Registering events
  Elephant:RegisterEventsRefresh()

  -- Sets skin
  Elephant:UpdateSkin()

  -- Sets chat tab buttons color
  SetTabButtonProperties(ElephantFrameGuildTabButton, "GUILD")
  SetTabButtonProperties(ElephantFrameOfficerTabButton, "OFFICER")
  SetTabButtonProperties(ElephantFrameWhisperTabButton, "WHISPER")
  SetTabButtonProperties(ElephantFramePartyTabButton, "PARTY")
  SetTabButtonProperties(ElephantFrameRaidTabButton, "RAID")
  SetTabButtonProperties(ElephantFrameInstanceTabButton, "INSTANCE_CHAT")
  SetTabButtonProperties(ElephantFrameSayTabButton, "SAY")
  SetTabButtonProperties(ElephantFrameYellTabButton, "YELL")

  -- Displays default log
  if not Elephant:LogsDb().logs[Elephant:CharDb().currentlogindex] then
    Elephant:CharDb().currentlogindex =
      Elephant:DefaultConfiguration().defaultlogindex
  end
  Elephant:VolatileConfig().currentline =
    #Elephant:LogsDb().logs[Elephant:CharDb().currentlogindex].logs
  Elephant:ShowCurrentLog()
end
