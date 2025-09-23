Feature: WFTC: Get Fixes by search keywords

  Background:
    * url 'https://dev-core-service.innova.com/api/wftcs/fix-names'
    * header Content-Type = 'application/json'
    * header Accept = 'application/json'
    * header api-key = 'EJPLzfSyCmdDSUzhG9LJwt3MCgTrAN'
    * def searchTerm = 'change'

  Scenario: Get Fixes by search keywords: "#(searchTerm)"
    And request
      """
        {
            "SearchTerm": "#(searchTerm)"
        }
      """
    When method post
    Then status 200
    And match response.Ok == true
    And match response.Data != null
    * def allContainSearchTerm = response.Data.every(x => x.FixNameDescription.toLowerCase().includes(searchTerm))
    * match allContainSearchTerm == true