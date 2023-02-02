local L = LibStub("AceLocale-3.0"):NewLocale("Elephant", "frFR")
if not L then return end

--[[ Common messages ]]
L['chatlog']        = "Enreg. le chat"
L['chatlog2_desc']    = "Enregistre le chat (pas le journal de combat) vers Logs\\WoWChatLog.txt."
L['chatlog2_desc2']    = "Si cette option est activée, l'enregistrement vers le fichier sera automatiquement rétabli à l'entrée en jeu."
L['combatlog']      = "Enreg. le journal de combat"
L['combatlog2_desc']    = "Enregistre le journal de combat vers Logs\\WoWCombatLog.txt."
L['combatlog2_desc2']    = "Si cette option est activée, l'enregistrement vers le fichier sera automatiquement rétabli à l'entrée en jeu."
L['disabled']      = "Désactivé"
L['enabled']        = "Activé"
L['enableddefault']    = "Logger nouv. chats"
L['enableddefault_desc']  = "Débute automatiquelent le log quand vous rejoignez un nouveau canal de discussion."
L['noprat']        = "Vous avez choisi d'utiliser le formatage de Prat pour les logs mais Prat n'est pas chargé. Les messages seront enregistrés au format d'Elephant."
L['reset']        = "Réinitialisation"
L['reset_desc']      = "Options de réinitialisation."
L['reset_header']    = {
  [1]      = "Pour réinitialiser la fenêtre principale, cliquez sur le bouton Position ci-dessous.",
  [2]      = "Pour réinitialiser la configuration et les canaux de discussion, cliquez sur le bouton Configuration ci-dessous. Cela: supprimera les logs de tous les canaux que vous n'avez pas rejoint, videra tous les autres, désactivera l'enregistrement des discussions et du combat dans un fichier, désactivera l'intégration avec Prat, désactivera le bouton d'Elephant, réinitialisera la position de la fenêtre principale, et enfin activera l'icône de minicarte."
}
L['toggle']        = "Afficher/Cacher Elephant"
L['toggle_desc']      = "Affiche ou cache la fenêtre principale."

--[[ Options menu elements ]]
L['activate']      = "Activer"
L['activate_desc2']    = "Autorise Elephant à contrôler l'enregistrement vers des fichiers. En désactivant cette option, vous laisserez le statut d'enregistrement actuel intact."
L['activate_desc22']    = "Attention: vous ne devriez pas laisser deux addons différents contrôler l'enregistrement vers des fichiers."
L['chatlog_limitation']    = "En raison des limitations de l'interface, il n'est pas possible de filter ce qui est envoyé aux fichiers de log. Lorsque vous activez une de ces options, tous les messages du type choisi (i.e. chat ou journal de combat) seront sauvegardés, ignorant vos filtres actuels."
L['clearallhelp']    = "Vider tous les logs"
L['clearallhelp_desc']  = "Supprimer tous les logs enregistrés."
L['files']        = "Enregistrement vers fichier"
L['files_desc']      = "Options pour enregistrer les logs vers des fichiers."
L['Filters']        = FILTERS
L['Filters_desc']    = "Les filtres sont utilisés pour éviter l'enregistrement de canaux spécifiques."
L['filters_header']    = {
  [1]      = "Vous pouvez utilisez les filtres pour éviter d'enregistrer certains canaux de discussion personnalisés que vous ou l'un de vos addons rejoint.",
  [2]      = "Par exemple, si l'un de vos addons rejoint de nombreaux canaux nommés 'AddonComm1', AddonComm2', ... ce peut être une bonne idée de rajouter le filtre '|c%sAddonComm*|r' pour qu'Elephant les ignore automatiquement.",
  [3]      = "Il est possible d'ignorer tous les canaux personnalisés que vous rejoignez en ajoutant le filtre '|c%s*|r'. Attention néanmoins, car lorsqu'un nouveau filtre est créé, les logs de tous les canaux dont le nom correspond au filtre sont immédiatement supprimés.",
  [4]      = "Enfin, vous pouvez obtenir la liste de tous les filtres actifs en passant la souris au-dessus de l'icône d'Elephant si elle est affichée."
}
L['filternew']      = "Nouveau"
L['filterusage']      = "Nom exact du canal. Vous pouvez aussi utiliser des jokers (*). Ex: <AceComm*>"
L['filtererror']      = "Filtre erroné: '%s'. Les filtres ne peuvent contenir que des lettres et des jokers (*)."
L['filterregex']      = "^[%a%*]+$"
L['filternotfound']    = "Filtre introuvable"
L['filteradded']    = "Filtre '%s' ajout?."
L['filterdeleted']    = "Filtre '%s' supprim? avec succ?s."
L['newfilter_desc']    = "Créer un nouveau filtre."
L['deletefilter_desc']  = "Supprime un filtre précédemment créé."
L['logs']        = "Logs"
L['logs_desc']      = "Options des logs."
L['maxlogwords']      = "Taille de log max (lignes)"
L['maxlogwords_desc']  = "Taille maximale de chaque log en nombre de lignes. Une ligne peut contenir n'importe quel nombre de caractères."
L['maxlogwords_desc_warning'] = "Attention: Toute valeur supérieure à 1000 entraînera une consommation de mémoire importante."
L['prat']        = "Formatage de Prat"
L['prat_integration']    = "Intégration avec Prat"
L['prat2_desc']      = "Enregistre les logs de la même façon que Prat. Les logs enregistrés de cette façon ne peuvent pas être rétablis vers le style d'Elephant."
L['prat2_desc2']    = "Note: tous les messages ne sont pas gérés par Prat, certains garderont le style d'Elephant."
L['prat2_desc22']    = "Cette option ne fonctionnera que si vous avez Prat d'activé."
L['resethelp']      = "Configuration"
L['resethelp_desc']    = "Réinitialise la configuration et les canaux de discussion."
L['resetloc']      = "Position"
L['resetloc_desc2']    = "Réinitialise la position de la fenêtre principale et du bouton d'Elephant."
L['showbutton']      = "Afficher boutton"
L['showbutton_desc']    = "Affiche un bouton au-dessus des boutons par défaut de la fenêtre de discussion, qui permet de basculer l'affichage d'Elephant."
L['classcolors']    = "Couleurs de classe"
L['classcolors_desc']    = "Affiche la couleur de classe des joueurs dans les logs."
L['classcolors_desc2']    = "Cela s'applique également aux messages non gérés par Prat lorsque l'option Formatage de Prat est cochée."

