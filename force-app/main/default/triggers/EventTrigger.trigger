trigger EventTrigger on Event (before insert, before update) {
	EventTriggerHandler.calendarValidation(Trigger.new);
	EventTriggerHandler.holidayValidation(Trigger.new);
}