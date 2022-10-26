import { Response } from "express";
import { Body, Controller, Post, Res, CurrentUser, Get } from "routing-controllers";
import { customerSignupRequest } from '../types'
import { getConnection } from "typeorm";
import { User } from "../entity/User";
import { APIError } from "../utils/APIError";
const bcrypt = require('bcryptjs')


@Controller("/user")
export class UserController {

    @Get("/details")
    async details(
        @Res() res: Response,
        @CurrentUser({ required: true })
        user: User
    ) {
        return res.status(200).send({
            status: true,
            message: "User fetched successfully!",
            data: user
        })
    }

    


}
