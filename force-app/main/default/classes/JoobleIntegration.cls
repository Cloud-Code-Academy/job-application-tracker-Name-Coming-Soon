public class JoobleIntegration {
    public List <Job__c> createJobsFromJson (String jsonResponse) {
        System.debug('>>> + ' + jsonResponse);
        Map<String, Object> jsonResponseMap = (Map<String, Object>) JSON.deserializeUntyped(jsonResponse);
        List<Object> jobList = (List<Object>) jsonResponseMap.get('jobs');
            List <Job__c> listOfJobs = new List <Job__c>();
            String salary;
            for(Object jobi: jobList) {
                Map<String, Object> jobMap  = (Map<String, Object>) jobi;
                System.debug(jobi);
                Job__c jobs = new Job__c();
                jobs.Title__c = (String) jobMap.get('title');
                jobs.Location__c = (String) jobMap.get('location');
                jobs.Link_to_Listing__c =(String) jobMap.get('link');
                jobs.Company_Name__c = (String) jobMap.get('company');
                salary = (String) jobMap.get('salary');
                jobs.Salary__c = JoobleIntegrationHelper.extractSalaries(salary);
                System.debug('>>> ' + jobs.Salary__c);
                if (String.isBlank(jobs.Company_Name__c)) {
                    jobs.Name = jobs.Title__c;
                } else {
                    jobs.Name = jobs.Title__c + ', ' + jobs.Company_Name__c;
                }
                jobs.Name = jobs.Name.abbreviate(80);
                jobs.Source__c = (String) jobMap.get('source');
                listOfJobs.add(jobs);
            }
        return listOfJobs;
    }

    public void JoobleIntegration() {
        Http http = new Http(); //create http object
        HttpRequest request = new HttpRequest(); //http request object
        request.setEndpoint('https://jooble.org/api/33d2aa45-68db-4814-bbe6-a017dbd62616');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        HttpResponse response;

        Map<String, Object> bodyMap = new Map<String, Object>();
        bodyMap.put('keywords', 'Salesforce Developer');
        bodyMap.put('location', 'USA');
        bodyMap.put('salary', 1);
        String body = JSON.serialize(bodyMap);
        request.setBody(body);

        response = http.send(request);
        if (response.getStatusCode() == 200) {
            List <Job__c> jobApps = createJobsFromJson(response.getBody());
            if (jobApps.isEmpty()) {
                return;
            }
            try{
                insert jobApps;
            } catch(Exception e){
                System.Debug('Error: '+ e.getMessage() + 'Line Number: '+ e.getLineNumber()); 
            }
        }
    }
}