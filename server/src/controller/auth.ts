import { Response } from "express";
import { Body, Controller, Post, Res } from "routing-controllers";
import { customerSigninRequest } from '../types'
import { getConnection } from "typeorm";
import { User } from "../entity/User";
import { APIError } from "../utils/APIError";
const bcrypt = require('bcryptjs')
import jwt from 'jsonwebtoken'
import { TokenData } from '../types'


@Controller("/auth")
export class AuthController {


  @Post("/login")
  async login(
    @Res() res: Response,
    @Body()
    obj: customerSigninRequest
  ) {
    try {
      const queryRunner = getConnection().createQueryRunner();

      const ifUserExist = await queryRunner.manager.getRepository(User).findOne({
        where: [
          { email: obj.email },
        ],
        select: ["id", "first_name", "last_name", "mobile_no", "email", "is_active", "password", "is_active", "is_verified"]
      })

      if (!ifUserExist) {
        return res.status(200).send({
          status: false,
          message: 'Invalid email!'
        })
      }
      if (!ifUserExist.is_active) {
        return res.status(200).send({
          status: false,
          message: "User isn't active, please contact admin!"
        })
      }
      const isPasswordValid = bcrypt.compareSync(obj.password, ifUserExist.password)
      if (!isPasswordValid) {
        return res.status(200).send({
          status: false,
          message: "Invalid password!"
        })
      }
      const tokenData: TokenData = {
        email: ifUserExist.email,
        roles: ifUserExist.roles
      }
      var auth_token = jwt.sign(tokenData, process.env.JWT_SECRET, {
        expiresIn: '2 days'
      })
      let user_details = {
        id: ifUserExist.id,
        first_name: ifUserExist.first_name,
        last_name: ifUserExist.last_name,
        email: ifUserExist.email,
        mobile_no: ifUserExist.mobile_no,
        token: auth_token,
        is_verified: ifUserExist.is_verified
      }

      return res.status(200).send({
        status: true,
        message: "Logged in successfully!",
        data: user_details
      })
    }
    catch (err) {
      throw new APIError(err.message, 500)
    }
  }

}
