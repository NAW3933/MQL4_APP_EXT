/*
Copyright 2020 FXcoder

This file is part of VP.

VP is free software: you can redistribute it and/or modify it under the terms of the GNU General
Public License as published by the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

VP is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the
implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
Public License for more details.

You should have received a copy of the GNU General Public License along with VP. If not, see
http://www.gnu.org/licenses/.
*/

// Errors. Better Standard Library (4.?/5.2006). © FXcoder

#property strict

#include "../type/uncopyable.mqh"
#include "math.mqh"

// 5.1881, не объявлены константы (баг?):
#ifndef __MQL4__
	#ifndef ERR_FTP_CLOSED
		#define ERR_FTP_CLOSED 4524
	#endif
#endif


class CBErrorUtil: public CBUncopyable
{
public:

	static int last(bool reset = true)
	{
		return(reset ? ::GetLastError() : _LastError);
	}

	static bool success(bool reset = true)
	{
#ifdef __MQL4__
		return(last(reset) == ERR_NO_ERROR);
#else
		return(last(reset) == ERR_SUCCESS);
#endif
	}

	static void reset()
	{
		::ResetLastError();
	}

	static string last_message(bool reset = true)
	{
		return(message(last(reset)));
	}

	static string message(int error_code)
	{
		switch(error_code)
		{
#ifdef __MQL4__

			case ERR_NO_ERROR:                         return("0:ok"); // Нет ошибки
			case ERR_NO_RESULT:                        return("1: Нет ошибки, но результат неизвестен");
			case ERR_COMMON_ERROR:                     return("2: Общая ошибка");
			case ERR_INVALID_TRADE_PARAMETERS:         return("3: Неправильные параметры");
			case ERR_SERVER_BUSY:                      return("4: Торговый сервер занят");
			case ERR_OLD_VERSION:                      return("5: Старая версия клиентского терминала");
			case ERR_NO_CONNECTION:                    return("6: Нет связи с торговым сервером");
			case ERR_NOT_ENOUGH_RIGHTS:                return("7: Недостаточно прав");
			case ERR_TOO_FREQUENT_REQUESTS:            return("8: Слишком частые запросы");
			case ERR_MALFUNCTIONAL_TRADE:              return("9: Недопустимая операция, нарушающая функционирование сервера");
			case ERR_ACCOUNT_DISABLED:                 return("64: Счет заблокирован");
			case ERR_INVALID_ACCOUNT:                  return("65: Неправильный номер счета");
			case ERR_TRADE_TIMEOUT:                    return("128: Истек срок ожидания совершения сделки");
			case ERR_INVALID_PRICE:                    return("129: Неправильная цена");
			case ERR_INVALID_STOPS:                    return("130: Неправильные стопы");
			case ERR_INVALID_TRADE_VOLUME:             return("131: Неправильный объем");
			case ERR_MARKET_CLOSED:                    return("132: Рынок закрыт");
			case ERR_TRADE_DISABLED:                   return("133: Торговля запрещена");
			case ERR_NOT_ENOUGH_MONEY:                 return("134: Недостаточно денег для совершения операции");
			case ERR_PRICE_CHANGED:                    return("135: Цена изменилась");
			case ERR_OFF_QUOTES:                       return("136: Нет цен");
			case ERR_BROKER_BUSY:                      return("137: Брокер занят");
			case ERR_REQUOTE:                          return("138: Новые цены");
			case ERR_ORDER_LOCKED:                     return("139: Ордер заблокирован и уже обрабатывается");
			case ERR_LONG_POSITIONS_ONLY_ALLOWED:      return("140: Разрешена только покупка");
			case ERR_TOO_MANY_REQUESTS:                return("141: Слишком много запросов");
			case ERR_TRADE_MODIFY_DENIED:              return("145: Модификация запрещена, так как ордер слишком близок к рынку");
			case ERR_TRADE_CONTEXT_BUSY:               return("146: Подсистема торговли занята");
			case ERR_TRADE_EXPIRATION_DENIED:          return("147: Использование даты истечения ордера запрещено брокером");
			case ERR_TRADE_TOO_MANY_ORDERS:            return("148: Количество открытых и отложенных ордеров достигло предела, установленного брокером");
			case ERR_TRADE_HEDGE_PROHIBITED:           return("149: Попытка открыть противоположный ордер в случае, если хеджирование запрещено");
			case ERR_TRADE_PROHIBITED_BY_FIFO:         return("150: Попытка закрыть позицию по инструменту в противоречии с правилом FIFO");
			case ERR_NO_MQLERROR:                      return("4000: Нет ошибки");
			case ERR_WRONG_FUNCTION_POINTER:           return("4001: Неправильный указатель функции");
			case ERR_ARRAY_INDEX_OUT_OF_RANGE:         return("4002: Индекс массива - вне диапазона");
			case ERR_NO_MEMORY_FOR_CALL_STACK:         return("4003: Нет памяти для стека функций");
			case ERR_RECURSIVE_STACK_OVERFLOW:         return("4004: Переполнение стека после рекурсивного вызова");
			case ERR_NOT_ENOUGH_STACK_FOR_PARAM:       return("4005: На стеке нет памяти для передачи параметров");
			case ERR_NO_MEMORY_FOR_PARAM_STRING:       return("4006: Нет памяти для строкового параметра");
			case ERR_NO_MEMORY_FOR_TEMP_STRING:        return("4007: Нет памяти для временной строки");
			case ERR_NOT_INITIALIZED_STRING:           return("4008: Неинициализированная строка");
			case ERR_NOT_INITIALIZED_ARRAYSTRING:      return("4009: Неинициализированная строка в массиве");
			case ERR_NO_MEMORY_FOR_ARRAYSTRING:        return("4010: Нет памяти для строкового массива");
			case ERR_TOO_LONG_STRING:                  return("4011: Слишком длинная строка");
			case ERR_REMAINDER_FROM_ZERO_DIVIDE:       return("4012: Остаток от деления на ноль");
			case ERR_ZERO_DIVIDE:                      return("4013: Деление на ноль");
			case ERR_UNKNOWN_COMMAND:                  return("4014: Неизвестная команда");
			case ERR_WRONG_JUMP:                       return("4015: Неправильный переход");
			case ERR_NOT_INITIALIZED_ARRAY:            return("4016: Неинициализированный массив");
			case ERR_DLL_CALLS_NOT_ALLOWED:            return("4017: Вызовы DLL не разрешены");
			case ERR_CANNOT_LOAD_LIBRARY:              return("4018: Невозможно загрузить библиотеку");
			case ERR_CANNOT_CALL_FUNCTION:             return("4019: Невозможно вызвать функцию");
			case ERR_EXTERNAL_CALLS_NOT_ALLOWED:       return("4020: Вызовы внешних библиотечных функций не разрешены");
			case ERR_NO_MEMORY_FOR_RETURNED_STR:       return("4021: Недостаточно памяти для строки, возвращаемой из функции");
			case ERR_SYSTEM_BUSY:                      return("4022: Система занята");
			case ERR_DLLFUNC_CRITICALERROR:            return("4023: Критическая ошибка вызова DLL-функции");
			case ERR_INTERNAL_ERROR:                   return("4024: Внутренняя ошибка");
			case ERR_OUT_OF_MEMORY:                    return("4025: Нет памяти");
			case ERR_INVALID_POINTER:                  return("4026: Неверный указатель");
			case ERR_FORMAT_TOO_MANY_FORMATTERS:       return("4027: Слишком много параметров форматирования строки");
			case ERR_FORMAT_TOO_MANY_PARAMETERS:       return("4028: Число параметров превышает число параметров форматирования строки");
			case ERR_ARRAY_INVALID:                    return("4029: Неверный массив");
			case ERR_CHART_NOREPLY:                    return("4030: График не отвечает");
			case ERR_INVALID_FUNCTION_PARAMSCNT:       return("4050: Неправильное количество параметров функции");
			case ERR_INVALID_FUNCTION_PARAMVALUE:      return("4051: Недопустимое значение параметра функции");
			case ERR_STRING_FUNCTION_INTERNAL:         return("4052: Внутренняя ошибка строковой функции");
			case ERR_SOME_ARRAY_ERROR:                 return("4053: Ошибка массива");
			case ERR_INCORRECT_SERIESARRAY_USING:      return("4054: Неправильное использование массива-таймсерии");
			case ERR_CUSTOM_INDICATOR_ERROR:           return("4055: Ошибка пользовательского индикатора");
			case ERR_INCOMPATIBLE_ARRAYS:              return("4056: Массивы несовместимы");
			case ERR_GLOBAL_VARIABLES_PROCESSING:      return("4057: Ошибка обработки глобальных переменных");
			case ERR_GLOBAL_VARIABLE_NOT_FOUND:        return("4058: Глобальная переменная не обнаружена");
			case ERR_FUNC_NOT_ALLOWED_IN_TESTING:      return("4059: Функция не разрешена в тестовом режиме");
			case ERR_FUNCTION_NOT_CONFIRMED:           return("4060: Функция не разрешена");
			case ERR_SEND_MAIL_ERROR:                  return("4061: Ошибка отправки почты");
			case ERR_STRING_PARAMETER_EXPECTED:        return("4062: Ожидается параметр типа string");
			case ERR_INTEGER_PARAMETER_EXPECTED:       return("4063: Ожидается параметр типа integer");
			case ERR_DOUBLE_PARAMETER_EXPECTED:        return("4064: Ожидается параметр типа double");
			case ERR_ARRAY_AS_PARAMETER_EXPECTED:      return("4065: В качестве параметра ожидается массив");
			case ERR_HISTORY_WILL_UPDATED:             return("4066: Запрошенные исторические данные в состоянии обновления");
			case ERR_TRADE_ERROR:                      return("4067: Ошибка при выполнении торговой операции");
			case ERR_RESOURCE_NOT_FOUND:               return("4068: Ресурс не найден");
			case ERR_RESOURCE_NOT_SUPPORTED:           return("4069: Ресурс не поддерживается");
			case ERR_RESOURCE_DUPLICATED:              return("4070: Дубликат ресурса");
			case ERR_INDICATOR_CANNOT_INIT:            return("4071: Ошибка инициализации пользовательского индикатора");
			case ERR_INDICATOR_CANNOT_LOAD:            return("4072: Ошибка загрузки пользовательского индикатора");
			case ERR_NO_HISTORY_DATA:                  return("4073: Нет исторических данных");
			case ERR_NO_MEMORY_FOR_HISTORY:            return("4074: Не хватает памяти для исторических данных");
			case ERR_NO_MEMORY_FOR_INDICATOR:          return("4075: Не хватает памяти для расчёта индикатора");
			case ERR_END_OF_FILE:                      return("4099: Конец файла");
			case ERR_SOME_FILE_ERROR:                  return("4100: Ошибка при работе с файлом");
			case ERR_WRONG_FILE_NAME:                  return("4101: Неправильное имя файла");
			case ERR_TOO_MANY_OPENED_FILES:            return("4102: Слишком много открытых файлов");
			case ERR_CANNOT_OPEN_FILE:                 return("4103: Невозможно открыть файл");
			case ERR_INCOMPATIBLE_FILEACCESS:          return("4104: Несовместимый режим доступа к файлу");
			case ERR_NO_ORDER_SELECTED:                return("4105: Ни один ордер не выбран");
			case ERR_UNKNOWN_SYMBOL:                   return("4106: Неизвестный символ");
			case ERR_INVALID_PRICE_PARAM:              return("4107: Неправильный параметр цены для торговой функции");
			case ERR_INVALID_TICKET:                   return("4108: Неверный номер тикета");
			case ERR_TRADE_NOT_ALLOWED:                return("4109: Торговля не разрешена. Необходимо включить опцию \"Разрешить советнику торговать\" в свойствах эксперта");
			case ERR_LONGS_NOT_ALLOWED:                return("4110: Ордера на покупку не разрешены. Необходимо проверить свойства эксперта");
			case ERR_SHORTS_NOT_ALLOWED:               return("4111: Ордера на продажу не разрешены. Необходимо проверить свойства эксперта");
			case ERR_TRADE_EXPERT_DISABLED_BY_SERVER:  return("4112: Автоматическая торговля с помощью экспертов/скриптов запрещена на стороне сервера");
			case ERR_OBJECT_ALREADY_EXISTS:            return("4200: Объект уже существует");
			case ERR_UNKNOWN_OBJECT_PROPERTY:          return("4201: Запрошено неизвестное свойство объекта");
			case ERR_OBJECT_DOES_NOT_EXIST:            return("4202: Объект не существует");
			case ERR_UNKNOWN_OBJECT_TYPE:              return("4203: Неизвестный тип объекта");
			case ERR_NO_OBJECT_NAME:                   return("4204: Нет имени объекта");
			case ERR_OBJECT_COORDINATES_ERROR:         return("4205: Ошибка координат объекта");
			case ERR_NO_SPECIFIED_SUBWINDOW:           return("4206: Не найдено указанное подокно");
			case ERR_SOME_OBJECT_ERROR:                return("4207: Ошибка при работе с объектом");
			case ERR_CHART_PROP_INVALID:               return("4210: Неизвестное свойство графика");
			case ERR_CHART_NOT_FOUND:                  return("4211: График не найден");
			case ERR_CHARTWINDOW_NOT_FOUND:            return("4212: Не найдено подокно графика");
			case ERR_CHARTINDICATOR_NOT_FOUND:         return("4213: Индикатор не найден");
			case ERR_SYMBOL_SELECT:                    return("4220: Ошибка выбора инструмента");
			case ERR_NOTIFICATION_ERROR:               return("4250: Ошибка отправки push-уведомления");
			case ERR_NOTIFICATION_PARAMETER:           return("4251: Ошибка параметров push-уведомления");
			case ERR_NOTIFICATION_SETTINGS:            return("4252: Уведомления запрещены");
			case ERR_NOTIFICATION_TOO_FREQUENT:        return("4253: Слишком частые запросы отсылки push-уведомлений");
			case ERR_FTP_NOSERVER:                     return("4260: Не указан FTP сервер");
			case ERR_FTP_NOLOGIN :                     return("4261: Не указан FTP логин");
			case ERR_FTP_CONNECT_FAILED :              return("4262: Ошибка при подключении к FTP серверу");
			case ERR_FTP_CLOSED:                       return("4263: Подключение к FTP серверу закрыто");
			case ERR_FTP_CHANGEDIR:                    return("4264: На FTP сервере не найдена директория для выгрузки файла ");
			case ERR_FTP_FILE_ERROR:                   return("4265: Не найден файл в директории MQL4\\Files для отправки на FTP сервер");
			case ERR_FTP_ERROR:                        return("4266: Ошибка при передаче файла на FTP сервер");
			case ERR_FILE_TOO_MANY_OPENED:             return("5001: Слишком много открытых файлов");
			case ERR_FILE_WRONG_FILENAME:              return("5002: Неверное имя файла");
			case ERR_FILE_TOO_LONG_FILENAME:           return("5003: Слишком длинное имя файла");
			case ERR_FILE_CANNOT_OPEN:                 return("5004: Ошибка открытия файла");
			case ERR_FILE_BUFFER_ALLOCATION_ERROR:     return("5005: Ошибка размещения буфера текстового файла");
			case ERR_FILE_CANNOT_DELETE:               return("5006: Ошибка удаления файла");
			case ERR_FILE_INVALID_HANDLE:              return("5007: Неверный хендл файла (файл закрыт или не был открыт)");
			case ERR_FILE_WRONG_HANDLE:                return("5008: Неверный хендл файла (индекс хендла отсутствует в таблице)");
			case ERR_FILE_NOT_TOWRITE:                 return("5009: Файл должен быть открыт с флагом FILE_WRITE");
			case ERR_FILE_NOT_TOREAD:                  return("5010: Файл должен быть открыт с флагом FILE_READ");
			case ERR_FILE_NOT_BIN:                     return("5011: Файл должен быть открыт с флагом FILE_BIN");
			case ERR_FILE_NOT_TXT:                     return("5012: Файл должен быть открыт с флагом FILE_TXT");
			case ERR_FILE_NOT_TXTORCSV:                return("5013: Файл должен быть открыт с флагом FILE_TXT или FILE_CSV");
			case ERR_FILE_NOT_CSV:                     return("5014: Файл должен быть открыт с флагом FILE_CSV");
			case ERR_FILE_READ_ERROR:                  return("5015: Ошибка чтения файла");
			case ERR_FILE_WRITE_ERROR:                 return("5016: Ошибка записи файла");
			case ERR_FILE_BIN_STRINGSIZE:              return("5017: Размер строки должен быть указан для двоичных файлов");
			case ERR_FILE_INCOMPATIBLE:                return("5018: Неверный тип файла (для строковых массивов-TXT, для всех других-BIN)");
			case ERR_FILE_IS_DIRECTORY:                return("5019: Файл является директорией");
			case ERR_FILE_NOT_EXIST:                   return("5020: Файл не существует");
			case ERR_FILE_CANNOT_REWRITE:              return("5021: Файл не может быть перезаписан");
			case ERR_FILE_WRONG_DIRECTORYNAME:         return("5022: Неверное имя директории");
			case ERR_FILE_DIRECTORY_NOT_EXIST:         return("5023: Директория не существует");
			case ERR_FILE_NOT_DIRECTORY:               return("5024: Указанный файл не является директорией");
			case ERR_FILE_CANNOT_DELETE_DIRECTORY:     return("5025: Ошибка удаления директории");
			case ERR_FILE_CANNOT_CLEAN_DIRECTORY:      return("5026: Ошибка очистки директории");
			case ERR_FILE_ARRAYRESIZE_ERROR:           return("5027: Ошибка изменения размера массива");
			case ERR_FILE_STRINGRESIZE_ERROR:          return("5028: Ошибка изменения размера строки");
			case ERR_FILE_STRUCT_WITH_OBJECTS:         return("5029: Структура содержит строки или динамические массивы");
			case ERR_WEBREQUEST_INVALID_ADDRESS:       return("5200: URL не прошел проверку");
			case ERR_WEBREQUEST_CONNECT_FAILED:        return("5201: Не удалось подключиться к указанному URL");
			case ERR_WEBREQUEST_TIMEOUT:               return("5202: Превышен таймаут получения данных");
			case ERR_WEBREQUEST_REQUEST_FAILED:        return("5203: Ошибка в результате выполнения HTTP запроса");

#else

			case ERR_SUCCESS:                            return("0:ok"); // Операция выполнена успешно
			case ERR_INTERNAL_ERROR:                     return("4001: Неожиданная внутренняя ошибка");
			case ERR_WRONG_INTERNAL_PARAMETER:           return("4002: Ошибочный параметр при внутреннем вызове функции клиентского терминала");
			case ERR_INVALID_PARAMETER:                  return("4003: Ошибочный параметр при вызове системной функции");
			case ERR_NOT_ENOUGH_MEMORY:                  return("4004: Недостаточно памяти для выполнения системной функции");
			case ERR_STRUCT_WITHOBJECTS_ORCLASS:         return("4005: Структура содержит объекты строк и/или динамических массивов и/или структуры с такими объектами и/или классы");
			case ERR_INVALID_ARRAY:                      return("4006: Массив неподходящего типа, неподходящего размера или испорченный объект динамического массива");
			case ERR_ARRAY_RESIZE_ERROR:                 return("4007: Недостаточно памяти для перераспределения массива либо попытка изменения размера статического массива");
			case ERR_STRING_RESIZE_ERROR:                return("4008: Недостаточно памяти для перераспределения строки");
			case ERR_NOTINITIALIZED_STRING:              return("4009: Неинициализированная строка");
			case ERR_INVALID_DATETIME:                   return("4010: Неправильное значение даты и/или времени");
			case ERR_ARRAY_BAD_SIZE:                     return("4011: Запрашиваемый размер массива превышает 2 гигабайта");
			case ERR_INVALID_POINTER:                    return("4012: Ошибочный указатель");
			case ERR_INVALID_POINTER_TYPE:               return("4013: Ошибочный тип указателя");
			case ERR_FUNCTION_NOT_ALLOWED:               return("4014: Системная функция не разрешена для вызова");
			case ERR_RESOURCE_NAME_DUPLICATED:           return("4015: Совпадении имени динамического и статического ресурсов");
			case ERR_RESOURCE_NOT_FOUND:                 return("4016: Ресурс с таким именем в EX5 не найден");
			case ERR_RESOURCE_UNSUPPOTED_TYPE:           return("4017: Неподдерживаемый тип ресурса или размер более 16 MB");
			case ERR_RESOURCE_NAME_IS_TOO_LONG:          return("4018: Имя ресурса превышает 63 символа");
			case ERR_MATH_OVERFLOW:                      return("4019: При вычислении математической функции произошло переполнение ");
			// Графики
			case ERR_CHART_WRONG_ID:                     return("4101: Ошибочный идентификатор графика");
			case ERR_CHART_NO_REPLY:                     return("4102: График не отвечает");
			case ERR_CHART_NOT_FOUND:                    return("4103: График не найден");
			case ERR_CHART_NO_EXPERT:                    return("4104: У графика нет эксперта, который мог бы обработать событие");
			case ERR_CHART_CANNOT_OPEN:                  return("4105: Ошибка открытия графика");
			case ERR_CHART_CANNOT_CHANGE:                return("4106: Ошибка при изменении для графика символа и периода");
			case ERR_CHART_WRONG_PARAMETER:              return("4107: Ошибочное значение параметра для функции по работе с графиком");
			case ERR_CHART_CANNOT_CREATE_TIMER:          return("4108: Ошибка при создании таймера");
			case ERR_CHART_WRONG_PROPERTY:               return("4109: Ошибочный идентификатор свойства графика");
			case ERR_CHART_SCREENSHOT_FAILED:            return("4110: Ошибка при создании скриншота");
			case ERR_CHART_NAVIGATE_FAILED:              return("4111: Ошибка навигации по графику");
			case ERR_CHART_TEMPLATE_FAILED:              return("4112: Ошибка при применении шаблона");
			case ERR_CHART_WINDOW_NOT_FOUND:             return("4113: Подокно, содержащее указанный индикатор, не найдено");
			case ERR_CHART_INDICATOR_CANNOT_ADD:         return("4114: Ошибка при добавлении индикатора на график");
			case ERR_CHART_INDICATOR_CANNOT_DEL:         return("4115: Ошибка при удалении индикатора с графика");
			case ERR_CHART_INDICATOR_NOT_FOUND:          return("4116: Индикатор не найден на указанном графике");
			// Графические объекты
			case ERR_OBJECT_ERROR:                       return("4201: Ошибка при работе с графическим объектом");
			case ERR_OBJECT_NOT_FOUND:                   return("4202: Графический объект не найден");
			case ERR_OBJECT_WRONG_PROPERTY:              return("4203: Ошибочный идентификатор свойства графического объекта");
			case ERR_OBJECT_GETDATE_FAILED:              return("4204: Невозможно получить дату, соответствующую значению");
			case ERR_OBJECT_GETVALUE_FAILED:             return("4205: Невозможно получить значение, соответствующее дате");
			// MarketInfo
			case ERR_MARKET_UNKNOWN_SYMBOL:              return("4301: Неизвестный символ");
			case ERR_MARKET_NOT_SELECTED:                return("4302: Символ не выбран в MarketWatch");
			case ERR_MARKET_WRONG_PROPERTY:              return("4303: Ошибочный идентификатор свойства символа");
			case ERR_MARKET_LASTTIME_UNKNOWN:            return("4304: Время последнего тика неизвестно (тиков не было)");
			case ERR_MARKET_SELECT_ERROR:                return("4305: Ошибка добавления или удаления символа в MarketWatch");
			// Доступ к истории
			case ERR_HISTORY_NOT_FOUND:                  return("4401: Запрашиваемая история не найдена");
			case ERR_HISTORY_WRONG_PROPERTY:             return("4402: Ошибочный идентификатор свойства истории");
			case ERR_HISTORY_TIMEOUT:                    return("4403: Превышен таймаут при запросе истории");
			case ERR_HISTORY_BARS_LIMIT:                 return("4404: Количество запрашиваемых баров ограничено настройками терминала");
			case ERR_HISTORY_LOAD_ERRORS:                return("4405: Множество ошибок при загрузке истории");
			case ERR_HISTORY_SMALL_BUFFER:               return("4407: Принимающий массив слишком мал чтобы вместить все запрошенные данные");
			// Global_Variables
			case ERR_GLOBALVARIABLE_NOT_FOUND:           return("4501: Глобальная переменная клиентского терминала не найдена");
			case ERR_GLOBALVARIABLE_EXISTS:              return("4502: Глобальная переменная клиентского терминала с таким именем уже существует");
			case ERR_GLOBALVARIABLE_NOT_MODIFIED:        return("4503: Не было модификаций глобальных переменных");
			case ERR_GLOBALVARIABLE_CANNOTREAD:          return("4504: Не удалось открыть и прочитать файл со значениями глобальных переменных");
			case ERR_GLOBALVARIABLE_CANNOTWRITE:         return("4505: Не удалось записать файл со значениями глобальных переменных");
			case ERR_MAIL_SEND_FAILED:                   return("4510: Не удалось отправить письмо");
			case ERR_PLAY_SOUND_FAILED :                 return("4511: Не удалось воспроизвести звук");
			case ERR_MQL5_WRONG_PROPERTY :               return("4512: Ошибочный идентификатор свойства программы");
			case ERR_TERMINAL_WRONG_PROPERTY:            return("4513: Ошибочный идентификатор свойства терминала");
			case ERR_FTP_SEND_FAILED:                    return("4514: Не удалось отправить файл по ftp");
			case ERR_NOTIFICATION_SEND_FAILED:           return("4515: Не удалось отправить уведомление");
			case ERR_NOTIFICATION_WRONG_PARAMETER:       return("4516: Неверный параметр для отправки уведомления – в функцию SendNotification()  передали пустую строку или NULL");
			case ERR_NOTIFICATION_WRONG_SETTINGS:        return("4517: Неверные настройки уведомлений в терминале (не указан ID или не выставлено разрешение)");
			case ERR_NOTIFICATION_TOO_FREQUENT:          return("4518: Слишком частая отправка уведомлений");
			case ERR_FTP_NOSERVER:                       return("4519: Не указан FTP сервер");
			case ERR_FTP_NOLOGIN:                        return("4520: Не указан FTP логин");
			case ERR_FTP_FILE_ERROR:                     return("4521: Не найден файл в директории MQL5\\Files для отправки на FTP сервер");
			case ERR_FTP_CONNECT_FAILED:                 return("4522: Ошибка при подключении к FTP серверу");
			case ERR_FTP_CHANGEDIR:                      return("4523: На FTP сервере не найдена директория для выгрузки файла ");
			case ERR_FTP_CLOSED:                        return("4524: Подключение к FTP серверу закрыто");
			// Буферы пользовательских индикаторов
			case ERR_BUFFERS_NO_MEMORY:                  return("4601: Недостаточно памяти для распределения индикаторных буферов");
			case ERR_BUFFERS_WRONG_INDEX:                return("4602: Ошибочный индекс своего индикаторного буфера");
			// Свойства пользовательских индикаторов
			case ERR_CUSTOM_WRONG_PROPERTY:              return("4603: Ошибочный идентификатор свойства пользовательского индикатора");
			// Account
			case ERR_ACCOUNT_WRONG_PROPERTY:             return("4701: Ошибочный идентификатор свойства счета");
			case ERR_TRADE_WRONG_PROPERTY:               return("4751: Ошибочный идентификатор свойства торговли");
			case ERR_TRADE_DISABLED:                     return("4752: Торговля для эксперта запрещена");
			case ERR_TRADE_POSITION_NOT_FOUND:           return("4753: Позиция не найдена");
			case ERR_TRADE_ORDER_NOT_FOUND:              return("4754: Ордер не найден");
			case ERR_TRADE_DEAL_NOT_FOUND:               return("4755: Сделка не найдена");
			case ERR_TRADE_SEND_FAILED:                  return("4756: Не удалось отправить торговый запрос");
			case ERR_TRADE_CALC_FAILED:                  return("4758: Не удалось вычислить значение прибыли или маржи");
			// Индикаторы
			case ERR_INDICATOR_UNKNOWN_SYMBOL:           return("4801: Неизвестный символ");
			case ERR_INDICATOR_CANNOT_CREATE:            return("4802: Индикатор не может быть создан");
			case ERR_INDICATOR_NO_MEMORY:                return("4803: Недостаточно памяти для добавления индикатора");
			case ERR_INDICATOR_CANNOT_APPLY:             return("4804: Индикатор не может быть применен к другому индикатору");
			case ERR_INDICATOR_CANNOT_ADD:               return("4805: Ошибка при добавлении индикатора");
			case ERR_INDICATOR_DATA_NOT_FOUND:           return("4806: Запрошенные данные не найдены");
			case ERR_INDICATOR_WRONG_HANDLE:             return("4807: Ошибочный хэндл индикатора");
			case ERR_INDICATOR_WRONG_PARAMETERS:         return("4808: Неправильное количество параметров при создании индикатора");
			case ERR_INDICATOR_PARAMETERS_MISSING:       return("4809: Отсутствуют параметры при создании индикатора");
			case ERR_INDICATOR_CUSTOM_NAME:              return("4810: Первым параметром в массиве должно быть имя пользовательского индикатора");
			case ERR_INDICATOR_PARAMETER_TYPE:           return("4811: Неправильный тип параметра в массиве при создании индикатора");
			case ERR_INDICATOR_WRONG_INDEX:              return("4812: Ошибочный индекс запрашиваемого индикаторного буфера");
			// Стакан цен
			case ERR_BOOKS_CANNOT_ADD:                   return("4901: Стакан цен не может быть добавлен");
			case ERR_BOOKS_CANNOT_DELETE:                return("4902: Стакан цен не может быть удален");
			case ERR_BOOKS_CANNOT_GET:                   return("4903: Данные стакана цен не могут быть получены");
			case ERR_BOOKS_CANNOT_SUBSCRIBE:             return("4904: Ошибка при подписке на получение новых данных стакана цен");
			// Файловые операции
			case ERR_TOO_MANY_FILES:                     return("5001: Не может быть открыто одновременно более 64 файлов");
			case ERR_WRONG_FILENAME:                     return("5002: Недопустимое имя файла");
			case ERR_TOO_LONG_FILENAME:                  return("5003: Слишком длинное имя файла");
			case ERR_CANNOT_OPEN_FILE:                   return("5004: Ошибка открытия файла");
			case ERR_FILE_CACHEBUFFER_ERROR:             return("5005: Недостаточно памяти для кеша чтения");
			case ERR_CANNOT_DELETE_FILE:                 return("5006: Ошибка удаления файла");
			case ERR_INVALID_FILEHANDLE:                 return("5007: Файл с таким хэндлом уже был закрыт, либо не открывался вообще");
			case ERR_WRONG_FILEHANDLE:                   return("5008: Ошибочный хэндл файла");
			case ERR_FILE_NOTTOWRITE:                    return("5009: Файл должен быть открыт для записи");
			case ERR_FILE_NOTTOREAD:                     return("5010: Файл должен быть открыт для чтения");
			case ERR_FILE_NOTBIN:                        return("5011: Файл должен быть открыт как бинарный");
			case ERR_FILE_NOTTXT:                        return("5012: Файл должен быть открыт как текстовый");
			case ERR_FILE_NOTTXTORCSV:                   return("5013: Файл должен быть открыт как текстовый или CSV");
			case ERR_FILE_NOTCSV:                        return("5014: Файл должен быть открыт как CSV");
			case ERR_FILE_READERROR:                     return("5015: Ошибка чтения файла");
			case ERR_FILE_BINSTRINGSIZE:                 return("5016: Должен быть указан размер строки, так как файл открыт как бинарный");
			case ERR_INCOMPATIBLE_FILE:                  return("5017: Для строковых массивов должен быть текстовый файл, для остальных – бинарный");
			case ERR_FILE_IS_DIRECTORY:                  return("5018: Это не файл, а директория");
			case ERR_FILE_NOT_EXIST:                     return("5019: Файл не существует");
			case ERR_FILE_CANNOT_REWRITE:                return("5020: Файл не может быть переписан");
			case ERR_WRONG_DIRECTORYNAME:                return("5021: Ошибочное имя директории");
			case ERR_DIRECTORY_NOT_EXIST:                return("5022: Директория не существует");
			case ERR_FILE_ISNOT_DIRECTORY:               return("5023: Это файл, а не директория");
			case ERR_CANNOT_DELETE_DIRECTORY:            return("5024: Директория не может быть удалена");
			case ERR_CANNOT_CLEAN_DIRECTORY:             return("5025: Не удалось очистить директорию (возможно, один или несколько файлов заблокированы и операция удаления не удалась)");
			case ERR_FILE_WRITEERROR:                    return("5026: Не удалось записать ресурс в файл");
			case ERR_FILE_ENDOFFILE:                     return("5027: Не удалось прочитать следующую порцию данных из CSV-файла (FileReadString, FileReadNumber, FileReadDatetime, FileReadBool), так как достигнут конец файла");
			// Преобразование строк
			case ERR_NO_STRING_DATE:                     return("5030: В строке нет даты");
			case ERR_WRONG_STRING_DATE:                  return("5031: В строке ошибочная дата");
			case ERR_WRONG_STRING_TIME:                  return("5032: В строке ошибочное время");
			case ERR_STRING_TIME_ERROR:                  return("5033: Ошибка преобразования строки в дату");
			case ERR_STRING_OUT_OF_MEMORY:               return("5034: Недостаточно памяти для строки");
			case ERR_STRING_SMALL_LEN:                   return("5035: Длина строки меньше, чем ожидалось");
			case ERR_STRING_TOO_BIGNUMBER:               return("5036: Слишком большое число, больше, чем ULONG_MAX");
			case ERR_WRONG_FORMATSTRING:                 return("5037: Ошибочная форматная строка");
			case ERR_TOO_MANY_FORMATTERS:                return("5038: Форматных спецификаторов больше, чем параметров");
			case ERR_TOO_MANY_PARAMETERS:                return("5039: Параметров больше, чем форматных спецификаторов");
			case ERR_WRONG_STRING_PARAMETER:             return("5040: Испорченный параметр типа string");
			case ERR_STRINGPOS_OUTOFRANGE:               return("5041: Позиция за пределами строки");
			case ERR_STRING_ZEROADDED:                   return("5042: К концу строки добавлен 0, бесполезная операция");
			case ERR_STRING_UNKNOWNTYPE:                 return("5043: Неизвестный тип данных при конвертации в строку");
			case ERR_WRONG_STRING_OBJECT:                return("5044: Испорченный объект строки");
			// Работа с массивами
			case ERR_INCOMPATIBLE_ARRAYS:                return("5050: Копирование несовместимых массивов. Строковый массив может быть скопирован только в строковый, а числовой массив – в числовой");
			case ERR_SMALL_ASSERIES_ARRAY:               return("5051: Приемный массив объявлен как AS_SERIES, и он недостаточного размера");
			case ERR_SMALL_ARRAY:                        return("5052: Слишком маленький массив, стартовая позиция за пределами массива");
			case ERR_ZEROSIZE_ARRAY:                     return("5053: Массив нулевой длины");
			case ERR_NUMBER_ARRAYS_ONLY:                 return("5054: Должен быть числовой массив");
			case ERR_ONEDIM_ARRAYS_ONLY:                 return("5055: Должен быть одномерный массив");
			case ERR_SERIES_ARRAY:                       return("5056: Таймсерия не может быть использована");
			case ERR_DOUBLE_ARRAY_ONLY:                  return("5057: Должен быть массив типа double");
			case ERR_FLOAT_ARRAY_ONLY:                   return("5058: Должен быть массив типа float");
			case ERR_LONG_ARRAY_ONLY:                    return("5059: Должен быть массив типа long");
			case ERR_INT_ARRAY_ONLY:                     return("5060: Должен быть массив типа int");
			case ERR_SHORT_ARRAY_ONLY:                   return("5061: Должен быть массив типа short");
			case ERR_CHAR_ARRAY_ONLY:                    return("5062: Должен быть массив типа char");
			case ERR_STRING_ARRAY_ONLY:                  return("5063: Должен быть массив типа string");
			// Работа с OpenCL
			case ERR_OPENCL_NOT_SUPPORTED:               return("5100: Функции OpenCL на данном компьютере не поддерживаются");
			case ERR_OPENCL_INTERNAL:                    return("5101: Внутренняя ошибка при выполнении OpenCL");
			case ERR_OPENCL_INVALID_HANDLE:              return("5102: Неправильный хэндл OpenCL");
			case ERR_OPENCL_CONTEXT_CREATE:              return("5103: Ошибка при создании контекста OpenCL");
			case ERR_OPENCL_QUEUE_CREATE:                return("5104: Ошибка создания очереди выполнения в OpenCL");
			case ERR_OPENCL_PROGRAM_CREATE :             return("5105: Ошибка при компиляции программы OpenCL");
			case ERR_OPENCL_TOO_LONG_KERNEL_NAME:        return("5106: Слишком длинное имя точки входа (кернел OpenCL)");
			case ERR_OPENCL_KERNEL_CREATE :              return("5107: Ошибка создания кернел - точки входа OpenCL");
			case ERR_OPENCL_SET_KERNEL_PARAMETER:        return("5108: Ошибка при установке параметров для кернел OpenCL (точки входа в программу OpenCL)");
			case ERR_OPENCL_EXECUTE:                     return("5109: Ошибка выполнения программы OpenCL");
			case ERR_OPENCL_WRONG_BUFFER_SIZE:           return("5110: Неверный размер буфера OpenCL");
			case ERR_OPENCL_WRONG_BUFFER_OFFSET:         return("5111: Неверное смещение в буфере OpenCL");
			case ERR_OPENCL_BUFFER_CREATE:               return("5112: Ошибка создания буфера OpenCL");
			case ERR_OPENCL_TOO_MANY_OBJECTS:            return("5113: Превышено максимальное число OpenCL объектов");
			case ERR_OPENCL_SELECTDEVICE:                return("5114: Ошибка выбора OpenCL устройства");
			// Работа с WebRequest
			case ERR_WEBREQUEST_INVALID_ADDRESS:         return("5200: URL не прошел проверку");
			case ERR_WEBREQUEST_CONNECT_FAILED:          return("5201: Не удалось подключиться к указанному URL");
			case ERR_WEBREQUEST_TIMEOUT:                 return("5202: Превышен таймаут получения данных");
			case ERR_WEBREQUEST_REQUEST_FAILED:          return("5203: Ошибка в результате выполнения HTTP запроса");
			// Работа с сетью (сокетами)
			case ERR_NETSOCKET_INVALIDHANDLE:            return("5270: В функцию передан неверный хэндл сокета");
			case ERR_NETSOCKET_TOO_MANY_OPENED:          return("5271: Открыто слишком много сокетов (максимум 128)");
			case ERR_NETSOCKET_CANNOT_CONNECT:           return("5272: Ошибка соединения с удаленным хостом");
			case ERR_NETSOCKET_IO_ERROR:                 return("5273: Ошибка отправки/получения данных из сокета");
			case ERR_NETSOCKET_HANDSHAKE_FAILED:         return("5274: Ошибка установления защищенного соединения (TLS Handshake)");
			case ERR_NETSOCKET_NO_CERTIFICATE:           return("5275: Отсутствуют данные о сертификате, которым защищено подключение");
			// Пользовательские символы
			case ERR_NOT_CUSTOM_SYMBOL:                  return("5300: Должен быть указан пользовательский символ");
			case ERR_CUSTOM_SYMBOL_WRONG_NAME:           return("5301: Некорректное имя пользовательского символа. В имени символа можно использовать только латинские буквы без знаков препинания, пробелов и спецсимволов (допускаются \".\", \"_\", \"&\" и \"#\"). Не рекомендуется использовать символы <, >, :, \", /,\\, |, ?, *.");
			case ERR_CUSTOM_SYMBOL_NAME_LONG:            return("5302: Слишком длинное имя для пользовательского символа. Длина имени символа не должна превышать 32 знака с учётом завершающего 0");
			case ERR_CUSTOM_SYMBOL_PATH_LONG:            return("5303: Слишком длинный путь для пользовательского символа. Длина пути не более 128 знаков с учётом \"Custom\\\\\", имени символа, разделителей групп и завершающего 0");
			case ERR_CUSTOM_SYMBOL_EXIST:                return("5304: Пользовательский символ с таким именем уже существует");
			case ERR_CUSTOM_SYMBOL_ERROR:                return("5305: Ошибка при создании, удалении или изменении пользовательского символа");
			case ERR_CUSTOM_SYMBOL_SELECTED:             return("5306: Попытка удалить пользовательский символ, выбранный в обзоре рынка (Market Watch)");
			case ERR_CUSTOM_SYMBOL_PROPERTY_WRONG:       return("5307: Неправильное свойство пользовательского символа");
			case ERR_CUSTOM_SYMBOL_PARAMETER_ERROR:      return("5308: Ошибочный параметр при установке свойства пользовательского символа");
			case ERR_CUSTOM_SYMBOL_PARAMETER_LONG:       return("5309: Слишком длинный строковый параметр при установке свойства пользовательского символа");
			case ERR_CUSTOM_TICKS_WRONG_ORDER:           return("5310: Не упорядоченный по времени массив тиков");
			// Календарь
			case ERR_CALENDAR_MORE_DATA:                 return("5400: массив мал для всего результата (отданы значения, которые поместились в массив)");
			case ERR_CALENDAR_TIMEOUT:                   return("5401: превышен таймаут ожидания ответа на запрос данных из календаря");
			case ERR_CALENDAR_NO_DATA:                   return("5402: данные не обнаружены");

#endif
		}

		if (_math.is_in_range(error_code, ERR_USER_ERROR_FIRST, ERR_USER_ERROR_FIRST + USHORT_MAX - 1))
			return("Пользовательская ошибка #" + string(error_code));

		return("Неизвестная ошибка #" + string(error_code));
	}

} _err;
