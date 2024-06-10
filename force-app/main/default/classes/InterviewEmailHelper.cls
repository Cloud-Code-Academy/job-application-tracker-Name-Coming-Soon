public with sharing class InterviewEmailHelper {
    public static void schedReminder(String schDayBefore) {
        List<CronTrigger> scheduledJobs = [SELECT Id, CronJobDetail.Name, CronJobDetail.JobType, State, NextFireTime, StartTime
                                            FROM CronTrigger WHERE CronJobDetail.Name = :'InterviewReminder'];
        if (scheduledJobs.size() == 0) {
            String schString = 'InterviewReminder';
            InterviewEmail jobReminder = new InterviewEmail();
            System.debug('Add interview reminder + ' + schDayBefore);
            System.schedule(schString, schDayBefore, jobReminder);
        } else {
            return;
        }
    }

    public static void schdInterviewReminder (List <Job_Interview__c> jobList) {
        String schDayBefore;
        for (Job_Interview__c newInterview : jobList) { 
            Date intDate = newInterview.Interview_Date__c;
            Time intTime = newInterview.Interview_Time__c;

            if (intdate != Null && intTime != Null) {
                String minute = intTime.addMinutes(2).minute().toString(); 
                String hour = intTime.hour().toString();
                String day = (intDate.day() - 1).toString();

                //Make the cron expression for the day before from the interview time and date
                schDayBefore = '0' + ' ' + minute + ' ' + hour + ' '  + day + ' '  + intDate.month() + ' '  + '?' + ' ' + intDate.year();
                schedReminder(schDayBefore);
            } else {
                newInterview.addError('Date or time cant be null or invalid');
            }
        }
    }
}