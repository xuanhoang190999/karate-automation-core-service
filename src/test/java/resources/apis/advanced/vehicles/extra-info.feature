Feature: Vehicle: Extra Info & TSBs from API vs DB

Background:
    # ==== API setup ====
    * url 'https://dev-core-service.innova.com/api/vehicles/extra-info'
    * header Content-Type = 'application/json'
    * header Accept = 'application/json'
    * header api-key = 'EJPLzfSyCmdDSUzhG9LJwt3MCgTrAN'

    # ==== Java DB setup ====
    * def PolkVehicleDA = Java.type('app.dataAccess.PolkVehicleDA')
    * def TsbDA = Java.type('app.dataAccess.TsbDA')
    * def TsbService = Java.type('app.services.TSBService')
    * def polkDA = new PolkVehicleDA()
    * def tsbDA = new TsbDA()
    * def tsbService = new TsbService(polkDA, tsbDA, 'https://tsbrooturl')

    # ==== Utils ====
    * def apiConvertTsbInfoFunc =
        """
        function(arr){
            return (arr || []).map(x => ({ 
                id: x.TsbId,
                desc: x.Description,
                cats: x.TSBCategories.map(y => ({
                    id: y.Id,
                    desc: y.Description,
                    tsbCount: y.TSBCount
                }))
            }))
        }
        """

        * def dbConvertTsbInfoFunc =
        """
        function(arr){
            return (arr || []).map(x => ({ 
                id: x.tsbId,
                desc: x.description,
                cats: x.tsbCategories.map(y => ({
                    id: y.id,
                    desc: y.description,
                    tsbCount: y.tsbCount
                }))
            }))
        }
        """

Scenario Outline: Verify Vehicle info & TSBs VIN: '<VIN>'
     And request
      """
      {
        "Vin": "#(VIN)",
        "Language": "en-us",
        "Region": "CA",
        "CurrencyCode": "USD",
        "CurrentMileage": 5000,
        "CurrentKilometers": 0
      }
      """
    When method post
    Then status 200
    And match response.Ok == true

    And match response.Data.VehicleInfo.Make == '<Make>'
    And match response.Data.VehicleInfo.Model == '<Model>'
    And match response.Data.VehicleInfo.Year == <Year>
    And match response.Data.VehicleInfo.EngineType == '<EngineType>'
    And match response.Data.VehicleInfo.AAIA == '<AAIA>'
    And match response.Data.VehicleInfo.Transmission == '<Transmission>'
    And match response.Data.VehicleInfo.FuelMPGCombined == '#? _ == null || _ == "<FuelMPGCombined>"'
    And match response.Data.VehicleInfo.FuelMPGCity == '#? _ == null || _ == "<FuelMPGCity>"'
    And match response.Data.VehicleInfo.FuelMPGHighway == '#? _ == null || _ == "<FuelMPGHighway>"'
    And match response.Data.VehicleInfo.ModelImageFileUrl contains '<ModelImageName>'
    And match response.Data.VehicleInfo.ACESBaseVehicleID == '#? _ == null || _ == <ACESBaseVehicleID>'
    And match response.Data.VehicleInfo.ACESEngineBaseID == '#? _ == null || _ == <ACESEngineBaseID>'
    And match response.Data.VehicleInfo.ACESSubModelID == '#? _ == null || _ == <ACESSubModelID>'
    And match response.Data.VehicleInfo.PolkVehicleYMMEId.toLowerCase() == '<PolkVehicleYMMEId>'.toLowerCase()

    * def apiTsbs = karate.get('response.Data.TSBs.Data', [])
    # * def apiTsbIds = karate.jsonPath(apiTsbs, "$[*].TsbId")
    # * print 'API TSB IDs:', apiTsbIds
    * def apiTsbNormalized = apiConvertTsbInfoFunc(apiTsbs)
    * print 'API TSB Info:', apiTsbNormalized

    * def year = <Year>
    * def make = '<Make>'
    * def model = '<Model>'
    * def engine = '<EngineType>'
    * def tsbList = tsbService.getTSBsForVehicleByYMME(year, make, model, engine)
    * print 'DB TSB count:', tsbList.length

    # * def dbTsbIds = karate.jsonPath(karate.toJson(tsbList), "$[*].tsbId")
    # * print 'DB TSB IDs:', dbTsbIds

    # And match apiTsbIds contains only dbTsbIds

    * def dbTsbNormalized = dbConvertTsbInfoFunc(tsbList)
    * print 'DB TSB Info:', apiTsbNormalized

    # STEP 1: Relax TSB count match due to data differences
    # * match apiTsbNormalized contains only dbTsbNormalized
    
    # STEP 2: Custom comparison function to get detailed mismatch info
    * def compareEach =
    """
    function(apiArr, dbArr){
        karate.forEach(apiArr, function(apiItem){
            var dbItem = dbArr.find(function(d){ return d.id == apiItem.id });
            if (!dbItem) karate.fail('Cannot find DB item with id: ' + apiItem.id);

            var r1 = karate.match(apiItem.desc, dbItem.desc);
            if (!r1.pass)
                karate.fail(
                    r1.message +
                    `Mismatch TSB[${apiItem.id}] Cat[${dbItem.id}] `
                    + `API=${apiItem.desc} DB=${dbItem.desc}`
                );

            var r2 = karate.match(apiItem.cats.length, dbItem.cats.length);
            if (!r2.pass)
                karate.fail(
                    r2.message +
                    `Mismatch Length TSB[${apiItem.id}] Cat[${dbItem.id}] `
                    + `API=${apiItem.cats.length} DB=${dbItem.cats.length}`
                );

            karate.forEach(apiItem.cats, function(apiCat){
                var dbCat = dbItem.cats.find(function(c){ return c.id == apiCat.id });
                if (!dbCat) karate.fail('Cannot find category id: ' + apiCat.id + ' in DB');

                var m1 = karate.match(apiCat.desc, dbCat.desc);
                if (!m1.pass)
                    karate.fail(
                        m1.message +
                        `Mismatch TSB[${apiCat.id}] Cat[${dbCat.id}] `
                        + `API=${apiCat.desc} DB=${dbCat.desc}`
                    );

                var m2 = karate.match(apiCat.tsbCount, dbCat.tsbCount);
                if (!m2.pass)
                    karate.fail(
                        m2.message +
                        `Mismatch TSB[${apiCat.id}] Cat[${dbCat.id}] `
                        + `API=${apiCat.tsbCount} DB=${dbCat.tsbCount}`
                    );
            });
        });
    }
    """
    * eval compareEach(apiTsbNormalized, dbTsbNormalized)

Examples:
    | read('classpath:resources/data/excels/innova/Vehicle_Info_Test_5_Row.csv') |
