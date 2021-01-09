import Vapor
import Leaf

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.views.use(.leaf)
    app.leaf.cache.isEnabled = app.environment.isRelease
    
    // register routes
    try routes(app)
    
//    let router = FrontendRouter()
//    try router.boot(routes: app.routes)
    
    let routers: [RouteCollection] = [
            FrontendRouter(),
            BlogRouter(),
    ]
    for router in routers {
        try router.boot(routes: app.routes)
    }
}
