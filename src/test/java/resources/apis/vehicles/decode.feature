Feature: Vehicles: Get Info by VIN

  Background:
    * url 'https://dev-core-service.innova.com/api/vehicles/decode'
    * header Content-Type = 'application/json'
    * header Accept = 'application/json'
    * header api-key = 'EJPLzfSyCmdDSUzhG9LJwt3MCgTrAN'
    * def vehiclesData = read('classpath:resources/data/vehicles/decode.json')
    * def expected_2CNDL73F976028975 = vehiclesData.expected_2CNDL73F976028975
    * def expected_1GNL = vehiclesData.expected_1GNL

  Scenario: Get Vehicle Info by VIN: 2CNDL73F976028975
    And request
      """
        {
            "Vin": "2CNDL73F976028975"
        }
      """
    When method post
    Then status 200
    And match response.Ok == true
    And match response.Data == expected_2CNDL73F976028975

  Scenario: Get Vehicle Info by VIN: 1GNLRFED*A*******
    And request
      """
        {
            "Vin": "1GNLRFED*A*******"
        }
      """
    When method post
    Then status 200
    And match response.Ok == true
    And match response.Data == expected_1GNL