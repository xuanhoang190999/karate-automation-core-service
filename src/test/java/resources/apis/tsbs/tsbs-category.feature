Feature: TSBS: Get Info by VIN

  Background:
    * url 'https://dev-core-service.innova.com/api/tsbs/category'
    * header Content-Type = 'application/json'
    * header Accept = 'application/json'
    * header api-key = 'EJPLzfSyCmdDSUzhG9LJwt3MCgTrAN'

  Scenario: Get TSBCount By Vehicle By VIN: 1C6SRFKM*PN******
    And request
      """
        {
            "Vin": "1C6SRFKM*PN******"
        }
      """
    When method post
    Then status 200
    And match response.Ok == true
    And match response.Data == []