Feature: Fixes: Get Makes by Make and PartNumber

  Background:
    * url 'https://dev-core-service.innova.com/api/fixes/makes-by-make-and-part-number'
    * header Content-Type = 'application/json'
    * header Accept = 'application/json'
    * header api-key = 'EJPLzfSyCmdDSUzhG9LJwt3MCgTrAN'
    * def makesData = read('classpath:resources/data/fixes/makes-by-make-and-part-number.json')
    * def expected_MAZDA_8E5Z12A650LB = makesData.expected_MAZDA_8E5Z12A650LB

  Scenario: Get Makes by Make: MAZDA and PartNumber: 8E5Z12A650LB
    And param Make = 'MAZDA'
    And param PartNumber = '8E5Z12A650LB'
    When method get
    Then status 200
    And match response.Data == expected_MAZDA_8E5Z12A650LB