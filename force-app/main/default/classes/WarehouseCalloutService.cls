public with sharing class WarehouseCalloutService {

    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';    
    
    public static List<Object> getJsonData(){
        
        try{
                
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(WAREHOUSE_URL);
            request.setMethod('GET');
            HttpResponse response = http.send(request);
        
            System.debug('response: '+response);
            // If the request is successful, parse the JSON response.
            if(response.getStatusCode() == 200) {
               List<Object> results = (List<Object>) JSON.deserializeUntyped(response.getBody());
               return results;
            }
            
            return null;
        
        }catch(Exception e){
            System.debug('error: '+e);
            return null;
        }
    }
    

    public static Boolean updateInventory(){

        try {
            
            List<Object> jsonResult = getJsonData();
            List<Product2> newEquipment = new List<Product2>();

            for(Object js :jsonResult){
                Map<String,Object> jsMap = (Map<String,Object>)js;
                Product2 p = new Product2();
                p.Replacement_Part__c = true;
                p.Current_Inventory__c = (Integer)jsMap.get('quantity');
                p.Maintenance_Cycle__c = (Integer)jsMap.get('maintenanceperiod');
                p.Lifespan_Months__c = (Integer)jsMap.get('lifespan');
                p.Cost__c = (Decimal)jsMap.get('cost');
                p.Warehouse_SKU__c = (String)jsMap.get('sku');

                newEquipment.add(p);

            }

            System.debug('newEquipment: '+newEquipment);

            return true;
        } catch (Exception e) {
            return false;
        }
    }
    
    
    
}