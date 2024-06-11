public class JoobleIntegration {
    public void fetchJoobleJobs() {
        Http http = new Http(); //create http object
        HttpRequest request = new HttpRequest(); //http request object
        HttpResponse response;
        Map<String, Object> bodyMap = new Map<String, Object>();

        //create header
        request.setEndpoint('https://jooble.org/api/33d2aa45-68db-4814-bbe6-a017dbd62616');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');

        //set fields in body to fetch Salesforce Developer Jobs in USA with a valid salary
        bodyMap.put('keywords', 'Salesforce Developer');
        bodyMap.put('location', 'USA');
        bodyMap.put('salary', 1);
        String body = JSON.serialize(bodyMap);
        request.setBody(body);

        JoobleIntegrationHelper helper = new JoobleIntegrationHelper();
        response = http.send(request);
        if (response.getStatusCode() == 200) {
            List <Job__c> jobApps = helper.extractJobs(response.getBody());
            if (jobApps.isEmpty()) {
                return;
            }
            //catch any DML exception during insertion
            try{
                insert jobApps;
            } catch(Exception e){
                System.Debug('Error: '+ e.getMessage() + 'Line Number: '+ e.getLineNumber()); 
            }
        }
    }
}