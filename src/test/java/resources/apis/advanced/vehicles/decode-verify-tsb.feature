Feature: Print TSBs from DB for a vehicle

Background:
    * def PolkVehicleDA = Java.type('app.dataAccess.PolkVehicleDA')
    * def TsbDA = Java.type('app.dataAccess.TsbDA')
    * def TsbService = Java.type('app.services.TSBService')

    * def polkDA = new PolkVehicleDA()
    * def tsbDA = new TsbDA()
    * def service = new TsbService(polkDA, tsbDA, 'https://tsbrooturl')

Scenario: Print TSB list for BMW X5 M50i
    * def tsbList = service.getTSBsForVehicleByYMME(2007, 'CHEVROLET', 'EQUINOX', 'V6, 3.4L; SEFI')
    * print 'TSB List from DB:', tsbList.length

    # * def tsbJson = karate.toJson(tsbList)
    # * def tsbIds = karate.jsonPath(tsbJson, "$[*].tsbId")
    # * print 'TSB IDs:', tsbIds
    # * print 'PDF URLs:', get tsbList[*].pdfFileUrl
    # * print 'Categories:', get tsbList[*].tsbCategories

    * def info =
        """
        function(arr){
            return arr.map(x => ({ 
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
    * def tsbInfo = info(tsbList)
    * print 'TSB Info:', tsbInfo
