Feature: Scheduled Maintenance: Get Next Services for vehicle

  Background:
    * url 'https://dev-core-service.innova.com/api/schedule-maintenances'
    * header Content-Type = 'application/json'
    * header Accept = 'application/json'
    * header api-key = 'EJPLzfSyCmdDSUzhG9LJwt3MCgTrAN'
    # * def records = read('classpath:resources/data/excels/innova/Vehicle_Info_Test_5_Row.csv')

    # ==== Java DB setup ====
    * def ScheduleMaintenanceDA = Java.type('app.dataAccess.ScheduleMaintenanceDA')
    * def ScheduleMaintenanceService = Java.type('app.services.ScheduleMaintenanceService')
    * def scheduleMaintenanceDA = new ScheduleMaintenanceDA()
    * def smService = new ScheduleMaintenanceService(scheduleMaintenanceDA)

    # ==== Utils ====
    * def apiConvertSMInfoFunc =
        """
        function(arr){
            return (arr || []).map(x => ({ 
                mileage: x.Mileage,
                kilometers: x.Kilometers,
                fixNameId: x.FixNameId,
                serviceName: x.ServiceName
            }))
        }
        """

    * def dbConvertSMInfoFunc =
        """
        function(arr){
            return (arr || []).map(x => ({ 
                mileage: x.mileage,
                kilometers: x.kilometers,
                fixNameId: x.fixNameId,
                serviceName: x.serviceName
            }))
        }
        """

  Scenario Outline: Verify Scheduled Maintenance matches expected data VIN: '<VIN>'
     And request
      """
      {
        "Vin": "#(VIN)",
        "Language": "en-us",
        "Region": "CA",
        "CurrencyCode": "USD",
        "CurrentMileage": 50000,
        "CurrentKilometers": 0
      }
      """
    When method post
    Then status 200
    And match response.Ok == true

    * def apiSMs = karate.get('response.Data', [])
    * def apiSMNormalized = apiConvertSMInfoFunc(apiSMs)

    * def year = <Year>
    * def make = '<Make>'
    * def model = '<Model>'
    * def engine = '<EngineType>'
    * def engineVINCode = ''
    * def transmission = '<Transmission>'
    * def trimLevel = ''
    * def smNextServides = smService.getScheduledMaintenanceNextServiceForVehicle(year, make, model, engine, engineVINCode, transmission, trimLevel, 5000, 0)
    * print 'DB SM count:', smNextServides.length

    * def dbSMNormalized = dbConvertSMInfoFunc(smNextServides)

    * def compareEach =
    """
    function(apiArr, dbArr){
        karate.forEach(apiArr, function(apiItem){
            var dbItem = dbArr.find(function(d){ return d.fixNameId == apiItem.fixNameId });
            if (dbItem == null)
            {
              karate.fail('Cannot find DB item with fixNameId: ' + apiItem.fixNameId);
            }
            else {
              var r1 = karate.match(apiItem.mileage, dbItem.mileage);
              if (!r1.pass)
                  karate.fail(
                      r1.message +
                      `Mismatch TSB[${apiItem.fixNameId}] Cat[${dbItem.fixNameId}] `
                      + `API=${apiItem.mileage} DB=${dbItem.mileage}`
                  );

              var r2 = karate.match(apiItem.serviceName, dbItem.serviceName);
              if (!r2.pass)
                  karate.fail(
                      r2.message +
                      `Mismatch TSB[${apiItem.fixNameId}] Cat[${dbItem.fixNameId}] `
                      + `API=${apiItem.serviceName} DB=${dbItem.serviceName}`
                  );
            }
        });
    }
    """
    * eval compareEach(apiSMNormalized, dbSMNormalized)

    Examples:
      | read('classpath:resources/data/excels/innova/Vehicle_Info_Test_5_Row.csv') |
