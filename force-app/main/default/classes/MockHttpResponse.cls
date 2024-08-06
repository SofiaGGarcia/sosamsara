public class MockHttpResponse implements HttpCalloutMock {
    public HTTPResponse respond(HTTPRequest req) {
        // Crear una respuesta simulada
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setStatusCode(200);
        res.setBody('[{"id": 556, "name": "Bid #123", "driver_id": 999, "vehicle_id": 444, "group_id": 101, "start_location_address": "123 Main St, Philadelphia, PA 19106", "start_location_lat": 123.456, "start_location_lng": 37.459, "destination_address": "456 Market St, San Francisco, CA 94105", "destination_lat": 37.774, "destination_lng": -122.419, "scheduled_start_ms": 1462881998034, "scheduled_end_ms": 1462882998034, "actual_start_ms": 1462882098034, "actual_end_ms": 1462883098034, "job_state": "JobState_Arrived", "notes": "Ensure crates are stacked no more than 3 high."}]');
        return res;
    }
}