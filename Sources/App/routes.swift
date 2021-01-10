import Vapor
import Fluent

func routes(_ app: Application) throws {
    registerVaporLessons(app)
    registerAcronyms(app)
    
    let acronymsController = AcronymsController()
    try app.register(collection: acronymsController)
    
    //    app.get("index") { req -> EventLoopFuture<View> in
    //        struct Context: Encodable {
    //            let title: String
    //            let body: String
    //        }
    //
    //        let context = Context(title: "My Playground - Leaf Lesson", body: "Hello Leaf!")
    //        return req.view.render("index", context)
    //    }
    
    //    let router = FrontendRouter()
    //    try router.boot(routes: app.routes)
    
    //    let routers: [RouteCollection] = [
    //            FrontendRouter(),
    //            BlogRouter(),
    //    ]
    //    for router in routers {
    //        try router.boot(routes: app.routes)
    //    }
    
    
    app.get(
      "api",
      "acronyms",
      use: acronymsController.getAllHandler)
}


private func registerVaporLessons(_ app: Application) {
    //    app.get { req in
    //        return "It works!"
    //    }
    
    app.get { req in
        return req.view.render("index", ["title": "Hello Vapor!"])
    }
    
    app.get("hello") { req -> String in
        return "Hello, world!"
    }
    
    app.get("hello", "vapor") { req -> String in
        return "Hello Vapor!"
    }
    
    app.get("hello", ":name") { req -> String in
        guard let name = req.parameters.get("name") else {
            throw Abort(.internalServerError)
        }
        return "Hello, \(name)!"
    }
    
    app.post("info") { req -> String in
        let data = try req.content.decode(InfoData.self)
        return "Hello \(data.name)!"
    }
    
    app.post("info2") { req -> InfoResponse in
        let data = try req.content.decode(InfoData.self)
        return InfoResponse(request: data)
    }
}

struct InfoData: Content {
    let name: String
}

struct InfoResponse: Content {
    let request: InfoData
}

// MARK: Acronyms
private func registerAcronyms(_ app: Application) {
    
    // Create
    app.post("api", "acronyms") { req -> EventLoopFuture<Acronym> in
        let acronym = try req.content.decode(Acronym.self)
        return acronym.save(on: req.db).map {
            acronym
        }
    }
    
    // All
    app.get("api", "acronyms") { req -> EventLoopFuture<[Acronym]> in
        Acronym.query(on: req.db).all()
    }
    
    // Single
    app.get("api", "acronyms", ":acronymID") { req -> EventLoopFuture<Acronym> in
        Acronym.find(req.parameters.get("acronymID"), on: req.db)
            .unwrap(or: Abort(.notFound))
    }
    
    // Update
    app.put("api", "acronyms", ":acronymID") { req -> EventLoopFuture<Acronym> in
        
        let updatedAcronym = try req.content.decode(Acronym.self)
        return Acronym.find(req.parameters.get("acronymID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { acronym in
                acronym.short = updatedAcronym.short
                acronym.long = updatedAcronym.long
                return acronym.save(on: req.db).map {
                    acronym
                }
            }
    }
    
    // Delete
    app.delete("api", "acronyms", ":acronymID") { req -> EventLoopFuture<HTTPStatus> in
        Acronym.find(req.parameters.get("acronymID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { acronym in
                acronym.delete(on: req.db)
                    .transform(to: .noContent)
            }
    }
    
    // Search
    app.get("api", "acronyms", "search") { req -> EventLoopFuture<[Acronym]> in
        guard let searchTerm = req.query[String.self, at: "term"] else {
            throw Abort(.badRequest)
        }
        
        //        return Acronym.query(on: req.db)
        //            .filter(\.$short == searchTerm)
        //            .all()
        
        return Acronym.query(on: req.db)
            .group(.or) { or in
                or.filter(\.$short == searchTerm)
                or.filter(\.$long == searchTerm)
            }.all()
    }
    
    // First
    app.get("api", "acronyms", "first") { req -> EventLoopFuture<Acronym> in
        Acronym.query(on: req.db)
            .first()
            .unwrap(or: Abort(.notFound))
    }
    
    // Sorted
    app.get("api", "acronyms", "sorted") { req -> EventLoopFuture<[Acronym]> in
        Acronym.query(on: req.db)
            .sort(\.$short, .ascending)
            .all()
    }
}
