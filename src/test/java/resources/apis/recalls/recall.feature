Feature: Recalls: Get Info

  Background:
    * url 'https://dev-core-service.innova.com/api/recalls'
    * header Content-Type = 'application/json'
    * header Accept = 'application/json'
    * header api-key = 'EJPLzfSyCmdDSUzhG9LJwt3MCgTrAN'

  Scenario: Get Recalls info by VIN: 3GKALVEV6NL120462
    And request
      """
        {
            "Language": "en-us",
            "VIN": "3GKALVEV6NL120462"
        }
      """
    When method post
    Then status 200
    And match response.Ok == true
    * def lengthData = response.Data.length
    And match lengthData == 2
    And match response.Data[0].RecordNumber == 85845
    And match response.Data[1].RecordNumber == 85846
    And match response.Data[0].CampaignNumber == '23V339000'
    And match response.Data[1].CampaignNumber == '22V724000'
    And match response.Data[0].RecallDateString == '1/11/2023'
    And match response.Data[1].RecallDateString == '1/29/2022'

    And match response.Data[0].DefectDescription != null
    And match response.Data[0].DefectDescription != ''
    And match response.Data[0].DefectConsequence != null
    And match response.Data[0].DefectConsequence != ''
    And match response.Data[0].DefectCorrectiveAction != null
    And match response.Data[0].DefectCorrectiveAction != ''

    And match response.Data[1].DefectDescription != null
    And match response.Data[1].DefectDescription != ''
    And match response.Data[1].DefectConsequence != null
    And match response.Data[1].DefectConsequence != ''
    And match response.Data[1].DefectCorrectiveAction != null
    And match response.Data[1].DefectCorrectiveAction != ''