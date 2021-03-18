import Fluent
import FluentPostgresDriver
import Vapor
import Leaf

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    

    let databaseName: String
    let databasePort: Int
    
    if app.environment == .testing {
        databaseName = "vapor-test"
        databasePort = 5433
    } else {
        databaseName = "vapor_database"
        databasePort = PostgresConfiguration.ianaPortNumber
    }
  
    app.databases.use(
        .postgres(
            hostname: Environment.get("DATABASE_HOST") ?? "localhost",
            port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? databasePort,
            username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
            password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
            database: Environment.get("DATABASE_NAME") ?? databaseName,
            tlsConfiguration: .forClient(certificateVerification: .none)
        ),
        as: .psql
    )
    

    app.logger.logLevel = .debug
    
    app.migrations.add(CreateUser())
    app.migrations.add(CreateAcronym())
    app.migrations.add(CreateCategory())
    app.migrations.add(CreateAcronymCategoryPivot())
    
    try app.autoMigrate().wait()
    
    
    
    app.views.use(.leaf)
    //    app.leaf.cache.isEnabled = app.environment.isRelease
    
    
    
    // register routes
    try routes(app)
}
