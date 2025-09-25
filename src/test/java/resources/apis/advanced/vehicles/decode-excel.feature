Feature: Decode VIN and compare with CSV data

  Background:
    * url 'https://dev-core-service.innova.com/api/vehicles/decode'
    * header Content-Type = 'application/json'
    * header Accept = 'application/json'
    * header api-key = 'EJPLzfSyCmdDSUzhG9LJwt3MCgTrAN'
    # * def records = read('classpath:resources/data/excels/innova/Vehicle_Info_Test_5_Row.csv')

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
    And match response.Data.FuelMPGCombined == '#? _ == null || _ == "<FuelMPGCombined>"'
    And match response.Data.FuelMPGCity == '#? _ == null || _ == "<FuelMPGCity>"'
    And match response.Data.FuelMPGHighway == '#? _ == null || _ == "<FuelMPGHighway>"'
    And match response.Data.ModelImageFileUrl contains '<ModelImageName>'
    And match response.Data.ACESBaseVehicleID == '#? _ == null || _ == <ACESBaseVehicleID>'
    And match response.Data.ACESEngineBaseID == '#? _ == null || _ == <ACESEngineBaseID>'
    And match response.Data.ACESSubModelID == '#? _ == null || _ == <ACESSubModelID>'
    And match response.Data.VehicleClass == '<VehicleClass>'
    And match response.Data.VehicleClass == '<VehicleClass>'
    And match response.Data.PolkVehicleYMMEId.toLowerCase() == '<PolkVehicleYMMEId>'.toLowerCase()

    Examples:
      | read('classpath:resources/data/excels/innova/Vehicle_Info_Test_5_Row.csv') |
