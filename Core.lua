--[[ Creating AddOn ]]
Elephant = LibStub("AceAddon-3.0"):NewAddon("Elephant", "AceConsole-3.0", "AceEvent-3.0")
Elephant.L = LibStub("AceLocale-3.0"):GetLocale("Elephant")

--[[ Bindings ]]
BINDING_HEADER_ELEPHANT = "Elephant"
BINDING_NAME_ELEPHANT_TOGGLE = Elephant.L['toggle']

--[[ Popup dialogs ]]
StaticPopupDialogs['ELEPHANT_CLEARALL'] = {
  text = Elephant.L['clearallpopup'][1],
  button1 = Elephant.L['clearallpopup'][2],
  button2 = Elephant.L['clearallpopup'][3],
  OnAccept = function ()
    Elephant:ClearAllLogs()
  end,
  timeout = 0,
  whileDead = 1,
  hideOnEscape = 1,
  showAlert = 1,
}
StaticPopupDialogs['ELEPHANT_EMPTY'] = {
  text = Elephant.L['emptypopup'][1],
  button1 = Elephant.L['emptypopup'][2],
  button2 = Elephant.L['emptypopup'][3],
  OnAccept = function ()
    Elephant:EmptyCurrentLog()
  end,
  timeout = 0,
  whileDead = 1,
  hideOnEscape = 1,
  showAlert = 1,
}
StaticPopupDialogs['ELEPHANT_RESET'] = {
  text = Elephant.L['resetpopup'][1],
  button1 = Elephant.L['resetpopup'][2],
  button2 = Elephant.L['resetpopup'][3],
  OnAccept = function ()
    Elephant:Reset()
  end,
  timeout = 0,
  whileDead = 1,
  hideOnEscape = 1,
  showAlert = 1,
}

--[[ Cloning function, used for tables ]]
function Elephant:clone(o)
  local new = {}
  local i, v = next(o, nil)
  while i do
    if type(v) == "table" then
      v = Elephant:clone(v)
    end
    new[i] = v
    i, v = next(o, i)
  end
  return new
end

