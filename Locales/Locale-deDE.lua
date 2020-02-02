local L = LibStub("AceLocale-3.0"):NewLocale("Elephant", "deDE")
if not L then return end

--[[
Umlautersetzung: Unicode for Gemrman Umlauts
ä->\195\164; ö->\195\182; ü->\195\188; ß->\195\159
]]

--[[ Common messages ]]
L['chatlog']        = "Chat in Datei speichern"
L['combatlog']      = "Kampflog in Datei speichern"
L['disabled']      = "Ausgeschaltet"
L['enabled']        = "Eingeschaltet"
L['enableddefault']    = "Logge neue Channels."
L['reset']        = "Zur\195\188cksetzen"
L['toggle']        = "Elephant \195\182ffnen/schlie\195\159en"

--[[ Options menu elements ]]
L['clearallhelp']    = "L\195\182scht alle Logs"
L['Filters']        = FILTERS
L['filterregex']      = "^[%a%*]+$"
L['logs']        = "Logs"
L['logs_desc']      = "Logging options."
L['maxlogwords']      = "Maximale Logl\195\164nge"
L['resethelp']      = "Setzt alle Einstellungen und Chats zur\195\188ck"
L['resethelp_desc']    = "Resets all settings and chats."
L['resetloc']      = "Positionen der Fenster zur\195\188cksetzen"
L['showbutton']      = "Zeige Schalter"

--[[ Main/Copy frame elements ]]
-- Main
L['clearall']    = "Alle Leeren"
L['copy']      = "Kopieren"
L['Disable']      = DISABLE
L['Empty']      = EMPTY
L['Enable']      = ENABLE
L['maxlog']      = "Maximal %s Zeilen."
L['nblines']      = "Zeilen: %s"
L['scroll']      = {
  ['bottom']    = {
    [1]  = "Zum Ende scrollen"
  },
  ['linedown']  = {
    [1]  = "Eine Zeile runter scrollen"
  },
  ['lineup']    = {
    [1]  = "Eine Zeile hoch scrollen"
  },
  ['pagedown']  = {
    [1]  = "Eine Seite runter scrollen"
  },
  ['pageup']    = {
    [1]  = "Eine Seite hoch scrollen"
  },
  ['top']      = {
    [1]  = "Zum Anfang scrollen"
  }
}

-- Copy
L['bbAndText']    = "BB/Text"
L['bbAndTextInfo'] = {
  [1] = "Switches between showing plain text and BBCode (e.g. when you want to paste the logs on a forum).",
  [2] = "Due to UI length limitations, only %s lines of BBCode can be shown."
}
L['copywindow']  = "Chat Kopieren"
L['copywindowloglength']    = "Log length: %s lines"
L['copywindowplaintext']    = "Plain text"
L['copywindowbbcode']    = "BBCode"
L['itemLinkSite'] = "http://de.wowhead.com/?item="

--[[ Special log messages ]]
L['logstartedon']  = "Log gestartet am %s up %s."
L['logstopped']    = "Log gestoppt."
L['monstersay']    = "%s sagt"
L['monsteryell']    = "%s schreit"
L['whisperfrom']    = "%s fl\195\188stert"
L['whisperto']    = "Zu %s"

--[[ Addon messages ]]
L['clearallconfirm']    = "Logs geleert."
L['combatlogdisabled']  = "Diese Funktion ist deaktiviert."
L['deleteconfirm']    = "Chat gel\195\182scht: %s"
L['emptyconfirm']    = "Log geleert: %s"
L['lootmethod']      = {
  ['freeforall']    = ERR_SET_LOOT_FREEFORALL,
  ['group']      = ERR_SET_LOOT_GROUP,
  ['master']      = ERR_SET_LOOT_MASTER,
  ['needbeforegreed']  = ERR_SET_LOOT_NBG,
  ['roundrobin']    = ERR_SET_LOOT_ROUNDROBIN
}
L['masterlooterchanged']  =  ERR_NEW_LOOT_MASTER_S
L['resetconfirm']    = "Alle Einstellungen und Chats zur\195\188ckgesetzt."

--[[ Tooltips ]]
L['togglebuttontooltip']    = {
  [1]  = "Linksklicken um Elephant ein-/auszuschalten.",
  [2]  = "Mittelklicken um die Schalterposition zur\195\188ck zu setzten.",
  [3]  = "Rechtsklicken um den Schalter zu bewegen."
}
L['toggletooltip']      = "Linksklick, um Elephant anzuzeigen/zu verstecken."

--[[ Popup windows ]]
L['clearallpopup']  = {
  [1]  = "Dies l\195\182scht alle Logs.",
  [2]  = "Ok",
  [3]  = "Abbruch"
}
L['emptypopup']    = {
  [1]  = "Dies leert das aktuelle Log.",
  [2]  = "Ok",
  [3]  = "Abbruch"
}
L['resetpopup']    = {
  [1]  = "Dies setzt alle Einstellungen und Chats zur\195\188ck.",
  [2]  = "Ok",
  [3]  = "Abbruch"
}

--[[ Default chat names to be displayed ]]
L['chatnames']  = {
  ['combat']  = "Kampf",
  ['custom']  = "Eigene Chats",
  ['general']  = "Allgemeine Chats",
  ['guild']  = CHAT_MSG_GUILD,
  ['loot']  = CHAT_MSG_LOOT,
  ['misc']  = "Misc.",
  ['officer']  = CHAT_MSG_OFFICER,
  ['party']  = CHAT_MSG_PARTY,
  ['raid']  = CHAT_MSG_RAID,
  ['say']    = CHAT_MSG_SAY,
  ['system']  = SYSTEM_MESSAGES,
  ['whisper']  = WHISPER,
  ['yell']  = YELL_MESSAGE,
  ['achievement'] = ACHIEVEMENTS,
  ['instance'] = INSTANCE
}

--[[ General chats (= that you cannot leave) names and strings that identify them ]]
L['generalchats']  = {
  ['allgemein']      = {
    ['name']  = "Allgemein",
    ['string']  = "allgemein"
  },
  ['gildenrekrutierung']  = {
    ['name']  = "Gildenrekrutierung",
    ['string']  = "gildenrekrutierung"
  },
  ['handel']        = {
    ['name']  = "Handel",
    ['string']  = "handel"
  },
  ['lokaleverteidigung']  = {
    ['name']  = "LokaleVerteidigung",
    ['string']  = "lokaleverteidigung"
  },
  ['weltverteidigung']  = {
    ['name']  = "WeltVerteidigung",
    ['string']  = "weltverteidigung"
  }
}

--[[ Custom chats special log messages ]]
L['customchat']  = {
  ['join']  = "Channel beigetreten.",
  ['leave']  = "Channel verlassen."
}
