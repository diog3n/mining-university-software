﻿
&НаКлиенте
Процедура КнопкаОтправить(Команда)
	СтрокаСообщения = Объект.Сообщения.Добавить();
	
	СтрокаСообщения.Сообщение       = ПолеСообщения;
	СтрокаСообщения.Время           = ЗапроситьВремяНаСервере();
	СтрокаСообщения.ИмяПользователя = ЗапроситьИмяПользователя();

	ПолеСообщения = "";
	
	КнопкаОтправитьНаСервере();
КонецПроцедуры

&НаСервере
Функция ЗапроситьВремяНаСервере()
	Возврат ТекущаяДата();
КонецФункции

&НаСервере
Функция ЗапроситьИмяПользователя()
	Возврат ПользователиИнформационнойБазы.ТекущийПользователь().Имя;
КонецФункции

&НаСервере
Процедура КнопкаОтправитьНаСервере()
	Записать();
КонецПроцедуры

&НаКлиенте
Процедура КнопкаЗакрыть(Команда)
	КнопкаЗакрытьНаСервере();
	Закрыть();
КонецПроцедуры

&НаСервере
Процедура КнопкаЗакрытьНаСервере()
	Записать();
КонецПроцедуры

&НаСервере
Процедура ПриЗакрытииНаСервере()
	Записать();
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	ПриЗакрытииНаСервере();
КонецПроцедуры
