Feature: Fixes: Update Part Pricing and get info

  Background:
    * url 'https://dev-core-service.innova.com/api/fixes/update-part-pricing'
    * header Content-Type = 'application/json'
    * header Accept = 'application/json'
    * header api-key = 'EJPLzfSyCmdDSUzhG9LJwt3MCgTrAN'
    * def partNumber = '8E5Z12A650LB'
    * def make = 'MAZDA' 
    * def newPrice = 199.99

  Scenario: Update pricing for part number '#(partNumber)' of make '#(make)'
    And request
    """
        {
            "Make": "#(make)",
            "PartNumber": "#(partNumber)",
            "Price": #(newPrice)
        }
    """
    When method post
    Then status 200
    And match response.Data.Ok == true
    And match response.Data.Message == 'Update part pricing succeed.'