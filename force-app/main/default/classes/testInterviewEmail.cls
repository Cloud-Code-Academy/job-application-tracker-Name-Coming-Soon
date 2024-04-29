/*
 * Test that :
 *  - An interview with a NULL/Invalid time doesn't get scheduled. The expected behaciour is that
 *   the trigger for insert will throw an exception
 *  - A test interview with a valid time gets scheduled. 
 *   This is done by checking if there is a cron expression with the same time as ours scheduled Email Job
 *   in the list of Cron Triggers
*/

@isTest
public with sharing class testInterviewEmail {
    @isTest
    static void interviewEmailTestvalidDate() {
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
        Job_Interview__c jobInt = new Job_Interview__c(Interview_Time__c = intTime,
                                                       Interview_Date__c = intDate,
                                                       Job_Application__c = jobApp.id);
		
        Job_Interview__c jobInt2 = new Job_Interview__c(Interview_Time__c = NULL,
                                                       Interview_Date__c = intDate,
                                                       Job_Application__c = jobApp.id);
		//Check that a NULL time throws exception
        Test.startTest();
		//Assert
        try {
    		insert jobInt2;
		} catch (DmlException e)  {
            Assert.isTrue(e.getMessage().contains('Date or time cant be null or invalid'), 'Unexpected exception on insert');
		}
        insert jobInt;
        Test.stopTest();

        String minute = intTime.minute().toString(); //can't be typcast
        String hour = intTime.hour().toString();
        String day = (intDate.day() - 1).toString();
        String schDayBefore = '0' + ' ' + minute + ' ' + hour + ' '  + day + ' '  + intDate.month() + ' '  + '?' + ' ' + intDate.year();

        List<CronTrigger> ct = [SELECT Id, CronExpression, TimesTriggered, 
        NextFireTime
        FROM CronTrigger];

       // check that the apex job for sending email was scheduled
       Integer foundCron;
	   for (CronTrigger ctSch : ct) {
           if (schDayBefore.equals(ctSch.CronExpression)) {
               foundCron = 1;
           }
	   }
       Assert.areEqual(1, foundCron, 'cron job for email not scheduled');
    }
}