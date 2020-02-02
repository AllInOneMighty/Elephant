--Chinese Local : CWDG Translation Team 月色狼影
--CWDG site: http://cwowaddon.com  Chinese Addon/UI download center.
--$Rev: 287 $
--$Date: 2016-10-30 21:38:13 -0700 (Sun, 30 Oct 2016) $

local L = LibStub("AceLocale-3.0"):NewLocale("Elephant", "zhCN")
if not L then return end

--[[ Common messages ]]
L['chatlog']      = "将聊天记录保存为文件"
L['chatlog_desc']    = "将聊天记录(不包含战斗记录)保存到Logs\\WoWChatLog.txt.\n\n注意: 如果此选项已经打开, 登录游戏后将自动启用."
L['combatlog']    = "将战斗记录保存为文件"
L['combatlog_desc']    = "保存战斗记录到Logs\\WoWCombatLog.txt.\n\n注意: 如果此选项已经打开, 登录游戏后将自动启用."
L['disabled']    = "被禁用"
L['enabled']      = "已启用"
L['enableddefault']  = "记录新频道"
L['enableddefault_desc']  = "当加入一新频道自动开始记录内容"
L['noprat']      = "你选择使用Prat的格式记录但Prat未记录.信息将被记录成Elephant格式."
L['reset']      = "重置"
L['reset_desc']      = "重置设置."
L['toggle']      = "显示Elephant"
L['toggle_desc']      = "显示/隐藏面板"

--[[ Options menu elements ]]
L['activate']      = "激活"
L['activate_desc']    = "让Elephant控制文件记录. 禁用此选项将离开当前记录状态.\n\n警告: 你无法同时让两个插件控制文件记录(比如Prat和Elephant)"
L['clearallhelp']    = "清除所有记录"
L['clearallhelp_desc']  = "清除所有保存的记录"
L['files']        = "文件记录"
L['files_desc']      = "保存记录文本到文件中."
L['Filters']        = "过滤器"
L['Filters_desc']    = "过滤器用来屏蔽记录特殊的频道"
L['filterusage']      = "频道全称. 你也可以使用通配符(*). 例: <AceComm*>"
L['filtererror']      = "不能增加过滤器 ‘%s’. 过滤器只能包括非空白字符以及通配符(*)."
L['filterregex']      = "^[%S%*]+$"
L['newfilter_desc']    = "创建一个新过滤器."
L['deletefilter_desc']  = "删除先前创建的过滤器"
L['logs']        = "日志"
L['logs_desc']      = "记录选项."
L['maxlogwords']      = "最大记录长度"
L['maxlogwords_desc']  = "每个记录文本最大记录行数."
L['prat']        = "保存记录为Prat格式"
L['prat_desc']      = "保存记录为Prat格式. 设置此选项后所保存的聊天记录不在为Elephant的默认保存样式.\n\n如果你使用Prat插件,此选项将被激活"
L['resethelp']      = "重置所有设置及聊天频道"
L['resethelp_desc']    = "重置所有频道和频道"
L['resetloc']      = "重置所有窗口位置"
L['resetloc_desc']    = "重置Elephant面板位置."
L['showbutton']      = "显示按钮"
L['showbutton_desc']    = "在聊天框显示一按钮,切换Elephant."

--[[ Main/Copy frame elements ]]
-- Main
L['catchers']  = {
  [1]  = "信息收集罐",
  [2]  = "在记录器中想保存哪些信息?",
  [3]  = "灰色的信息类型不能被禁用."
}
L['clearall']    = "清除所有记录"
L['copy']      = "复制"
L['Disable']      = "禁用"
L['Empty']      = "清除"
L['Enable']      = "启用"
L['maxlog']      = "最大记录：%s 行。"
L['nblines']      = "行：%s"
L['scroll']      = {
  ['bottom']    = {
    [1]  = "下翻到最后一页"
  },
  ['linedown']  = {
    [1]  = "下翻一行"
  },
  ['lineup']    = {
    [1]  = "上翻一行"
  },
  ['pagedown']  = {
    [1]  = "下翻一页"
  },
  ['pageup']    = {
    [1]  = "上翻一页"
  },
  ['top']      = {
    [1]  = "上翻到第一页"
  }
}

