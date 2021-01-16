import Vapor

struct AlfaController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let alfaRoute = routes.grouped("api", "alfa")
        
        alfaRoute.get("info", use: getInfoHandler)
        alfaRoute.get("reports", use: getReports)
        
//        usersRoute.get(use: getAllHandler)
//        usersRoute.get(":userID", use: getHandler)
//        usersRoute.get(":userID", "acronyms", use: getAcronymsHandler)
    }
    
    func getInfoHandler(_ req: Request) throws -> String {
        "{\"key\":\"value\"}"
    }
    
    func getReports(_ req: Request) throws -> String {
        """
        {
            "reports": [
                {
                    "id": 12345678901,
                    "status": "Согласование 2",
                    "name": "ООО \\"Дом на патриарших\\" 1",
                    "sum": 10120.23,
                    "date": "01-11-2020"
                },
                {
                    "id": 12345678902,
                    "status": "Согласование",
                    "name": "ООО \\"Дом на патриарших\\" 2",
                    "sum": 10120.23,
                    "date": "01-11-2020"
                },
                {
                    "id": 12345678903,
                    "status": "Согласование",
                    "name": "ООО \\"Дом на патриарших\\" 3",
                    "sum": 10120.23,
                    "date": "01-12-2020"
                }
            ]
        }
        """
    }
}
