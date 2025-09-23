Feature: DTC Library ErrorCode: Info

  Background:
    * url 'https://dev-core-service.innova.com/api/dtc-library-error-code'
    * header Content-Type = 'application/json'
    * header Accept = 'application/json'
    * header api-key = 'EJPLzfSyCmdDSUzhG9LJwt3MCgTrAN'

  Scenario: Get DTC Code info for Make: FORD, ErrorCode: P0132
    And request
      """
      {
        "Make": "FORD",
        "ErrorCode": "P0132",
        "Language": "en-us"
      }
      """
    When method post
    Then status 200
    And match response.Ok == true
    And match response.Data.ErrorCode == 'P0132'
    And match response.Data.Make == 'FORD'
    And match response.Data.Description == '\"(O2) Circuit High Voltage (Bank 1, Sensor 1)\"'