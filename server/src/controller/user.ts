import { Response } from "express";
import { Controller, Res, CurrentUser, Get } from "routing-controllers";
import { User } from "../entity/User";


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
