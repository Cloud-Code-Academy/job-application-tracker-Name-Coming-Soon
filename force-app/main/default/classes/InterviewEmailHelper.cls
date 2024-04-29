public with sharing class InterviewEmailHelper {
    public static void schdInterviewReminder (List <Job_Interview__c> jobList) {
        String schDayBefore;
        for (Job_Interview__c newInterview : jobList) {
            Date intDate = newInterview.Interview_Date__c;
            Time intTime = newInterview.Interview_Time__c;

            if (intdate != Null && intTime != Null) {
                String minute = intTime.minute().toString();
                String hour = intTime.hour().toString();
                String day = (intDate.day() - 1).toString();

                //Make the cron expression for the day before from the interview time and date
                schDayBefore = '0' + ' ' + minute + ' ' + hour + ' '  + day + ' '  + intDate.month() + ' '  + '?' + ' ' + intDate.year();
                String schString = 'Scheduled Interview' + math.random();
                interviewEmail jobReminder = new interviewEmail(newInterview.Id);
                // Pass in the Interviw Id so that the SOQL query is effecient
                String jobID = System.schedule(schString, schDayBefore, jobReminder);
            } else {
                newInterview.addError('Date or time cant be null or invalid');
            }
        }
    }
}