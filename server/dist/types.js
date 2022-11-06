"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.SkipLimitURLParams = exports.ServiceType = exports.customerSignupRequest = exports.customerSigninRequest = exports.ResponseStatus = exports.UserPermissions = void 0;
const class_validator_1 = require("class-validator");
var UserPermissions;
(function (UserPermissions) {
    UserPermissions["admin"] = "admin";
    UserPermissions["sub_admin"] = "sub_admin";
})(UserPermissions = exports.UserPermissions || (exports.UserPermissions = {}));
var ResponseStatus;
(function (ResponseStatus) {
    ResponseStatus[ResponseStatus["ALREADY_EXISTS"] = 409] = "ALREADY_EXISTS";
    ResponseStatus[ResponseStatus["SUCCESS_FETCH"] = 200] = "SUCCESS_FETCH";
    ResponseStatus[ResponseStatus["SUCCESS_UPDATE"] = 201] = "SUCCESS_UPDATE";
    ResponseStatus[ResponseStatus["FAILED_UPDATE"] = 400] = "FAILED_UPDATE";
    ResponseStatus[ResponseStatus["API_ERROR"] = 500] = "API_ERROR";
})(ResponseStatus = exports.ResponseStatus || (exports.ResponseStatus = {}));
class customerSigninRequest {
}
__decorate([
    (0, class_validator_1.IsString)(),
    (0, class_validator_1.IsEmail)(),
    (0, class_validator_1.IsNotEmpty)(),
    __metadata("design:type", String)
], customerSigninRequest.prototype, "email", void 0);
__decorate([
    (0, class_validator_1.IsString)(),
    (0, class_validator_1.IsNotEmpty)(),
    __metadata("design:type", String)
], customerSigninRequest.prototype, "password", void 0);
exports.customerSigninRequest = customerSigninRequest;
class customerSignupRequest {
}
__decorate([
    (0, class_validator_1.IsNotEmpty)(),
    (0, class_validator_1.IsString)(),
    __metadata("design:type", String)
], customerSignupRequest.prototype, "first_name", void 0);
__decorate([
    (0, class_validator_1.IsString)(),
    (0, class_validator_1.IsNotEmpty)(),
    __metadata("design:type", String)
], customerSignupRequest.prototype, "last_name", void 0);
__decorate([
    (0, class_validator_1.IsString)(),
    (0, class_validator_1.IsEmail)(),
    (0, class_validator_1.IsNotEmpty)(),
    __metadata("design:type", String)
], customerSignupRequest.prototype, "email", void 0);
__decorate([
    (0, class_validator_1.IsNumber)(),
    (0, class_validator_1.IsNotEmpty)(),
    __metadata("design:type", String)
], customerSignupRequest.prototype, "mobile_no", void 0);
__decorate([
    (0, class_validator_1.IsString)(),
    (0, class_validator_1.IsNotEmpty)(),
    __metadata("design:type", String)
], customerSignupRequest.prototype, "password", void 0);
__decorate([
    (0, class_validator_1.IsString)(),
    (0, class_validator_1.IsNotEmpty)(),
    __metadata("design:type", String)
], customerSignupRequest.prototype, "roles", void 0);
exports.customerSignupRequest = customerSignupRequest;
class ServiceType {
}
__decorate([
    (0, class_validator_1.IsString)(),
    (0, class_validator_1.IsNotEmpty)(),
    __metadata("design:type", String)
], ServiceType.prototype, "serviceName", void 0);
__decorate([
    (0, class_validator_1.IsString)(),
    (0, class_validator_1.IsNotEmpty)(),
    (0, class_validator_1.Matches)(/^\d+\.?\d*$/),
    __metadata("design:type", String)
], ServiceType.prototype, "price", void 0);
exports.ServiceType = ServiceType;
class SkipLimitURLParams {
}
__decorate([
    (0, class_validator_1.Matches)(/^\d+$/),
    __metadata("design:type", String)
], SkipLimitURLParams.prototype, "skip", void 0);
__decorate([
    (0, class_validator_1.Matches)(/^\d+$/),
    (0, class_validator_1.IsNotIn)(["0"]),
    __metadata("design:type", String)
], SkipLimitURLParams.prototype, "limit", void 0);
exports.SkipLimitURLParams = SkipLimitURLParams;
//# sourceMappingURL=types.js.map