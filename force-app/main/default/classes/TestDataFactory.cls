public class TestDataFactory {

    public static List<Job_Application__c> createTestData() {
        // Test data setup. Not bulkified.

        // Create Account
        Account testAccount1 = new Account(Name = 'Test Account');
        insert testAccount1;
        System.debug('The test account: ' + testAccount1);

        // Create Contact
        Contact testContact1 = new Contact(LastName = 'Test', 
                                            AccountId = testAccount1.Id, 
                                            Role__c = 'Recruiter');
        insert testContact1;
        System.debug('The test contact: ' + testContact1);

        // Create Job
        Job__c testJob = new Job__c(Name = 'Test Job', 
                                    Company_Name__c = testAccount1.Name);
        insert testJob;
        System.debug('The test job: ' + testJob);

        // Create Application
        Job_Application__c testJobApplication = new Job_Application__c(
                            Name = 'Test Job Application',
                            Company_Name__c = testAccount1.id,
                            Job__c = testJob.Id,
                            Applicant__c = [SELECT Id FROM User WHERE IsActive = true LIMIT 1].Id,
                            Primary_Contact__c = testContact1.Id,
                            Status__c = 'Saved',
                            Follow_up_date__c = Date.today().addDays(30)
        );
        
        List<Job_Application__c> jobApplications = new List<Job_Application__c>{testJobApplication};
        insert jobApplications;
        System.debug('The test application: ' + testJobApplication);
        return jobApplications;
        
    }
}