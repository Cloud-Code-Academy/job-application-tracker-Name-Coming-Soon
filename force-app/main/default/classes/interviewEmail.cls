public class interviewEmail implements Schedulable {
    public Id schId;
    public interviewEmail(Id jId) {
        schId = jId;
    }

    public void execute(SchedulableContext sc) {
        //Date tomorrow = Date.today().addDays(1);
        List<String> toaddress = new List <String> ();
        List<Job_Interview__c> upcomingInterviews = [SELECT Id, Interview_Date__c, Name,
                                                    Interview_Time__c, Interview_Type__c,
                                                    Job_Application__c,
                                                    Job_Application__r.Title__c,
                                                    Job_Application__r.Applicant__r.Name,
                                                    Job_Application__r.Applicant__r.Address,
                                                    Job_Application__r.Company_Name__r.Name,
                                                    Job_Application__r.Applicant__r.Email,
                                                    Interviewer__c
                                                    FROM Job_Interview__c WHERE Id = :schId];
                                                       
        
        
        List<Messaging.SingleEmailMessage> emailMessages = new List<Messaging.SingleEmailMessage>();
        System.debug('>>> upcomingInterviews: ' + upcomingInterviews + 'Id: ' + schId);
        for (Job_Interview__c interview : upcomingInterviews) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            if ((interview.Job_Application__r.Applicant__r.Email == NULL) ||
                String.isBlank(interview.Job_Application__r.Applicant__r.Email)) {
                    continue;
            }
            List <String> toAddr = new List<String> ();
            mail.setSubject('Upcoming Interview Reminder');
            mail.setPlainTextBody('Dear ' + interview.Job_Application__r.Applicant__r.Name+ ',\n\n' +
                                  'This is to remind you of the upcoming interview scheduled for tomorrow with ' + 
                                   interview.Job_Application__r.Company_Name__r.Name + ' at ' + 
                                   interview.Interview_Time__c + 
                                   ' for the ' + 
                                   interview.Job_Application__r.Title__c + ' position.' +
                                   '\n\nThank you.');
            
            System.debug('>>>>scheduling email for ' + interview + 'at ' + interview.Interview_Time__c + '> ' + interview.Name);
            System.debug('>>> email  >>>' + interview.Job_Application__r.Applicant__r.Email);
            mail.setSaveAsActivity(false);
            toAddr.add(interview.Job_Application__r.Applicant__r.Email);
            mail.setToAddresses(toAddr);
            emailMessages.add(mail);
        }
        Messaging.sendEmail(emailMessages);

    }

}