--[[ Main/Copy frame elements ]]
-- Main
L['catchers']  = {
  [1]  = "Messages à enregistrer",
  [2]  = "Que faut-il sauver dans ce log?",
  [3]  = "Les types de messages en gris ne peuvent être désactivés."
}
L['clearall']  = "Tout vider"
L['copy']  = "Copier"
L['copyinfo']  = "Vous permet de copier %s caractères du log, en terminant par la dernière ligne affichée ci-dessus."
L['copywarn']  = "Les messages envoyés par Battle.net sont automatiquement enlevés pour protéger votre vie privée."
L['Disable']  = DISABLE
L['Empty']  = "Vider"
L['Enable']  = ENABLE
L['maxlog']  = "Log max: %s lignes."
L['move2']  = {
  [1]  = "Déplacer la fenêtre",
  [2]  = "Clic central pour réinitialiser la position d'Elephant.",
  [3]  = "Fonctionne aussi sur la fenêtre principale."
}
L['nblines']    = "Lignes: %s"
L['scroll']  = {
  ['bottom']    = {
    [1]  = "Atteindre le bas"
  },
  ['linedown']  = {
    [1]  = "Descendre d'une ligne"
  },
  ['lineup']    = {
    [1]  = "Monter d'une ligne"
  },
  ['pagedown']  = {
    [1]  = "Descendre d'une page"
  },
  ['pageup']    = {
    [1]  = "Monter d'une page"
  },
  ['top']      = {
    [1]  = "Atteindre le haut"
  }
}
L['customchatsinfo']  = "Les canaux non cochés sont ceux que vous avez quittés."

