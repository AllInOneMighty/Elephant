local L = LibStub("AceLocale-3.0"):NewLocale("Elephant", "frFR")
if not L then return end

--[[ Common messages ]]
L['STRING_OPTIONS_FILE_LOGGING_CHAT'] = "Enreg. le chat"
L['STRING_OPTIONS_FILE_LOGGING_CHAT_DESC_1'] = "Enregistre le chat (pas le journal de combat) vers Logs\\WoWChatLog.txt."
L['STRING_OPTIONS_FILE_LOGGING_CHAT_DESC_2'] = "Si cette option est activée, l'enregistrement vers le fichier sera automatiquement rétabli à l'entrée en jeu."
L['STRING_OPTIONS_FILE_LOGGING_COMBAT'] = "Enreg. le journal de combat"
L['STRING_OPTIONS_FILE_LOGGING_COMBAT_DESC_1'] = "Enregistre le journal de combat vers Logs\\WoWCombatLog.txt."
L['STRING_OPTIONS_FILE_LOGGING_COMBAT_DESC_2'] = "Si cette option est activée, l'enregistrement vers le fichier sera automatiquement rétabli à l'entrée en jeu."
L['STRING_DISABLED'] = "Désactivé"
L['STRING_ENABLED'] = "Activé"
L['STRING_OPTIONS_LOG_NEW_CHANNELS'] = "Logger nouv. chats"
L['STRING_OPTIONS_LOG_NEW_CHANNELS_DESC'] = "Débute automatiquelent le log quand vous rejoignez un nouveau canal de discussion."
L['STRING_INFORM_CHAT_PRAT_WITHOUT_PRAT'] = "Vous avez choisi d'utiliser le formatage de Prat pour les logs mais Prat n'est pas chargé. Les messages seront enregistrés au format d'Elephant."
L['STRING_RESET'] = "Réinitialisation"
L['STRING_OPTIONS_RESET_TAB_DESC'] = "Options de réinitialisation."
L['STRING_OPTIONS_RESET_TAB_HEADER_1'] = "Pour réinitialiser la fenêtre principale, cliquez sur le bouton Position ci-dessous."
L['STRING_OPTIONS_RESET_TAB_HEADER_2'] = "Pour réinitialiser la configuration et les canaux de discussion, cliquez sur le bouton Configuration ci-dessous. Cela: supprimera les logs de tous les canaux que vous n'avez pas rejoint, videra tous les autres, désactivera l'enregistrement des discussions et du combat dans un fichier, désactivera l'intégration avec Prat, désactivera le bouton d'Elephant, réinitialisera la position de la fenêtre principale, et enfin activera l'icône de minicarte."
L['STRING_OPTIONS_RESET_TAB_HEADER_3'] = "Attention: La réinitialisation de la configuration supprimera également les logs partagés, que l'option soit activée ou non."

L['STRING_KEYBIND_TOGGLE'] = "Afficher/Cacher Elephant"
L['STRING_KEYBIND_TOGGLE_DESC'] = "Affiche ou cache la fenêtre principale."

