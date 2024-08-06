# Proyecto Salesforce: Integración con Samsara

## Descripción del Proyecto

Este proyecto integra Salesforce con la API de Samsara para gestionar y actualizar información de viajes. Se han desarrollado clases Apex para realizar llamadas a la API externa, manejar la lógica de programación y programar un job diario para actualizar los registros de viajes en Salesforce.

## Funcionalidades Implementadas

1. **Llamada a la API Externa de Samsara**:
    - **Clase**: `SamsaraService`
    - Descripción: Esta clase realiza una llamada HTTP GET a la API de Samsara para obtener información de los viajes y conductores asignados. Se utilizó un mock server en Postman para simular la API de Samsara debido a restricciones de acceso.

2. **Lógica de Programación**:
    - **Clase**: `TripScheduler`
    - Descripción: Esta clase consulta el objeto `Trips` para obtener los viajes activos del día, realiza llamadas a la API de Samsara para cada viaje, y actualiza el conductor asignado en los registros de `Trips`.

3. **Job Diario Programado**:
    - **Clase**: `DailyTripJob`
    - Descripción: Esta clase implementa la interfaz `Schedulable` y programa un job diario que ejecuta la lógica de programación de `TripScheduler`.

## Configuración y Despliegue

### Prerrequisitos

- **Salesforce**:
    - Cuenta de Salesforce con permisos de desarrollo.
    - Herramientas de desarrollo configuradas: Salesforce CLI o VS Code con la extensión Salesforce Extension Pack.

### Pasos para Configurar y Desplegar el Proyecto

1. **Clonar el Repositorio**:

    ```bash
    git clone https://github.com/tu_usuario/proyecto-salesforce-samsara.git
    cd proyecto-salesforce-samsara
    ```

### Mock Server

Se utilizó un mock server en Postman para simular la API de Samsara. El mock server retorna datos de ejemplo de viajes, incluyendo `Trip_ID`, `Driver_ID`, `Vehicle_ID`, `Group_ID`, entre otros.

- **Endpoint del Mock Server**: `https://0fe980ee-ab51-44bf-aa83-b34ae7c84a5d.mock.pstmn.io/endpoint/trips`
- **Datos de Ejemplo**:

    ```json
    [
        {
            "id": 556,
            "name": "Bid #123",
            "driver_id": 555,
            "vehicle_id": 444,
            "group_id": 101,
            "start_location_address": "123 Main St, Philadelphia, PA 19106",
            "start_location_lat": 123.456,
            "start_location_lng": 37.459,
            "destination_address": "456 Market St, San Francisco, CA 94105",
            "destination_lat": 37.774,
            "destination_lng": -122.419,
            "scheduled_start_ms": 1462881998034,
            "scheduled_end_ms": 1462882998034,
            "actual_start_ms": 1462882098034,
            "actual_end_ms": 1462883098034,
            "job_state": "JobState_Arrived",
            "notes": "Ensure crates are stacked no more than 3 high."
        }
    ]
    ```

### Programar el Job Diario

1. **Programar el Job desde Salesforce**:
    - Ir a `Setup` > `Apex Classes` > `Schedule Apex`.
    - Completar los campos:
        - **Job Name**: Daily Trip Update Job
        - **Apex Class**: DailyTripJob
        - **Cron Expression**: `0 0 0 * * ? *` (Ejecuta diariamente a medianoche).

### Pruebas

Se desarrollaron clases de prueba para asegurar el correcto funcionamiento de las funcionalidades implementadas:

- **SamsaraServiceTest**
- **TripSchedulerTest**
- **DailyTripJobTest**

