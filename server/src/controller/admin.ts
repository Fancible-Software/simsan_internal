import { Response } from "express";
import { Body, Controller, Post, Res, CurrentUser, Get, Params, Authorized } from "routing-controllers";
import { customerSignupRequest, SkipLimitURLParams, UserPermissions } from '../types'
import { getConnection } from "typeorm";
import { User } from "../entity/User";
import { APIError } from "../utils/APIError";
import logger from "src/utils/logger";
const bcrypt = require('bcryptjs')

@Controller("/admin")
@Authorized(UserPermissions.admin)
export class AdminController {

    @Get("/users/:skip/:limit")
    async users(
        @Params({ validate: true }) { skip, limit }: SkipLimitURLParams,
        @Res() res: Response
    ) {
        try {
            const repo = getConnection().getRepository(User)
            const users = await repo.find({
                select: ['id', 'first_name', 'last_name', 'email', 'roles', 'createdBy', 'createdAt'],
                order: {
                    id: "ASC"
                },
                skip: +skip,
                take: +limit
            })

            const total = repo.count()

            return res.status(200).send({
                status: true,
                message: 'Users list fetched!',
                data: {
                    total: total,
                    rows: users
                }
            })
        }
        catch (err) {
            logger.error(err)
            throw new APIError(err.message, 500)
        }
    }

    @Post("/create/user")
    async customerSignup(
        @Res() res: Response,
        @Body()
        obj: customerSignupRequest,
        @CurrentUser() user: User
    ) {
        try {
            const queryRunner = getConnection().createQueryRunner();

            const ifCustomerExist = await queryRunner.manager.getRepository(User).find({
                where: [
                    { email: obj.email },
                    { mobile_no: obj.mobile_no }
                ]
            })

            if (ifCustomerExist.length) {
                return res.status(409).send({
                    status: false,
                    message: "Email or Mobile Number already exist!"
                })
            }

            let newCustomer = new User()
            newCustomer.first_name = obj.first_name;
            newCustomer.last_name = obj.last_name;
            newCustomer.email = obj.email;
            newCustomer.mobile_no = obj.mobile_no;
            newCustomer.createdBy = user.first_name + " " + user.last_name
            newCustomer.password = bcrypt.hashSync(obj.password);

            await queryRunner.manager.save(newCustomer)

            return res.status(200).send({
                status: true,
                message: "User created successfully!"
            })
        }
        catch (err) {
            throw new APIError(err.message, 500)
        }
    }
}