--[[ Options menu elements ]]
L['STRING_OPTIONS_DESC'] = "Ces options sont configurées par personage, à l'exception de la taille de log maximum qui est partagée par tous les personnages du même serveur et de la même faction."
L['STRING_OPTIONS_FILE_LOGGING_ACTIVATE'] = "Activer"
L['STRING_OPTIONS_FILE_LOGGING_ACTIVATE_DESC_1'] = "Autorise Elephant à contrôler l'enregistrement vers des fichiers. En désactivant cette option, vous laisserez le statut d'enregistrement actuel intact."
L['STRING_OPTIONS_FILE_LOGGING_ACTIVATE_DESC_2'] = "Attention: vous ne devriez pas laisser deux addons différents contrôler l'enregistrement vers des fichiers."
L['STRING_OPTIONS_FILE_LOGGING_LIMITATIONS'] = "En raison des limitations de l'interface, il n'est pas possible de filter ce qui est envoyé aux fichiers de log. Lorsque vous activez une de ces options, tous les messages du type choisi (i.e. chat ou journal de combat) seront sauvegardés, ignorant vos filtres actuels."
L['STRING_OPTIONS_CLEAR_LOGS'] = "Vider tous les logs"
L['STRING_OPTIONS_CLEAR_LOGS_DESC'] = "Supprimer tous les logs enregistrés."
L['STRING_OPTIONS_FILE_LOGGING_GROUP'] = "Enregistrement vers fichier"
L['STRING_OPTIONS_FILE_LOGGING_GROUP_DESC'] = "Options pour enregistrer les logs vers des fichiers."
L['STRING_FILTERS'] = FILTERS
L['STRING_OPTIONS_FILTERS_TAB_DESC'] = "Les filtres sont utilisés pour éviter l'enregistrement de canaux spécifiques."
L['STRING_OPTIONS_FILTERS_TAB_HEADER_1'] = "Vous pouvez utilisez les filtres pour éviter d'enregistrer certains canaux de discussion personnalisés que vous ou l'un de vos addons rejoint."
L['STRING_OPTIONS_FILTERS_TAB_HEADER_2'] = "Par exemple, si l'un de vos addons rejoint de nombreaux canaux nommés 'AddonComm1', AddonComm2', ... ce peut être une bonne idée de rajouter le filtre '|c%sAddonComm*|r' pour qu'Elephant les ignore automatiquement."
L['STRING_OPTIONS_FILTERS_TAB_HEADER_3'] = "Il est possible d'ignorer tous les canaux personnalisés que vous rejoignez en ajoutant le filtre '|c%s*|r'. Attention néanmoins, car lorsqu'un nouveau filtre est créé, les logs de tous les canaux dont le nom correspond au filtre sont immédiatement supprimés."
L['STRING_OPTIONS_FILTERS_TAB_HEADER_4'] = "Enfin, vous pouvez obtenir la liste de tous les filtres actifs en passant la souris au-dessus de l'icône d'Elephant si elle est affichée."
L['STRING_NEW'] = "Nouveau"
L['STRING_OPTIONS_FILTER_NEW_DESC_2'] = "Nom exact du canal. Vous pouvez aussi utiliser des jokers (*). Ex: <AceComm*>"
L['STRING_INFORM_CHAT_FILTER_INVALID'] = "Filtre erroné: '%s'. Les filtres ne peuvent contenir que des lettres et des jokers (*)."
L['STRING_FILTER_VALIDATION_REGEXP'] = "^[%a%*]+$"
L['STRING_INFORM_CHAT_FILTER_NOT_FOUND'] = "Filtre introuvable"
L['STRING_INFORM_CHAT_FILTER_ADDED'] = "Filtre '%s' ajout?."
L['STRING_INFORM_CHAT_FILTER_DELETED'] = "Filtre '%s' supprim? avec succ?s."
L['STRING_OPTIONS_FILTER_NEW_DESC_1'] = "Créer un nouveau filtre."
L['STRING_OPTIONS_FILTER_DELETE_DESC'] = "Supprime un filtre précédemment créé."
L['STRING_OPTIONS_LOGS_TAB'] = "Logs"
L['STRING_OPTIONS_LOGS_TAB_DESC'] = "Options des logs."
L['STRING_OPTIONS_MAX_LOG_LINES'] = "Taille de log max (lignes)"
L['STRING_OPTIONS_MAX_LOG_LINES_DESC_1'] = "Taille maximale de chaque log en nombre de lignes. Une ligne peut contenir n'importe quel nombre de caractères."
L['STRING_OPTIONS_MAX_LOG_LINES_DESC_2'] = "Cette option est partagée avec tous les personages de ce serveur et cette faction."
L['STRING_OPTIONS_MAX_LOG_LINES_DESC_3'] = "Attention: Toute valeur supérieure à 1000 entraînera une consommation de mémoire importante."
L['STRING_OPTIONS_PRAT_FORMATTING'] = "Formatage de Prat"
L['STRING_OPTIONS_PRAT_INTEGRATION_GROUP'] = "Intégration avec Prat"
L['STRING_OPTIONS_PRAT_FORMATTING_DESC_1'] = "Enregistre les logs de la même façon que Prat. Les logs enregistrés de cette façon ne peuvent pas être rétablis vers le style d'Elephant."
L['STRING_OPTIONS_PRAT_FORMATTING_DESC_2'] = "Note: tous les messages ne sont pas gérés par Prat, certains garderont le style d'Elephant."
L['STRING_OPTIONS_PRAT_FORMATTING_DESC_3'] = "Cette option ne fonctionnera que si vous avez Prat d'activé."
L['STRING_SETTINGS'] = "Configuration"
L['STRING_OPTIONS_RESET_SETTINGS_DESC'] = "Réinitialise la configuration et les canaux de discussion."
L['STRING_POSITION'] = "Position"
L['STRING_OPTIONS_RESET_POSITION_DESC'] = "Réinitialise la position de la fenêtre principale et du bouton d'Elephant."
L['STRING_OPTIONS_SHOW_CHAT_BUTTON'] = "Afficher boutton"
L['STRING_OPTIONS_SHOW_CHAT_BUTTON_DESC'] = "Affiche un bouton au-dessus des boutons par défaut de la fenêtre de discussion, qui permet de basculer l'affichage d'Elephant."
L['STRING_OPTIONS_USE_CLASS_COLORS'] = "Couleurs de classe"
L['STRING_OPTIONS_USE_CLASS_COLORS_DESC_1'] = "Affiche la couleur de classe des joueurs dans les logs."
L['STRING_OPTIONS_USE_CLASS_COLORS_DESC_2'] = "Cela s'applique également aux messages non gérés par Prat lorsque l'option Formatage de Prat est cochée."
L['STRING_OPTIONS_SHARE_LOGS_WITH_ALTS'] = "Partager les logs"
L['STRING_OPTIONS_SHARE_LOGS_WITH_ALTS_DESC_1'] = "Partages les logs vus par ce personnage avec tous les autres personnages de ce serveur et cette faction où cette option est activée."
L['STRING_OPTIONS_SHARE_LOGS_WITH_ALTS_DESC_2'] = "Activer cette option échangera les logs de ce personnage avec les logs partagés. Désactiver cette option rétablira les logs de ce personnage seulement, mais ne copiera pas les logs partagés."

