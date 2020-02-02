local L = LibStub("AceLocale-3.0"):NewLocale("Elephant", "ruRU")
if not L then return end

--[[ Common messages ]]
L['chatlog']        = "Регистрировать чат в файл"
L['chatlog_desc']    = "Регистрирует чат (не лог боя) как Логи \\WoWChatLog.txt.\n\nЗамечу: Если опция активна,то запись лога происходит автоматически."
L['combatlog']      = "Регистрировать лог боя в чат"
L['combatlog_desc']    = "Регистрирует чат (не лог боя) как Логи \\WoWCombatLog.txt.\n\nЗамечу: Если опция активна,то запись лога происходит автоматически."
L['disabled']      = "Включено"
L['enabled']        = "Выключено"
L['enableddefault']    = "Регистрировать новый канал"
L['enableddefault_desc']  = "Автоматически начинать регистрацию вновом канале."
L['noprat']        = "Вы можете использовать  Prat'sформатирование для логов когда Prat не загружен. Сообщения будут форматироваться с помощью Elephant's."
L['reset']        = "Обновить"
L['reset_desc']      = "Обновить опции."
L['toggle']        = "Показать"
L['toggle_desc']      = "Показывает или скрывает главное окно."

--[[ Options menu elements ]]
L['activate']      = "Активировано"
L['activate_desc']    = "Позволяет Elephant контролировать запись в файл. Отключении опции оставить текущий статус лога неизменным.\n\nВнимание: Вы не должны разрешать контролировать двум разным аддонам файл лога."
L['clearallhelp']    = "Очистить"
L['clearallhelp_desc']  = "Очищает все сохраненные логи."
L['files']        = "Файл логов"
L['files_desc']      = "Опции для сохранения лога в файл."
L['Filters']        = FILTERS
L['Filters_desc']    = "Фильтры для не использования лога в определенных каналах."
L['filterusage']      = "Точное название  канала. Вы также можете использовать (*). Ex: <AceComm*>"
L['filtererror']      = "Не может добавить фильтр '%s'. Фильтр должен содержать (*)."
L['filterregex']      = "^[%a%*]+$"
L['newfilter_desc']    = "Создает новый фильтр."
L['deletefilter_desc']  = "Удаляяет ранее созданый фильтр."
L['logs']        = "Логи"
L['logs_desc']      = "Опции Логов."
L['maxlogwords']      = "Max Лог"
L['maxlogwords_desc']  = "Максимальный размер каждого лога."
L['prat']        = "Prat форматирование"
L['prat_desc']      = "Сохраняет логи так же как и  Prat. Сохраненные опции логов разрешают в дальнейшем o Elephant's использовать его стиль по умолчанию.\n\nЭто опция возможна если у вас стоит и работает Prat."
L['resethelp']      = "Настройки"
L['resethelp_desc']    = "Обновить все настройки и чаты."
L['resetloc']      = "Position"
L['resetloc_desc']    = "Обновляет Elephant's позицию главного окна."
L['showbutton']      = "Показать кнопки"
L['showbutton_desc']    = "Показывает кнопки нормального чата как кнопки Elephant."

--[[ Main/Copy frame elements ]]
-- Main
L['catchers']  = {
  [1]  = "Ловить сообщения",
  [2]  = "Что должно быть сохранено в этом логе?",
  [3]  = "Сообщения серые они отключены."
}
L['clearall']  = "очистить все"
L['copy']    = "Копировать"
L['Disable']    = DISABLE
L['Empty']    = EMPTY
L['Enable']    = ENABLE
L['maxlog']    = "Max Лог: %s Линии."
L['nblines']    = "Линии: %s"
L['scroll']    = {
  ['bottom']    = {
    [1]  = "Листать по Кнопке"
  },
  ['linedown']  = {
    [1]  = "Листать по Линии вниз"
  },
  ['lineup']    = {
    [1]  = "Листать по Линии вверх"
  },
  ['pagedown']  = {
    [1]  = "Листать по Странице Вперед"
  },
  ['pageup']    = {
    [1]  = "Листать по Странице Назад"
  },
  ['top']      = {
    [1]  = "Листать по Верху"
  }
}

