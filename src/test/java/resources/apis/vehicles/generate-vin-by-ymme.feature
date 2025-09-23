Feature: Vehicles: Generates a masked VIN By Year/Make/Model/Engine

  Background:
    * url 'https://dev-core-service.innova.com/api/vehicles/generate-vin-by-ymme'
    * header Content-Type = 'application/json'
    * header Accept = 'application/json'
    * header api-key = 'EJPLzfSyCmdDSUzhG9LJwt3MCgTrAN'

  Scenario: Generates a masked VIN by Year: 2010, Make: "CHEVROLET", Model: "TRAVERSE", EngineType: "V6, 3.6L; SOHC"
    And request
      """
        {
            "Year": 2010,
            "Make": "CHEVROLET",
            "Model": "TRAVERSE",
            "EngineType": "V6, 3.6L; SOHC"
        }
      """
    When method post
    Then status 200
    And match response.Ok == true
    And match response.Data == "1GNLRFED*A*******"
