@isTest
public with sharing class JoobleIntegration_Test {
/**
 * Create a Mock callout and test that the Integration class correctly
 * creates and inserts dummy jobs
 */
    @isTest
    public static void testSuccessfulCallout() {
        Test.startTest();
        //this mock callout returns a dummy job and status 200 so it should be inserted
        Test.setMock(HttpCalloutMock.class, new JoobleCallout());
        JoobleIntegration joobleInstance = new JoobleIntegration();
        joobleInstance.fetchJoobleJobs();
        Test.stopTest();

        List <Job__c> jobsL;
        jobsL = [SELECT Title__c, Location__c, Link_to_Listing__c, Company_Name__c FROM Job__c
                        WHERE Title__c LIKE '%Dummy%'];
        Job__c dummyJob = jobsL[0];

        System.assertEquals(dummyJob.Title__c, 'Dummy Salesforce Admin', 'unexpected title');
        System.assertEquals(dummyJob.Location__c, 'San Fransisco', 'unexpected location');
        System.assertEquals(dummyJob.Link_to_Listing__c, 'www.dummyjob.com', 'unexpected Job link');
        System.assertEquals(dummyJob.Company_Name__c, 'Capstone Org', 'Unexpected Org');
    }

/**
 * Check that we are correctly handling error respsonses to
 * our HTTP requests. No job should be inserted
 */
    @isTest
    public static void testFailCallout() {
        JoobleIntegration joobleInstance = new JoobleIntegration();

        Test.startTest();
        //this mock callout returns a bad status(500) and a valid Job body so it
        //should fail and not be inserted
        Test.setMock(HttpCalloutMock.class, new JoobleBadStatus());
        joobleInstance.fetchJoobleJobs();
        Test.stopTest();

        List <Job__c> jobsL;
        jobsL = [SELECT Title__c, Location__c, Link_to_Listing__c, Company_Name__c FROM Job__c
                        WHERE Title__c LIKE '%Dummy%'];

        System.assertEquals(0, jobsL.size(), 'There should be no Dummy jobs created');
    }
}