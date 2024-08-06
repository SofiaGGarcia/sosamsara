public class SamsaraService {
   
    public static void fetchAllRoutes() {
        // URL de la API simulada (mock)
        String endpoint = 'https://0fe980ee-ab51-44bf-aa83-b34ae7c84a5d.mock.pstmn.io/endpoint/trips';
        
        // Crear la solicitud HTTP
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        
        HttpResponse response = http.send(request);
        
        if (response.getStatusCode() == 200) {
    
            System.debug('Response Body: ' + response.getBody());

            // Parsear los datos de la respuesta
            List<Object> tripsRaw = (List<Object>) JSON.deserializeUntyped(response.getBody());
            List<Map<String, Object>> trips = new List<Map<String, Object>>();
            for (Object tripRaw : tripsRaw) {
                trips.add((Map<String, Object>) tripRaw);
            }

          
            System.debug('Parsed Trips: ' + trips);
            
                      // Crear y actualizar registros en Salesforce
            List<Trip__c> tripRecords = new List<Trip__c>();
            for (Map<String, Object> trip : trips) {
                Trip__c tripRecord = new Trip__c();
                tripRecord.Trip_ID__c = (Decimal) trip.get('id');
                tripRecord.Name = (String) trip.get('name');
                tripRecord.Driver_ID__c = (Decimal) trip.get('driver_id');
                tripRecord.Vehicle_ID__c = (Decimal) trip.get('vehicle_id');
                tripRecord.Group_ID__c = (Decimal) trip.get('group_id');
                tripRecord.Start_Location_Address__c = (String) trip.get('start_location_address');
                tripRecord.Start_Location_Latitude__c = (Decimal) trip.get('start_location_lat');
                tripRecord.Start_Location_Longitude__c = (Decimal) trip.get('start_location_lng');
                tripRecord.End_Location_Address__c = (String) trip.get('destination_address');
                tripRecord.End_Location_Latitude__c = (Decimal) trip.get('destination_lat');
                tripRecord.End_Location_Longitude__c = (Decimal) trip.get('destination_lng');
                tripRecord.Scheduled_Start_Time__c = Datetime.newInstance(((Long) trip.get('scheduled_start_ms')) / 1000);
                tripRecord.Scheduled_End_Time__c = Datetime.newInstance(((Long) trip.get('scheduled_end_ms')) / 1000);
                tripRecord.Actual_Start_Time__c = Datetime.newInstance(((Long) trip.get('actual_start_ms')) / 1000);
                tripRecord.Actual_End_Time__c = Datetime.newInstance(((Long) trip.get('actual_end_ms')) / 1000);
                tripRecord.Status__c = (String) trip.get('job_state');
                tripRecord.Notes__c = (String) trip.get('notes');
                tripRecords.add(tripRecord);
            }
            upsert tripRecords Trip_ID__c; 
            
        }  else {
            System.debug('Error en la llamada a la API: ' + response.getStatus());
        }
    }
}