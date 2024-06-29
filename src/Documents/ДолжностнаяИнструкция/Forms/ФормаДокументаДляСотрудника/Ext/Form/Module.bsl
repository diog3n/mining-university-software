﻿#Область ПрикладныеФункцииИПроцедуры
&НаСервере
Процедура ЗаполнитьТекстом()
	Если Объект.ТекстДолжностнойИнструкции = "" Тогда
		Элементы.ДекорацияТекстДИ.Заголовок = Объект.Подписант.Должность.ДолжностнаяИнструкция;
	Иначе
		Элементы.ДекорацияТекстДИ
		.Заголовок = Объект.ТекстДолжностнойИнструкции;   
	КонецЕсли;
	
	Элементы.ДекорацияНазваниеВУЗа.Заголовок = Константы.НаименованиеВУЗа.Получить();
КонецПроцедуры

&НаСервере
Процедура ПоказатьТекст()
	ЗаполнитьТекстом();
	Элементы.ГруппаПоложенияДолжностнойИнструкции.Видимость = Истина;
КонецПроцедуры

&НаСервере
Процедура СкрытьТекст()
	Элементы.ГруппаПоложенияДолжностнойИнструкции.Видимость = Ложь;	
КонецПроцедуры

&НаСервере
Процедура ОбновитьВидимостьТекста()
	Если Объект.Подписант.Должность.Пустая() Тогда
		СкрытьТекст();
	Иначе
		ПоказатьТекст();
	КонецЕсли;
КонецПроцедуры

Процедура ОбновитьДоступностьФормы()
	ЭтаФорма.ТолькоПросмотр = Истина; 
	ЭтаФорма.КоманднаяПанель.Доступность = Не Объект.Подписан;  
КонецПроцедуры
#КонецОбласти

#Область ОбработчикиСобытий
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("Подписант") Тогда
		Объект.Подписант = Параметры.Подписант;
	КонецЕсли;
	
	ОбновитьВидимостьТекста();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбновитьВидимостьТекста();
	ОбновитьДоступностьФормы();
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	Объект.ТекстДолжностнойИнструкции = Элементы.ДекорацияТекстДИ.Заголовок;
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	Сотрудник = ТекущийОбъект.Подписант.ПолучитьОбъект();
	Сотрудник.ДолжностнаяИнструкция = ТекущийОбъект.Ссылка;
	Сотрудник.Записать();
КонецПроцедуры

&НаКлиенте
Процедура ПодписантПриИзменении(Элемент)
	ОбновитьВидимостьТекста();
КонецПроцедуры

&НаСервере
Процедура ДобавитьВЛичныйКабинет()
	Сотрудник = Объект.Подписант.ПолучитьОбъект();
	Попытка
		Сотрудник.Заблокировать();
		Сотрудник.ДолжностнаяИнструкция = Объект.Ссылка;
		Сотрудник.Записать();
		Сотрудник.Разблокировать();
	Исключение
		Сообщить("Объект сейчас используется. Попробуйте позже.", СтатусСообщения.Важное);
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоставитьПодпись()
	Объект.Подписан = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПровестиДокумент()
	ПараметрыЗаписи = Новый Структура("РежимЗаписи, Закрыть", РежимЗаписиДокумента.Проведение, Ложь);
	Записать(ПараметрыЗаписи);
КонецПроцедуры

&НаКлиенте
Процедура КнопкаПодписать(Команда)
	ПоставитьПодпись();
	ПровестиДокумент();
	ОбновитьДоступностьФормы();
КонецПроцедуры     

&НаКлиенте
Процедура КнопкаПодписатьИЗакрыть(Команда)
	ПоставитьПодпись();
	ПровестиДокумент();
	Закрыть();
КонецПроцедуры
#КонецОбласти