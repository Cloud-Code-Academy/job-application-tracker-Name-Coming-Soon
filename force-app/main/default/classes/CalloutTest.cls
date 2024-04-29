/*
*  Test the createJobsFromJson method in JoobleIntegration.cls
*  We test that the response from a callout to a dummy endpoint 
*  passed to createJobsFromJson creates the correct Job__c with the 
*  right fields
*/

@isTest
public with sharing class CalloutTest{
@isTest
	public static void createJobsFromJsonTest() {
        Test.setMock(HttpCalloutMock.class, new DummyJsonCalloutGen());
        Test.startTest();
		// Create HTTP request to send.
		Http http = new Http();
		HttpRequest request = new HttpRequest();
		request.setEndpoint('https://dummyjson.com/user/' + 1);
		request.setMethod('POST');
		HttpResponse response = http.send(request);

		// If the HTTP response code is successful, parse the JSON response and insert the Job
		if (response.getStatusCode() == 200) {
			System.debug('Jsoncallout response ' + response.getBody());
            JoobleIntegration joobleJob = new JoobleIntegration();
            List <Job__c> jobs = joobleJob.createJobsFromJson(response.getBody());
            System.debug('jobs: ' + jobs);
            insert jobs;
		}

        Test.stopTest();

        List <Job__c> jobsL;
        jobsL = [SELECT Title__c, Location__c, Link_to_Listing__c, Company_Name__c FROM Job__c
				WHERE Title__c LIKE '%Dummy%'];
        Job__c dummyJob = jobsL[0];
        Assert.areequal(dummyJob.Title__c, 'Dummy Salesforce Admin', 'unexpected title');
        Assert.areequal(dummyJob.Location__c, 'San Fransisco', 'unexpected location');
        Assert.areequal(dummyJob.Link_to_Listing__c, 'www.dummyjob.com', 'unexpected Job link');
        Assert.areequal(dummyJob.Company_Name__c, 'Capstone Org', 'Unexpected Org');
	}
}