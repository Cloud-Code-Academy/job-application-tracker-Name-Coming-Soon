/*
 * Test that :
 *  - An interview with a NULL/Invalid time doesn't get scheduled. The expected behaciour is that
 *   the trigger for insert will throw an exception
 *  - A test interview with a valid time gets scheduled. 
 *   This is done by checking if there is a cron expression with the same time as ours scheduled Email Job
 *   in the list of Cron Triggers
*/

@isTest
public with sharing class InterviewEmailTest {
    @isTest
    static void interviewEmailTestInvalidDate() {
        List <User> users = new List <User> ();

        users = [SELECT ID, Email, Name FROM User];
		
        Job__c job = new Job__c(Title__c = 'Salesforce Developer',
                                Company_Name__c = 'Cloudcode');
        insert job;
        Job_Application__c jobApp = new Job_Application__c(Job__c = job.id, Name='testClassJob1',
                                                           Applicant__c = users[0].id);
        insert jobApp;
        Time intTime = DateTime.now().time().addMinutes(1);
        Date intDate = Date.today().addDays(1);

        Job_Interview__c jobInt = new Job_Interview__c(Interview_Time__c = NULL,
                                                       Interview_Date__c = intDate,
                                                       Job_Application__c = jobApp.id);
		//Check that a NULL time throws exception
        Test.startTest();
		//Assert
        try {
    		insert jobInt;
		} catch (DmlException e)  {
            Assert.isTrue(e.getMessage().contains('Date or time cant be null or invalid'), 'Unexpected exception on insert');
		}
        Test.stopTest();
    }

    @isTest
    static void interviewEmailTestvalidDate() {
        List <User> users = new List <User> ();
        Integer i;
        
        users = [SELECT ID, Email, Name FROM User];
		
        Job__c job = new Job__c(Title__c = 'Salesforce Developer',
                                Company_Name__c = 'Cloudcode');
        insert job;
        Job_Application__c jobApp = new Job_Application__c(Job__c = job.id, Name='testClassJob1',
                                                           Applicant__c = users[0].id);
        insert jobApp;
        Time intTime = DateTime.now().time();
        Date intDate = Date.today().addDays(1);
        List <Job_Interview__c> jobInts = new List<Job_Interview__c>();

        for (i=0 ; i < 4; i++) {
            jobInts.add(new Job_Interview__c(Interview_Time__c = intTime.addMinutes(i),
                                                       Interview_Date__c = intDate,
                                                       Job_Application__c = jobApp.id));
        }
        System.debug('>>> + '  + jobInts);
		//Check that a NULL time throws exception
        Test.startTest();
        insert jobInts;
        Test.stopTest();

       List<EmailMessage> emailMessages = [SELECT Id, Subject, TextBody FROM EmailMessage];
       System.debug('emailMessages' + emailMessages);

       List<CronTrigger> scheduledJobs = [SELECT Id, CronJobDetail.Name, CronJobDetail.JobType, State, NextFireTime, StartTime
       FROM CronTrigger WHERE CronJobDetail.Name = :'InterviewReminder'];

       System.debug('>>>> ' + scheduledJobs[0].CronJobDetail.Name);
       Assert.areEqual(scheduledJobs[0].CronJobDetail.Name, 'InterviewReminder',
                        'Email reminder Job was not scheduled');
    }
}