--[[ Main/Copy frame elements ]]
-- Main
L['STRING_MAIN_WINDOW_MESSAGE_CATCHERS_BUTTON'] = "Messages à enregistrer"
L['STRING_MAIN_WINDOW_MESSAGE_CATCHERS_BUTTON_DESC_1'] = "Que faut-il sauver dans ce log?"
L['STRING_MAIN_WINDOW_MESSAGE_CATCHERS_BUTTON_DESC_2'] = "Les types de messages en gris ne peuvent être désactivés."
L['STRING_COPY'] = "Copier"
L['STRING_MAIN_WINDOW_COPY_BUTTON_DESC_1'] = "Vous permet de copier %s caractères du log, en terminant par la dernière ligne affichée ci-dessus."
L['STRING_MAIN_WINDOW_COPY_BUTTON_DESC_2'] = "Les messages envoyés par Battle.net sont automatiquement enlevés pour protéger votre vie privée."
L['STRING_DISABLE'] = DISABLE
L['STRING_EMPTY'] = "Vider"
local empty_info = "Ceci videra le log courant."
L['STRING_MAIN_WINDOW_EMPTY_BUTTON_DESC_1'] = empty_info
local empty_warn = "Si vous partagez les logs, cela videra ce log de tous les autres personnages qui le partagent."
L['STRING_MAIN_WINDOW_EMPTY_BUTTON_DESC_2'] = empty_warn
L['STRING_ENABLE'] = ENABLE
L['STRING_MAIN_WINDOW_MAX_LOG'] = "Log max: %s lignes."
L['STRING_MAIN_WINDOW_TITLE_TOOLTIP'] = "Déplacer la fenêtre"
L['STRING_MAIN_WINDOW_TITLE_TOOLTIP_DESC_1'] = "Clic central pour réinitialiser la position d'Elephant."
L['STRING_MAIN_WINDOW_TITLE_TOOLTIP_DESC_2'] = "Fonctionne aussi sur la fenêtre principale."
L['STRING_MAIN_WINDOW_CHAT_BUTTONS_LINES'] = "Lignes: %s"
L['STRING_MAIN_WINDOW_SCROLL_BOTTOM_BUTTON_TOOLTIP'] = "Atteindre le bas"
L['STRING_MAIN_WINDOW_SCROLL_ONE_LINE_DOWN_BUTTON_TOOLTIP'] = "Descendre d'une ligne"
L['STRING_MAIN_WINDOW_SCROLL_ONE_LINE_UP_BUTTON_TOOLTIP'] = "Monter d'une ligne"
L['STRING_MAIN_WINDOW_SCROLL_ONE_PAGE_DOWN_BUTTON_TOOLTIP'] = "Descendre d'une page"
L['STRING_MAIN_WINDOW_SCROLL_ONE_PAGE_UP_BUTTON_TOOLTIP'] = "Monter d'une page"
L['STRING_MAIN_WINDOW_SCROLL_TOP_BUTTON_TOOLTIP'] = "Atteindre le haut"
L['STRING_MAIN_WINDOW_CUSTOM_CHATS_BUTTON_DESC'] = "Les canaux non cochés sont ceux que vous avez quittés."

