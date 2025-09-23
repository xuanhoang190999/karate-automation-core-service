Feature: DLC Locations: Available makes by years

  Background:
    * url 'https://dev-core-service.innova.com/api/dlc-locations/available-makes-by-years'
    * header Content-Type = 'application/json'
    * header Accept = 'application/json'
    * header api-key = 'EJPLzfSyCmdDSUzhG9LJwt3MCgTrAN'
    * def makesData = read('classpath:resources/data/dlc-locations/available-makes-by-years.json')
    * def expectedMakes_2009_2015 = makesData.expectedMakes_2009_2015
    * def expectedMakes_1995 = makesData.expectedMakes_1995
    * def expectedMakes_2025 = makesData.expectedMakes_2025

  Scenario: Check available makes for years 2009 and 2015
    And request
      """
      {
        "Years": [2009, 2015]
      }
      """
    When method post
    Then status 200
    And match response.Data == expectedMakes_2009_2015

  Scenario: Check available makes for year 1995
    And request
      """
      {
        "Years": [1995]
      }
      """
    When method post
    Then status 200
    And match response.Data == expectedMakes_1995

  Scenario: Check available makes for year 2025
    And request
      """
      {
        "Years": [2025]
      }
      """
    When method post
    Then status 200
    And match response.Data == expectedMakes_2025
