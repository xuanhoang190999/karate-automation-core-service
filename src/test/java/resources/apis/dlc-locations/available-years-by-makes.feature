Feature: DLC Locations: Available years by makes

  Background:
    * url 'https://dev-core-service.innova.com/api/dlc-locations/available-years-by-makes'
    * header Content-Type = 'application/json'
    * header Accept = 'application/json'
    * header api-key = 'EJPLzfSyCmdDSUzhG9LJwt3MCgTrAN'
    * def makesData = read('classpath:resources/data/dlc-locations/available-years-by-makes.json')
    * def expectedYears_Sprinter_Ferrari = makesData.expectedYears_Sprinter_Ferrari
    * def expectedYears_Ford = makesData.expectedYears_Ford

  Scenario: Check available years for makes Sprinter and Ferrari
    And request
      """
      {
        "Makes": ["Sprinter","Ferrari"]
      }
      """
    When method post
    Then status 200
    And match response.Data == expectedYears_Sprinter_Ferrari

  Scenario: Check available years for make Ford
    And request
      """
      {
        "Makes": ["Ford"]
      }
      """
    When method post
    Then status 200
    And match response.Data == expectedYears_Ford