--[[ Default configuration, doesn't change at runtime ]]
Elephant.defaultConf = {
  -- Frame positions
  position = { x = 0, y = -150 },
  copyposition = { x = 0, y = -175 },

  -- Log sizes / Scroll sizes
  minlogsize = 50,
  maxlogsize = 10000,
  scrollmaxlines = 35,
  scrollpage = 20,
  scrollmouse = 3,
  copywindowminletters = 1000,
  copywindowmaxletters = 100000,

  -- Default logs of the addon, cannot be removed
  -- (related to default chats defined by Blizzard)
  defaultindexes = {
    whisper = 1,
    raid = 2,
    party = 3,
    say = 4,
    yell = 5,
    officer = 6,
    guild = 7,
    loot = 8,
    system = 9,
    achievement = 10,
    instance = 11,
  },
  defaultnames = {
    whisper = Elephant.L['chatnames']['whisper'],
    raid = Elephant.L['chatnames']['raid'],
    party = Elephant.L['chatnames']['party'],
    say = Elephant.L['chatnames']['say'],
    yell = Elephant.L['chatnames']['yell'],
    officer = Elephant.L['chatnames']['officer'],
    guild = Elephant.L['chatnames']['guild'],
    loot = Elephant.L['chatnames']['loot'],
    system = Elephant.L['chatnames']['system'],
    achievement = Elephant.L['chatnames']['achievement'],
    instance = Elephant.L['chatnames']['instance'],
  },
  defaultlogindex = 1,

  -- Used when registering addon databases
  -- Warning: these tables are completed below
  savedconfdefaults  = {
    chatlog = false,
    combatlog = false,
    defaultlog = true,
    maxlog = 250,
    maxcopyletters = 15000,
    button = false,
    events = {},
    filters = {},
    prat = false,
    activate_log = false,
    class_colors_in_log = true,
    timestamps_in_copywindow = true,
    -- Minimap
    minimap = {
      hide = false
    },
  },
  savedpercharconfdefaults = {
    logs = {},
    currentlogindex = 1,
  }
}

--[[ Temporary config, not saved but does change at runtime ]]
Elephant.tempConf = {
  currentline = Elephant.defaultConf.defaultline,

  -- Data for specific events, such as loot method
  -- change (here only for reference)
  lootmethod = nil,
  masterlooter = nil,

  -- For copy window state
  is_copywindow_bbcode = false
}

--[[
  Completing saved default configuration: Events & Default catchers
  Possible values for channels:
    -1: Always enabled, cannot be disabled
    0: Starts disabled, can be enabled
    1: Starts enabled, can be disabled
]]
Elephant.defaultConf.savedconfdefaults.events = {
  ['CHAT_MSG_ACHIEVEMENT'] = {
    type = "ACHIEVEMENT",
    register_with_prat = true,
    desc = CHAT_MSG_ACHIEVEMENT,
    channels = {
      [Elephant.defaultConf.defaultindexes.achievement] = 0,
    }
  },
  ['CHAT_MSG_BG_SYSTEM_ALLIANCE'] = {
    type = "BG_SYSTEM_ALLIANCE",
    register_with_prat = true,
    desc = CHAT_MSG_BG_SYSTEM_ALLIANCE,
    channels = {
      [Elephant.defaultConf.defaultindexes.raid] = 0,
      [Elephant.defaultConf.defaultindexes.instance] = 1,
    }
  },
  ['CHAT_MSG_BG_SYSTEM_HORDE'] = {
    type = "BG_SYSTEM_HORDE",
    register_with_prat = true,
    desc = CHAT_MSG_BG_SYSTEM_HORDE,
    channels = {
      [Elephant.defaultConf.defaultindexes.raid] = 0,
      [Elephant.defaultConf.defaultindexes.instance] = 1,
    }
  },
  ['CHAT_MSG_BG_SYSTEM_NEUTRAL'] = {
    type = "BG_SYSTEM_NEUTRAL",
    register_with_prat = true,
    desc = CHAT_MSG_BG_SYSTEM_NEUTRAL,
    channels = {
      [Elephant.defaultConf.defaultindexes.raid] = 0,
      [Elephant.defaultConf.defaultindexes.instance] = 1,
    }
  },
  ['CHAT_MSG_BN_WHISPER'] = {
    type = "BN_WHISPER",
    desc = CHAT_MSG_BN_WHISPER,
    channels = {
      [Elephant.defaultConf.defaultindexes.whisper] = -1,
    },
  },
  ['CHAT_MSG_BN_WHISPER_INFORM'] = {
    type = "BN_WHISPER_INFORM",
    desc = CHAT_MSG_BN_CONVERSATION,
    channels = {
      [Elephant.defaultConf.defaultindexes.whisper] = -1,
    },
  },
  ['CHAT_MSG_CHANNEL'] = {
    type = "CHANNEL",
  },
  ['CHAT_MSG_CHANNEL_NOTICE'] = {
    type = "CHANNEL_NOTICE",
    register_with_prat = true
  },
  ['CHAT_MSG_EMOTE'] = {
    type = "EMOTE",
    register_with_prat = true,
    desc = CHAT_MSG_EMOTE,
    channels = {
      [Elephant.defaultConf.defaultindexes.say] = 1,
      [Elephant.defaultConf.defaultindexes.party] = 0,
      [Elephant.defaultConf.defaultindexes.raid] = 0,
      [Elephant.defaultConf.defaultindexes.instance] = 0,
    }
  },
  ['CHAT_MSG_GUILD'] = {
    type = "GUILD",
    desc = CHAT_MSG_GUILD,
    channels = {
      [Elephant.defaultConf.defaultindexes.guild] = -1,
    }
  },
  ['CHAT_MSG_GUILD_ACHIEVEMENT'] = {
    type = "GUILD_ACHIEVEMENT",
    register_with_prat = true,
    desc = CHAT_MSG_GUILD_ACHIEVEMENT,
    channels = {
      [Elephant.defaultConf.defaultindexes.achievement] = -1,
      [Elephant.defaultConf.defaultindexes.guild] = 0,
      [Elephant.defaultConf.defaultindexes.officer] = 0,
    }
  },
  ['CHAT_MSG_INSTANCE_CHAT'] = {
    type = "INSTANCE_CHAT",
    desc = INSTANCE_CHAT,
    channels = {
      [Elephant.defaultConf.defaultindexes.instance] = -1,
    }
  },
  ['CHAT_MSG_INSTANCE_CHAT_LEADER'] = {
    type = "INSTANCE_CHAT",
    desc = INSTANCE_CHAT_LEADER,
    channels = {
      [Elephant.defaultConf.defaultindexes.instance] = -1,
    }
  },
  ['CHAT_MSG_LOOT'] = {
    type = "LOOT",
    register_with_prat = true,
    desc = CHAT_MSG_LOOT,
    channels = {
      [Elephant.defaultConf.defaultindexes.loot] = -1,
    }
  },
  ['CHAT_MSG_MONEY'] = {
    type = "MONEY",
    register_with_prat = true,
    desc = CHAT_MSG_MONEY,
    channels = {
      [Elephant.defaultConf.defaultindexes.loot] = 1,
    }
  },
  ['CHAT_MSG_CURRENCY'] = {
    type = "CURRENCY",
    register_with_prat = true,
    desc = CURRENCY,
    channels = {
      [Elephant.defaultConf.defaultindexes.loot] = 1,
    }
  },
  ['CHAT_MSG_MONSTER_EMOTE'] = {
    type = "MONSTER_EMOTE",
    register_with_prat = true,
    desc = CHAT_MSG_MONSTER_EMOTE,
    channels = {
      [Elephant.defaultConf.defaultindexes.say] = 1,
      [Elephant.defaultConf.defaultindexes.party] = 0,
      [Elephant.defaultConf.defaultindexes.raid] = 0,
      [Elephant.defaultConf.defaultindexes.instance] = 0,
    }
  },
  ['CHAT_MSG_MONSTER_SAY'] = {
    type = "MONSTER_SAY",
    register_with_prat = true,
    desc = CHAT_MSG_MONSTER_SAY,
    channels = {
      [Elephant.defaultConf.defaultindexes.say] = 1,
      [Elephant.defaultConf.defaultindexes.party] = 0,
      [Elephant.defaultConf.defaultindexes.raid] = 0,
      [Elephant.defaultConf.defaultindexes.instance] = 0,
    }
  },
  ['CHAT_MSG_MONSTER_WHISPER'] = {
    type = "MONSTER_WHISPER",
    register_with_prat = true,
    desc = CHAT_MSG_MONSTER_WHISPER,
    channels = {
      [Elephant.defaultConf.defaultindexes.whisper] = 1,
      [Elephant.defaultConf.defaultindexes.party] = 1,
      [Elephant.defaultConf.defaultindexes.raid] = 1,
      [Elephant.defaultConf.defaultindexes.instance] = 1,
    }
  },
  ['CHAT_MSG_MONSTER_YELL'] = {
    type = "MONSTER_YELL",
    register_with_prat = true,
    desc = CHAT_MSG_MONSTER_YELL,
    channels = {
      [Elephant.defaultConf.defaultindexes.say] = 0,
      [Elephant.defaultConf.defaultindexes.party] = 1,
      [Elephant.defaultConf.defaultindexes.yell] = 1,
      [Elephant.defaultConf.defaultindexes.raid] = 1,
      [Elephant.defaultConf.defaultindexes.instance] = 1,
    }
  },
  ['CHAT_MSG_OFFICER'] = {
    type = "OFFICER",
    desc = CHAT_MSG_OFFICER,
    channels = {
      [Elephant.defaultConf.defaultindexes.officer] = -1,
    }
  },
  ['CHAT_MSG_PARTY'] = {
    type = "PARTY",
    desc = CHAT_MSG_PARTY,
    channels = {
      [Elephant.defaultConf.defaultindexes.party] = -1,
      [Elephant.defaultConf.defaultindexes.raid] = 0,
    }
  },
  ['CHAT_MSG_PARTY_LEADER'] = {
    type = "PARTY_LEADER",
    desc = CHAT_MSG_PARTY_LEADER,
    channels = {
      [Elephant.defaultConf.defaultindexes.party] = -1,
      [Elephant.defaultConf.defaultindexes.raid] = 0,
    }
  },
  ['CHAT_MSG_RAID'] = {
    type = "RAID",
    desc = CHAT_MSG_RAID,
    channels = {
      [Elephant.defaultConf.defaultindexes.raid] = -1,
    }
  },
  ['CHAT_MSG_RAID_LEADER'] = {
    type = "RAID_LEADER",
    desc = CHAT_MSG_RAID_LEADER,
    channels = {
      [Elephant.defaultConf.defaultindexes.raid] = -1,
    }
  },
  ['CHAT_MSG_RAID_WARNING'] = {
    type = "RAID_WARNING",
    desc = CHAT_MSG_RAID_WARNING,
    channels = {
      [Elephant.defaultConf.defaultindexes.raid] = -1,
    }
  },
  ['CHAT_MSG_SAY'] = {
    type = "SAY",
    desc = CHAT_MSG_SAY,
    channels = {
      [Elephant.defaultConf.defaultindexes.say] = -1,
    }
  },
  ['CHAT_MSG_SYSTEM'] = {
    type = "SYSTEM",
    desc = CHAT_MSG_SYSTEM,
    channels = {
      [Elephant.defaultConf.defaultindexes.system] = -1,
    }
  },
  ['CHAT_MSG_TEXT_EMOTE'] = {
    type = "TEXT_EMOTE",
    register_with_prat = true,
    desc = CHAT_MSG_TEXT_EMOTE,
    channels = {
      [Elephant.defaultConf.defaultindexes.say] = 1,
      [Elephant.defaultConf.defaultindexes.party] = 0,
      [Elephant.defaultConf.defaultindexes.raid] = 0,
      [Elephant.defaultConf.defaultindexes.instance] = 0,
    }
  },
  ['CHAT_MSG_WHISPER'] = {
    type = "WHISPER",
    desc = CHAT_MSG_WHISPER,
    channels = {
      [Elephant.defaultConf.defaultindexes.whisper] = -1,
    }
  },
  ['CHAT_MSG_WHISPER_INFORM'] = {
    type = "WHISPER_INFORM",
    desc = CHAT_MSG_WHISPER_INFORM,
    channels = {
      [Elephant.defaultConf.defaultindexes.whisper] = -1,
    }
  },
  ['CHAT_MSG_YELL'] = {
    type = "YELL",
    desc = CHAT_MSG_YELL,
    channels = {
      [Elephant.defaultConf.defaultindexes.say] = 0,
      [Elephant.defaultConf.defaultindexes.yell] = -1,
    }
  },
  ['PARTY_LOOT_METHOD_CHANGED'] = {
    type = "SYSTEM",
    register_with_prat = true,
    desc = LOOT_METHOD,
    channels = {
      [Elephant.defaultConf.defaultindexes.loot] = -1,
      [Elephant.defaultConf.defaultindexes.party] = 1,
      [Elephant.defaultConf.defaultindexes.raid] = 1,
      [Elephant.defaultConf.defaultindexes.instance] = 1,
    }
  },
  -- To be added: CHAT_MG_MONSTER_PARTY, CHAT_MSG_RAID_BOSS_EMOTE,
  -- CHAT_MSG_RAID_BOSS_WHISPER, pet battles?
}
