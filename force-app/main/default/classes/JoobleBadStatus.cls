/**
 * Mock callout that returns a valid body but error code 500
 */
global class JoobleBadStatus implements HttpCalloutMock {
	global HTTPResponse respond(HTTPRequest req) {
		HttpResponse res = new HttpResponse();
		res.setHeader('Content-Type', 'application/json');
        res.setBody(
            '{"jobs" : [{"title": "Dummy Salesforce Admin", "location": "San Fransisco", "link": "www.dummyjob.com", "company": "Capstone Org"}]}'
			);
		res.setStatusCode(500);
		return res;
	}
}