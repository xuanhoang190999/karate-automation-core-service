Feature: DLC Locations: Get info by Year, Make, Model

  Background:
    * url 'https://dev-core-service.innova.com/api/dlc-locations/get-infos-by-year-make-model'
    * header Content-Type = 'application/json'
    * header Accept = 'application/json'
    * header api-key = 'EJPLzfSyCmdDSUzhG9LJwt3MCgTrAN'

  Scenario: Check dlc location info for Year: 2022, Make: Acura, Model: ILX
    And request
      """
      {
        "Language": "en-us",
        "Year": 2020,
        "Make": "Acura",
        "Model": "ILX"
      }
      """
    When method post
    Then status 200
    And match response.Ok == true
    And match response.Data[0].Year == '2020'
    And match response.Data[0].Make == 'Acura'
    And match response.Data[0].Model == 'ILX'
    And match response.Data[0].LocationNumber == 2
    And match response.Data[0].Access == 'uncovered '
    And match response.Data[0].Comments == 'Driver Side - Under Lower Left Side of Dashboard'
    And match response.Data[0].ImageFileName == 'ilx-1'
    And match response.Data[0].ImageFileUrl != null
    And match response.Data[0].ImageFileUrlSmall != null