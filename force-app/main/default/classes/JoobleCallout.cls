@isTest
global class JoobleCallout implements HttpCalloutMock {
	global HTTPResponse respond(HTTPRequest req) {
		HttpResponse res = new HttpResponse();
		res.setHeader('Content-Type', 'application/json');
		if (req.getMethod() == 'GET') {
			res.setBody('{"status": "success"}');
		} else {
			res.setBody(
            '{"jobs" : [{"title": "Dummy Salesforce Admin", "location": "San Fransisco", "link": "www.dummyjob.com", "company": "Capstone Org"}]}'
			);
		}
		res.setStatusCode(200);
		return res;
	} 
}