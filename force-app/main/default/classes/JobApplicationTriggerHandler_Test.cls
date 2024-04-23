@isTest
public with sharing class JobApplicationTriggerHandler_Test {

    @isTest
    static void testCreateTaskFromStatus() {
        // Test data setup
        
        Account testAccount1 = new Account(Name = 'Test Account');
        insert testAccount1;

        List<Contact> testContacts = new List<Contact>();
        Contact testContact1 = new Contact(LastName = 'Test', AccountId = testAccount1.Id, Role__c = 'Recruiter');
        insert testContact1;

        Job__c testJob = new Job__c(Name = 'Test Job', Company__c = testAccount1.Id);
        insert testJob;

        Job_Application__c testJobApplication = new Job_Application__c(
            Name = 'Test Job Application',
            Company_Name__c = testAccount1.id,
            Job__c = testJob.Id,
            Applicant__c = [SELECT Id FROM User WHERE IsActive = true LIMIT 1].Id,
            Primary_Contact__c = testContact1.Id,
            Status__c = 'Saved'
        );
        
        insert testJobApplication;
        System.debug('The test application: ' + testJobApplication);

        // Test execution
        Test.startTest();
        JobApplicationTriggerHandler.createTaskFromStatus(new List<Job_Application__c>{testJobApplication});
        Test.stopTest();

        // Test verification
        List<Task> tasks = [SELECT Id FROM Task WHERE Job_Application__c = :testJobApplication.Id];
        System.debug('The generated Task: ' + tasks);
        Assert.areEqual(2, tasks.size(), 'Expected 1 task to be created');
    }
}