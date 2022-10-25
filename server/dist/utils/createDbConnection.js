"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.createDbConnection = void 0;
const typeorm_1 = require("typeorm");
const createDbConnection = async () => {
    const connectionOptions = await (0, typeorm_1.getConnectionOptions)();
    Object.assign(connectionOptions, {
        synchronize: process.env.NODE_ENV === 'development'
    });
    return await (0, typeorm_1.createConnection)(connectionOptions);
};
exports.createDbConnection = createDbConnection;
//# sourceMappingURL=createDbConnection.js.map