local L = LibStub("AceLocale-3.0"):NewLocale("Elephant", "enUS", true)
-- No check on the validity of L here. We badly need this locale.

--[[ Common messages ]]
L['chatlog']        = "Log normal chat"
L['chatlog2_desc']    = "Logs the chat (not the combat log) to Logs\\WoWChatLog.txt."
L['chatlog2_desc2']    = "If this option is activated, the file logging will automatically be enabled back at login."
L['combatlog']      = "Log combat chat"
L['combatlog2_desc']    = "Logs the combat chat to Logs\\WoWCombatLog.txt."
L['combatlog2_desc2']    = "If this option is activated, the file logging will automatically be enabled back at login."
L['disabled']      = "Disabled"
L['enabled']        = "Enabled"
L['enableddefault']    = "Log new channels"
L['enableddefault_desc']  = "Automaticaly starts logging when you join a new channel."
L['noprat']        = "You choose to use Prat's formatting for logs but Prat is not loaded. Messages will be logged with Elephant's formatting."
L['reset']        = "Reset"
L['reset_desc']      = "Reset options."
L['reset_header']    = {
  [1]      = "To reset the main window and the button positions, click on the Position button below.",
  [2]      = "To reset all settings and chats, click on the Settings button. This will: delete any log of a channel you have not joined, clear all other logs, disable WoW file logging for chat and combat, disable Prat integration, disable the chat button, reset the position of the main window and finally enable the minimap icon."
}
L['toggle']        = "Toggle"
L['toggle_desc']      = "Shows or hides the main window."

--[[ Options menu elements ]]
L['activate']      = "Activate"
L['activate_desc2']    = "Let Elephant control file logging. Disabling this option will leave the current logging status unchanged."
L['activate_desc22']    = "Warning: You shouldn't let two different addons control file logging."
L['chatlog_limitation']    = "Due to limitations of the Blizzard interface, it is not possible to filter what will be sent to the log files. When you activate one of these options, all messages of the selected type (i.e. chat or combat) will be saved, regardless of your current filters."
L['clearallhelp']    = "Clear"
L['clearallhelp_desc']  = "Clears all saved logs."
L['files']        = "File logging"
L['files_desc']      = "Options to save the logs into files."
L['Filters']      = FILTERS
L['Filters_desc']    = "Filters are used to avoid the logging of specific channels."
L['filters_header']    = {
  [1]      = "You can use filters to avoid logging custom channels that you or other addons join.",
  [2]      = "Typically, if one of your addons joins a lot of channels such as 'AddonComm1', AddonComm2', ... it is a good idea to add the '|c%sAddonComm*|r' filter so that Elephant ignores them automatically.",
  [3]      = "It is possible to ignore all custom channels joined by adding the '|c%s*|r' filter. Be careful, though, because when creating a new filter, logs of all channels that match it are immediately deleted.",
  [4]      = "Finally, you can see a list of all active filters by hovering the icon of Elephant if it is displayed."
}
L['filternew']      = NEW
L['filterusage']    = "Exact channel name. You can also use wildcards (*). Ex: <AceComm*>"
L['filtererror']    = "Cannot add filter '%s'. Filter must contain only letters and wildcards (*)."
L['filterregex']    = "^[%a%*]+$"
L['filternotfound']    = "Filter not found."
L['filteradded']    = "Added filter '%s'"
L['filterdeleted']    = "Filter '%s' successfuly deleted."
L['newfilter_desc']    = "Creates a new filter."
L['deletefilter_desc']  = "Deletes a previously created filter."
L['logs']        = "Logs"
L['logs_desc']      = "Logging options."
L['maxlogwords']      = "Max log lines"
L['maxlogwords_desc']  = "Maximum size of each log in lines. A line may contain any amount of characters."
L['maxlogwords_desc_warning'] = "Warning: Any value over 1000 will dramatically increase the memory usage."
L['prat']        = "Prat formatting"
L['prat_integration']    = "Prat integration"
L['prat2_desc']      = "Saves the logs the same way than Prat. Logs saved with this option enabled cannot be brought back to Elephant's formatting."
L['prat2_desc2']    = "Note: all messages are not handled by Prat, some of them will still use Elephant's formatting."
L['prat2_desc22']    = "This option will only work if you have Prat currently enabled."
L['resethelp']      = "Settings"
L['resethelp_desc']    = "Resets all settings and chats."
L['resetloc']      = "Position"
L['resetloc_desc2']    = "Resets Elephant main window and button positions."
L['showbutton']      = "Show chat button"
L['showbutton_desc']    = "Displays a button above the normal chat buttons to toggle Elephant."
L['classcolors']    = "Use class colors"
L['classcolors_desc']    = "Displays players class color in the logs."
L['classcolors_desc2']    = "This also applies to messages not handled by Prat when using Prat formatting."

