public class JoobleIntegration {
    public List <Job__c> createJobsFromJson (String jsonResponse) {
        Map<String, Object> jsonResponseMap = (Map<String, Object>) JSON.deserializeUntyped(jsonResponse);
        List<Object> jobList = (List<Object>) jsonResponseMap.get('jobs');
            List <Job__c> listOfJobs = new List <Job__c>();

            for(Object jobi: jobList) {
                Map<String, Object> jobMap  = (Map<String, Object>) jobi;
                Job__c jobs = new Job__c();
                jobs.Title__c = (String) jobMap.get('title');
                jobs.Location__c = (String) jobMap.get('location');
                jobs.Link_to_Listing__c =(String) jobMap.get('link');
                jobs.Company_Name__c = (String) jobMap.get('company');
                jobs.Name = jobs.Title__c + ', ' + jobs.Company_Name__c;
                jobs.Name = jobs.Name.abbreviate(80);
                jobs.Source__c = (String) jobMap.get('source');
                listOfJobs.add(jobs);
            }
        return listOfJobs;
    }

    public void JoobleIntegration() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://jooble.org/api/33d2aa45-68db-4814-bbe6-a017dbd62616?Key=33d2aa45-68db-4814-bbe6-a017dbd62616');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        List <List <Job__c>> jobList = new List <List <Job__c>> ();
        HttpResponse response;
        Integer pageNum = 1;
        Integer numReqs = 0;

        do {
            String pageString = '"page" : "' + pageNum + '"';
            String resultonPage  = '"resultonpage" : "50"';
            //Make the request for consecutive pages with 50 results on each page
            String reqBody = '{"keywords":"Salesforce developer", ' + pageString + ',' + resultonPage + '}';
            request.setBody(reqBody);
            response = http.send(request);
            List <Job__c> jobApps = createJobsFromJson(response.getBody());
            jobList.add(jobApps);
            pageNum++;
            numReqs = numReqs + 50;          
        } while (response.getStatusCode() == 200 && numReqs <= 500);

        for (List <Job__c> jobL : jobList) {
            insert jobL;
        }
    }
}
