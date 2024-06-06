public class InterviewEmail implements Schedulable {
    public void execute(SchedulableContext sc) {
        List<String> toaddress = new List <String> ();        

        Date tomorrow = Date.today().addDays(1);

        List<Job_Interview__c> upcomingInterviews = [SELECT Id, Interview_Date__c, Name,
                                                    Interview_Time__c,
                                                    Job_Application__r.Job__r.Company_Name__c,
                                                    Job_Application__r.Job__r.Title__c,
                                                    Job_Application__r.Applicant__r.Name,
                                                    Job_Application__r.Applicant__r.Email
                                                    FROM Job_Interview__c WHERE Interview_Date__c =:tomorrow];

        System.debug('Upcoming interviews'  + upcomingInterviews);
        String userTimeZone = UserInfo.getTimeZone().getID();
        DateTime myDateTime = DateTime.newInstance(Date.today(), upcomingInterviews[0].Interview_Time__c);
        // Format the DateTime object to get the time in the user's local time zone
        String formattedTime = myDateTime.format('h:mm a', userTimeZone);
        System.debug('Formatted Time (Local): ' + formattedTime);

        List<Messaging.SingleEmailMessage> emailMessages = new List<Messaging.SingleEmailMessage>();
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
                                   interview.Job_Application__r.Job__r.Company_Name__c + ' at ' + 
                                   + formattedTime +
                                   ' for the ' + 
                                   interview.Job_Application__r.Job__r.Title__c + ' position.' +
                                   '\n\nThank you.');
            
            mail.setSaveAsActivity(false);
            toAddr.add(interview.Job_Application__r.Applicant__r.Email);
            mail.setToAddresses(toAddr);
            emailMessages.add(mail);
            System.debug('+++ ' + interview.Job_Application__r.Applicant__r.Email);
        }
        List<Messaging.SendEmailResult>  sendEmailResults = Messaging.sendEmail(emailMessages);
        System.debug(emailMessages);
    }
}

