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
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.AuthController = void 0;
const routing_controllers_1 = require("routing-controllers");
const types_1 = require("../types");
const typeorm_1 = require("typeorm");
const User_1 = require("../entity/User");
const APIError_1 = require("../utils/APIError");
const bcrypt = require('bcryptjs');
const jsonwebtoken_1 = __importDefault(require("jsonwebtoken"));
let AuthController = class AuthController {
    async login(res, obj) {
        try {
            const queryRunner = (0, typeorm_1.getConnection)().createQueryRunner();
            const ifUserExist = await queryRunner.manager.getRepository(User_1.User).findOne({
                where: [
                    { email: obj.email }
                ],
                select: ["id", "first_name", "last_name", "mobile_no", "email", "is_active", "password", "is_active"]
            });
            if (!ifUserExist) {
                return res.status(200).send({
                    status: false,
                    message: 'Invalid email!'
                });
            }
            if (!ifUserExist.is_active) {
                return res.status(200).send({
                    status: false,
                    message: "User isn't active, please contact admin!"
                });
            }
            const isPasswordValid = bcrypt.compareSync(obj.password, ifUserExist.password);
            if (!isPasswordValid) {
                return res.status(200).send({
                    status: false,
                    message: "Invalid password!"
                });
            }
            const tokenData = {
                email: ifUserExist.email,
                roles: ifUserExist.roles
            };
            var auth_token = jsonwebtoken_1.default.sign(tokenData, process.env.JWT_SECRET, {
                expiresIn: '2 days'
            });
            let user_details = {
                id: ifUserExist.id,
                first_name: ifUserExist.first_name,
                last_name: ifUserExist.last_name,
                email: ifUserExist.email,
                mobile_no: ifUserExist.mobile_no,
                token: auth_token
            };
            return res.status(200).send({
                status: true,
                message: "Logged in successfully!",
                data: user_details
            });
        }
        catch (err) {
            throw new APIError_1.APIError(err.message, 500);
        }
    }
};
__decorate([
    (0, routing_controllers_1.Post)("/login"),
    __param(0, (0, routing_controllers_1.Res)()),
    __param(1, (0, routing_controllers_1.Body)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, types_1.customerSigninRequest]),
    __metadata("design:returntype", Promise)
], AuthController.prototype, "login", null);
AuthController = __decorate([
    (0, routing_controllers_1.Controller)("/auth")
], AuthController);
exports.AuthController = AuthController;
//# sourceMappingURL=auth.js.map