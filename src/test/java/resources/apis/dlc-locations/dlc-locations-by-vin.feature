Feature: DLC Locations: Get info by VIN

  Background:
    * url 'https://dev-core-service.innova.com/api/dlc-locations'
    * header Content-Type = 'application/json'
    * header Accept = 'application/json'
    * header api-key = 'EJPLzfSyCmdDSUzhG9LJwt3MCgTrAN'

  Scenario Outline: Check invalid VIN and Language VIN: '<VIN>' and Language: '<LANG>'
    And request { Language: '#(LANG)', Vin: '#(VIN)' }
    When method post
    Then status <Status>
    And match response.Ok == false
    And match response.Message == <Message>
    And match response.Data == ERRORS

    Examples:
      | LANG!   | VIN!                  | Status | Message                 | ERRORS!                                                                                                  |
      | null    | null                  | 400    | 'Invalid data provided' | [{"Field":"Vin","Error":"The Vin field is required."},{"Field":"Language","Error":"The Language field is required."}] |
      | null    | 'JM1DRACB*N1******'   | 400    | 'Invalid data provided' | [{"Field":"Language","Error":"The Language field is required."}]                                     |
      | 'en-us' | null                  | 400    | 'Invalid data provided' | [{"Field":"Vin","Error":"The Vin field is required."}]                                               |
      | 'en-us' | 'JM1DRACB*N1******__'   | 200    | 'The VIN supplied is invalid. The following VINs were tried and failed: JM1DRACB*N1******__' | null |

  Scenario: Check Authentication
    And header api-key = ''
    And request { Language: 'en-us', Vin: 'JM1DRACB*N1******' }
    When method post
    Then status 401
    And match response.Ok == false
    And match response.Message == "Invalid Api Key"
    And match response.Data == null

  Scenario: Check Year/Make/Model/LocationNumber/Access/Comments and Image URLs is null with VIN JM1DRACB*N1******
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
    And match response.Data[0].ImageFileName == '#? _ == null || _ == ""'
    And match response.Data[0].ImageFileUrl == '#? _ == null || _ == ""'
    And match response.Data[0].ImageFileUrlSmall == '#? _ == null || _ == ""'

  Scenario: Check Year/Make/Model/LocationNumber/Access/Comments and Image URLs can not null with VIN 4T4BF1FK1FR513668
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

  Scenario: Check Year/Make/Model/LocationNumber/Access/Comments and Image URLs can not null with VIN 2CNDL73F976028975
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
