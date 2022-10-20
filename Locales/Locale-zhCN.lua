local L = LibStub("AceLocale-3.0"):NewLocale("Elephant", "zhCN")
if not L then return end

--[[ Common messages ]]
L['chatlog']      = "记录聊天为日志文件"
L['chatlog2_desc']    = "保存聊天记录(不含战斗记录)到Logs\\WoWChatLog.txt."
L['chatlog2_desc2']    = "如果激活此选项，则登录时将自动启用文件日志记录。"
L['combatlog']    = "=记录战斗记录为日志文件"
L['combatlog2_desc']    = "保存战斗记录到Logs\\WoWCombatLog.txt."
L['combatlog2_desc2']    = "如果激活此选项，则登录时将自动启用文件日志记录。"
L['disabled']    = "已禁用"
L['enabled']      = "已启用"
L['enableddefault']  = "记录新频道"
L['enableddefault_desc']  = "加入新频道时自动开始记录日志。"
L['noprat']      = "您选择使用Prat的日志格式，但Prat未加载。消息将以Elephant的格式记录。"
L['reset']      = "重置"
L['reset_desc']      = "重置设置"
L['reset_header']    = {
  [1]      = "要重置主窗口和按钮位置，请单击下面的位置按钮。",
  [2]      = "要重置所有设置和聊天，请单击设置按钮。这将：删除您尚未加入的频道的任何日志，清除所有其他日志，为聊天和战斗禁用WoW文件日志，禁用Prat集成，禁用聊天按钮，重置主窗口的位置，最后启用小地图图标。"
}
L['toggle']      = "显示/隐藏"
L['toggle_desc']      = "显示/隐藏 Elephant 主窗口。"

--[[ Options menu elements ]]
L['activate']      = "启用"
L['activate_desc2']    = "让Elephant控制文件日志记录。禁用此选项将保持当前日志记录状态不变。"
L['activate_desc22']    = "警告：您不应该让两个不同的插件控制文件日志记录(比如Prat和Elephant)。"
L['chatlog_limitation']    = "由于暴雪界面的限制，无法过滤将发送到日志文件的内容。当您激活其中一个选项时，无论您当前的过滤器如何，所选类型的所有消息（即聊天或战斗）都将被保存。"
L['clearallhelp']    = "清除"
L['clearallhelp_desc']  = "清除所有保存的日志"
L['files']        = "文件日志记录"
L['files_desc']      = "将日志保存到文件中的选项。"
L['Filters']        = FILTERS
L['Filters_desc']    = "过滤器用于避免记录特定频道。"
L['filters_header']    = {
  [1]      = "您可以使用过滤器来避免记录您或其他插件加入的自定义频道。",
  [2]      = "通常，如果您的一个插件加入了许多频道，如“AddonComm1”、“AddonComm2”……最好添加“|c%sAddonComm*|r”过滤器，以便Elephant自动忽略它们。",
  [3]      = "可以通过添加“|c%s*|r”过滤器，忽略加入的所有自定义频道。但是要小心，因为在创建新过滤器时，与之匹配的所有通道的日志都会立即删除。",
  [4]      = "最后，如果设置显示 Elephant图标，您可以鼠标在图标上悬停，来查看所有活动的过滤器列表。"
}
L['filternew']      = NEW
L['filterusage']      = "频道全称. 你也可以使用通配符(*). 例: <AceComm*>"
L['filtererror']      = "不能添加过滤器 '%s'。 过滤器只能包含字母和通配符(*)."
L['filterregex']      = "^[%a%*]+$"
L['filternotfound']    = "未找到过滤器。"
L['filteradded']    = "添加过滤器 '%s'"
L['filterdeleted']    = "成功删除过滤器 '%s' 。"
L['newfilter_desc']    = "创建一个新过滤器。"
L['deletefilter_desc']  = "删除先前创建的过滤器"
L['logs']        = "日志"
L['logs_desc']      = "日志记录选项"
L['maxlogwords']      = "最大日志行数"
L['maxlogwords_desc']  = "每个日志行的最大大小。一行可以包含任意数量的字符。"
L['maxlogwords_desc_warning'] = "警告：任何超过1000的值都会显著增加内存使用量。"
L['prat']        = "Prat格式化"
L['prat_integration']    = "Prat集成"
L['prat2_desc']      = "以与Prat相同的方式保存日志。启用此选项后保存的日志无法恢复为Elephant的格式。"
L['prat2_desc2']    = "注意：并非所有消息都由Prat处理，其中一些消息仍将使用Elephant的格式。"
L['prat2_desc22']    = "只有当前启用了Prat，此选项才有效。"
L['resethelp']      = "设置"
L['resethelp_desc']    = "重置所有设置和聊天。"
L['resetloc']      = "位置"
L['resetloc_desc2']    = "重置Elephant主窗口和按钮位置。"
L['showbutton']      = "显示聊天栏按钮"
L['showbutton_desc']    = "在聊天框显示一按钮,切换Elephant."
L['classcolors']    = "使用职业颜色"
L['classcolors_desc']    = "在日志中显示玩家职业颜色。"
L['classcolors_desc2']    = "这也适用于使用Prat格式时未由Prat处理的消息。"

