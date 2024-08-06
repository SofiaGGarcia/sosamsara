@IsTest
public class TripSchedulerTest {
    
    @IsTest
    static void testGetActiveTripsToday() {
        Trip__c trip1 = new Trip__c(
            Trip_ID__c = 556,
            Name = 'Test Trip 1',
            Scheduled_Start_Time__c = DateTime.now(),
            Driver_ID__c = 555
        );
        insert trip1;

        Trip__c trip2 = new Trip__c(
            Trip_ID__c = 557,
            Name = 'Test Trip 2',
            Scheduled_Start_Time__c = DateTime.now().addDays(1),
            Driver_ID__c = 556
        );
        insert trip2;

        List<Trip__c> activeTrips = TripScheduler.getActiveTripsToday();
        System.assertEquals(1, activeTrips.size());
        System.assertEquals(trip1.Id, activeTrips[0].Id);
    }
    
    @IsTest
    static void testUpdateActiveTrips() {
        Trip__c trip = new Trip__c(
            Trip_ID__c = 556,
            Name = 'Test Trip',
            Scheduled_Start_Time__c = DateTime.now(),
            Driver_ID__c = 555
        );
        insert trip;

        Test.setMock(HttpCalloutMock.class, new SamsaraServiceTest.MockHttpResponse());
        
        TripScheduler.updateActiveTrips();
        
        trip = [SELECT Driver_ID__c FROM Trip__c WHERE Id = :trip.Id];
        System.assertEquals(999, trip.Driver_ID__c);
    }

    @IsTest
    static void testNoActiveTripsToday() {
        List<Trip__c> activeTrips = TripScheduler.getActiveTripsToday();
        System.assertEquals(0, activeTrips.size());
    }

    @IsTest
    static void testUpdateActiveTripsNoDriver() {
        Trip__c trip = new Trip__c(
            Trip_ID__c = 556,
            Name = 'Test Trip',
            Scheduled_Start_Time__c = DateTime.now(),
            Driver_ID__c = 555
        );
        insert trip;

        Test.setMock(HttpCalloutMock.class, new SamsaraServiceTest.MockHttpResponseNoDriver());
        
        TripScheduler.updateActiveTrips();
        
        trip = [SELECT Driver_ID__c FROM Trip__c WHERE Id = :trip.Id];
        System.assertEquals(555, trip.Driver_ID__c);
    }
}