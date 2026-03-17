-- Creating AddOn
Elephant =
  LibStub("AceAddon-3.0"):NewAddon("Elephant", "AceConsole-3.0", "AceEvent-3.0")
Elephant.L = LibStub("AceLocale-3.0"):GetLocale("Elephant")

-- Bindings
_G["BINDING_NAME_ELEPHANT_TOGGLE"] = Elephant.L["STRING_KEYBIND_TOGGLE"]

-- Popup dialogs
StaticPopupDialogs["ELEPHANT_CLEARALL"] = {
  text = Elephant.L["STRING_POPUP_CLEAR_LOGS"],
  button1 = Elephant.L["STRING_OK"],
  button2 = Elephant.L["STRING_CANCEL"],
  OnAccept = function()
    Elephant:ClearAllLogs()
  end,
  timeout = 0,
  whileDead = 1,
  hideOnEscape = 1,
  showAlert = 1,
}
StaticPopupDialogs["ELEPHANT_EMPTY"] = {
  text = Elephant.L["STRING_POPUP_EMPTY_LOG"],
  button1 = Elephant.L["STRING_OK"],
  button2 = Elephant.L["STRING_CANCEL"],
  OnAccept = function()
    Elephant:EmptyCurrentLog()
  end,
  timeout = 0,
  whileDead = 1,
  hideOnEscape = 1,
  showAlert = 1,
}
StaticPopupDialogs["ELEPHANT_RESET"] = {
  text = Elephant.L["STRING_POPUP_RESET_SETTINGS"],
  button1 = Elephant.L["STRING_OK"],
  button2 = Elephant.L["STRING_CANCEL"],
  OnAccept = function()
    Elephant:Reset()
  end,
  timeout = 0,
  whileDead = 1,
  hideOnEscape = 1,
  showAlert = 1,
}

-- Cloning function, used for tables
function Elephant:Clone(o)
  local new = {}
  local i, v = next(o, nil)
  while i do
    if type(v) == "table" then
      v = Elephant:Clone(v)
    end
    new[i] = v
    i, v = next(o, i)
  end
  return new
end

-- Profile database. Can be changed when changing addon profile. Initialized
-- with DefaultConfiguration().savedconfdefaults
function Elephant:ProfileDb()
  return Elephant._db.profile
end

-- Returns an appropriate database to save logs. The returned database depends
-- on the per-profile use_factionrealm_db setting.
function Elephant:LogsDb()
  if Elephant:ProfileDb().use_factionrealm_db then
    return Elephant:FactionRealmDb()
  else
    return Elephant:CharDb()
  end
end

-- Character database. Proper to the character and only them. Initialized with
-- DefaultConfiguration().savedpercharconfdefaults
function Elephant:CharDb()
  return Elephant._db.char
end

-- Faction realm database. Shared between all characters on the same realm AND
-- faction. Initialized with
-- DefaultConfiguration().savedperfactionrealmconfdefaults
function Elephant:FactionRealmDb()
  return Elephant._db.factionrealm
end

local volatile_configuration = {
  currentline = nil,

  -- Data for specific events, such as loot method change (here only for
  -- reference).

  lootmethod = nil,
  masterlooter = nil,

  -- For copy window state
  is_copywindow_bbcode = false,

  warned_cannot_log_some_msgs_in_combat = false,
}

-- Temporary config, not saved but does change at runtime
function Elephant:VolatileConfig()
  return volatile_configuration
end

-- Default logs that the user cannot delete. Does not include some General chats
-- owned by Blizzard (General, Trade, etc.).
local default_logs = {
  whisper = {
    id = 1,
    localized_name = Elephant.L["STRING_CHAT_NAME_WHISPER"],
    type_info = ChatTypeInfo["WHISPER"],
  },
  raid = {
    id = 2,
    localized_name = Elephant.L["STRING_CHAT_NAME_RAID"],
    type_info = ChatTypeInfo["RAID"],
  },
  party = {
    id = 3,
    localized_name = Elephant.L["STRING_CHAT_NAME_PARTY"],
    type_info = ChatTypeInfo["PARTY"],
  },
  say = {
    id = 4,
    localized_name = Elephant.L["STRING_CHAT_NAME_SAY"],
    type_info = ChatTypeInfo["SAY"],
  },
  yell = {
    id = 5,
    localized_name = Elephant.L["STRING_CHAT_NAME_YELL"],
    type_info = ChatTypeInfo["YELL"],
  },
  officer = {
    id = 6,
    localized_name = Elephant.L["STRING_CHAT_NAME_OFFICER"],
    type_info = ChatTypeInfo["OFFICER"],
  },
  guild = {
    id = 7,
    localized_name = Elephant.L["STRING_CHAT_NAME_GUILD"],
    type_info = ChatTypeInfo["GUILD"],
  },
  loot = {
    id = 8,
    localized_name = Elephant.L["STRING_CHAT_NAME_LOOT"],
    type_info = ChatTypeInfo["LOOT"],
  },
  system = {
    id = 9,
    localized_name = Elephant.L["STRING_CHAT_NAME_SYSTEM"],
    type_info = ChatTypeInfo["SYSTEM"],
  },
  achievement = {
    id = 10,
    localized_name = Elephant.L["STRING_CHAT_NAME_ACHIEVEMENT"],
    type_info = ChatTypeInfo["ACHIEVEMENT"],
  },
  instance = {
    id = 11,
    localized_name = Elephant.L["STRING_CHAT_NAME_INSTANCE_CHAT"],
    type_info = ChatTypeInfo["INSTANCE_CHAT"],
  },
  pet_battle = {
    id = 12,
    localized_name = Elephant.L["STRING_CHAT_NAME_PET_BATTLE_COMBAT_LOG"],
    type_info = ChatTypeInfo["PET_BATTLE_COMBAT_LOG"],
  },
}