-- Copy
L['bbAndText']    = "BB/Text"
L['bbAndTextInfo'] = {
  [1] = "Switches between showing plain text and BBCode (e.g. when you want to paste the logs on a forum).",
  [2] = "Due to UI length limitations, only %s lines of BBCode can be shown."
}
L['copywindow']  = "复制窗口"
L['copywindowloglength']    = "Log length: %s lines"
L['copywindowplaintext']    = "Plain text"
L['copywindowbbcode']    = "BBCode"
L['showtimestamps']  = "Show timestamps"

--[[ Special log messages ]]
L['logstartedon']  = "记录开始于 %s 的 %s。"
L['logstopped']    = "记录停止。"
L['monstersay']    = "%s 说"
L['monsteryell']    = "%s 喊话"
L['whisperfrom']    = "%s 密语"
L['whisperto']    = "发送给 %s"

--[[ Addon messages ]]
L['clearallconfirm']    = "所有聊天清除。"
L['combatlogdisabled']  = "战斗记录被禁用"
L['deleteconfirm']    = "聊天被删除： %s"
L['emptyconfirm']    = "聊天被清除： %s"
L['lootmethod']      = {
  ['freeforall']    = ERR_SET_LOOT_FREEFORALL,
  ['group']      = ERR_SET_LOOT_GROUP,
  ['master']      = ERR_SET_LOOT_MASTER,
  ['needbeforegreed']  = ERR_SET_LOOT_NBG,
  ['roundrobin']    = ERR_SET_LOOT_ROUNDROBIN
}
L['masterlooterchanged']  =  ERR_NEW_LOOT_MASTER_S
L['resetconfirm']    = "所有设置及聊天频道被重置。"

--[[ Tooltips ]]
L['togglebuttontooltip']    = {
  [1]  = "左击显示Elephant界面",
  [2]  = "中键点击重置按钮位置.",
  [3]  = "右击拖动按钮."
}
L['toggletooltip']      = "左击显示Elephant界面."

--[[ Popup windows ]]
L['clearallpopup']  = {
  [1]  = "是否要清除所有记录？",
  [2]  = "确定",
  [3]  = "取消"
}
L['emptypopup']    = {
  [1]  = "是否清除当前聊天记录？",
  [2]  = "确定",
  [3]  = "取消"
}
L['resetpopup']    = {
  [1]  = "是否要重置所有设置及聊天频道？",
  [2]  = "确定",
  [3]  = "取消"
}

--[[ Default chat names to be displayed ]]
L['chatnames']  = {
  ['combat']    = "战斗记录",
  ['custom']    = "自定义频道",
  ['general']    = "综合",
  ['guild']    = CHAT_MSG_GUILD,
  ['loot']    = CHAT_MSG_LOOT,
  ['misc']    = "分配物品界限",
  ['officer']    = CHAT_MSG_OFFICER,
  ['party']    = CHAT_MSG_PARTY,
  ['raid']    = CHAT_MSG_RAID,
  ['say']      = CHAT_MSG_SAY,
  ['system']    = SYSTEM_MESSAGES,
  ['whisper']    = WHISPER,
  ['yell']    = YELL_MESSAGE,
  ['achievement']  = ACHIEVEMENTS
}

--[[ General chats (= that you cannot leave) names and strings that identify them ]]
L['generalchats']  = {
  ['综合']    = {
    ['name']  = "综合",
    ['string']  = "综合"
  },
  ['交易']    = {
    ['name']  = "交易",
    ['string']  = "交易"
  },
  ['本地防务']  = {
    ['name']  = "本地防务",
    ['string']  = "本地防务"
  },
  ['世界防务']  = {
    ['name']  = "世界防务",
    ['string']  = "世界防务"
  },
  ['公会招募']  = {
    ['name']  = "公会招募",
    ['string']  = "公会招募"
  }
}

--[[ Custom chats special log messages ]]
L['customchat']  = {
  ['join']  = "你加入了频道。",
  ['leave']  = "你离开了频道。"
}
