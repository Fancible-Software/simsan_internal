import { createConnection, getConnectionOptions } from "typeorm";

export const createDbConnection = async () => {
  const connectionOptions = await getConnectionOptions();
  Object.assign(connectionOptions, {
    synchronize: process.env.NODE_ENV === 'development'
  })
  return await createConnection(connectionOptions)
}
