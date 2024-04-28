@isTest
public with sharing class CloseStaleApplications_Test {
    @IsTest
    public static void testCloseStaleApplications_Schedule() {
        
         // Call the TestDataFactory class to create test data
        List<Job_Application__c> testJobApplications = TestDataFactory.createTestData();
        Job_Application__c testJobApplication = testJobApplications[0];

        // Schedule the CloseStaleApplications_Schedulable class for execution
        Test.startTest();
        CloseStaleApplications_Schedulable closeStaleApplications = new CloseStaleApplications_Schedulable();
        String year = String.valueOf(Date.today().year() + 1);
        String cron = '0 0 0 15 3 ? ' + year; // Arbitrary cron expression for once-off execution in the future
        //Seconds Minutes Hours Day_of_month Month Day_of_week Optional_year
        //'?' Specifies no specific value. This option is only available for Day_of_month and Day_of_week. It’s typically used when specifying a value for one and not the other.
        System.debug('cron: ' + cron);
        System.schedule('CloseStaleApplsTest', cron, closeStaleApplications);
        closeStaleApplications.execute(null);
        Test.stopTest();

        

        // Query the updated job applications
        List<Job_Application__c> updatedJobApplications = [SELECT Id, Status__c 
                                                            FROM Job_Application__c 
                                                            WHERE Id = :testJobApplication.Id];
        System.debug('updatedJobApplications: ' + updatedJobApplications);
    

        // Assert that all job applications's Status__c fields are updated
        for (Job_Application__c jobApp : updatedJobApplications) {
            System.assertEquals('Closed', jobApp.Status__c, 'Job Application Status__c field was not updated correctly.');
        }
    }
}