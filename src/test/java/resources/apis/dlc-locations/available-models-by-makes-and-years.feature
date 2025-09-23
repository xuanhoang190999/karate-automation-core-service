Feature: DLC Locations: Available models by makes and years

  Background:
    * url 'https://dev-core-service.innova.com/api/dlc-locations/available-models-by-makes-and-years'
    * header Content-Type = 'application/json'
    * header Accept = 'application/json'
    * header api-key = 'EJPLzfSyCmdDSUzhG9LJwt3MCgTrAN'
    * def makesData = read('classpath:resources/data/dlc-locations/available-models-by-makes-and-years.json')
    * def expected_Ferrari_2021_2014_2001 = makesData.expected_Ferrari_2021_2014_2001
    * def expected_Plymouth_2021_2014_2001 = makesData.expected_Plymouth_2021_2014_2001

  Scenario: Check available models for makes Ferrari and Years: 2021, 2014, 2001
    And request
      """
      {
        "Makes": ["Ferrari"],
        "Years": [2021, 2014, 2001]
      }
      """
    When method post
    Then status 200
    And match response.Data == expected_Ferrari_2021_2014_2001

  Scenario: Check available models for makes Plymouth and Years: 2021, 2014, 2001
    And request
      """
      {
        "Makes": ["Plymouth"],
        "Years": [2021, 2014, 2001]
      }
      """
    When method post
    Then status 200
    And match response.Data == expected_Plymouth_2021_2014_2001