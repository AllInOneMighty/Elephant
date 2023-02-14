local L = LibStub("AceLocale-3.0"):NewLocale("Elephant", "ruRU")
if not L then return end

--[[ Common messages ]]
L['STRING_OPTIONS_FILE_LOGGING_CHAT'] = "Регистрировать чат в файл"
L['chatlog_desc'] = "Регистрирует чат (не лог боя) как Логи \\WoWChatLog.txt.\n\nЗамечу: Если опция активна,то запись лога происходит автоматически."
L['STRING_OPTIONS_FILE_LOGGING_COMBAT'] = "Регистрировать лог боя в чат"
L['STRING_OPTIONS_FILE_LOGGING_COMBAT_DESC_1'] = "Регистрирует чат (не лог боя) как Логи \\WoWCombatLog.txt.\n\nЗамечу: Если опция активна,то запись лога происходит автоматически."
L['STRING_DISABLED'] = "Включено"
L['STRING_ENABLED'] = "Выключено"
L['STRING_OPTIONS_LOG_NEW_CHANNELS'] = "Регистрировать новый канал"
L['STRING_OPTIONS_LOG_NEW_CHANNELS_DESC'] = "Автоматически начинать регистрацию вновом канале."
L['STRING_INFORM_CHAT_PRAT_WITHOUT_PRAT'] = "Вы можете использовать  Prat'sформатирование для логов когда Prat не загружен. Сообщения будут форматироваться с помощью Elephant's."
L['STRING_RESET'] = "Обновить"
L['STRING_OPTIONS_RESET_TAB_DESC'] = "Обновить опции."
L['STRING_KEYBIND_TOGGLE'] = "Показать"
L['STRING_KEYBIND_TOGGLE_DESC'] = "Показывает или скрывает главное окно."

--[[ Options menu elements ]]
L['STRING_OPTIONS_FILE_LOGGING_ACTIVATE'] = "Активировано"
L['activate_desc'] = "Позволяет Elephant контролировать запись в файл. Отключении опции оставить текущий статус лога неизменным.\n\nВнимание: Вы не должны разрешать контролировать двум разным аддонам файл лога."
L['STRING_OPTIONS_CLEAR_LOGS'] = "Очистить"
L['STRING_OPTIONS_CLEAR_LOGS_DESC'] = "Очищает все сохраненные логи."
L['STRING_OPTIONS_FILE_LOGGING_GROUP'] = "Файл логов"
L['STRING_OPTIONS_FILE_LOGGING_GROUP_DESC'] = "Опции для сохранения лога в файл."
L['STRING_FILTERS'] = FILTERS
L['STRING_OPTIONS_FILTERS_TAB_DESC'] = "Фильтры для не использования лога в определенных каналах."
L['STRING_OPTIONS_FILTER_NEW_DESC_2'] = "Точное название  канала. Вы также можете использовать (*). Ex: <AceComm*>"
L['STRING_INFORM_CHAT_FILTER_INVALID'] = "Не может добавить фильтр '%s'. Фильтр должен содержать (*)."
L['STRING_FILTER_VALIDATION_REGEXP'] = "^[%a%*]+$"
L['STRING_OPTIONS_FILTER_NEW_DESC_1'] = "Создает новый фильтр."
L['STRING_OPTIONS_FILTER_DELETE_DESC'] = "Удаляяет ранее созданый фильтр."
L['STRING_OPTIONS_LOGS_TAB'] = "Логи"
L['STRING_OPTIONS_LOGS_TAB_DESC'] = "Опции Логов."
L['STRING_OPTIONS_MAX_LOG_LINES'] = "Max Лог"
L['STRING_OPTIONS_MAX_LOG_LINES_DESC_1'] = "Максимальный размер каждого лога."
L['STRING_OPTIONS_PRAT_FORMATTING'] = "Prat форматирование"
L['prat_desc'] = "Сохраняет логи так же как и  Prat. Сохраненные опции логов разрешают в дальнейшем o Elephant's использовать его стиль по умолчанию.\n\nЭто опция возможна если у вас стоит и работает Prat."
L['STRING_SETTINGS'] = "Настройки"
L['STRING_OPTIONS_RESET_SETTINGS_DESC'] = "Обновить все настройки и чаты."
L['STRING_POSITION'] = "Position"
L['resetloc_desc'] = "Обновляет Elephant's позицию главного окна."
L['STRING_OPTIONS_SHOW_CHAT_BUTTON'] = "Показать кнопки"
L['STRING_OPTIONS_SHOW_CHAT_BUTTON_DESC'] = "Показывает кнопки нормального чата как кнопки Elephant."

