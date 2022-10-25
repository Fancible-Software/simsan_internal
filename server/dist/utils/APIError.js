"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.APIError = void 0;
const routing_controllers_1 = require("routing-controllers");
class APIError extends routing_controllers_1.HttpError {
    constructor(msg, httpCode = 500, isPublic = true) {
        super(httpCode);
        Object.setPrototypeOf(this, APIError.prototype);
        this.msg = msg;
        this.isPublic = isPublic;
    }
    toJSON() {
        return {
            status: this.httpCode,
            msg: this.isPublic ? this.msg : "Something went wrong",
        };
    }
}
exports.APIError = APIError;
//# sourceMappingURL=APIError.js.map