Feature: DLC Locations: Get info by VIN

  Background:
    * url 'https://dev-core-service.innova.com/api/dlc-locations'
    * header Content-Type = 'application/json'
    * header Accept = 'application/json'
    * header api-key = 'EJPLzfSyCmdDSUzhG9LJwt3MCgTrAN'
    * def apiKeyDefault = 'EJPLzfSyCmdDSUzhG9LJwt3MCgTrAN'

  Scenario Outline: <title>
    And request { Language: '#(lang)', Vin: '#(vin)' }
    * def keys = Object.keys(__row)
    # * print 'keys =', keys
    * def key = keys.includes('apiKey') ? __row.apiKey : apiKeyDefault
    * header api-key = key
    When method post
    Then status <status>
    And match response.Ok == false
    # And match response.Message == '#(message)'
    And match response.Data == __row.data
    And match response.Message == '<message>'
    * print 'Data: ', __row.data
    And match response.Data == __row.data

    Examples:
      | read('classpath:resources/data/dlc-locations/test-cases/dlc-locations.json') |

  Scenario: Verify DLC Location Info and verify ImageFileName is null by VIN: JM1DRACB*N1******
    And request
      """
      {
        "Language": "en-us",
        "Vin": "JM1DRACB*N1******"
      }
      """
    When method post
    Then status 200
    And match response.Ok == true
    And match response.Data[0].Year == '2022'
    And match response.Data[0].Make == 'MAZDA'
    And match response.Data[0].Model == 'MX-30'
    And match response.Data[0].LocationNumber == 2
    And match response.Data[0].Access == 'uncovered'
    And match response.Data[0].Comments == 'Driver Side - Under Lower Left Side of Dashboard'
    And match response.Data[0].ImageFileName == '#[null, ""]'
    And match response.Data[0].ImageFileUrl == '#[null, ""]'
    And match response.Data[0].ImageFileUrlSmall == '#[null, ""]'

  Scenario: Check DLC Location Info and Image URLs cannot null by VIN: 4T4BF1FK1FR513668
    And request
      """
      {
        "Language": "en-us",
        "Vin": "4T4BF1FK1FR513668"
      }
      """
    When method post
    Then status 200
    And match response.Ok == true
    And match response.Data[0].Year == '2015'
    And match response.Data[0].Make == 'Toyota'
    And match response.Data[0].Model == 'Camry'
    And match response.Data[0].LocationNumber == 2
    And match response.Data[0].Access == 'uncovered '
    And match response.Data[0].Comments == 'Driver Side - Under Lower Left Side of Dashboard'
    And match response.Data[0].ImageFileName != null
    And match response.Data[0].ImageFileUrl != null
    And match response.Data[0].ImageFileUrlSmall != null

  Scenario: Check DLC Location Info and Image URLs can not null by VIN: 2CNDL73F976028975
    And request
      """
      {
        "Language": "en-us",
        "Vin": "2CNDL73F976028975"
      }
      """
    When method post
    Then status 200
    And match response.Ok == true
    And match response.Data[0].Year == '2007'
    And match response.Data[0].Make == 'Chevrolet'
    And match response.Data[0].Model == 'Equinox'
    And match response.Data[0].LocationNumber == 2
    And match response.Data[0].Access == 'uncovered '
    And match response.Data[0].Comments == 'Driver Side - Under Lower Left Side of Dashboard'
    And match response.Data[0].ImageFileName != null
    And match response.Data[0].ImageFileUrl != null
    And match response.Data[0].ImageFileUrlSmall != null

  Scenario: Check DLC Location Info and Image URLs can not null with VIN: JM1DRACB*N1****** and es-mx Language
    And request
      """
      {
        "Language": "es-mx",
        "Vin": "JM1DRACB*N1******"
      }
      """
    When method post
    Then status 200
    And match response.Ok == true
    And match response.Data[0].Year == '2022'
    And match response.Data[0].Make == 'MAZDA'
    And match response.Data[0].Model == 'MX-30'
    And match response.Data[0].LocationNumber == 2
    And match response.Data[0].Access == 'descubierto'
    And match response.Data[0].Comments == 'Del lado del conductor - En la parte inferior izquierda del panel'
    And match response.Data[0].ImageFileName == '#[null, ""]'
    And match response.Data[0].ImageFileUrl == '#[null, ""]'
    And match response.Data[0].ImageFileUrlSmall == '#[null, ""]'
