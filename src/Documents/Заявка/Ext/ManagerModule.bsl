﻿
Процедура Печать(ТабДок, Ссылка) Экспорт
	//{{_КОНСТРУКТОР_ПЕЧАТИ(Печать)
	Макет = Документы.Заявка.ПолучитьМакет("Печать");
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Заявка.Гражданство,
	|	Заявка.Дата,
	|	Заявка.ДатаРождения,
	|	Заявка.ЖелаемаяДолжность,
	|	Заявка.Пол,
	|	Заявка.ПолноеИмя,
	|	Заявка.ПослевузовскоеОбразование,
	|	Заявка.Стаж,
	|	Заявка.УченаяСтепень,
	|	Заявка.Образование.(
	|		НомерСтроки,
	|		НаименовниеУЗ,
	|		АдресУЗ,
	|		ФакультетИлиОтделение,
	|		ГодПоступления,
	|		ГодОкончанияИлиУхода,
	|		КурсПриОкончанииИлиУходе,
	|		Специальность,
	|		СерияДипломаУдостоверения,
	|		НомерДипломаУдостоверения
	|	),
	|	Заявка.СписокМестРаботы.(
	|		НомерСтроки,
	|		МесяцИГодПоступления,
	|		МесяцИГодУхода,
	|		Должность,
	|		НаименованиеОрганизации,
	|		АдресОрганизации
	|	)
	|ИЗ
	|	Документ.Заявка КАК Заявка
	|ГДЕ
	|	Заявка.Ссылка В (&Ссылка)";
	Запрос.Параметры.Вставить("Ссылка", Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();

	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	Шапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьОбразованиеШапка = Макет.ПолучитьОбласть("ОбразованиеШапка");
	ОбластьОбразование = Макет.ПолучитьОбласть("Образование");
	ОбластьСписокМестРаботыШапка = Макет.ПолучитьОбласть("СписокМестРаботыШапка");
	ОбластьСписокМестРаботы = Макет.ПолучитьОбласть("СписокМестРаботы");   
	ОбластьМестоДляПодписи = Макет.ПолучитьОбласть("МестоДляПодписи");
	ТабДок.Очистить();

	ВставлятьРазделительСтраниц = Ложь;
	Пока Выборка.Следующий() Цикл
		Если ВставлятьРазделительСтраниц Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;

		ТабДок.Вывести(ОбластьЗаголовок);

		Шапка.Параметры.Заполнить(Выборка);
		ТабДок.Вывести(Шапка, Выборка.Уровень());

		ТабДок.Вывести(ОбластьОбразованиеШапка);
		ВыборкаОбразование = Выборка.Образование.Выбрать();
		Пока ВыборкаОбразование.Следующий() Цикл
			ОбластьОбразование.Параметры.Заполнить(ВыборкаОбразование);
			ТабДок.Вывести(ОбластьОбразование, ВыборкаОбразование.Уровень());
		КонецЦикла;

		ТабДок.Вывести(ОбластьСписокМестРаботыШапка);
		ВыборкаСписокМестРаботы = Выборка.СписокМестРаботы.Выбрать();
		Пока ВыборкаСписокМестРаботы.Следующий() Цикл
			ОбластьСписокМестРаботы.Параметры.Заполнить(ВыборкаСписокМестРаботы);
			ТабДок.Вывести(ОбластьСписокМестРаботы, ВыборкаСписокМестРаботы.Уровень());
		КонецЦикла;

		ВставлятьРазделительСтраниц = Истина;
	КонецЦикла;
	ТабДок.Вывести(ОбластьМестоДляПодписи);
	//}}
КонецПроцедуры
