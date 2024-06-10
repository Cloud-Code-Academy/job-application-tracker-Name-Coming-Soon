/**
 * Schedule a reminder to send the email. We only need schedule
 * the reminder once since it triggers every day at 11:30 pm after
 * that
 */
public with sharing class InterviewEmailTriggerHelper {
    /*schedule the reminder once, after that it triggers at 11:30 pm daily*/
    public static void schedReminder(String schDayBefore) {
        List<CronTrigger> scheduledJobs = [SELECT Id, CronJobDetail.Name, CronJobDetail.JobType, State, NextFireTime, StartTime
                                            FROM CronTrigger WHERE CronJobDetail.Name = :'InterviewReminder'];
        /*Check if this job was already shcheduled */
        if (scheduledJobs.size() == 0) {
            String schString = 'InterviewReminder';
            InterviewEmail_Schedulable jobReminder = new InterviewEmail_Schedulable();
            System.schedule(schString, schDayBefore, jobReminder);
        } else {
            return;
        }
    }

    //basic checks to see if we have a sane value of Interview date/time(not Null/not in the past)
    public static Integer checkIntTime(Job_Interview__c newInterview) {
        Date intDate = newInterview.Interview_Date__c;
        Time intTime = newInterview.Interview_Time__c;
        DateTime currentDateTime = DateTime.now();

        if (intdate == Null || intTime != Null) {
            return -1;
        }
        if (intDate < currentDateTime.date() || (intDate == currentDateTime.date() && intTime < currentDateTime.time())) {
            return -1;
        }
        return 0;
    }

    public static void schdInterviewReminder (List <Job_Interview__c> jobList) {
        for (Job_Interview__c newInterview : jobList) { 
            Date intDate = newInterview.Interview_Date__c;
            Time intTime = newInterview.Interview_Time__c;

            if (checkIntTime(newInterview) != 0) {
                String minute = intTime.addMinutes(2).minute().toString(); 
                String hour = intTime.hour().toString();
                String day = (intDate.day() - 1).toString();

                //Schedule Job to run everyday at 11:30 pm
                schedReminder('0 30 23 * * ?');
            } else {
                newInterview.addError('Date or time cant be null or invalid');
            }
        }
    }
}