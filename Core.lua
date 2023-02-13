--[[ Creating AddOn ]]
Elephant = LibStub("AceAddon-3.0"):NewAddon("Elephant", "AceConsole-3.0", "AceEvent-3.0")
Elephant.L = LibStub("AceLocale-3.0"):GetLocale("Elephant")

--[[ Bindings ]]
_G['BINDING_NAME_ELEPHANT_TOGGLE'] = Elephant.L['toggle']

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

function Elephant:ProfileDb()
  return Elephant.db.profile
end

function Elephant:CharDb()
  return Elephant.dbpc.char
end

--[[ Indexes used for default WoW channels ]]
local default_channel_indexes = {
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
}

--[[ Default configuration, doesn't change at runtime ]]
local default_configuration = {
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
  defaultindexes = Elephant:Clone(default_channel_indexes),
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
    --[[
      Completing saved default configuration: Events & Default catchers
      Possible values for channels:
        -1: Always enabled, cannot be disabled
        0: Starts disabled, can be enabled
        1: Starts enabled, can be disabled
    ]]
    events = {
      ['CHAT_MSG_ACHIEVEMENT'] = {
        type = "ACHIEVEMENT",
        desc = CHAT_MSG_ACHIEVEMENT,
        channels = {
          [default_channel_indexes.achievement] = 0,
        }
      },
      ['CHAT_MSG_BG_SYSTEM_ALLIANCE'] = {
        type = "BG_SYSTEM_ALLIANCE",
        desc = CHAT_MSG_BG_SYSTEM_ALLIANCE,
        channels = {
          [default_channel_indexes.raid] = 0,
          [default_channel_indexes.instance] = 1,
        }
      },
      ['CHAT_MSG_BG_SYSTEM_HORDE'] = {
        type = "BG_SYSTEM_HORDE",
        desc = CHAT_MSG_BG_SYSTEM_HORDE,
        channels = {
          [default_channel_indexes.raid] = 0,
          [default_channel_indexes.instance] = 1,
        }
      },
      ['CHAT_MSG_BG_SYSTEM_NEUTRAL'] = {
        type = "BG_SYSTEM_NEUTRAL",
        desc = CHAT_MSG_BG_SYSTEM_NEUTRAL,
        channels = {
          [default_channel_indexes.raid] = 0,
          [default_channel_indexes.instance] = 1,
        }
      },
      ['CHAT_MSG_BN_WHISPER'] = {
        type = "BN_WHISPER",
        desc = CHAT_MSG_BN_WHISPER,
        channels = {
          [default_channel_indexes.whisper] = -1,
        },
      },
      ['CHAT_MSG_BN_WHISPER_INFORM'] = {
        type = "BN_WHISPER_INFORM",
        desc = CHAT_MSG_BN_CONVERSATION,
        channels = {
          [default_channel_indexes.whisper] = -1,
        },
      },
      ['CHAT_MSG_CHANNEL'] = {
        type = "CHANNEL",
      },
      ['CHAT_MSG_CHANNEL_NOTICE'] = {
        type = "CHANNEL_NOTICE",
      },
      ['CHAT_MSG_EMOTE'] = {
        type = "EMOTE",
        desc = CHAT_MSG_EMOTE,
        channels = {
          [default_channel_indexes.say] = 1,
          [default_channel_indexes.party] = 0,
          [default_channel_indexes.raid] = 0,
          [default_channel_indexes.instance] = 0,
        }
      },
      ['CHAT_MSG_GUILD'] = {
        type = "GUILD",
        desc = CHAT_MSG_GUILD,
        channels = {
          [default_channel_indexes.guild] = -1,
        }
      },
      ['CHAT_MSG_GUILD_ACHIEVEMENT'] = {
        type = "GUILD_ACHIEVEMENT",
        desc = CHAT_MSG_GUILD_ACHIEVEMENT,
        channels = {
          [default_channel_indexes.achievement] = -1,
          [default_channel_indexes.guild] = 0,
          [default_channel_indexes.officer] = 0,
        }
      },
      ['CHAT_MSG_INSTANCE_CHAT'] = {
        type = "INSTANCE_CHAT",
        desc = INSTANCE_CHAT,
        channels = {
          [default_channel_indexes.instance] = -1,
        }
      },
      ['CHAT_MSG_INSTANCE_CHAT_LEADER'] = {
        type = "INSTANCE_CHAT",
        desc = INSTANCE_CHAT_LEADER,
        channels = {
          [default_channel_indexes.instance] = -1,
        }
      },
      ['CHAT_MSG_LOOT'] = {
        type = "LOOT",
        register_with_prat = true,
        desc = CHAT_MSG_LOOT,
        channels = {
          [default_channel_indexes.loot] = -1,
        }
      },
      ['CHAT_MSG_MONEY'] = {
        type = "MONEY",
        register_with_prat = true,
        desc = CHAT_MSG_MONEY,
        channels = {
          [default_channel_indexes.loot] = 1,
        }
      },
      ['CHAT_MSG_CURRENCY'] = {
        type = "CURRENCY",
        register_with_prat = true,
        desc = CURRENCY,
        channels = {
          [default_channel_indexes.loot] = 1,
        }
      },
      ['CHAT_MSG_MONSTER_EMOTE'] = {
        type = "MONSTER_EMOTE",
        desc = CHAT_MSG_MONSTER_EMOTE,
        channels = {
          [default_channel_indexes.say] = 1,
          [default_channel_indexes.party] = 0,
          [default_channel_indexes.raid] = 0,
          [default_channel_indexes.instance] = 0,
        }
      },
      ['CHAT_MSG_MONSTER_SAY'] = {
        type = "MONSTER_SAY",
        desc = CHAT_MSG_MONSTER_SAY,
        channels = {
          [default_channel_indexes.say] = 1,
          [default_channel_indexes.party] = 0,
          [default_channel_indexes.raid] = 0,
          [default_channel_indexes.instance] = 0,
        }
      },
      ['CHAT_MSG_MONSTER_WHISPER'] = {
        type = "MONSTER_WHISPER",
        desc = CHAT_MSG_MONSTER_WHISPER,
        channels = {
          [default_channel_indexes.whisper] = 1,
          [default_channel_indexes.party] = 1,
          [default_channel_indexes.raid] = 1,
          [default_channel_indexes.instance] = 1,
        }
      },
      ['CHAT_MSG_MONSTER_YELL'] = {
        type = "MONSTER_YELL",
        desc = CHAT_MSG_MONSTER_YELL,
        channels = {
          [default_channel_indexes.say] = 0,
          [default_channel_indexes.party] = 1,
          [default_channel_indexes.yell] = 1,
          [default_channel_indexes.raid] = 1,
          [default_channel_indexes.instance] = 1,
        }
      },
      ['CHAT_MSG_OFFICER'] = {
        type = "OFFICER",
        desc = CHAT_MSG_OFFICER,
        channels = {
          [default_channel_indexes.officer] = -1,
        }
      },
      ['CHAT_MSG_PARTY'] = {
        type = "PARTY",
        desc = CHAT_MSG_PARTY,
        channels = {
          [default_channel_indexes.party] = -1,
          [default_channel_indexes.raid] = 0,
        }
      },
      ['CHAT_MSG_PARTY_LEADER'] = {
        type = "PARTY_LEADER",
        desc = CHAT_MSG_PARTY_LEADER,
        channels = {
          [default_channel_indexes.party] = -1,
          [default_channel_indexes.raid] = 0,
        }
      },
      ['CHAT_MSG_RAID'] = {
        type = "RAID",
        desc = CHAT_MSG_RAID,
        channels = {
          [default_channel_indexes.raid] = -1,
        }
      },
      ['CHAT_MSG_RAID_LEADER'] = {
        type = "RAID_LEADER",
        desc = CHAT_MSG_RAID_LEADER,
        channels = {
          [default_channel_indexes.raid] = -1,
        }
      },
      ['CHAT_MSG_RAID_WARNING'] = {
        type = "RAID_WARNING",
        desc = CHAT_MSG_RAID_WARNING,
        channels = {
          [default_channel_indexes.raid] = -1,
        }
      },
      ['CHAT_MSG_RAID_BOSS_EMOTE'] = {
        type = "RAID_BOSS_EMOTE",
        desc = CHAT_MSG_RAID_BOSS_EMOTE,
        channels = {
          [default_channel_indexes.raid] = 1,
          [default_channel_indexes.instance] = 1,
        }
      },
      ['CHAT_MSG_SAY'] = {
        type = "SAY",
        desc = CHAT_MSG_SAY,
        channels = {
          [default_channel_indexes.say] = -1,
        }
      },
      ['CHAT_MSG_SYSTEM'] = {
        type = "SYSTEM",
        desc = CHAT_MSG_SYSTEM,
        channels = {
          [default_channel_indexes.system] = -1,
        }
      },
      ['CHAT_MSG_TEXT_EMOTE'] = {
        type = "TEXT_EMOTE",
        desc = CHAT_MSG_TEXT_EMOTE,
        channels = {
          [default_channel_indexes.say] = 1,
          [default_channel_indexes.party] = 0,
          [default_channel_indexes.raid] = 0,
          [default_channel_indexes.instance] = 0,
        }
      },
      ['CHAT_MSG_WHISPER'] = {
        type = "WHISPER",
        desc = CHAT_MSG_WHISPER,
        channels = {
          [default_channel_indexes.whisper] = -1,
        }
      },
      ['CHAT_MSG_WHISPER_INFORM'] = {
        type = "WHISPER_INFORM",
        desc = CHAT_MSG_WHISPER_INFORM,
        channels = {
          [default_channel_indexes.whisper] = -1,
        }
      },
      ['CHAT_MSG_YELL'] = {
        type = "YELL",
        desc = CHAT_MSG_YELL,
        channels = {
          [default_channel_indexes.say] = 0,
          [default_channel_indexes.yell] = -1,
        }
      },
      ['PARTY_LOOT_METHOD_CHANGED'] = {
        type = "SYSTEM",
        register_with_prat = true,
        desc = LOOT_METHOD,
        channels = {
          [default_channel_indexes.loot] = -1,
          [default_channel_indexes.party] = 1,
          [default_channel_indexes.raid] = 1,
          [default_channel_indexes.instance] = 1,
        }
      },
    },
  },
  savedpercharconfdefaults = {
    logs = {},
    currentlogindex = 1,
  }
}
function Elephant:DefaultConfiguration()
  return default_configuration
end

--[[ Temporary config, not saved but does change at runtime ]]
Elephant.volatileConfiguration = {
  currentline = Elephant:DefaultConfiguration().defaultline,

  -- Data for specific events, such as loot method
  -- change (here only for reference)
  lootmethod = nil,
  masterlooter = nil,

  -- For copy window state
  is_copywindow_bbcode = false
}
