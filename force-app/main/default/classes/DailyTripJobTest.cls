@IsTest
public class DailyTripJobTest {
    @IsTest
    static void testDailyTripJob() {
        
        Trip__c trip = new Trip__c(
            Trip_ID__c = 556,
            Name = 'Test Trip',
            Scheduled_Start_Time__c = DateTime.now(),
            Driver_ID__c = 555
        );
        insert trip;

        
        Test.setMock(HttpCalloutMock.class, new SamsaraServiceTest.MockHttpResponse());

        
        try {
            for (CronTrigger ct : [SELECT Id FROM CronTrigger WHERE CronJobDetail.Name = 'Daily Trip Update Job']) {
                System.abortJob(ct.Id);
            }
        } catch (Exception e) {
            System.debug('Error canceling existing jobs: ' + e.getMessage());
        }

        
        String cronExp = '0 0 0 * * ?';
        System.schedule('Daily Trip Update Job', cronExp, new DailyTripJob());

        Test.startTest();
        
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE NextFireTime != NULL LIMIT 1];
        System.runAs(new User(Id = UserInfo.getUserId())) {
            System.abortJob(ct.Id);
        }
        Test.stopTest();

        
        trip = [SELECT Driver_ID__c FROM Trip__c WHERE Id = :trip.Id];
        System.assertEquals(999, trip.Driver_ID__c);  
    }
}