--[[ Main/Copy frame elements ]]
-- Main
L['catchers']  = {
  [1]  = "消息捕捉器",
  [2]  = "此日志中应保存什么？",
  [3]  = "无法禁用灰色消息类型。"
}
L['clearall']    = "全部清除"
L['copy']      = "复制"
L['copyinfo']  = "允许您复制日志的%s个字符，以上面窗口中显示的最后一行结束。"
L['copywarn']  = "Battle.net战网消息将自动删除，已保护你的隐私。"
L['Disable']    = DISABLE
L['Empty']    = "清空"  --使用EMPTY仅是显示1个字“空”
L['Enable']    = ENABLE
L['maxlog']    = "最大日志记录: %s 行。"
L['move2']    = {
  [1]  = "移动窗口",
  [2]  = "中键点击重置 Elephant 位置。",
  [3]  = "在主窗口也生效。"
}
L['nblines']      = "行：%s"
L['scroll']      = {
  ['bottom']    = {
    [1]  = "尾页"
  },
  ['linedown']  = {
    [1]  = "下一行"
  },
  ['lineup']    = {
    [1]  = "上一行"
  },
  ['pagedown']  = {
    [1]  = "下一页"
  },
  ['pageup']    = {
    [1]  = "上一页"
  },
  ['top']      = {
    [1]  = "首页"
  }
}
L['customchatsinfo']  = "未选频道是你离开的频道。"

-- Copy
L['bbAndText']    = "BB/Text"
L['bbAndTextInfo'] = {
  [1] = "在显示纯文本和BBCode之间切换（例如，当您想在论坛上粘贴日志时）。",
  [2] = "由于BBCode更加冗长，因此在该模式下实际上只显示更少的行。"
}
L['copywindow']  = "复制窗口"
L['copywindowloglength']    = "最多字符: %s"
L['copywindowplaintext']    = "纯文本"
L['copywindowbbcode']    = "BBCode代码"
L['showtimestamps']  = "显示时间戳"
L['itemLinkSite']  = "http://www.wowhead.com/?item="
L['maxcopycharacters'] = "最大复制字符数"
L['maxcopycharacters_desc'] = "要在复制窗口中显示的最大字符数（非行数）。"
L['maxcopycharacters_desc_warning'] = "警告：此值越高，加载复制窗口所需的时间越长。您的游戏将冻结，直到窗口填满为止。任何超过15000的值都会使加载时间明显。"

--[[ Special log messages ]]
L['logstartedon']  = "记录开始于 %s日 %s时。"
L['logstopped']    = "记录停止。"
L['monstersay']    = "%s 说"
L['monsteryell']    = "%s 喊话"
L['whisperfrom']    = "%s 密语"
L['whisperto']    = "发送给 %s"

--[[ Addon messages ]]
L['clearallconfirm']    = "已清除所有聊天。"
L['combatlogdisabled']  = "战斗记录已禁用"
L['deleteconfirm']    = "已删除聊天： %s"
L['emptyconfirm']    = "已清除聊天： %s"
L['lootmethod']      = {
  ['freeforall']    = ERR_SET_LOOT_FREEFORALL,
  ['group']      = ERR_SET_LOOT_GROUP,
  ['master']      = ERR_SET_LOOT_MASTER,
  ['needbeforegreed']  = ERR_SET_LOOT_NBG,
  ['roundrobin']    = ERR_SET_LOOT_ROUNDROBIN,
}
L['masterlooterchanged']  =  ERR_NEW_LOOT_MASTER_S
L['masterlooternameunknown']  = "无法确定战利品主人的名字"
L['resetconfirm']    = "重置所有设置及聊天。"

--[[ Tooltips ]]
L['togglebuttontooltip']    = {
  [1]  = "左击显示Elephant界面",
  [2]  = "中键点击重置按钮位置.",
  [3]  = "右击拖动按钮."
}
L['activefilters'] = "激活过滤器"
L['toggletooltiphint1'] = "|c%sClick|r 开关Elephant面板"
L['toggletooltiphint2'] = "\n|c%sRight-Click|r 打开选项窗口"

--[[ Popup windows ]]
L['clearallpopup']  = {
  [1]  = "是否清除所有记录？",
  [2]  = "确定",
  [3]  = "取消",
}
L['emptypopup']    = {
  [1]  = "是否清除当前记录？",
  [2]  = "确定",
  [3]  = "取消",
}
L['resetpopup']    = {
  [1]  = "是否重置所有设置及聊天？",
  [2]  = "确定",
  [3]  = "取消",
}
--[[ Minimap icon ]]
L['minimapicon']  = "小地图图标"
L['minimapicon_desc']  = "在小地图显示Elephant图标"

--[[ Default chat names to be displayed ]]
L['chatnames']  = {
  ['combat']    = "战斗",
  ['custom']    = "自定义频道",
  ['general']    = "综合",
  ['guild']    = CHAT_MSG_GUILD,
  ['loot']    = CHAT_MSG_LOOT,
  ['misc']    = "杂项",
  ['officer']    = CHAT_MSG_OFFICER,
  ['party']    = CHAT_MSG_PARTY,
  ['raid']    = CHAT_MSG_RAID,
  ['say']      = CHAT_MSG_SAY,
  ['system']    = SYSTEM_MESSAGES,
  ['whisper']    = WHISPER,
  ['yell']    = YELL_MESSAGE,
  ['achievement']  = ACHIEVEMENTS,
  ['instance'] = INSTANCE
}

--[[ General chats (= that you cannot leave) names and strings that identify them ]]
L['generalchats']  = {
  ['本地防务']    = {
    ['name']  = "本地防务",
    ['string']  = "本地防务",
  },
  ['寻求组队']    = {
    ['name']  = "寻求组队",
    ['string']  = "寻求组队",
  },
  ['综合']        = {
    ['name']  = "综合",
    ['string']  = "综合",
  },
  ['公会招募']  = {
    ['name']  = "公会招募",
    ['string']  = "公会招募",
  },
  ['交易']        = {
    ['name']  = "交易",
    ['string']  = "交易",
  },
  ['世界防务']    = {
    ['name']  = "世界防务",
    ['string']  = "世界防务",
  },
}

--[[ Custom chats special log messages ]]
L['customchat']  = {
  ['join']  = "你加入了频道。",
  ['leave']  = "你离开了频道。"
}
