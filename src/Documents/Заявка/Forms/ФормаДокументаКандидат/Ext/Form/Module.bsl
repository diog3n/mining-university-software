﻿#Область ОбработчикиСобытий
&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	#Область СозданиеДокументаАвторекомендаци
	РежимЗаписи     = РежимЗаписиДокумента.Запись;
	
	Авторекомендация = Документы.Авторекомендация.СоздатьДокумент();
	Авторекомендация.Дата = ТекущийОбъект.Дата;
	Авторекомендация.Заявка = ТекущийОбъект.Ссылка;
	
	ПравилоОтбора = Новый Структура("ДолжностьПоШтатномуРасписанию");
	ПравилоОтбора.ДолжностьПоШтатномуРасписанию = ТекущийОбъект.ЖелаемаяДолжность;
	ТребованияВыборка = Справочники.БазовыеТребованияКВакансии.Выбрать( , , ПравилоОтбора, );									  
		
	Если Не ТребованияВыборка.Следующий() Тогда
		Авторекомендация.ЗаключениеАвтопроверки = Перечисления.ЗаключениеАвтопроверки.ТребованиеНеНайдено;
		Авторекомендация.Записать();
		Возврат;
	КонецЕсли;	
	
	Требования = ТребованияВыборка;
    #КонецОбласти

	#Область ПроверкаЗаявкиНаСоответствиеТребованиям
	Заявка = ТекущийОбъект;
		
	// Проверка наличия послевузовского образования
	Если Заявка.ПослевузовскоеОбразование = Перечисления.ПослевузовскоеОбразование.Нет Тогда
		// Проверка стажа 
		Если Заявка.Стаж < Требования.МинимальныйСтаж Тогда
			Авторекомендация.ЗаключениеАвтопроверки = Перечисления.ЗаключениеАвтопроверки.Отказать;
			Авторекомендация.Записать();
			Возврат;
		КонецЕсли;
		
		// Вынести заключение и прекратить выполнение
		Авторекомендация.ЗаключениеАвтопроверки = Перечисления.ЗаключениеАвтопроверки.Пригласить;
		Авторекомендация.Записать();
		Возврат;	
	КонецЕсли;
	
	// Проверка минимального стажа при наличии послевузовского образования
	Если Заявка.Стаж < Требования.МинимальныйСтажПриНаличииОбразования Тогда
		Авторекомендация.ЗаключениеАвтопроверки = Перечисления.ЗаключениеАвтопроверки.Отказать;
		Авторекомендация.Записать();
		Возврат;
	КонецЕсли;
	
	// Проверка ученой степени
	ТребуемаяУченаяСтепень = ОбщиеФункцииПроцедуры.УченаяСтепеньВЧисло(Требования.МинимальнаяУченаяСтепень);
	УченаяСтепеньЗаявки    = ОбщиеФункцииПроцедуры.УченаяСтепеньВЧисло(Заявка.УченаяСтепень);
	
	Если УченаяСтепеньЗаявки < ТребуемаяУченаяСтепень Тогда
		Авторекомендация.ЗаключениеАвтопроверки = Перечисления.ЗаключениеАвтопроверки.Отказать;
		Авторекомендация.Записать();
        Возврат;
	КонецЕсли;
	
	Авторекомендация.ЗаключениеАвтопроверки = Перечисления.ЗаключениеАвтопроверки.Пригласить;  
	#КонецОбласти
	
	Авторекомендация.Записать();
КонецПроцедуры             

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	// Pass		  
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Сообщить("Заявка отправлена! Можно закрыть это окно.", СтатусСообщения.Информация);
КонецПроцедуры                        

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	Если Объект.Проведен Тогда
		Отказ = Истина;
		ПоказатьПредупреждение( , "Вы уже отправили заявку. Не переживайте мы ее рассматриваем!", 
								, "Повторная отправка заявки");   
		Возврат;	
	КонецЕсли;
	
	Если Объект.Образование.Количество() = 0 Тогда
		Отказ = Истина;
		ПоказатьПредупреждение( , "Укажите, пожалуйста, информацию об образовании.
								  |Сделать это можно на странице '" 
								+ Элементы.ГруппаОбразованиеИНачунаяДеятельность.Заголовок
								+ "' Спасибо!", 
								, "Вы кое-что забыли!");
		Возврат;
	КонецЕсли;
	
	Если Объект.СписокМестРаботы.Количество() = 0 Тогда
		Отказ = Истина;
		ПоказатьПредупреждение( , "Укажите, пожалуйста, информацию о местах работы.
								  |Сделать это можно на странице '" 
								+ Элементы.ГруппаОбразованиеИНачунаяДеятельность.Заголовок
								+ "' Спасибо!", 
								, "Вы кое-что забыли!");
		Возврат;
	КонецЕсли;

	Если Объект.СогласиеНаОбработкуПД = Ложь Тогда
		Отказ = Истина;
		ПоказатьПредупреждение( , "Для подачи заявки необходимо дать согласие на обработку персональных данных.
								  |Сделать это можно на странице 'Формальности'. Спасибо!", 
								, "Вы кое-что забыли!");
		Возврат;
	КонецЕсли;
