﻿
&НаСервере
Процедура ТолькоНовыеПриИзмененииНаСервере()
	Если ПоказатьВсе = Истина Тогда
		ТекстОригинальногоЗапроса = Список.ТекстЗапроса;
		Список.ТекстЗапроса = 
		"ВЫБРАТЬ
		|	Авторекомендация.Ссылка КАК Ссылка,
		|	Авторекомендация.ВерсияДанных КАК ВерсияДанных,
		|	Авторекомендация.ПометкаУдаления КАК ПометкаУдаления,
		|	Авторекомендация.Номер КАК Номер,
		|	Авторекомендация.Дата КАК Дата,
		|	Авторекомендация.Проведен КАК Проведен,
		|	Авторекомендация.Заявка КАК Заявка,
		|	Авторекомендация.ЗаключениеАвтопроверки КАК ЗаключениеАвтопроверки,
		|	Авторекомендация.Представление КАК Представление,
		|	Авторекомендация.МоментВремени КАК МоментВремени
		|ИЗ
		|	Документ.Авторекомендация КАК Авторекомендация";
		Возврат;
	КонецЕсли;
	
	Список.ТекстЗапроса = ТекстОригинальногоЗапроса;
КонецПроцедуры

&НаКлиенте
Процедура ТолькоНовыеПриИзменении(Элемент)
	ТолькоНовыеПриИзмененииНаСервере();
КонецПроцедуры
