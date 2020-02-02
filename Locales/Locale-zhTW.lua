local L = LibStub("AceLocale-3.0"):NewLocale("Elephant", "zhTW")
if not L then return end

--[[ Common messages ]]
L['chatlog']      = "將聊天記錄保存為檔案"
L['chatlog_desc']    = "將聊天記錄(不包含戰鬥記錄)保存到Logs\\WoWChatLog.txt.\n\n注意: 如果此選項已經打開, 進入游戲後將自動啟用."
L['combatlog']    = "將戰鬥記錄保存為檔案"
L['combatlog_desc']    = "保存戰鬥記錄到Logs\\WoWCombatLog.txt.\n\n注意: 如果此選項已經打開, 進入游戲後將自動啟用."
L['disabled']    = "已停用"
L['enabled']      = "已啟用"
L['enableddefault']  = "記錄新頻道"
L['enableddefault_desc']  = "當你進入新頻道時自動記錄."
L['noprat']      = "你選擇根據 Prat 格式保存記錄，但 Prat 並未載入。會使用 Elephant 格式記錄訊息。"
L['reset']      = "重設"
L['reset_desc']      = "重置設定."
L['toggle']      = "顯示 Elephant"
L['toggle_desc']      = "顯示或隱藏主視窗."

--[[ Options menu elements ]]
L['activate']      = "啟用"
L['activate_desc']    = "讓Elephant控制文件記錄. 禁用此選項將離開當前記錄狀態.\n\n警告: 你無法同時讓兩個插件控制文件記錄(比如Prat和Elephant)"
L['clearallhelp']    = "清除所有記錄"
L['clearallhelp_desc']  = "清除所有保存的記錄."
L['files']        = "檔案記錄"
L['files_desc']      = "檔案記錄選項."
L['Filters']        = "過濾器"
L['Filters_desc']    = "過濾器用來屏蔽記錄特殊的頻道"
L['filterusage']      = "頻道全名。你也可用通配字元 (*)。例: <AceComm*>"
L['filtererror']      = "不能增加過濾器「%s」。過濾器只能包括非空白字元及通配字元 (*)。"
L['filterregex']      = "^[%S%*]+$"
L['newfilter_desc']    = "建立新的過濾器."
L['deletefilter_desc']  = "刪除一個舊的過濾器."
L['logs']        = "記錄"
L['logs_desc']      = "記錄選項."
L['maxlogwords']      = "聊天最多記錄"
L['maxlogwords_desc']  = "每記錄檔最大的大小."
L['prat']        = "根據 Prat 格式保存記錄"
L['prat_desc']      = "保存記錄為Prat格式. 設置此選項後所保存的聊天記錄不在為Elephant的默認保存樣式.\n\n如果你使用Prat插件,此選項將被激活"
L['resethelp']      = "重設所有設定及聊天記錄"
L['resethelp_desc']    = "重設所有設定及聊天記錄."
L['resetloc']      = "重設 Elephant 視窗位置"
L['resetloc_desc']    = "重設 Elephant 視窗位置."
L['showbutton']      = "顯示按鈕"
L['showbutton_desc']    = "在聊天框顯示一按鈕,切換Elephant."

--[[ Main/Copy frame elements ]]
-- Main
L['catchers']  = {
  [1]  = "訊息捕捉器",
  [2]  = "在這個記錄保存什麼訊息?",
  [3]  = "灰色的訊息類型不能被停用。"
}
L['clearall']  = "清除所有"
L['copy']    = "複製"
L['Disable']    = "停用"
L['Empty']    = "清除"
L['Enable']    = "啟用"
L['maxlog']    = "最多記錄: %s行。"
L['nblines']    = "行: %s"
L['scroll']    = {
  ['bottom']    = {
    [1]  = "最後一頁"
  },
  ['linedown']  = {
    [1]  = "下一行"
  },
  ['lineup']    = {
    [1]  = "上一行"
  },
  ['pagedown']  = {
    [1]  = "下一頁"
  },
  ['pageup']    = {
    [1]  = "上一頁"
  },
  ['top']      = {
    [1]  = "第一頁"
  }
}