КонецПроцедуры

#Область БлокировкаФормыПослеПроведения
&НаСервере
Процедура ПроверитьВозможностьРедактирования()
	Если РедактированиеЗапрещено() Тогда
    	ЭтаФорма.ТолькоПросмотр = Истина;
	КонецЕсли;
КонецПроцедуры // ЗаблокироватьОбъект()

&НаСервере
Функция РедактированиеЗапрещено()
	Возврат Объект.Проведен И Константы.ЗапретНаРедактированиеДокументов.Получить();
КонецФункции

&НаСервере
Процедура ПриОткрытииНаСервере()
	ПроверитьВозможностьРедактирования();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПриОткрытииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура КнопкаОтправить(Команда)
	КнопкаОтправитьНаСервере(); 
	
	ПараметрыЗаписи = Новый Структура("РежимЗаписи, Закрыть", РежимЗаписиДокумента.Проведение, Ложь);
	Записать(ПараметрыЗаписи);
КонецПроцедуры

&НаСервере
Процедура КнопкаОтправитьНаСервере()   
		
	
	//НоваяЗаявка = Документы.Заявка.СоздатьДокумент();
	//
	//НоваяЗаявка.Дата                      = ТекущаяДата();
	//НоваяЗаявка.Гражданство               = Объект.Гражданство;
	//НоваяЗаявка.ДатаРождения              = Объект.ДатаРождения;
	//НоваяЗаявка.ЖелаемаяДолжность         = Объект.ЖелаемаяДолжность;
	//НоваяЗаявка.ОСебе                     = Объект.ОСебе;
	//НоваяЗаявка.Пол                       = Объект.Пол;
	//НоваяЗаявка.ПолноеИмя                 = Объект.ПолноеИмя;
	//НоваяЗаявка.ПослевузовскоеОбразование = Объект.ПослевузовскоеОбразование;
	//НоваяЗаявка.СогласиеНаОбработкуПД     = Объект.СогласиеНаОбработкуПД;
	//НоваяЗаявка.Стаж                      = Объект.Стаж;
	//НоваяЗаявка.УченаяСтепень             = Объект.УченаяСтепень;
	//Для Каждого ТекСтрокаОбразование Из Объект.Образование Цикл
	//	НоваяСтрока = НоваяЗаявка.Образование.Добавить();
	//	НоваяСтрока.АдресУЗ = ТекСтрокаОбразование.АдресУЗ;
	//	НоваяСтрока.ГодОкончанияИлиУхода = ТекСтрокаОбразование.ГодОкончанияИлиУхода;
	//	НоваяСтрока.ГодПоступления = ТекСтрокаОбразование.ГодПоступления;
	//	НоваяСтрока.КурсПриОкончанииИлиУходе = ТекСтрокаОбразование.КурсПриОкончанииИлиУходе;
	//	НоваяСтрока.НаименовниеУЗ = ТекСтрокаОбразование.НаименовниеУЗ;
	//	НоваяСтрока.НомерДипломаУдостоверения = ТекСтрокаОбразование.НомерДипломаУдостоверения;
	//	НоваяСтрока.СерияДипломаУдостоверения = ТекСтрокаОбразование.СерияДипломаУдостоверения;
	//	НоваяСтрока.Специальность = ТекСтрокаОбразование.Специальность;
	//	НоваяСтрока.ФакультетИлиОтделение = ТекСтрокаОбразование.ФакультетИлиОтделение;
	//КонецЦикла;
	//Для Каждого ТекСтрокаСписокМестРаботы Из Объект.СписокМестРаботы Цикл
	//	НоваяСтрока = НоваяЗаявка.СписокМестРаботы.Добавить();
	//	НоваяСтрока.АдресОрганизации = ТекСтрокаСписокМестРаботы.АдресОрганизации;
	//	НоваяСтрока.Должность = ТекСтрокаСписокМестРаботы.Должность;
	//	НоваяСтрока.МесяцИГодПоступления = ТекСтрокаСписокМестРаботы.МесяцИГодПоступления;
	//	НоваяСтрока.МесяцИГодУхода = ТекСтрокаСписокМестРаботы.МесяцИГодУхода;
	//	НоваяСтрока.НаименованиеОрганизации = ТекСтрокаСписокМестРаботы.НаименованиеОрганизации;
	//КонецЦикла;
	//
	//НоваяЗаявка.Записать(РежимЗаписиДокумента.Проведение);
КонецПроцедуры
#КонецОбласти

#КонецОбласти

