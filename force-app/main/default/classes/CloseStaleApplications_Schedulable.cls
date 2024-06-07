global class CloseStaleApplications_Schedulable implements Schedulable {
    global void execute(SchedulableContext sc){
        CloseStaleApplications_Batchable batch = new CloseStaleApplications_Batchable();
        Database.executeBatch(batch);
    }
}