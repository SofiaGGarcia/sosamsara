@IsTest
public class SamsaraServiceTest {
    
    // Simulación de la respuesta HTTP
    public class MockHttpResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            res.setBody('[{"id": 556, "name": "Bid #123", "driver_id": 555, "vehicle_id": 444, "group_id": 101, "start_location_address": "123 Main St, Philadelphia, PA 19106", "start_location_lat": 123.456, "start_location_lng": 37.459, "destination_address": "456 Market St, San Francisco, CA 94105", "destination_lat": 37.774, "destination_lng": -122.419, "scheduled_start_ms": 1462881998034, "scheduled_end_ms": 1462882998034, "actual_start_ms": 1462882098034, "actual_end_ms": 1462883098034, "job_state": "JobState_Arrived", "notes": "Ensure crates are stacked no more than 3 high."}]');
            return res;
        }
    }
    
    public class MockHttpResponseNoDriver implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            res.setBody('[{"id": 556, "name": "Bid #123", "vehicle_id": 444, "group_id": 101, "start_location_address": "123 Main St, Philadelphia, PA 19106", "start_location_lat": 123.456, "start_location_lng": 37.459, "destination_address": "456 Market St, San Francisco, CA 94105", "destination_lat": 37.774, "destination_lng": -122.419, "scheduled_start_ms": 1462881998034, "scheduled_end_ms": 1462882998034, "actual_start_ms": 1462882098034, "actual_end_ms": 1462883098034, "job_state": "JobState_Arrived", "notes": "Ensure crates are stacked no more than 3 high."}]');
            return res;
        }
    }
    
    public class MockHttpErrorResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(500);
            res.setBody('{"error": "Internal Server Error"}');
            return res;
        }
    }

    @IsTest
    static void testFetchAllRoutes() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse());
        
        Test.startTest();
        SamsaraService.fetchAllRoutes();
        Test.stopTest();
        
        List<Trip__c> trips = [SELECT Trip_ID__c, Name FROM Trip__c WHERE Trip_ID__c = 556];
        System.assertEquals(1, trips.size());
        System.assertEquals('Bid #123', trips[0].Name);
    }
}