-- Copy
L['bbAndText']    = "BB/Text"
L['bbAndTextInfo'] = {
  [1] = "Switches between showing plain text and BBCode (e.g. when you want to paste the logs on a forum).",
  [2] = "Due to UI length limitations, only %s lines of BBCode can be shown."
}
L['copywindow']  = "Copy window"
L['copywindowloglength']    = "Log length: %s lines"
L['copywindowplaintext']    = "Plain text"
L['copywindowbbcode']    = "BBCode"
L['showtimestamps']  = "Show timestamps"
L['itemLinkSite'] = "http://ru.wowhead.com/?item="

--[[ Special log messages ]]
L['logstartedon']  = "Запись начинается на %s в %s."
L['logstopped']    = "Запись остановлена."
L['monstersay']    = "%s сказать"
L['monsteryell']    = "%s крикнуть"
L['whisperfrom']    = "%s шепнуть"
L['whisperto']    = "К %s"

--[[ Addon messages ]]
L['clearallconfirm']    = "Все чаты очищены."
L['combatlogdisabled']  = "Эта функция отключена."
L['deleteconfirm']    = "Чат удален: %s"
L['emptyconfirm']    = "Чат Создан: %s"
L['lootmethod']      = {
  ['freeforall']    = ERR_SET_LOOT_FREEFORALL,
  ['group']      = ERR_SET_LOOT_GROUP,
  ['master']      = ERR_SET_LOOT_MASTER,
  ['needbeforegreed']  = ERR_SET_LOOT_NBG,
  ['roundrobin']    = ERR_SET_LOOT_ROUNDROBIN
}
L['masterlooterchanged']  =  ERR_NEW_LOOT_MASTER_S
L['resetconfirm']    = "Обновить все настройки и чаты."

--[[ Tooltips ]]
L['togglebuttontooltip']    = {
  [1]  = "Left-Click для показа Elephant",
  [2]  = "Центр-Click для обновления позиции  кнопки.",
  [3]  = "Right-Click для того чтобы двигать кнопки."
}
L['toggletooltip']      = "Left-Click для показа Elephant."

--[[ Popup windows ]]
L['clearallpopup']  = {
  [1]  = "Это очистит все логи.",
  [2]  = "Ok",
  [3]  = "Отмена"
}
L['emptypopup']    = {
  [1]  = "Это очистит все текущие логи.",
  [2]  = "Ok",
  [3]  = "Cancel"
}
L['resetpopup']    = {
  [1]  = "Это обновит все настройки и чаты.",
  [2]  = "Ok",
  [3]  = "Отмена"
}

--[[ Default chat names to be displayed ]]
L['chatnames']  = {
  ['combat']  = "Бой",
  ['custom']  = "Обычный чат",
  ['general']  = "Главный чат",
  ['guild']  = CHAT_MSG_GUILD,
  ['loot']  = CHAT_MSG_LOOT,
  ['misc']  = "Скрытый.",
  ['officer']  = CHAT_MSG_OFFICER,
  ['party']  = CHAT_MSG_PARTY,
  ['raid']  = CHAT_MSG_RAID,
  ['say']    = CHAT_MSG_SAY,
  ['system']  = SYSTEM_MESSAGES,
  ['whisper']  = WHISPER,
  ['yell']  = YELL_MESSAGE,
  ['achievement'] = ACHIEVEMENTS,
  ['instance'] = INSTANCE,
  ['instance'] = INSTANCE
}

--[[ General chats (= that you cannot leave) names and strings that identify them ]]
L['generalchats']  = {
  ['localdefense']    = {
    ['name']  = "Местная оборона",
    ['string']  = "Местная оборона"
  },
  ['general']        = {
    ['name']  = "Главный",
    ['string']  = "Главный"
  },
  ['guildrecruitment']  = {
    ['name']  = "Канал Гильдии",
    ['string']  = "Канал Гильдии"
  },
  ['trade']        = {
    ['name']  = "Торговля",
    ['string']  = "Торговля"
  },
  ['worlddefense']    = {
    ['name']  = "Оборона Мира",
    ['string']  = "Оборона Мира"
  }
}

--[[ Custom chats special log messages ]]
L['customchat']  = {
  ['join']  = "Вы покинули канал.",
  ['leave']  = "Вы покинули канал."
}
