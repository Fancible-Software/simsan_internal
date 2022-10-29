"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    Object.defineProperty(o, k2, { enumerable: true, get: function() { return m[k]; } });
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const dotenv_safe_1 = require("dotenv-safe");
(0, dotenv_safe_1.config)();
const express_1 = __importDefault(require("express"));
const express_actuator_1 = __importDefault(require("express-actuator"));
const jsonwebtoken_1 = __importStar(require("jsonwebtoken"));
const morgan_1 = __importDefault(require("morgan"));
const routing_controllers_1 = require("routing-controllers");
const typeorm_1 = require("typeorm");
const admin_1 = require("./controller/admin");
const auth_1 = require("./controller/auth");
const user_1 = require("./controller/user");
const User_1 = require("./entity/User");
const errorHandler_1 = require("./middleware/errorHandler");
const APIError_1 = require("./utils/APIError");
const createDbConnection_1 = require("./utils/createDbConnection");
const logger_1 = __importDefault(require("./utils/logger"));
async function run() {
    var _a;
    try {
        await (0, createDbConnection_1.createDbConnection)();
        const app = (0, express_1.default)();
        app.all("/*", (req, res, next) => {
            const allowedDomains = process.env.CORS_DOMAINS.split(",");
            if (allowedDomains.includes(req.headers.origin || "")) {
                res.header("Access-Control-Allow-Origin", req.headers.origin || "");
            }
            res.header("Access-Control-Allow-Methods", "GET,PUT,POST,DELETE,PATCH");
            res.header("Access-Control-Allow-Headers", "*");
            next();
        });
        app.use(express_1.default.json());
        app.use(express_1.default.urlencoded({ extended: true }));
        app.use((0, morgan_1.default)("combined", {
            stream: {
                write(text) {
                    logger_1.default.info(text);
                },
            },
        }));
        app.use((0, express_actuator_1.default)());
        (0, routing_controllers_1.useExpressServer)(app, {
            cors: {
                origin: (_a = process.env.CORS_DOMAINS) === null || _a === void 0 ? void 0 : _a.split(","),
                credentials: true,
            },
            defaultErrorHandler: false,
            controllers: [user_1.UserController, auth_1.AuthController, admin_1.AdminController],
            middlewares: [errorHandler_1.CustomErrorHandler],
            authorizationChecker: (action) => {
                const { authorization } = action.request.headers || {};
                const { token: queryToken } = action.request.query || {};
                if (!authorization && typeof queryToken !== "string")
                    return false;
                let token = authorization === null || authorization === void 0 ? void 0 : authorization.split("Bearer ")[1];
                if (!token)
                    token = queryToken;
                if (!token)
                    return false;
                try {
                    const userData = jsonwebtoken_1.default.verify(token, process.env.JWT_SECRET);
                    if (!userData)
                        return false;
                }
                catch (error) {
                    if (error instanceof jsonwebtoken_1.TokenExpiredError) {
                        throw new APIError_1.APIError("JWT expired", 401);
                    }
                    else {
                        throw new APIError_1.APIError("Something went wrong", 500);
                    }
                }
                return true;
            },
            currentUserChecker: (action) => {
                const { authorization } = action.request.headers || {};
                const { token: queryToken } = action.request.query || {};
                if (!authorization && typeof queryToken !== "string")
                    return;
                let token = authorization === null || authorization === void 0 ? void 0 : authorization.split("Bearer ")[1];
                if (!token)
                    token = queryToken;
                if (!token)
                    return;
                try {
                    const userData = jsonwebtoken_1.default.verify(token, process.env.JWT_SECRET);
                    if (!userData)
                        return;
                    return (0, typeorm_1.getConnection)().getRepository(User_1.User).findOne({ email: userData.email });
                }
                catch (error) {
                    if (error instanceof jsonwebtoken_1.TokenExpiredError) {
                        throw new APIError_1.APIError("JWT expired", 401);
                    }
                    else {
                        throw new APIError_1.APIError("Something went wrong", 500);
                    }
                }
            },
        });
        let port = process.env.PORT ? +process.env.PORT : NaN;
        port = isNaN(port) ? 4000 : port;
        app.listen(port, () => {
            logger_1.default.info(`env is ${process.env.NODE_ENV}`);
            logger_1.default.info(`Listening on http://localhost:${port}`);
        });
    }
    catch (error) {
        console.log(error);
        logger_1.default.error(error);
        process.exit(1);
    }
}
run();
//# sourceMappingURL=index.js.map