-- Copy
L['STRING_COPY_WINDOW_BB_TEXT_BUTTON'] = "BB/Texte"
L['STRING_COPY_WINDOW_BB_TEXT_BUTTON_DESC_1'] = "Change l'affichage entre le texte et le BBCode (quand vous voulez coller les logs sur un forum par exemple)."
L['STRING_COPY_WINDOW_BB_TEXT_BUTTON_DESC_2'] = "Le BBCode étant plus verbeux, moins de lignes peuvent être affichées dans ce mode."
L['STRING_COPY_WINDOW'] = "Fenêtre de copie"
L['STRING_COPY_WINDOW_MAX_CHARACTERS'] = "Caractères max: %s"
L['STRING_COPY_WINDOW_PLAIN_TEXT'] = "Texte"
L['STRING_COPY_WINDOW_BB_CODE'] = "BBCode"
L['STRING_COPY_WINDOW_SHOW_TIMESTAMPS_CHECKBOX'] = "Montrer les heures"
L['URL_ITEM_LINK'] = "http://fr.wowhead.com/?item="
L['STRING_OPTIONS_MAX_COPY_CHARACTERS'] = "Max. caractères de copie"
L['STRING_OPTIONS_MAX_COPY_CHARACTERS_DESC_1'] = "Nombre maximum de caractères (et pas de lignes) affichés dans la fenêtre de copie."
L['STRING_OPTIONS_MAX_COPY_CHARACTERS_DESC_2'] = "Attention: Plus cette valeur est grande et plus la fenêtre de copie prendra de temps pour s'afficher. Votre jeu se bloquera temporairement pendant que la fenêtre se remplit. Toute valeur supérieure à 15000 rendra le temps de chargement perceptible."

--[[ Special log messages ]]
L['STRING_SPECIAL_LOG_LOGGING_STARTED_ON'] = "Log commencé pour %s le %s à %s."
L['STRING_SPECIAL_LOG_LOGGING_STOPPED'] = "Log arrêté."
L['STRING_SPECIAL_LOG_MONSTER_SAYS'] = "%s says"
L['STRING_SPECIAL_LOG_MONSTER_YELLS'] = "%s crie"
L['STRING_SPECIAL_LOG_WHISPER_FROM'] = "%s chuchote"
L['STRING_SPECIAL_LOG_WHISPER_TO'] = "A %s"

--[[ Addon messages ]]
L['STRING_INFORM_CHAT_CLEAR_LOGS_SUCCESS'] = "Tous les logs ont été vidé"
L['STRING_INFORM_CHAT_FUNCTION_IS_DISABLED'] = "Cette fonction est désactivée"
L['STRING_INFORM_CHAT_LOG_DELETED'] = "Chat supprimé: %s"
L['STRING_INFORM_CHAT_LOG_EMPTIED'] = "Chat vidé: %s"
L['STRING_LOOT_METHOD_freeforall'] = ERR_SET_LOOT_FREEFORALL
L['STRING_LOOT_METHOD_group'] = ERR_SET_LOOT_GROUP
L['STRING_LOOT_METHOD_master'] = ERR_SET_LOOT_MASTER
L['STRING_LOOT_METHOD_needbeforegreed'] = ERR_SET_LOOT_NBG
L['STRING_LOOT_METHOD_roundrobin'] = ERR_SET_LOOT_ROUNDROBIN
L['STRING_INFORM_CHAT_LOOT_MASTER_LOOTER_CHANGED'] =  ERR_NEW_LOOT_MASTER_S
L['STRING_INFORM_CHAT_LOOT_MASTER_LOOTER_UNKNOWN'] = "Impossible de déterminer le nom du maître du butin"
L['STRING_INFORM_CHAT_RESET_SETTINGS_SUCCESS'] = "Paramètres et chats réinitialisés"