-- Default configuration, doesn't change at runtime
local default_configuration = {
  -- Frame positions
  position = { x = 0, y = -150 },
  copyposition = { x = 0, y = -175 },

  -- Log sizes / Scroll sizes
  minlogsize = 50,
  maxlogsize = 10000,
  scrollmaxlines = 50,
  scrollpage = 20,
  scrollmouse = 3,
  copywindowminletters = 1000,
  copywindowmaxletters = 100000,

  -- Default logs of the addon, cannot be removed (related to default chats
  -- defined by Blizzard).
  defaultlogs = default_logs,
  generalchatchannelmetadata = {
    -- Keep it in the order it should be shown in the dropdown menu.
    {
      id = Elephant.L["STRING_GENERAL_CHAT_CHANNEL_NAME_GENERAL_ID"],
      name = Elephant.L["STRING_GENERAL_CHAT_CHANNEL_NAME_GENERAL"],
    },
    {
      id = Elephant.L["STRING_GENERAL_CHAT_CHANNEL_NAME_LOOKING_FOR_GROUP_ID"],
      name = Elephant.L["STRING_GENERAL_CHAT_CHANNEL_NAME_LOOKING_FOR_GROUP"],
    },
    {
      id = Elephant.L["STRING_GENERAL_CHAT_CHANNEL_NAME_GUILD_RECRUITMENT_ID"],
      name = Elephant.L["STRING_GENERAL_CHAT_CHANNEL_NAME_GUILD_RECRUITMENT"],
    },
    {
      id = Elephant.L["STRING_GENERAL_CHAT_CHANNEL_NAME_LOCAL_DEFENSE_ID"],
      name = Elephant.L["STRING_GENERAL_CHAT_CHANNEL_NAME_LOCAL_DEFENSE"],
    },
    {
      id = Elephant.L["STRING_GENERAL_CHAT_CHANNEL_NAME_WORLD_DEFENSE_ID"],
      name = Elephant.L["STRING_GENERAL_CHAT_CHANNEL_NAME_WORLD_DEFENSE"],
    },
    {
      id = Elephant.L["STRING_GENERAL_CHAT_CHANNEL_NAME_TRADE_ID"],
      name = Elephant.L["STRING_GENERAL_CHAT_CHANNEL_NAME_TRADE"],
    },
    {
      id = Elephant.L["STRING_GENERAL_CHAT_CHANNEL_NAME_TRADE_SERVICES_ID"],
      id_alt = Elephant.L["STRING_GENERAL_CHAT_CHANNEL_NAME_TRADE_SERVICES_ID_ALT"],
      name = Elephant.L["STRING_GENERAL_CHAT_CHANNEL_NAME_TRADE_SERVICES"],
    },
  },
  defaultlogindex = 1,

  -- Used when registering addon databases
  savedconfdefaults = {
    chatlog = false,
    combatlog = false,
    defaultlog = true,
    maxcopyletters = 15000,
    button = false,
    events = {},
    filters = {},
    prat = false,
    activate_log = false,
    class_colors_in_log = true,
    timestamps_in_copywindow = true,

    -- By default, use a per-character database. It has historically been the
    -- case with Elephant, so keep it as-is.
    use_factionrealm_db = false,
    skip_cannot_log_restricted_warning = false,
    -- Minimap
    minimap = {
      hide = false,
    },
    log_font_id = nil,
    log_font_size = 14,
    skin_id = "default",

    -- Completing saved default configuration: Events & Default catchers.
    -- Possible values for channels:
    --   -1: Always enabled, cannot be disabled
    --    0: Starts disabled, can be enabled
    --    1: Starts enabled, can be disabled
    --
    -- Types are used for getting literal messages.
    events = {
      ["CHAT_MSG_ACHIEVEMENT"] = {
        type = "ACHIEVEMENT",
        channels = {
          [default_logs.achievement.id] = 0,
        },
      },
      ["CHAT_MSG_BG_SYSTEM_ALLIANCE"] = {
        type = "BG_SYSTEM_ALLIANCE",
        channels = {
          [default_logs.raid.id] = 0,
          [default_logs.instance.id] = 1,
        },
      },
      ["CHAT_MSG_BG_SYSTEM_HORDE"] = {
        type = "BG_SYSTEM_HORDE",
        channels = {
          [default_logs.raid.id] = 0,
          [default_logs.instance.id] = 1,
        },
      },
      ["CHAT_MSG_BG_SYSTEM_NEUTRAL"] = {
        type = "BG_SYSTEM_NEUTRAL",
        channels = {
          [default_logs.raid.id] = 0,
          [default_logs.instance.id] = 1,
        },
      },
      ["CHAT_MSG_BN_WHISPER"] = {
        type = "BN_WHISPER",
        desc = format("%s (%s)", BN_WHISPER, CHAT_MSG_WHISPER),
        channels = {
          [default_logs.whisper.id] = -1,
        },
      },
      ["CHAT_MSG_BN_WHISPER_INFORM"] = {
        type = "BN_WHISPER_INFORM",
        desc = format("%s (%s)", BN_WHISPER, CHAT_MSG_WHISPER_INFORM),
        channels = {
          [default_logs.whisper.id] = -1,
        },
      },
      ["CHAT_MSG_CHANNEL"] = {
        type = "CHANNEL",
      },
      ["CHAT_MSG_CHANNEL_NOTICE"] = {
        type = "CHANNEL_NOTICE",
      },
      ["CHAT_MSG_EMOTE"] = {
        type = "EMOTE",
        channels = {
          [default_logs.say.id] = 1,
          [default_logs.party.id] = 0,
          [default_logs.raid.id] = 0,
          [default_logs.instance.id] = 0,
        },
      },
      ["CHAT_MSG_GUILD"] = {
        type = "GUILD",
        desc = GUILD_CHAT,
        channels = {
          [default_logs.guild.id] = -1,
        },
      },
      ["CHAT_MSG_GUILD_ACHIEVEMENT"] = {
        type = "GUILD_ACHIEVEMENT",
        channels = {
          [default_logs.achievement.id] = -1,
          [default_logs.guild.id] = 0,
          [default_logs.officer.id] = 0,
        },
      },
      ["CHAT_MSG_INSTANCE_CHAT"] = {
        type = "INSTANCE_CHAT",
        channels = {
          [default_logs.instance.id] = -1,
        },
      },
      ["CHAT_MSG_INSTANCE_CHAT_LEADER"] = {
        type = "INSTANCE_CHAT_LEADER",
        channels = {
          [default_logs.instance.id] = -1,
        },
      },
      ["CHAT_MSG_LOOT"] = {
        type = "LOOT",
        register_with_prat = true,
        desc = ITEM_LOOT,
        channels = {
          [default_logs.loot.id] = -1,
        },
      },
      ["CHAT_MSG_MONEY"] = {
        type = "MONEY",
        register_with_prat = true,
        desc = MONEY_LOOT,
        channels = {
          [default_logs.loot.id] = 1,
        },
      },
      ["CHAT_MSG_CURRENCY"] = {
        type = "CURRENCY",
        register_with_prat = true,
        channels = {
          [default_logs.loot.id] = 1,
        },
      },
      ["CHAT_MSG_MONSTER_EMOTE"] = {
        type = "MONSTER_EMOTE",
        channels = {
          [default_logs.say.id] = 1,
          [default_logs.party.id] = 0,
          [default_logs.raid.id] = 0,
          [default_logs.instance.id] = 0,
        },
      },
      ["CHAT_MSG_MONSTER_SAY"] = {
        type = "MONSTER_SAY",
        channels = {
          [default_logs.say.id] = 1,
          [default_logs.party.id] = 0,
          [default_logs.raid.id] = 0,
          [default_logs.instance.id] = 0,
        },
      },
      ["CHAT_MSG_MONSTER_WHISPER"] = {
        type = "MONSTER_WHISPER",
        channels = {
          [default_logs.whisper.id] = 1,
          [default_logs.party.id] = 1,
          [default_logs.raid.id] = 1,
          [default_logs.instance.id] = 1,
        },
      },
      ["CHAT_MSG_MONSTER_YELL"] = {
        type = "MONSTER_YELL",
        channels = {
          [default_logs.say.id] = 0,
          [default_logs.party.id] = 1,
          [default_logs.yell.id] = 1,
          [default_logs.raid.id] = 1,
          [default_logs.instance.id] = 1,
        },
      },
      ["CHAT_MSG_OFFICER"] = {
        type = "OFFICER",
        desc = OFFICER_CHAT,
        channels = {
          [default_logs.officer.id] = -1,
        },
      },
      ["CHAT_MSG_PARTY"] = {
        type = "PARTY",
        channels = {
          [default_logs.party.id] = -1,
          [default_logs.raid.id] = 0,
        },
      },
      ["CHAT_MSG_PARTY_LEADER"] = {
        type = "PARTY_LEADER",
        channels = {
          [default_logs.party.id] = -1,
          [default_logs.raid.id] = 0,
        },
      },
      ["CHAT_MSG_PET_BATTLE_COMBAT_LOG"] = {
        type = "PET_BATTLE_INFO",
        channels = {
          [default_logs.pet_battle.id] = -1,
        },
      },
      ["CHAT_MSG_PET_BATTLE_INFO"] = {
        type = "PET_BATTLE_COMBAT_LOG",
        channels = {
          [default_logs.pet_battle.id] = -1,
        },
      },
      ["CHAT_MSG_RAID"] = {
        type = "RAID",
        channels = {
          [default_logs.raid.id] = -1,
        },
      },
      ["CHAT_MSG_RAID_LEADER"] = {
        type = "RAID_LEADER",
        channels = {
          [default_logs.raid.id] = -1,
        },
      },
      ["CHAT_MSG_RAID_WARNING"] = {
        type = "RAID_WARNING",
        channels = {
          [default_logs.raid.id] = -1,
        },
      },
      ["CHAT_MSG_RAID_BOSS_WHISPER"] = {
        type = "RAID_BOSS_WHISPER",
        channels = {
          [default_logs.whisper.id] = 0,
          [default_logs.raid.id] = 1,
          [default_logs.instance.id] = 1,
        },
      },
      ["CHAT_MSG_RAID_BOSS_EMOTE"] = {
        type = "RAID_BOSS_EMOTE",
        channels = {
          [default_logs.raid.id] = 1,
          [default_logs.instance.id] = 1,
        },
      },
      ["CHAT_MSG_SAY"] = {
        type = "SAY",
        channels = {
          [default_logs.say.id] = -1,
        },
      },
      ["CHAT_MSG_SYSTEM"] = {
        type = "SYSTEM",
        desc = SYSTEM_MESSAGES,
        channels = {
          [default_logs.system.id] = -1,
        },
      },
      ["CHAT_MSG_TEXT_EMOTE"] = {
        type = "TEXT_EMOTE",
        desc = CHAT_MSG_TEXT_EMOTE,
        channels = {
          [default_logs.say.id] = 1,
          [default_logs.party.id] = 0,
          [default_logs.raid.id] = 0,
          [default_logs.instance.id] = 0,
        },
      },
      ["CHAT_MSG_WHISPER"] = {
        type = "WHISPER",
        desc = CHAT_MSG_WHISPER,
        channels = {
          [default_logs.whisper.id] = -1,
        },
      },
      ["CHAT_MSG_WHISPER_INFORM"] = {
        type = "WHISPER_INFORM",
        desc = CHAT_MSG_WHISPER_INFORM,
        channels = {
          [default_logs.whisper.id] = -1,
        },
      },
      ["CHAT_MSG_YELL"] = {
        type = "YELL",
        channels = {
          [default_logs.say.id] = 0,
          [default_logs.yell.id] = -1,
        },
      },
      ["PARTY_LOOT_METHOD_CHANGED"] = {
        type = "SYSTEM",
        register_with_prat = true,
        desc = LOOT_METHOD,
        channels = {
          [default_logs.loot.id] = -1,
          [default_logs.party.id] = 1,
          [default_logs.raid.id] = 1,
          [default_logs.instance.id] = 1,
        },
      },
    },
  },
  savedpercharconfdefaults = {
    logs = {},
    -- Current log displayed is a per character setting.
    currentlogindex = 1,
  },
  savedperfactionrealmconfdefaults = {
    logs = {},
    maxlog = 1000,
  },
}
function Elephant:DefaultConfiguration()
  return default_configuration
end

-- Returns the loot method with a compatibility code.
function Elephant:GetLootMethod()
  if C_PartyInfo and C_PartyInfo.GetLootMethod then
    return C_PartyInfo.GetLootMethod()
  end

  return GetLootMethod()
end
