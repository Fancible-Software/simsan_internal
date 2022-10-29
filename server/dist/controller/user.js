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
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.UserController = void 0;
const routing_controllers_1 = require("routing-controllers");
const User_1 = require("../entity/User");
let UserController = class UserController {
    async details(res, user) {
        return res.status(200).send({
            status: true,
            message: "User fetched successfully!",
            data: user
        });
    }
};
__decorate([
    (0, routing_controllers_1.Get)("/details"),
    __param(0, (0, routing_controllers_1.Res)()),
    __param(1, (0, routing_controllers_1.CurrentUser)({ required: true })),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, User_1.User]),
    __metadata("design:returntype", Promise)
], UserController.prototype, "details", null);
UserController = __decorate([
    (0, routing_controllers_1.Controller)("/user")
], UserController);
exports.UserController = UserController;
//# sourceMappingURL=user.js.map