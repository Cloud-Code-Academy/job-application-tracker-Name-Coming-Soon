public with sharing class EventTriggerHandler {

    //get list of events at the time that matches the new event
    public static void calendarValidation(List<Event> newEvents) {
        
        for (Event event : newEvents) {
            //not on weekends
            if (event.StartDateTime.format('EEEE') == 'Sunday' || event.StartDateTime.format('EEEE') == 'Saturday') {
                event.addError('This is a weekend. Please select a different day.');
            } else if (event.StartDateTime.date() < Date.today()) {
            //not in the past
                event.addError('You cannot schedule an event in the past.');
            }  else if (event.StartDateTime != null) {
                List<Event> existingEvents = [SELECT Id, StartDateTime FROM Event WHERE StartDateTime = :event.StartDateTime];
                if (existingEvents.size() > 0) {
            //not at the same time as another event
                    event.StartDateTime.addError('An event already exists at this time. Please reschedule.');
                }
            }    
        }
    }

    //check if event is on a public holiday
    public static void holidayValidation(List<Event> newEvents) {
        List<Holiday> holidays = [SELECT ActivityDate, Name  FROM Holiday];
        System.debug('Holidays: ' + holidays);

        Set<Date> holidayDates = new Set<Date>();
        for (Holiday holiday : holidays) {
            holidayDates.add(holiday.ActivityDate);
        }

        for (Event event : newEvents) {
            if (holidayDates.contains(event.StartDateTime.date())){ 
                event.addError('This is a holiday. Please select a different day.');
            }
        }
    }
}