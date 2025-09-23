Feature: TSBS: Get Tsbs count

  Background:
    * url 'https://dev-core-service.innova.com/api/tsbs'
    * header Content-Type = 'application/json'
    * header Accept = 'application/json'
    * header api-key = 'EJPLzfSyCmdDSUzhG9LJwt3MCgTrAN'

  Scenario: Get TSB Info by Vehicle and Error Codes by VIN: 1C6RRFJG*PN******, Category: Cooling, ErrorCodes: [P26A3]
    And request
      """
        {
            "PageNumber": 1,
            "PageSize": 20,
            "VIN": "1C6RRFJG*PN******",
            "Category": "Cooling",
            "ErrorCodes": [
                "P26A3"
            ]
        }
      """
    When method post
    Then status 200
    And match response.Ok == true
    And match response.Data.TotalRecords == 0
    And match response.Data.Records == []