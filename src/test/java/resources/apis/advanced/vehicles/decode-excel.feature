Feature: Vehicle: Info By VIN

  Background:
    * url 'https://dev-core-service.innova.com/api/vehicles/decode'
    * header Content-Type = 'application/json'
    * header Accept = 'application/json'
    * header api-key = 'EJPLzfSyCmdDSUzhG9LJwt3MCgTrAN'
    # * def records = read('classpath:resources/data/excels/innova/Vehicle_Info_Test_5_Row.csv')
    * def isNullOrEqual = function(x, expected){ return x == null || x == expected }

  Scenario Outline: Verify Vehicle info matches expected data VIN: '<VIN>'
    And request { Vin: '<VIN>' }
    When method post
    Then status 200
    And match response.Ok == true

    And match response.Data.Make == '<Make>'
    And match response.Data.Model == '<Model>'
    And match response.Data.Year == <Year>
    And match response.Data.EngineType == '<EngineType>'
    And match response.Data.AAIA == '<AAIA>'
    And match response.Data.VehicleClass == '<VehicleClass>'
    And match response.Data.Transmission == '<Transmission>'
    And match isNullOrEqual(response.Data.FuelMPGCombined, <FuelMPGCombined>) == true
    And match isNullOrEqual(response.Data.FuelMPGCity, <FuelMPGCity>) == true
    And match isNullOrEqual(response.Data.FuelMPGHighway, <FuelMPGHighway>) == true
    And match response.Data.ModelImageFileUrl contains '<ModelImageName>'
    And match isNullOrEqual(response.Data.ACESBaseVehicleID, <ACESBaseVehicleID>) == true
    And match isNullOrEqual(response.Data.ACESEngineBaseID, <ACESEngineBaseID>) == true
    And match isNullOrEqual(response.Data.ACESSubModelID, <ACESSubModelID>) == true
    And match response.Data.PolkVehicleYMMEId.toLowerCase() == '<PolkVehicleYMMEId>'.toLowerCase()

    Examples:
      | read('classpath:resources/data/excels/innova/Vehicle_Info_Test_5_Row.csv') |
