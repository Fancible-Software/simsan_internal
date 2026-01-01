import { createConnection, ConnectionOptions } from "typeorm";

export const createDbConnection = async () => {
  const isDevelopment = process.env.NODE_ENV === 'development';
  
  // Check if we're running from compiled code (dist folder)
  // When running from dist, we must use .js files, not .ts files
  // __dirname will be something like /app/dist/utils when running compiled code
  const isCompiled = __dirname.includes('dist');
  const entityExtension = isCompiled ? '*.js' : '*.ts';
  
  const connectionOptions: ConnectionOptions = {
    name: "default", // Explicitly name the connection to prevent auto-loading ormconfig.json
    type: "postgres",
    host: process.env.DB_HOST,
    port: parseInt(process.env.DB_PORT || "5432", 10),
    username: process.env.DB_USERNAME,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    schema: process.env.DB_SCHEMA,
    ssl: process.env.DB_SSL === "true" ? { rejectUnauthorized: false } : false,
    logging: process.env.DB_LOGGING === "true",
    synchronize: process.env.DB_SYNCHRONIZE === "true" || isDevelopment,
    entities: [__dirname + "/../entity/" + entityExtension],
    migrations: [],
  };

  return await createConnection(connectionOptions);
}
