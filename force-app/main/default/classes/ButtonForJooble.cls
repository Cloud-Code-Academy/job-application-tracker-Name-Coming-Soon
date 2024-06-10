public class ButtonForJooble {
    @AuraEnabled
    public static void executeJoobleIntegration() {
        JoobleIntegration joobleIntegrationInstance = new JoobleIntegration();
        joobleIntegrationInstance.fetchJoobleJobs();
    }
}