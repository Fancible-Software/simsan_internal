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
exports.EntityId = exports.FormType = exports.SkipLimitURLParams = exports.ServiceType = exports.customerSignupRequest = exports.customerSigninRequest = exports.ResponseStatus = exports.UserPermissions = void 0;
const class_validator_1 = require("class-validator");
const Form_1 = require("./entity/Form");
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
__decorate([
    (0, class_validator_1.IsString)(),
    __metadata("design:type", String)
], ServiceType.prototype, "isActive", void 0);
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
class FormType {
    toForm() {
        const form = new Form_1.Form();
        form.customerName = this.customerName;
        form.customerEmail = this.customerEmail;
        form.customerAddress = this.customerAddress;
        form.customerCity = this.customerCity;
        form.customerCountry = this.customerCountry;
        form.customerPostalCode = this.customerPostalCode;
        form.customerPhone = this.customerPhone;
        form.customerProvince = this.customerProvince;
        return form;
    }
    updateForm(formRecord) {
        formRecord.customerName = this.customerName;
        formRecord.customerEmail = this.customerEmail;
        formRecord.customerAddress = this.customerAddress;
        formRecord.customerCity = this.customerCity;
        formRecord.customerCountry = this.customerCountry;
        formRecord.customerPostalCode = this.customerPostalCode;
        formRecord.customerPhone = this.customerPhone;
        formRecord.customerProvince = this.customerProvince;
        return formRecord;
    }
}
__decorate([
    (0, class_validator_1.IsNotEmpty)(),
    (0, class_validator_1.IsString)(),
    __metadata("design:type", String)
], FormType.prototype, "customerName", void 0);
__decorate([
    (0, class_validator_1.IsNotEmpty)(),
    (0, class_validator_1.IsString)(),
    __metadata("design:type", String)
], FormType.prototype, "customerEmail", void 0);
__decorate([
    (0, class_validator_1.IsNotEmpty)(),
    (0, class_validator_1.IsString)(),
    __metadata("design:type", String)
], FormType.prototype, "customerPhone", void 0);
__decorate([
    (0, class_validator_1.IsNotEmpty)(),
    (0, class_validator_1.IsString)(),
    __metadata("design:type", String)
], FormType.prototype, "customerAddress", void 0);
__decorate([
    (0, class_validator_1.IsNotEmpty)(),
    (0, class_validator_1.IsString)(),
    __metadata("design:type", String)
], FormType.prototype, "customerPostalCode", void 0);
__decorate([
    (0, class_validator_1.IsNotEmpty)(),
    (0, class_validator_1.IsString)(),
    __metadata("design:type", String)
], FormType.prototype, "customerCity", void 0);
__decorate([
    (0, class_validator_1.IsNotEmpty)(),
    (0, class_validator_1.IsString)(),
    __metadata("design:type", String)
], FormType.prototype, "customerProvince", void 0);
__decorate([
    (0, class_validator_1.IsString)(),
    __metadata("design:type", String)
], FormType.prototype, "customerCountry", void 0);
exports.FormType = FormType;
class EntityId {
}
__decorate([
    (0, class_validator_1.IsNotEmpty)(),
    __metadata("design:type", Object)
], EntityId.prototype, "id", void 0);
exports.EntityId = EntityId;
//# sourceMappingURL=types.js.map