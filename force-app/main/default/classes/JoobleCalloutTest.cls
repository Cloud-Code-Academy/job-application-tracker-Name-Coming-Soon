/*
*  Test the createJobsFromJson method in JoobleIntegration.cls
*  We test that the response from a callout to a dummy endpoint 
*  passed to createJobsFromJson creates the correct Job__c with the 
*  right fields
*/

@isTest
public with sharing class JoobleCalloutTest{
@isTest
	public static void testSuccessfulCallout() {
    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new JoobleCallout());
    JoobleIntegration joobleInstance = new JoobleIntegration();
    joobleInstance.JoobleIntegration();
    Test.stopTest();

    List <Job__c> jobsL;
    jobsL = [SELECT Title__c, Location__c, Link_to_Listing__c, Company_Name__c FROM Job__c
				     WHERE Title__c LIKE '%Dummy%'];
    Job__c dummyJob = jobsL[0];
    System.debug('dummyJob: ' + dummyJob);
    
    Assert.areequal(dummyJob.Title__c, 'Dummy Salesforce Admin', 'unexpected title');
    Assert.areequal(dummyJob.Location__c, 'San Fransisco', 'unexpected location');
    Assert.areequal(dummyJob.Link_to_Listing__c, 'www.dummyjob.com', 'unexpected Job link');
    Assert.areequal(dummyJob.Company_Name__c, 'Capstone Org', 'Unexpected Org');
	}

  @isTest
	public static void testFailCallout() {
    JoobleIntegration joobleInstance = new JoobleIntegration();

    Test.startTest();
    Test.setMock(HttpCalloutMock.class, new JoobleBadStatus());
    joobleInstance.JoobleIntegration();
    Test.stopTest();

    List <Job__c> jobsL;
    jobsL = [SELECT Title__c, Location__c, Link_to_Listing__c, Company_Name__c FROM Job__c
				     WHERE Title__c LIKE '%Dummy%'];

    System.assertEquals(0, jobsL.size(), 'There should be no Dummy jobs created');

	}
}