@isTest
public with sharing class JobApplicationTriggerHandler_Test {

    @isTest
    static void testCreateTaskFromStatus() {

        // Test data setup
        List<Job_Application__c> testJobApplications = TestDataFactory.createTestData();
        Job_Application__c testJobApplication = testJobApplications[0];

        // Test execution
        Test.startTest();
        JobApplicationTriggerHandler.createTaskFromStatus(new List<Job_Application__c>{testJobApplication}, null);
        Test.stopTest();

        // Test verification
        List<Task> tasks = [SELECT Id FROM Task WHERE Job_Application__c = :testJobApplication.Id];
        System.debug('The testJobApplication.Id ' + testJobApplication.Id);
        System.debug('The generated Task: ' + tasks);
        Assert.areEqual(1, tasks.size(), 'Expected 1 task to be created');
    }

    @isTest
    static void testCreateAppFollowUpDate() {

        // Test data setup
        List<Job_Application__c> testJobApplications = TestDataFactory.createTestData();
        Job_Application__c testJobApplication = testJobApplications[0];


        // Test execution
        Test.startTest();
        JobApplicationTriggerHandler.createAppFollowUpDate(new List<Job_Application__c>{testJobApplication});
        Test.stopTest();

        // Test verification
        Job_Application__c updatedJobApplication = [SELECT Follow_up_date__c FROM Job_Application__c WHERE Id = :testJobApplication.Id];
        System.assertEquals(Date.today().addDays(30), updatedJobApplication.Follow_up_date__c, 'Follow-up date not set correctly');
    }
    
}
