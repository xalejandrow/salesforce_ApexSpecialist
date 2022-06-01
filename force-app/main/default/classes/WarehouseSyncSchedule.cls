public with sharing class WarehouseSyncSchedule implements Schedulable{
    // implement scheduled code here
    public void execute(SchedulableContext ctx){
        // Seconds Minutes Hours Day_of_month Month Day_of_week optional_year
        //String sch = '00 00 01 * * ?';//1 AM
        //System.schedule('WarehouseSyncScheduleJob', sch,new WarehouseSyncSchedule());
        Id jobId = System.enqueueJob(new WarehouseCalloutService());
        
    }
}