-- Copy
L['bbAndText']    = "BB/Texte"
L['bbAndTextInfo'] = {
  [1] = "Change l'affichage entre le texte et le BBCode (quand vous voulez coller les logs sur un forum par exemple).",
  [2] = "Le BBCode étant plus verbeux, moins de lignes peuvent être affichées dans ce mode."
}
L['copywindow']    = "Fenêtre de copie"
L['copywindowloglength']    = "Caractères max: %s"
L['copywindowplaintext']    = "Texte"
L['copywindowbbcode']    = "BBCode"
L['showtimestamps']  = "Montrer les heures"
L['itemLinkSite']  = "http://fr.wowhead.com/?item="
L['maxcopycharacters'] = "Max. caractères de copie"
L['maxcopycharacters_desc'] = "Nombre maximum de caractères (et pas de lignes) affichés dans la fenêtre de copie."
L['maxcopycharacters_desc_warning'] = "Attention: Plus cette valeur est grande et plus la fenêtre de copie prendra de temps pour s'afficher. Votre jeu se bloquera temporairement pendant que la fenêtre se remplit. Toute valeur supérieure à 15000 rendra le temps de chargement perceptible."

--[[ Special log messages ]]
L['logstartedon']  = "Log commencé le %s à %s."
L['logstopped']    = "Log arrêté."
L['monstersay']    = "%s says"
L['monsteryell']    = "%s crie"
L['whisperfrom']    = "%s chuchote"
L['whisperto']    = "A %s"

--[[ Addon messages ]]
L['clearallconfirm']    = "Tous les logs ont été vidé"
L['combatlogdisabled']  = "Cette fonction est désactivée"
L['deleteconfirm']    = "Chat supprimé: %s"
L['emptyconfirm']    = "Chat vidé: %s"
L['lootmethod']      = {
  ['freeforall']    = ERR_SET_LOOT_FREEFORALL,
  ['group']      = ERR_SET_LOOT_GROUP,
  ['master']      = ERR_SET_LOOT_MASTER,
  ['needbeforegreed']  = ERR_SET_LOOT_NBG,
  ['roundrobin']    = ERR_SET_LOOT_ROUNDROBIN
}
L['masterlooterchanged']  =  ERR_NEW_LOOT_MASTER_S
L['masterlooternameunknown']  = "Impossible de déterminer le nom du maître du butin"
L['resetconfirm']    = "Paramètres et chats réinitialisés"

--[[ Tooltips ]]
L['togglebuttontooltip']    = {
  [1]  = "Clic gauche pour afficher/cacher Elephant",
  [2]  = "Clic central pour réinit. le bouton.",
  [3]  = "Clic droit pour bouger le bouton."
}
L['activefilters'] = "Filtres actifs"
L['toggletooltiphint1'] = "|c%sClic|r pour ouvrir/fermer Elephant"
L['toggletooltiphint2'] = "|c%sClic-Droit|r pour ouvrir la fen?tre des options"

--[[ Popup windows ]]
L['clearallpopup']  = {
  [1]  = "Ceci va vider tous les logs.",
  [2]  = "Ok",
  [3]  = "Annuler"
}
L['emptypopup']    = {
  [1]  = "Ceci videra le log en cours.",
  [2]  = "Ok",
  [3]  = "Annuler"
}
L['resetpopup']    = {
  [1]  = "Ceci réinitialisera tous les paramêtres et chats.",
  [2]  = "Ok",
  [3]  = "Annuler"
}

--[[ Minimap icon ]]
L['minimapicon']  = "Icône de minicarte"
L['minimapicon_desc']  = "Affiche une icône sur la minicarte"

--[[ Default chat names to be displayed ]]
L['chatnames']  = {
  ['combat']    = "Combat",
  ['custom']    = "Chats personnalisés",
  ['general']    = "Chats généraux",
  ['guild']    = CHAT_MSG_GUILD,
  ['loot']    = CHAT_MSG_LOOT,
  ['misc']    = "Divers",
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
  ['commerce']  = {
    ['name']  = "Commerce",
    ['string']  = "commerce"
  },
  ['défenselocale']    = {
    ['name']  = "DéfenseLocale",
    ['string']  = "défenselocale"
  },
  ['défenseuniverselle']  = {
    ['name']  = "DéfenseUniverselle",
    ['string']  = "défenseuniverselle"
  },
  ['général']        = {
    ['name']  = "Général",
    ['string']  = "général"
  },
  ['recherchedegroupe']    = {
    ['name']  = "Recherche de groupe",
    ['string']  = "recherchedegroupe"
  },
  ['recrutementdeguilde']  = {
    ['name']  = "RecrutementDeGuilde",
    ['string']  = "recrutementdeguilde"
  }
}

--[[ Custom chats special log messages ]]
L['customchat']  = {
  ['join']  = "Vous rejoignez un canal.",
  ['leave']  = "Vous quittez un canal."
}
