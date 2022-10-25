"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.CustomErrorHandler = void 0;
const routing_controllers_1 = require("routing-controllers");
const logger_1 = __importDefault(require("../utils/logger"));
const APIError_1 = require("../utils/APIError");
let CustomErrorHandler = class CustomErrorHandler {
    error(error, request, response) {
        logger_1.default.error(`${error.status || 500} - ${error.message} - ${request.originalUrl} - ${request.method} - ${request.ip}`);
        logger_1.default.error("Error:");
        logger_1.default.error(`${error.message} | ${error.stack}`);
        logger_1.default.error("Body:");
        logger_1.default.error(JSON.stringify(request.body));
        if (error instanceof APIError_1.APIError) {
            response.status(error.httpCode).json(error.toJSON());
        }
        else if (error instanceof routing_controllers_1.HttpError) {
            response.status(error.httpCode).json({
                status: error.httpCode,
                msg: "Something went wrong",
            });
        }
        else {
            response.status(500).json({
                status: 500,
                msg: "Something went wrong",
            });
        }
    }
};
CustomErrorHandler = __decorate([
    (0, routing_controllers_1.Middleware)({ type: "after" })
], CustomErrorHandler);
exports.CustomErrorHandler = CustomErrorHandler;
//# sourceMappingURL=errorHandler.js.map