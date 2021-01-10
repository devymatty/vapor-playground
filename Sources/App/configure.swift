import Fluent
import FluentPostgresDriver
import Vapor
import Leaf

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    
    
    app.databases.use(
        .postgres(
            hostname: Environment.get("DATABASE_HOST") ?? "localhost",
            port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? PostgresConfiguration.ianaPortNumber,
            username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
            password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
            database: Environment.get("DATABASE_NAME") ?? "vapor_database",
            tlsConfiguration: .forClient(certificateVerification: .none)
        ),
        as: .psql
    )
    
    
    
    app.migrations.add(CreateAcronym())
    
    app.logger.logLevel = .debug
    
    try app.autoMigrate().wait()
    
    
    
    app.views.use(.leaf)
    //    app.leaf.cache.isEnabled = app.environment.isRelease
    
    
    
    // register routes
    try routes(app)
}
