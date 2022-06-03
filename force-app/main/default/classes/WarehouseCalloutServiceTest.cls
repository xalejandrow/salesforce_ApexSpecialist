@IsTest
private class WarehouseCalloutServiceTest {
    // implement your mock callout test here
    
    @isTest 
    static void calloutTest(){

        Test.setMock(HttpCalloutMock.class,new WarehouseCalloutServiceMock());

        Test.startTest();

        //Id jobId = System.enqueueJob(new WarehouseCalloutService());

        List<Object> response = WarehouseCalloutService.getJsonData();
        System.assertEquals(5, response.size(), response.size());
        Test.stopTest();
    }


    @isTest
    static void failCalloutTest(){

        Test.startTest();
        List<Object> response = WarehouseCalloutService.getJsonData();
        System.assertEquals(null, response, 'Response error');
        Test.stopTest();
    }


    @isTest
    static void nullCalloutTest(){

        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('jsonMainEquip');
        mock.setStatusCode(404);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        // Associate the callout with a mock response
        Test.setMock(HttpCalloutMock.class, mock);
        
        Test.startTest();
        List<Object> response = WarehouseCalloutService.getJsonData();
        System.assertEquals(null, response, 'Response error');
        Test.stopTest();
    }

    @isTest
    static void updateInventory(){

        Test.setMock(HttpCalloutMock.class,new WarehouseCalloutServiceMock());
        Test.startTest();
        WarehouseCalloutService.updateInventory();
        Test.stopTest();

         System.assertEquals(5, [SELECT count() FROM Product2], '5 Equipment was not inserted');
    }



    @isTest
    static void queueTest(){

        Test.startTest();

        // Schedule the test job
        
        WarehouseSyncSchedule job = new WarehouseSyncSchedule();
        String sch = '0 0 1 * * ?';
         
        String jobId = System.schedule('WarehouseSyncScheduleJob', sch, job);
  
        // Get the information from the CronTrigger API object
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
           NextFireTime
           FROM CronTrigger WHERE id = :jobId];
  
        // Verify the expressions are the same
        System.assertEquals(sch, 
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