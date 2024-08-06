public class TripScheduler {
    
    // Método para obtener los viajes activos del día y actualizar el conductor
    public static void updateActiveTrips() {
        System.debug('Iniciando el método updateActiveTrips');

        // Obtener los viajes activos del día
        List<Trip__c> activeTrips = getActiveTripsToday();
        System.debug('Viajes activos obtenidos: ' + activeTrips);
        
        // Lista para guardar los viajes actualizados
        List<Trip__c> tripsToUpdate = new List<Trip__c>();

        // Iterar sobre los viajes activos y actualizar el conductor
        for (Trip__c trip : activeTrips) {
            System.debug('Procesando el viaje: ' + trip);

            // Llamada a la API de Samsara para obtener el conductor asignado al viaje
            Decimal driverId = getDriverIdFromSamsara(trip.Trip_ID__c);
            System.debug('Driver ID obtenido para el viaje ' + trip.Trip_ID__c + ': ' + driverId);

            // Actualizar el conductor en el registro de Trip
            if (driverId != null) {
                trip.Driver_ID__c = driverId;
                tripsToUpdate.add(trip);
                System.debug('Viaje actualizado: ' + trip);
            }
        }

        // Guardar los cambios
        if (!tripsToUpdate.isEmpty()) {
            update tripsToUpdate;
            System.debug('Viajes actualizados guardados: ' + tripsToUpdate);
        } else {
            System.debug('No hay viajes para actualizar');
        }
    }

    // Método para obtener los viajes activos del día
    public static List<Trip__c> getActiveTripsToday() {
        System.debug('Iniciando el método getActiveTripsToday');

        // Consultar los viajes activos del día
        List<Trip__c> activeTrips = [SELECT Id, Trip_ID__c, Name, Driver_ID__c, Scheduled_Start_Time__c
                                     FROM Trip__c
                                     WHERE Scheduled_Start_Time__c = TODAY];
        System.debug('Active Trips Today: ' + activeTrips);
        
        // Retornar la lista de viajes activos
        return activeTrips;
    }

   // Método para obtener el driverId desde la API de Samsara (mock server)
    public static Decimal getDriverIdFromSamsara(Decimal tripId) {
        System.debug('Iniciando el método getDriverIdFromSamsara con tripId: ' + tripId);

        try {
            // Construir el endpoint de la API del mock server
            String endpoint = 'https://0fe980ee-ab51-44bf-aa83-b34ae7c84a5d.mock.pstmn.io/endpoint/trips';
            System.debug('Endpoint de la API: ' + endpoint);
            
            // Configurar la solicitud HTTP
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(endpoint);
            request.setMethod('GET');
            System.debug('Solicitud HTTP configurada: ' + request);
            
            // Enviar la solicitud y recibir la respuesta
            HttpResponse response = http.send(request);
            System.debug('Respuesta de la API: ' + response.getBody());
            
            // Procesar la respuesta
            if (response.getStatusCode() == 200) {
                Object jsonResponse = JSON.deserializeUntyped(response.getBody());
                System.debug('JSON deserializado: ' + jsonResponse);

                List<Object> trips = (List<Object>) jsonResponse;
                for (Object tripObj : trips) {
                    Map<String, Object> trip = (Map<String, Object>) tripObj;
                    System.debug('Evaluando trip: ' + trip);
                    if (((Decimal) trip.get('id')).intValue() == tripId.intValue()) {
                        System.debug('Trip encontrado: ' + trip);
                        return (Decimal) trip.get('driver_id');
                    }
                }
            } else {
                System.debug('Error en la llamada a la API: ' + response.getStatus());
            }
        } catch (Exception e) {
            System.debug('Excepción en la llamada a la API: ' + e.getMessage());
        }
        return null;
    }
}