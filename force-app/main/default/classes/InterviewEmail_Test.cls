/*
 *Test that :
 * - An interview with a NULL/Invalid time doesn't get scheduled. The expected behaciour is that
 *   the trigger for insert Job_interview_c will throw an exception
 * 
 * - A bunch of interviews with a valid time gets scheduled. 
 *   This is done by checking that our CronJob is submitted. We also check that expected number of
 *   emails have been sent
*/

@isTest
public with sharing class InterviewEmail_Test {
    @isTest
    static void interviewEmailTestInvalidDate() {
        List <User> users = new List <User> ();

        users = [SELECT ID, Email, Name FROM User];
		
        Job__c job = new Job__c(Title__c = 'Salesforce Developer',
                                Company_Name__c = 'Cloudcode');
        insert job;

        //create a job and application for a user
        Job_Application__c jobApp = new Job_Application__c(Job__c = job.id, Name='testClassJob1',
                                                           Applicant__c = users[0].id);
        insert jobApp;
        Time intTime = DateTime.now().time().addMinutes(1);
        Date intDate = Date.today().addDays(1);

        //create a job interviewe and for above application
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

    /**
     * create 4 jobs with valid date time and check that they get scheduled
     * and reminder emails are indeed sent
     */
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

        Test.startTest();
        insert jobInts;
        Test.stopTest();

        //check that our job got scheduled
        List<CronTrigger> scheduledJobs = [SELECT Id, CronJobDetail.Name, CronJobDetail.JobType, State, NextFireTime, StartTime
                                            FROM CronTrigger WHERE CronJobDetail.Name = :'InterviewReminder'];

        System.assertEquals(scheduledJobs[0].CronJobDetail.Name, 'InterviewReminder',
                        'Email reminder Job was not scheduled');

        //check that emails got sent for all 4 interviews with the right subject
        List<EmailMessage> emailMessages = [SELECT Id, Subject, TextBody FROM EmailMessage];
        System.assertEquals(emailMessages.size(), 4, 'Expected 4 emails' + 'Sent ' + emailMessages.size());
    }
}