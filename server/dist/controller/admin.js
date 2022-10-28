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
exports.AdminController = void 0;
const routing_controllers_1 = require("routing-controllers");
const types_1 = require("../types");
const typeorm_1 = require("typeorm");
const User_1 = require("../entity/User");
const APIError_1 = require("../utils/APIError");
const logger_1 = __importDefault(require("../utils/logger"));
const bcrypt = require('bcryptjs');
let AdminController = class AdminController {
    async users({ skip, limit }, res) {
        try {
            const repo = (0, typeorm_1.getConnection)().getRepository(User_1.User);
            const users = await repo.find({
                select: ['id', 'first_name', 'last_name', 'email', 'roles', 'createdBy', 'createdAt'],
                order: {
                    id: "ASC"
                },
                skip: +skip,
                take: +limit
            });
            const total = repo.count();
            return res.status(200).send({
                status: true,
                message: 'Users list fetched!',
                data: {
                    total: total,
                    rows: users
                }
            });
        }
        catch (err) {
            logger_1.default.error(err);
            throw new APIError_1.APIError(err.message, 500);
        }
    }
    async customerSignup(res, obj, user) {
        try {
            const queryRunner = (0, typeorm_1.getConnection)().createQueryRunner();
            const ifCustomerExist = await queryRunner.manager.getRepository(User_1.User).find({
                where: [
                    { email: obj.email },
                    { mobile_no: obj.mobile_no }
                ]
            });
            if (ifCustomerExist.length) {
                return res.status(409).send({
                    status: false,
                    message: "Email or Mobile Number already exist!"
                });
            }
            let newCustomer = new User_1.User();
            newCustomer.first_name = obj.first_name;
            newCustomer.last_name = obj.last_name;
            newCustomer.email = obj.email;
            newCustomer.mobile_no = obj.mobile_no;
            newCustomer.createdBy = user.first_name + " " + user.last_name;
            newCustomer.password = bcrypt.hashSync(obj.password);
            newCustomer.roles = obj.roles;
            await queryRunner.manager.save(newCustomer);
            return res.status(200).send({
                status: true,
                message: "User created successfully!"
            });
        }
        catch (err) {
            throw new APIError_1.APIError(err.message, 500);
        }
    }
};
__decorate([
    (0, routing_controllers_1.Get)("/users/:skip/:limit"),
    __param(0, (0, routing_controllers_1.Params)({ validate: true })),
    __param(1, (0, routing_controllers_1.Res)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [types_1.SkipLimitURLParams, Object]),
    __metadata("design:returntype", Promise)
], AdminController.prototype, "users", null);
__decorate([
    (0, routing_controllers_1.Post)("/create/user"),
    __param(0, (0, routing_controllers_1.Res)()),
    __param(1, (0, routing_controllers_1.Body)()),
    __param(2, (0, routing_controllers_1.CurrentUser)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, types_1.customerSignupRequest,
        User_1.User]),
    __metadata("design:returntype", Promise)
], AdminController.prototype, "customerSignup", null);
AdminController = __decorate([
    (0, routing_controllers_1.Controller)("/admin"),
    (0, routing_controllers_1.Authorized)(types_1.UserPermissions.admin)
], AdminController);
exports.AdminController = AdminController;
//# sourceMappingURL=admin.js.map