Feature: Fixes: Get fixes and repair tips by VIN

  Background:
    * url 'https://dev-core-service.innova.com/api/fixes/repair-tips-by-vin'
    * header Content-Type = 'application/json'
    * header Accept = 'application/json'
    * header api-key = 'EJPLzfSyCmdDSUzhG9LJwt3MCgTrAN'
    * def fixesData = read('classpath:resources/data/fixes/repair-tips-by-vin.json')
    * def expected_VIN_1GT2 = fixesData.expected_VIN_1GT2
    * def expected_VIN_1GNA = fixesData.expected_VIN_1GNA

  Scenario: Get fixes and repair tips by VIN: 1GT21XEG*HZ******
    And request
      """
        {
            "VIN": "1GT21XEG*HZ******",
            "Language": "en-us",
            "Region": "CA",
            "CurrencyCode": "USD",
            "PwrCodes": [
                "P05A0",
                "P0307",
                "P0300",
                "P0301"
            ],
            "AbsCodes": [
                "C0221",
                "C0236",
                "C0246",
                "C0222",
                "P0300"
            ],
            "SrsCodes": [
                "P0300",
                "P0301"
            ]
        }
      """
    When method post
    Then status 200
    And match response.Ok == true
    And match response.Data == expected_VIN_1GT2

    Scenario: Get fixes and repair tips by VIN: 1GNALAEK1FZ105363
    And request
      """
        {
            "VIN": "1GNALAEK1FZ105363",
            "Language": "en-us",
            "Region": "CA",
            "CurrencyCode": "USD",
            "PwrCodes": [
                "P0420"
            ],
            "AbsCodes": [
                "B0017-05"
            ],
            "SrsCodes": []
        }
      """
    When method post
    Then status 200
    And match response.Ok == true
    And match response.Data == expected_VIN_1GNA