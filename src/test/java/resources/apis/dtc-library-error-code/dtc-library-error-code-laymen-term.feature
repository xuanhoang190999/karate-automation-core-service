Feature: DTC Library ErrorCode: Laymen Term

  Background:
    * url 'https://dev-core-service.innova.com/api/dtc-library-error-code/laymen-term'
    * header Content-Type = 'application/json'
    * header Accept = 'application/json'
    * header api-key = 'EJPLzfSyCmdDSUzhG9LJwt3MCgTrAN'

  Scenario: Get DTC Code Laymen Term info for Make: Toyota, ErrorCode: P0113
    And request
      """
      {
        "Make": "Toyota",
        "ErrorCode": "P0113",
        "Language": "en-us"
      }
      """
    When method post
    Then status 200
    And match response.Ok == true
    And match response.Data.ErrorCode == 'P0113'
    And match response.Data.Make == 'Toyota'
    And match response.Data.Title == 'Intake Air Temperature Sensor 1 Circuit High Bank 1'
    And match response.Data.DTCCodeLaymanTermId != null
    And match response.Data.Description == 'Code P0113 indicates that the Intake Air Temperature Sensor 1 electrical circuit input signal had high voltage for a predetermined period of time.'
    And match response.Data.SeverityLevel == 2
    And match response.Data.SeverityLevelDefinition == 'Repair immediately if drivability issues are present. Threat to essential system components if not repaired as soon as possible.'
    And match response.Data.EffectOnVehicle == 'This condition will prevent the vehicle from running at its optimum efficiency and fuel economy may suffer.'
    And match response.Data.ResponsibleComponentOrSystem == 'The intake air temperature sensor input is used by the computer to control air/fuel mixture and compare it to other temperature sensors.'
    And match response.Data.WhyItsImportant == 'The intake air temperature sensor reduces emissions and increases fuel economy.'
    And match response.Data.VerifiedFixCount == 96