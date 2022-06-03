@isTest
public with sharing class WarehouseSyncScheduleTest {
    // implement scheduled code here
    public static final String CRON_EXP = '0 0 1 * * ?';

    @isTest
    static void queueTest(){

        Test.startTest();

        // Schedule the test job
        
        String jobId = System.schedule(
            'TestWarehouseSyncScheduleJob', 
            CRON_EXP, 
            new WarehouseSyncSchedule()
        );

         // Get the information from the CronTrigger API object
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];

        // Verify the expressions are the same
        System.assertEquals(CRON_EXP, 
            ct.CronExpression);

        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);


        Test.stopTest();

        String status = [SELECT Id, CronExpression, TimesTriggered, 
         NextFireTime,CronJobDetail.Name,CronJobDetail.Id,State
         FROM CronTrigger  WHERE id = :jobId].State;
        System.assertEquals('WAITING',status);

      
    }
}