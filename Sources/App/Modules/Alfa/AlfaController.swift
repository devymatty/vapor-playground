import Vapor

struct AlfaController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let apiRoute = routes.grouped("alfa", "api")
        
        apiRoute.get("auth", use: getAuth)
        apiRoute.get("advancereport", use: getReports)
        apiRoute.get("reports","1", use: getReportDetail)
    }
    
    func getAuth(_ req: Request) throws -> String  {
        guard let basic = req.headers.basicAuthorization else {
            throw Abort(.badRequest, reason: "No login")
        }
        guard basic.username == "alfacapital\\m.matveev"
//              basic.password == "12345678"
        else {
            throw Abort(.badRequest, reason: "Bad Login or Password")
        }
        return "123456"
    }
    
    func getReports(_ req: Request) throws -> String {
        guard let context = req.headers.first(name: "x-UserContextDirectum"),
             context == "123456" else {
            throw Abort(.unauthorized, reason: "Bad Login or Password")
        }
        
        guard let jsonData = FileManager.default.contents(atPath: "Resources/json/alfaAdvanceReport.json"),
              let json = String(data: jsonData, encoding: .utf8) else {
            throw Abort(.internalServerError, reason: "No read file alfaAdvanceReport.json")
        }

        return json
    }
    
    func getReportDetail(_ req: Request) throws -> String {
        """
        {
            "name": "Какое-то наименование",
            "number": 12345678901,
            "date": "05-07-2020",
            "sum": 10500.00,
            "department": "Название из справочника",
            "article": "Название из справочника",
            "event_name": "Корпоратив (Ручной ввод)",
            "event_purpose": "Провести кастдев (Ручной ввод)",
            "event_date": "05-07-2020",
            "event_location": ""
        }
        """
    }
}