--[[ Main/Copy frame elements ]]
-- Main
L['STRING_MAIN_WINDOW_MESSAGE_CATCHERS_BUTTON'] = "Ловить сообщения"
L['STRING_MAIN_WINDOW_MESSAGE_CATCHERS_BUTTON_DESC_1'] = "Что должно быть сохранено в этом логе?"
L['STRING_MAIN_WINDOW_MESSAGE_CATCHERS_BUTTON_DESC_2'] = "Сообщения серые они отключены."
L['STRING_COPY'] = "Копировать"
L['STRING_DISABLE'] = DISABLE
L['STRING_EMPTY'] = EMPTY
L['STRING_ENABLE'] = ENABLE
L['STRING_MAIN_WINDOW_MAX_LOG'] = "Max Лог: %s Линии."
L['STRING_MAIN_WINDOW_CHAT_BUTTONS_LINES'] = "Линии: %s"
L['STRING_MAIN_WINDOW_SCROLL_BOTTOM_BUTTON_TOOLTIP'] = "Листать по Кнопке"
L['STRING_MAIN_WINDOW_SCROLL_ONE_LINE_DOWN_BUTTON_TOOLTIP'] = "Листать по Линии вниз"
L['STRING_MAIN_WINDOW_SCROLL_ONE_LINE_UP_BUTTON_TOOLTIP'] = "Листать по Линии вверх"
L['STRING_MAIN_WINDOW_SCROLL_ONE_PAGE_DOWN_BUTTON_TOOLTIP'] = "Листать по Странице Вперед"
L['STRING_MAIN_WINDOW_SCROLL_ONE_PAGE_UP_BUTTON_TOOLTIP'] = "Листать по Странице Назад"
L['STRING_MAIN_WINDOW_SCROLL_TOP_BUTTON_TOOLTIP'] = "Листать по Верху"

-- Copy
L['STRING_COPY_WINDOW_BB_TEXT_BUTTON'] = "BB/Text"
L['STRING_COPY_WINDOW'] = "Copy window"
L['STRING_COPY_WINDOW_MAX_CHARACTERS'] = "Log length: %s lines"
L['STRING_COPY_WINDOW_PLAIN_TEXT'] = "Plain text"
L['STRING_COPY_WINDOW_BB_CODE'] = "BBCode"
L['STRING_COPY_WINDOW_SHOW_TIMESTAMPS_CHECKBOX'] = "Show timestamps"
L['URL_ITEM_LINK'] = "http://ru.wowhead.com/?item="

--[[ Special log messages ]]
L['STRING_SPECIAL_LOG_LOGGING_STARTED_ON'] = "Запись начинается для %s на %s в %s."
L['STRING_SPECIAL_LOG_LOGGING_STOPPED'] = "Запись остановлена."
L['STRING_SPECIAL_LOG_MONSTER_SAYS'] = "%s сказать"
L['STRING_SPECIAL_LOG_MONSTER_YELLS'] = "%s крикнуть"
L['STRING_SPECIAL_LOG_WHISPER_FROM'] = "%s шепнуть"
L['STRING_SPECIAL_LOG_WHISPER_TO'] = "К %s"

