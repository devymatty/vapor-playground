import Vapor

func routes(_ app: Application) throws {
//    app.get { req in
//        return "It works!"
//    }
    
    app.get("hello") { req -> String in
        return "Hello, world!"
    }
    
    app.get { req -> EventLoopFuture<View> in
        struct Context: Encodable {
            let title: String
            let body: String
        }
        
        let context = Context(title: "My Playground - Leaf Lesson", body: "Hello Leaf!")
        return req.view.render("index", context)
    }
}