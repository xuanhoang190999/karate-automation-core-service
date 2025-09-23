Feature: Vehicles: Gets the list of available YMME by Years/Makes/Models

  Background:
    * url 'https://dev-core-service.innova.com/api/vehicles/available-ymmes'
    * header Content-Type = 'application/json'
    * header Accept = 'application/json'
    * header api-key = 'EJPLzfSyCmdDSUzhG9LJwt3MCgTrAN'

  Scenario: Gets the list of available YMME by Years: [1990, 2010], Makes: ["BENTLEY", "CHEVROLET"], Models: ["TRAVERSE", "MULSANNE"], SelectedManufacturer: "CHEVROLET"
    And request
      """
        {
            "SelectedManufacturer": "CHEVROLET",
            "Years": [1990, 2010],
            "Makes": ["BENTLEY", "CHEVROLET"],
            "Models": ["TRAVERSE", "MULSANNE"]
        }
      """
    When method post
    Then status 200
    And match response.Ok == true
    And match response.Data != null
    And match response.Data[0].Year == 2010
    And match response.Data[0].Make == "CHEVROLET"
    And match response.Data[0].Model == "TRAVERSE"
    And match response.Data[0].EngineType == "V6, 3.6L; DOHC; 24V; DI"