--[[ Addon messages ]]
L['STRING_INFORM_CHAT_CLEAR_LOGS_SUCCESS'] = "Все чаты очищены."
L['STRING_INFORM_CHAT_FUNCTION_IS_DISABLED'] = "Эта функция отключена."
L['STRING_INFORM_CHAT_LOG_DELETED'] = "Чат удален: %s"
L['STRING_INFORM_CHAT_LOG_EMPTIED'] = "Чат Создан: %s"
L['STRING_LOOT_METHOD_freeforall'] = ERR_SET_LOOT_FREEFORALL
L['STRING_LOOT_METHOD_group'] = ERR_SET_LOOT_GROUP
L['STRING_LOOT_METHOD_master'] = ERR_SET_LOOT_MASTER
L['STRING_LOOT_METHOD_needbeforegreed'] = ERR_SET_LOOT_NBG
L['STRING_LOOT_METHOD_roundrobin'] = ERR_SET_LOOT_ROUNDROBIN
L['STRING_INFORM_CHAT_LOOT_MASTER_LOOTER_CHANGED'] =  ERR_NEW_LOOT_MASTER_S
L['STRING_INFORM_CHAT_RESET_SETTINGS_SUCCESS'] = "Обновить все настройки и чаты."

--[[ Tooltips ]]
L['STRING_CHAT_BUTTON_TOOLTIP'] = "Left-Click для показа Elephant"
L['STRING_CHAT_BUTTON_TOOLTIP_DESC_1'] = "Центр-Click для обновления позиции  кнопки."
L['STRING_CHAT_BUTTON_TOOLTIP_DESC_2'] = "Right-Click для того чтобы двигать кнопки."

--[[ Popup windows ]]
L['STRING_OK'] = "OK"
L['STRING_CANCEL'] = CANCEL
L['STRING_POPUP_CLEAR_LOGS'] = "Это очистит все логи."

--[[ Default chat names to be displayed ]]
L['STRING_CHAT_NAME_COMBAT'] = "Бой"
L['STRING_CHAT_NAME_CUSTOM'] = "Обычный чат"
L['STRING_CHAT_NAME_GENERAL'] = "Главный чат"
L['STRING_CHAT_NAME_GUILD'] = CHAT_MSG_GUILD
L['STRING_CHAT_NAME_LOOT'] = CHAT_MSG_LOOT
L['STRING_CHAT_NAME_MISC'] = "Скрытый."
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
L['STRING_GENERAL_CHAT_CHANNEL_NAME_LOCAL_DEFENSE'] = "Местная оборона"
L['STRING_GENERAL_CHAT_CHANNEL_NAME_LOCAL_DEFENSE_ID'] = "Местная оборона"
L['STRING_GENERAL_CHAT_CHANNEL_NAME_LOOKING_FOR_GROUP'] = "Looking for group"
L['STRING_GENERAL_CHAT_CHANNEL_NAME_LOOKING_FOR_GROUP_ID'] = "lookingforgroup"
L['STRING_GENERAL_CHAT_CHANNEL_NAME_GENERAL'] = "Главный"
L['STRING_GENERAL_CHAT_CHANNEL_NAME_GENERAL_ID'] = "Главный"
L['STRING_GENERAL_CHAT_CHANNEL_NAME_GUILD_RECRUITMENT'] = "Канал Гильдии"
L['STRING_GENERAL_CHAT_CHANNEL_NAME_GUILD_RECRUITMENT_ID'] = "Канал Гильдии"
L['STRING_GENERAL_CHAT_CHANNEL_NAME_TRADE'] = "Торговля"
L['STRING_GENERAL_CHAT_CHANNEL_NAME_TRADE_ID'] = "Торговля"
L['STRING_GENERAL_CHAT_CHANNEL_NAME_WORLD_DEFENSE'] = "Оборона Мира"
L['STRING_GENERAL_CHAT_CHANNEL_NAME_WORLD_DEFENSE_ID'] = "Оборона Мира"

--[[ Custom chats special log messages ]]
L['STRING_SPECIAL_LOG_JOINED_CHANNEL'] = "Вы покинули канал."
L['STRING_SPECIAL_LOG_LEFT_CHANNEL'] = "Вы покинули канал."