--[[ Main/Copy frame elements ]]
-- Main
L['catchers']  = {
  [1]  = "Message catchers",
  [2]  = "What should be saved in this log?",
  [3]  = "Message types in grey cannot be disabled."
}
L['clearall']  = "Clear all"
L['copy']  = "Copy"
L['copyinfo']  = "Lets you copy %s characters of log, ending with the last line displayed in the window above."
L['copywarn']  = "Messages sent over Battle.net are automatically removed to protect your privacy."
L['Disable']    = DISABLE
L['Empty']    = EMPTY
L['Enable']    = ENABLE
L['maxlog']    = "Max log: %s lines."
L['move2']    = {
  [1]  = "Move window",
  [2]  = "Middle-Click to reset Elephant position.",
  [3]  = "Also works on main window."
}
L['nblines']    = "Lines: %s"
L['scroll']    = {
  ['bottom']    = {
    [1]  = "Scroll to bottom",
  },
  ['linedown']  = {
    [1]  = "Scroll one line down",
  },
  ['lineup']    = {
    [1]  = "Scroll one line up",
  },
  ['pagedown']  = {
    [1]  = "Scroll one page down",
  },
  ['pageup']    = {
    [1]  = "Scroll one page up",
  },
  ['top']      = {
    [1]  = "Scroll to top",
  },
}
L['customchatsinfo']  = "Channels not checked are channels you left."

-- Copy
L['bbAndText']    = "BB/Text"
L['bbAndTextInfo'] = {
  [1] = "Switches between showing plain text and BBCode (e.g. when you want to paste the logs on a forum).",
  [2] = "Due to BBCode being more verbose, less lines can actually be shown in that mode."
}
L['copywindow']    = "Copy window"
L['copywindowloglength']    = "Max characters: %s"
L['copywindowplaintext']    = "Plain text"
L['copywindowbbcode']    = "BBCode"
L['showtimestamps']  = "Show timestamps"
L['itemLinkSite']  = "http://www.wowhead.com/?item="
L['maxcopycharacters'] = "Max copy characters"
L['maxcopycharacters_desc'] = "Maximum number of characters (not lines) to show in the copy window."
L['maxcopycharacters_desc_warning'] = "Warning: The higher this value, the longer the copy window will take to load. Your game will freeze until the window is filled. Any value over 15000 will make the loading time noticeable."

--[[ Special log messages ]]
L['logstartedon']  = "Logging started on %s at %s."
L['logstopped']    = "Logging stopped."
L['monstersay']    = "%s says"
L['monsteryell']    = "%s yells"
L['whisperfrom']    = "%s whispers"
L['whisperto']    = "To %s"

--[[ Addon messages ]]
L['clearallconfirm']    = "All chats cleared."
L['combatlogdisabled']  = "This function is disabled."
L['deleteconfirm']    = "Chat deleted: %s"
L['emptyconfirm']    = "Chat cleared: %s"
L['lootmethod']      = {
  ['freeforall']    = ERR_SET_LOOT_FREEFORALL,
  ['group']      = ERR_SET_LOOT_GROUP,
  ['master']      = ERR_SET_LOOT_MASTER,
  ['needbeforegreed']  = ERR_SET_LOOT_NBG,
  ['roundrobin']    = ERR_SET_LOOT_ROUNDROBIN,
}
L['masterlooterchanged']  =  ERR_NEW_LOOT_MASTER_S
L['masterlooternameunknown']  = "Couldn't determine name of master looter"
L['resetconfirm']    = "Reseted all settings and chats."

--[[ Tooltips ]]
L['togglebuttontooltip']    = {
  [1]  = "Left-Click to toggle Elephant",
  [2]  = "Middle-Click to reset button position.",
  [3]  = "Right-Click to move button.",
}
L['activefilters'] = "Active filters"
L['toggletooltiphint1'] = "|c%sClick|r to toggle Elephant"
L['toggletooltiphint2'] = "|c%sRight-Click|r to open the option window"

--[[ Popup windows ]]
L['clearallpopup']  = {
  [1]  = "This will clear all logs.",
  [2]  = "Ok",
  [3]  = "Cancel",
}
L['emptypopup']    = {
  [1]  = "This will clear the current log.",
  [2]  = "Ok",
  [3]  = "Cancel",
}
L['resetpopup']    = {
  [1]  = "This will reset all settings and chats.",
  [2]  = "Ok",
  [3]  = "Cancel",
}

--[[ Minimap icon ]]
L['minimapicon']  = "Minimap icon"
L['minimapicon_desc']  = "Shows an icon on the minimap"

--[[ Default chat names to be displayed ]]
L['chatnames']  = {
  ['combat']    = "Combat",
  ['custom']    = "Custom chats",
  ['general']    = "General chats",
  ['guild']    = CHAT_MSG_GUILD,
  ['loot']    = CHAT_MSG_LOOT,
  ['misc']    = "Misc.",
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
  ['localdefense']    = {
    ['name']  = "Local defense",
    ['string']  = "localdefense",
  },
  ['lookingforgroup']    = {
    ['name']  = "Looking for group",
    ['string']  = "lookingforgroup",
  },
  ['general']        = {
    ['name']  = "General",
    ['string']  = "general",
  },
  ['guildrecruitment']  = {
    ['name']  = "Guild recruitment",
    ['string']  = "guildrecruitment",
  },
  ['trade']        = {
    ['name']  = "Trade",
    ['string']  = "trade",
  },
  ['worlddefense']    = {
    ['name']  = "World defense",
    ['string']  = "worlddefense",
  },
}

--[[ Custom chats special log messages ]]
L['customchat']  = {
  ['join']  = "You joined channel.",
  ['leave']  = "You left channel.",
}