--[[ Tooltips ]]
L['STRING_CHAT_BUTTON_TOOLTIP'] = "Clic gauche pour afficher/cacher Elephant"
L['STRING_CHAT_BUTTON_TOOLTIP_DESC_1'] = "Clic central pour réinit. le bouton."
L['STRING_CHAT_BUTTON_TOOLTIP_DESC_2'] = "Clic droit pour bouger le bouton."
L['STRING_MINIMAP_TOOLTIP_ACTIVE_FILTERS'] = "Filtres actifs"
L['STRING_MINIMAP_TOOLTIP_HINT_TOGGLE'] = "|c%sClic|r pour ouvrir/fermer Elephant"
L['STRING_MINIMAP_TOOLTIP_HINT_SETTINGS'] = "|c%sClic-Droit|r pour ouvrir la fen?tre des options"

--[[ Popup windows ]]
L['STRING_OK'] = "OK"
L['STRING_CANCEL'] = CANCEL
L['STRING_POPUP_CLEAR_LOGS'] = "Ceci va vider tous les logs."
L['STRING_POPUP_EMPTY_LOG'] = empty_info .. "\n\n" .. empty_warn
L['STRING_POPUP_RESET_SETTINGS'] = "Ceci réinitialisera tous les paramêtres et chats.\n\nCELA AUSSI SUPPRIME TOUS LES LOGS PARTAGÉS."

--[[ Minimap icon ]]
L['STRING_OPTIONS_MINIMAP_ICON'] = "Icône de minicarte"
L['STRING_OPTIONS_MINIMAP_ICON_DESC'] = "Affiche une icône sur la minicarte"

--[[ Default chat names to be displayed ]]
L['STRING_CHAT_NAME_COMBAT'] = "Combat"
L['STRING_CHAT_NAME_CUSTOM'] = "Chats personnalisés"
L['STRING_CHAT_NAME_GENERAL'] = "Chats généraux"
L['STRING_CHAT_NAME_GUILD'] = CHAT_MSG_GUILD
L['STRING_CHAT_NAME_LOOT'] = CHAT_MSG_LOOT
L['STRING_CHAT_NAME_MISC'] = "Divers"
L['STRING_CHAT_NAME_OFFICER'] = CHAT_MSG_OFFICER
L['STRING_CHAT_NAME_PARTY'] = CHAT_MSG_PARTY
L['STRING_CHAT_NAME_RAID'] = CHAT_MSG_RAID
L['STRING_CHAT_NAME_SAY'] = CHAT_MSG_SAY
L['STRING_CHAT_NAME_SYSTEM'] = SYSTEM_MESSAGES
L['STRING_CHAT_NAME_WHISPER'] = WHISPER
L['STRING_CHAT_NAME_YELL'] = YELL_MESSAGE
L['STRING_CHAT_NAME_ACHIEVEMENT'] = ACHIEVEMENTS
L['STRING_CHAT_NAME_INSTANCE'] = INSTANCE

--[[ General chats (= that you cannot leave) names and strings that identify them ]]
L['STRING_GENERAL_CHAT_CHANNEL_NAME_LOCAL_DEFENSE'] = "DéfenseLocale"
L['STRING_GENERAL_CHAT_CHANNEL_NAME_LOCAL_DEFENSE_ID'] = "défenselocale"
L['STRING_GENERAL_CHAT_CHANNEL_NAME_LOOKING_FOR_GROUP'] = "Recherche de groupe"
L['STRING_GENERAL_CHAT_CHANNEL_NAME_LOOKING_FOR_GROUP_ID'] = "recherchedegroupe"
L['STRING_GENERAL_CHAT_CHANNEL_NAME_GENERAL'] = "Général"
L['STRING_GENERAL_CHAT_CHANNEL_NAME_GENERAL_ID'] = "général"
L['STRING_GENERAL_CHAT_CHANNEL_NAME_GUILD_RECRUITMENT'] = "RecrutementDeGuilde"
L['STRING_GENERAL_CHAT_CHANNEL_NAME_GUILD_RECRUITMENT_ID'] = "recrutementdeguilde"
L['STRING_GENERAL_CHAT_CHANNEL_NAME_TRADE'] = "Commerce"
L['STRING_GENERAL_CHAT_CHANNEL_NAME_TRADE_ID'] = "commerce"
L['STRING_GENERAL_CHAT_CHANNEL_NAME_WORLD_DEFENSE'] = "DéfenseUniverselle"
L['STRING_GENERAL_CHAT_CHANNEL_NAME_WORLD_DEFENSE_ID'] = "défenseuniverselle"

--[[ Custom chats special log messages ]]
L['STRING_SPECIAL_LOG_JOINED_CHANNEL'] = "Vous rejoignez un canal."
L['STRING_SPECIAL_LOG_LEFT_CHANNEL'] = "Vous quittez un canal."
