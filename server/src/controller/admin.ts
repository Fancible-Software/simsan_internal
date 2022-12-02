import { Response } from "express";
import { Body, Controller, Post, Res, CurrentUser, Get, Params, Authorized } from "routing-controllers";
import { customerSignupRequest, ResponseStatus, SkipLimitURLParams, UserPermissions, tokenType, verificationRequest, ResendOtpRequest } from '../types'
import { getConnection } from "typeorm";
import { User } from "../entity/User";
import { APIError } from "../utils/APIError";
import logger from "../utils/logger"
import generateOtp from '../utils/generateOtp'
import dateDifference from "../utils/dateDifference";
import { UserVerification } from "../entity/UserVerification";
const bcrypt = require('bcryptjs')

@Controller("/admin")
export class AdminController {

    @Authorized(UserPermissions.admin)
    @Get("/users/:skip/:limit")
    async users(
        @Params()
        { skip, limit }: SkipLimitURLParams,
        @Res() res: Response
    ) {
        try {
            const repo = getConnection().getRepository(User)
            let users = await repo.find({
                select: ['id', 'first_name', 'last_name', 'email', 'roles', 'is_verified', 'is_active', 'createdBy', 'createdAt'],
                order: {
                    id: "DESC"
                },
                skip: +skip,
                take: +limit
            })

            const total = await repo.count()

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
            console.log(err.message)
            logger.error(err)
            throw new APIError(err.message, 500)
        }
    }

    @Authorized(UserPermissions.admin)
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
                return res.status(ResponseStatus.ALREADY_EXISTS).send({
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
            newCustomer.roles = obj.roles;
            await queryRunner.manager.save(newCustomer)


            let userVerify = new UserVerification()
            userVerify.userId = newCustomer
            userVerify.token = await generateOtp()
            userVerify.type = tokenType.otp
            await queryRunner.manager.save(userVerify)

            return res.status(ResponseStatus.SUCCESS_UPDATE).send({
                status: true,
                message: "User created successfully!"
            })
        }
        catch (err) {

            throw new APIError(err.message, ResponseStatus.API_ERROR)
        }
    }

    @Authorized()
    @Post("/verify/user")
    async verifyUser(
        @Res() res: Response,
        @Body()
        obj: verificationRequest,
        @CurrentUser() user: User
    ) {
        try {
            if (user.is_verified) {
                return res.status(ResponseStatus.ALREADY_EXISTS).send({
                    status: true,
                    message: "User is already verified!"
                })
            }
            const queryRunner = getConnection().createQueryRunner();

            const fetchRecord: UserVerification | undefined = await queryRunner.manager.getRepository(UserVerification).findOne({
                where: [
                    { type: obj.type },
                    { token: obj.otp },
                    { userId: user.id }
                ]
            })

            if (!fetchRecord) {
                return res.status(ResponseStatus.FAILED_UPDATE).send({
                    status: false,
                    message: "Invalid OTP"
                })
            }
            const previousDate = fetchRecord.updatedAt
            let dayDiff
            if (previousDate) {
                dayDiff = await dateDifference(new Date(previousDate), new Date())
            }
            else {
                return res.status(ResponseStatus.API_ERROR).send({
                    status: false,
                    message: "Something went wrong, try again later!"
                })
            }
            //comparison of difference with mins.
            if (dayDiff > 15) {
                return res.status(ResponseStatus.FAILED_UPDATE).send({
                    status: false,
                    message: "OTP has been expired, click on resend OTP to generate a new OTP!"
                })
            }
            const userRepo = await queryRunner.manager.getRepository(User)
            const userObj = await userRepo.findOne(user.id)
            if (userObj) {
                userObj.is_verified = true
                userObj.verified_at = new Date()
                await queryRunner.manager.save(userObj)
                return res.status(ResponseStatus.SUCCESS_UPDATE).send({
                    status: true,
                    message: "User verified successfully!"
                })
            }
            return res.status(ResponseStatus.API_ERROR).send({
                status: false,
                message: "Something went wrong, try again later!"
            })




        }
        catch (error) {
            throw new APIError(error.message, ResponseStatus.API_ERROR)
        }
    }

    @Authorized()
    @Get("/resend/otp/:type")
    async resendOtp(
        @Res() res: Response,
        @Params()
        { type }: ResendOtpRequest,
        @CurrentUser() user: User
    ) {
        try {
            // console.log(user)
            if (type === tokenType.otp && user.is_verified) {
                return res.status(ResponseStatus.ALREADY_EXISTS).send({
                    status: true,
                    message: "User is already verified!"
                })
            }
            const queryRunner = getConnection().createQueryRunner();
            const verificationRepo = getConnection().getRepository(UserVerification)
            const userVerificationObj: UserVerification | undefined = await verificationRepo.findOne({
                where: [
                    { type: type },
                    { userId: user.id }
                ]
            });
            if (userVerificationObj) {
                userVerificationObj.token = await generateOtp()
                await queryRunner.manager.save(userVerificationObj)
                return res.status(ResponseStatus.SUCCESS_UPDATE).send({
                    status: true,
                    message: "OTP generated successfully!"
                })
            } else {
                return res.status(ResponseStatus.API_ERROR).send({
                    status: false,
                    message: "Something went wrong, try again later!"
                })
            }


        }
        catch (error) {
            throw new APIError(error.message, ResponseStatus.API_ERROR)
        }
    }


}