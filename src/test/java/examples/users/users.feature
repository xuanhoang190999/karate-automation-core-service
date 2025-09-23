Feature: Sample Karate test script
  For help, see: https://github.com/karatelabs/karate/wiki/IDE-Support

  Background:
    * url 'https://dev-core-service.innova.com/api/dlc-locations'
    * header Content-Type = 'application/json'
    * header Accept = 'application/json'
    * header api-key = 'EJPLzfSyCmdDSUzhG9LJwt3MCgTrAN'

  Scenario: Check Year/Make/Model/LocationNumber/Access/Comments and Image URLs are present
    And request
      """
      {
        "Language": "en-us",
        "Vin": "4T4BF1FK1FR513668"
      }
      """
    When method post
    Then status 200
    And match response.Ok == true
    And match response.Data[0].Year == '2015'
    And match response.Data[0].ImageFileUrl != null
    And match response.Data[0].ImageFileUrlSmall != null
