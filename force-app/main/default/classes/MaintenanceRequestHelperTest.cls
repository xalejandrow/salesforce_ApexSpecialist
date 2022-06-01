@isTest
public with sharing class MaintenanceRequestHelperTest {
    // implement scheduled code here


    @isTest
    static void testInsertData(){
        
        Integer count = 10;
        List<Case> cases = TestDataFactory.createAllData();

        for(Case c : cases) {
            c.Status = 'Closed';
        }

        Test.startTest();
            List<Database.SaveResult> results = Database.update(cases, true);
        Test.stopTest();


        for(Database.SaveResult result : results) {
            System.assert(result.isSuccess(), 'Update was not successful');
        }

        System.assertEquals(
            count, 
            [SELECT count() FROM Case WHERE Status = 'New'],
            '10 Case records was created with Status = "New"'
        );

        System.assertEquals(
            0,
            [SELECT count() FROM Case WHERE Subject = 'Maintenance request routine for: Test Maintenance Request Routine'],
            '10 Case records was not created with Subject = "Maintenance request routine for: Test Maintenance Request Routine"'
        );
        
        System.assertEquals(
            count,
            [SELECT count() FROM Case WHERE Type = 'Routine Maintenance'],
            '10 Case record was created with Type = "Routine Maintenance"'
        );


        
    }
}