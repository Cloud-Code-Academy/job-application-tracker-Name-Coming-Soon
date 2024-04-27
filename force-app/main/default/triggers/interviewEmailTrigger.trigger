trigger interviewEmailTrigger on Job_Interview__c (after insert, after update) {
        system.debug('>>>>>>>>>>>>>>>>>interviewEmailTrigger');
        //system.debug(' >> trigger.new ' + trigger.new);
        String schDayBefore;
        for (Job_Interview__c newInterview : trigger.new) {
            
            System.debug('>>> date: ' + newInterview.Interview_Date__c);
            System.debug('>>> time : ' + newInterview.Interview_Time__c);
            Date intDate = newInterview.Interview_Date__c;
            Time intTime = newInterview.Interview_Time__c;
            if (intdate != Null && intTime != Null) {
                String minute = intTime.minute().toString(); //can't be typcast
                String hour = intTime.hour().toString();
                System.debug('day >> ' + intDate.day());
                String day = (intDate.day() - 1).toString();
                schDayBefore = '0' + ' ' + minute + ' ' + hour + ' '  + day + ' '  + intDate.month() + ' '  + '?' + ' ' + intDate.year();
                System.debug('schDayBefore + ' + schDayBefore);
              

                String schString = 'Scheduled Interview' + math.random();
                interviewEmail jobReminder = new interviewEmail(newInterview.Id);
                String jobID = System.schedule(schString, schDayBefore, jobReminder);
                System.debug('Scheduled Job ID: ' + jobID);
            }
        }
}