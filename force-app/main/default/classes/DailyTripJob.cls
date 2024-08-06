global class DailyTripJob implements Schedulable {
    global void execute(SchedulableContext sc) {
        TripScheduler.updateActiveTrips();
    }
}