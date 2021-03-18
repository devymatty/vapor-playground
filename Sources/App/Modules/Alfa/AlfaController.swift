import Vapor

struct AlfaController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let apiRoute = routes.grouped("alfa", "api")
        
        apiRoute.get("auth", use: getAuth)
        apiRoute.get("reports", use: getReports)
        apiRoute.get("reportdetail", use: getReportDetail)
    }
    
    func getAuth(_ req: Request) throws -> Response  {
        let data = try req.query.decode(LoginData.self)
        
        if data.login != "test_login" {
            throw Abort(.badRequest, reason: "Bad Login")
        }
        if data.password != "12345678" {
            throw Abort(.badRequest, reason: "Bad Password")
        }

        guard let jsonData = FileManager.default.contents(atPath: "Resources/json/alfa/LoginToken.json"),
              let json = String(data: jsonData, encoding: .utf8) else {
            throw Abort(.internalServerError, reason: "No read file loginToken.json")
        }
        
        return Response(status: .ok, body: .init(string: json))
    }
    
    func getReports(_ req: Request) throws -> Response {
        guard let token = req.headers.bearerAuthorization?.token,
              token == "1-23-452-98-7" else {
            throw Abort(.unauthorized, reason: "Bad Token")
        }
        
        guard let jsonData = FileManager.default.contents(atPath: "Resources/json/alfa/ReportsList.json"),
              let json = String(data: jsonData, encoding: .utf8) else {
            throw Abort(.internalServerError, reason: "No read file alfaAdvanceReport.json")
        }

        return Response(status: .ok, body: .init(string: json))
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

struct LoginData: Content {
    let login: String
    let password: String
}

//extension Data {
//    static func fromFile(
//        _ fileName: String,
//        folder: String = "Resources/json"
//    ) throws -> Data {
//        let directory = DirectoryConfig.detect()
//        let fileURL = URL(fileURLWithPath: directory.workDir)
//            .appendingPathComponent(folder, isDirectory: true)
//            .appendingPathComponent(fileName, isDirectory: false)
//
//        return try Data(contentsOf: fileURL)
//    }
//}
