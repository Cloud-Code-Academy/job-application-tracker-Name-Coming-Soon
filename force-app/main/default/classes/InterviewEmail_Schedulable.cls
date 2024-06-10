public class InterviewEmail_Schedulable implements Schedulable {
    public void execute(SchedulableContext sc) {
        InterviewEmailSender.EmailSender();
    }
}