-- Copy
L['bbAndText']    = "BB/Text"
L['bbAndTextInfo'] = {
  [1] = "Switches between showing plain text and BBCode (e.g. when you want to paste the logs on a forum).",
  [2] = "Due to UI length limitations, only %s lines of BBCode can be shown."
}
L['copywindow']  = "複製視窗"
L['copywindowloglength']    = "Log length: %s lines"
L['copywindowplaintext']    = "Plain text"
L['copywindowbbcode']    = "BBCode"
L['showtimestamps']  = "Show timestamps"

--[[ Special log messages ]]
L['logstartedon']  = "記錄開始日期: %s，時間: %s。"
L['logstopped']    = "記錄停止。"
L['monstersay']    = "%s說"
L['monsteryell']    = "%s大喊"
L['whisperfrom']    = "%s悄悄地說"
L['whisperto']    = "告訴%s"

--[[ Addon messages ]]
L['clearallconfirm']    = "已清除所有聊天記錄。"
L['combatlogdisabled']  = "戰鬥記錄被停用。"
L['deleteconfirm']    = "已刪除聊天記錄: %s"
L['emptyconfirm']    = "已清除聊天記錄: %s"
L['lootmethod']      = {
  ['freeforall']    = ERR_SET_LOOT_FREEFORALL,
  ['group']      = ERR_SET_LOOT_GROUP,
  ['master']      = ERR_SET_LOOT_MASTER,
  ['needbeforegreed']  = ERR_SET_LOOT_NBG,
  ['roundrobin']    = ERR_SET_LOOT_ROUNDROBIN
}
L['masterlooterchanged']  =  ERR_NEW_LOOT_MASTER_S
L['resetconfirm']    = "已重設所有設定及聊天記錄。"

--[[ Tooltips ]]
L['togglebuttontooltip']    = {
  [1]  = "|cffeda55f左擊: |r顯示 Elephant。",
  [2]  = "|cffeda55f中擊: |r重設按鈕位置。",
  [3]  = "|cffeda55f右擊: |r移動位置。"
}
L['toggletooltip']      = "\n|cffeda55f左擊: |r顯示 Elephant。"

--[[ Popup windows ]]
L['clearallpopup']  = {
  [1]  = "是否要清除所有記錄?",
  [2]  = "確定",
  [3]  = "取消"
}
L['emptypopup']    = {
  [1]  = "是否清除目前的聊天記錄?",
  [2]  = "確定",
  [3]  = "取消"
}
L['resetpopup']    = {
  [1]  = "是否要重設所有設定及聊天記錄?",
  [2]  = "確定",
  [3]  = "取消"
}

--[[ Default chat names to be displayed ]]
L['chatnames']  = {
  ['combat']    = "戰鬥",
  ['custom']    = "自訂頻道",
  ['general']    = "綜合頻道",
  ['guild']    = CHAT_MSG_GUILD,
  ['loot']    = CHAT_MSG_LOOT,
  ['misc']    = "雜項",
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
  ['本地防務']    = {
    ['name']  = "本地防務",
    ['string']  = "本地防務"
  },
  ['綜合']      = {
    ['name']  = "綜合",
    ['string']  = "綜合"
  },
  ['公會招募']    = {
    ['name']  = "公會招募",
    ['string']  = "公會招募"
  },
  ['交易']      = {
    ['name']  = "交易",
    ['string']  = "交易"
  },
  ['世界防務']    = {
    ['name']  = "世界防務",
    ['string']  = "世界防務"
  }
}

--[[ Custom chats special log messages ]]
L['customchat']  = {
  ['join']  = "你進入了頻道。",
  ['leave']  = "你離開了頻道。"
}
