public class WarehouseCalloutServiceMock implements HttpCalloutMock {
    // implement http mock callout
    public HttpResponse respond(HttpRequest request){

         // Create a fake response
         StaticResource sr = [SELECT Id, Body FROM StaticResource WHERE Name = 'jsonMainEquip']; 
         String json = sr.Body.toString(); 
         
         HttpResponse response = new HttpResponse();
         response.setHeader('Content-Type', 'application/json');

         response.setBody(json);
         response.setStatusCode(200);
         return response; 

    }
}