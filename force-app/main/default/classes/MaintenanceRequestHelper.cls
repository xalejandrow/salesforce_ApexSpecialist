public with sharing class MaintenanceRequestHelper {
    
    public static void updateWorkOrders(List<Case> caseList) {
        // TODO: Complete the method to update workorders
        Set<ID> caseIDs = new Set<ID>();
       
        // Filter Closed Cases though type
        for(Case c : caseList){
            System.debug('c: '+c);
            if(c.status == 'Closed'){
                if(c.type == 'Repair' || c.type == 'Routine Maintenance'){
                    caseIDs.add(c.ID);
                }
            }
        }
       
        if(!caseIDs.isEmpty()){
            List<Case> newCases = new List<Case>();
            // Get Closed Cases with related Equipment
            Map<Id,Case> closedCases = new Map<Id,Case>([SELECT Id, Vehicle__c, Product__c, 
                                                            status,
                                                            (SELECT Id,Equipment__c,Quantity__c FROM Equipment_Maintenance_Items__r) 
                                                         FROM Case 
                                                         WHERE Id IN :caseIDs]);
            
            Map<Id,Decimal> maintenanceCycles = new Map<ID,Decimal>();
            // Find Maintenance Request in Cases
            AggregateResult[] results = [SELECT Maintenance_Request__c, MIN(Equipment__r.Maintenance_Cycle__c)cycle 
                                         FROM Equipment_Maintenance_Item__c 
                                         WHERE Maintenance_Request__c IN :caseIDs 
                                         GROUP BY Maintenance_Request__c];
            // Get min Maintenance cycle
            for (AggregateResult ar : results){ 
            	maintenanceCycles.put((Id) ar.get('Maintenance_Request__c'), (Decimal) ar.get('cycle'));
        	}
            
            for(Case c : closedCases.values()){
                Case nCase = new Case();
                nCase.ParentId = c.Id;
                nCase.Status = 'New';
                nCase.Type = 'Routine Maintenance';
                nCase.Subject = 'Routine Maintenance';
                nCase.Origin = 'Web';
                nCase.Vehicle__c = c.Vehicle__c;
                nCase.Product__c = c.Product__c;
                nCase.Date_Reported__c = Date.today();
                
                if(maintenanceCycles.containskey(c.Id)){
                    nCase.Date_Due__c = Date.today().addDays((Integer) maintenanceCycles.get(c.Id));
                }else{
                    nCase.Date_Due__c = c.Date_Due__c; 
                }
                
                newCases.add(nCase);
            }
            
            //System.debug('newCases: '+ newCases);
        	insert newCases;

            // Get Equip Maint Items asociated to CaseIDs
           	List<Equipment_Maintenance_Item__c> eqMantIt = [select id, name, Quantity__c, Equipment__c, Maintenance_Request__c 
                                                from Equipment_Maintenance_Item__c
                                                WHERE Maintenance_Request__c IN :CaseIDs
                                                ORDER BY Maintenance_Request__c];

            List<Equipment_Maintenance_Item__c> newEmis = new List<Equipment_Maintenance_Item__c>();
            
            for(Case c :newCases){
                for(Equipment_Maintenance_Item__c emi : eqMantIt){
                    if(emi.Maintenance_Request__c == c.ParentId){
                        Equipment_Maintenance_Item__c emiCloned = emi.clone();
                        emiCloned.Maintenance_Request__c = c.Id;
                        newEmis.add(emiCloned);
                    }
                }
            }
            
            //System.debug('newEmis: '+ newEmis);
            insert newEmis;
       

        }
              
        
       
    }


    
}