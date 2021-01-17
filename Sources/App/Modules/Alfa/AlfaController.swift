import Vapor

struct AlfaController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let apiRoute = routes.grouped("alfa", "api")
        
        apiRoute.get("reports/token", use: getToken)
        apiRoute.get("reports", use: getReports)
        apiRoute.get("reports","1", use: getReportDetail)
    }
    
    func getToken(_ req: Request) throws -> String  {
        
        "123456"
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
