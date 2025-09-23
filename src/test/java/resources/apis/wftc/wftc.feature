Feature: WFTC: Submit WFTC

  Background:
    * url 'https://dev-core-service.innova.com/api/wftcs'
    * header Content-Type = 'application/json'
    * header Accept = 'application/json'
    * header api-key = 'EJPLzfSyCmdDSUzhG9LJwt3MCgTrAN'

  Scenario: Submit WFTC by Year: 2024, Make: Mitsubishi, Model: Xforce, Engine: MIVEC 1.5L, DtcCode: P0420
    And request
      """
        {
            "Year": 2024,
            "Make": "Mitsubishi",
            "Model": "Xforce",
            "EngineType": "MIVEC 1.5L",
            "DtcCode": "P0420",
            "FixId": "",
            "FixNameId": "",
            "OtherFixNameId": "",
            "OtherFixNameText": "",
            "ExternalSystemId": ""
        }
      """
    When method post
    Then status 200
    And match response.Ok == true
    And match response.Data != null