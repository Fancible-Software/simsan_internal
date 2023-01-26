import { Response } from "express";
import {
  Body,
  Controller,
  Post,
  Res,
  CurrentUser,
  Get,
  Params,
  Authorized,
} from "routing-controllers";
import {
  customerSignupRequest,
  ResponseStatus,
  SkipLimitURLParams,
  UserPermissions,
  tokenType,
  verificationRequest,
  ResendOtpRequest,
} from "../types";
import { getConnection } from "typeorm";
import { User } from "../entity/User";
import { APIError } from "../utils/APIError";
import logger from "../utils/logger";
import generateOtp from "../utils/generateOtp";
import dateDifference from "../utils/dateDifference";
import { UserVerification } from "../entity/UserVerification";
import sendMail from "../utils/sendMail";
const bcrypt = require("bcryptjs");

@Controller("/admin")
@Authorized(UserPermissions.admin)
export class AdminController {
  @Authorized(UserPermissions.admin)
  @Get("/users/:skip/:limit")
  async users(
    @Params()
    { skip, limit }: SkipLimitURLParams,
    @Res() res: Response
  ) {
    try {
      const repo = getConnection().getRepository(User);
      let users = await repo.find({
        select: [
          "id",
          "first_name",
          "last_name",
          "email",
          "roles",
          "is_verified",
          "is_active",
          "createdBy",
          "createdAt",
        ],
        order: {
          id: "DESC",
        },
        skip: +skip,
        take: +limit,
      });

      const total = await repo.count();

      return res.status(200).send({
        status: true,
        message: "Users list fetched!",
        data: {
          total: total,
          rows: users,
        },
      });
    } catch (err) {
      console.log(err.message);
      logger.error(err);
      throw new APIError(err.message, 500);
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

      const ifCustomerExist = await queryRunner.manager
        .getRepository(User)
        .find({
          where: [{ email: obj.email }, { mobile_no: obj.mobile_no }],
        });

      if (ifCustomerExist.length) {
        return res.status(ResponseStatus.ALREADY_EXISTS).send({
          status: false,
          message: "Email or Mobile Number already exist!",
        });
      }

      let newCustomer = new User();
      newCustomer.first_name = obj.first_name;
      newCustomer.last_name = obj.last_name;
      newCustomer.email = obj.email;
      newCustomer.mobile_no = obj.mobile_no;
      newCustomer.createdBy = user.first_name + " " + user.last_name;
      newCustomer.password = bcrypt.hashSync(obj.password);
      newCustomer.roles = obj.roles;
      await queryRunner.manager.save(newCustomer);

      let userVerify = new UserVerification();
      userVerify.userId = newCustomer;
      userVerify.token = await generateOtp();
      userVerify.type = tokenType.otp;
      await queryRunner.manager.save(userVerify);

      await sendMail({
        to: newCustomer.email,
        subject: "Email Verification for your Simsan Fraser Pvt. Ltd. account",
        html: `<!DOCTYPE html>
        <html>
          <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
            <title>Simple Transactional Email</title>
            <style>
              /* -------------------------------------
                  GLOBAL RESETS
              ------------------------------------- */
        
              /*All the styling goes here*/
        
              img {
                border: none;
                -ms-interpolation-mode: bicubic;
                max-width: 100%;
              }
        
              body {
                background-color: #f6f6f6;
                font-family: sans-serif;
                -webkit-font-smoothing: antialiased;
                font-size: 14px;
                line-height: 1.4;
                margin: 0;
                padding: 0;
                -ms-text-size-adjust: 100%;
                -webkit-text-size-adjust: 100%;
              }
        
              table {
                border-collapse: separate;
                mso-table-lspace: 0pt;
                mso-table-rspace: 0pt;
                width: 100%;
              }
              table td {
                font-family: sans-serif;
                font-size: 14px;
                vertical-align: top;
              }
        
              /* -------------------------------------
                  BODY & CONTAINER
              ------------------------------------- */
        
              .body {
                background-color: #f6f6f6;
                width: 100%;
              }
        
              /* Set a max-width, and make it display as block so it will automatically stretch to that width, but will also shrink down on a phone or something */
              .container {
                display: block;
                margin: 0 auto !important;
                /* makes it centered */
                max-width: 580px;
                padding: 10px;
                width: 580px;
              }
        
              /* This should also be a block element, so that it will fill 100% of the .container */
              .content {
                box-sizing: border-box;
                display: block;
                margin: 0 auto;
                max-width: 580px;
                padding: 10px;
              }
        
              /* -------------------------------------
                  HEADER, FOOTER, MAIN
              ------------------------------------- */
              .main {
                background: #ffffff;
                border-radius: 3px;
                width: 100%;
              }
        
              .wrapper {
                box-sizing: border-box;
                padding: 20px;
              }
        
              .content-block {
                padding-bottom: 10px;
                padding-top: 10px;
              }
        
              .footer {
                clear: both;
                margin-top: 10px;
                text-align: center;
                width: 100%;
              }
              .footer td,
              .footer p,
              .footer span,
              .footer a {
                color: #999999;
                font-size: 12px;
                text-align: center;
              }
        
              /* -------------------------------------
                  TYPOGRAPHY
              ------------------------------------- */
              h1,
              h2,
              h3,
              h4 {
                color: #000000;
                font-family: sans-serif;
                font-weight: 400;
                line-height: 1.4;
                margin: 0;
                margin-bottom: 30px;
              }
        
              h1 {
                font-size: 35px;
                font-weight: 300;
                text-align: center;
                text-transform: capitalize;
              }
        
              p,
              ul,
              ol {
                font-family: sans-serif;
                font-size: 14px;
                font-weight: normal;
                margin: 0;
                margin-bottom: 15px;
              }
              p li,
              ul li,
              ol li {
                list-style-position: inside;
                margin-left: 5px;
              }
        
              a {
                color: #3498db;
                text-decoration: underline;
              }
        
              /* -------------------------------------
                  BUTTONS
              ------------------------------------- */
              .btn {
                box-sizing: border-box;
                width: 100%;
              }
              .btn > tbody > tr > td {
                padding-bottom: 15px;
              }
              .btn table {
                width: auto;
              }
              .btn table td {
                background-color: #ffffff;
                border-radius: 5px;
                text-align: center;
              }
              .btn a {
                background-color: #ffffff;
                border: solid 1px #3498db;
                border-radius: 5px;
                box-sizing: border-box;
                color: #3498db;
                cursor: pointer;
                display: inline-block;
                font-size: 14px;
                font-weight: bold;
                margin: 0;
                padding: 12px 25px;
                text-decoration: none;
                text-transform: capitalize;
              }
        
              .btn-primary table td {
                background-color: #3498db;
              }
        
              .btn-primary a {
                background-color: #3498db;
                border-color: #3498db;
                color: #ffffff;
              }
        
              /* -------------------------------------
                  OTHER STYLES THAT MIGHT BE USEFUL
              ------------------------------------- */
              .last {
                margin-bottom: 0;
              }
        
              .first {
                margin-top: 0;
              }
        
              .align-center {
                text-align: center;
              }
        
              .align-right {
                text-align: right;
              }
        
              .align-left {
                text-align: left;
              }
        
              .clear {
                clear: both;
              }
        
              .mt0 {
                margin-top: 0;
              }
        
              .mb0 {
                margin-bottom: 0;
              }
        
              .preheader {
                color: transparent;
                display: none;
                height: 0;
                max-height: 0;
                max-width: 0;
                opacity: 0;
                overflow: hidden;
                mso-hide: all;
                visibility: hidden;
                width: 0;
              }
        
              .powered-by a {
                text-decoration: none;
              }
        
              hr {
                border: 0;
                border-bottom: 1px solid #f6f6f6;
                margin: 20px 0;
              }
        
              /* -------------------------------------
                  RESPONSIVE AND MOBILE FRIENDLY STYLES
              ------------------------------------- */
              @media only screen and (max-width: 620px) {
                table.body h1 {
                  font-size: 28px !important;
                  margin-bottom: 10px !important;
                }
                table.body p,
                table.body ul,
                table.body ol,
                table.body td,
                table.body span,
                table.body a {
                  font-size: 16px !important;
                }
                table.body .wrapper,
                table.body .article {
                  padding: 10px !important;
                }
                table.body .content {
                  padding: 0 !important;
                }
                table.body .container {
                  padding: 0 !important;
                  width: 100% !important;
                }
                table.body .main {
                  border-left-width: 0 !important;
                  border-radius: 0 !important;
                  border-right-width: 0 !important;
                }
                table.body .btn table {
                  width: 100% !important;
                }
                table.body .btn a {
                  width: 100% !important;
                }
                table.body .img-responsive {
                  height: auto !important;
                  max-width: 100% !important;
                  width: auto !important;
                }
              }
        
              /* -------------------------------------
                  PRESERVE THESE STYLES IN THE HEAD
              ------------------------------------- */
              @media all {
                .ExternalClass {
                  width: 100%;
                }
                .ExternalClass,
                .ExternalClass p,
                .ExternalClass span,
                .ExternalClass font,
                .ExternalClass td,
                .ExternalClass div {
                  line-height: 100%;
                }
                .apple-link a {
                  color: inherit !important;
                  font-family: inherit !important;
                  font-size: inherit !important;
                  font-weight: inherit !important;
                  line-height: inherit !important;
                  text-decoration: none !important;
                }
                #MessageViewBody a {
                  color: inherit;
                  text-decoration: none;
                  font-size: inherit;
                  font-family: inherit;
                  font-weight: inherit;
                  line-height: inherit;
                }
                .btn-primary table td:hover {
                  background-color: #34495e !important;
                }
                .btn-primary a:hover {
                  background-color: #34495e !important;
                  border-color: #34495e !important;
                }
              }
            </style>
          </head>
          <body>
            <p>Dear ${newCustomer.first_name + " " + newCustomer.last_name},</p>
            <p>
              We are sending this email to verify that you are the owner of the email
              address <b>${newCustomer.email}</b> associated with your
              <b>Simsan Fraser Pvt. Ltd.</b> account.
            </p>
            <p>
              To complete the verification process, please enter the following one-time
              verification code (OTP) in the field provided on our website:
            </p>
            <p>OTP: <b>${userVerify.token}</b></p>
            <p>This code will expire in <b>10</b> minutes.</p>
            <p>
              If you did not request this email, please ignore it and no further action
              will be taken.
            </p>
            <p>Thank you!</p>
            <p>Best regards,</p>
        
            <p><b>Simsan Fraser Pvt. Ltd.</b> Customer Support Team</p>
          </body>
        </html>
        `,
        from: process.env.EMAIL_USER,
      });

      return res.status(ResponseStatus.SUCCESS_UPDATE).send({
        status: true,
        message: "User created successfully!",
      });
    } catch (err) {
      throw new APIError(err.message, ResponseStatus.API_ERROR);
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
      console.log(obj);
      if (user.is_verified) {
        return res.status(ResponseStatus.ALREADY_EXISTS).send({
          status: true,
          message: "User is already verified!",
        });
      }
      const queryRunner = getConnection().createQueryRunner();

      const fetchRecord: UserVerification | undefined =
        await queryRunner.manager.getRepository(UserVerification).findOne({
          where: [
            {
              type: obj.type,
              token: obj.otp,
              userId: user.id,
            },
          ],
        });
      console.log(fetchRecord);

      if (!fetchRecord) {
        return res.status(ResponseStatus.FAILED_UPDATE).send({
          status: false,
          message: "Invalid OTP",
        });
      }
      const previousDate = fetchRecord.updatedAt;
      let dayDiff;
      if (previousDate) {
        dayDiff = await dateDifference(new Date(previousDate), new Date());
      } else {
        return res.status(ResponseStatus.API_ERROR).send({
          status: false,
          message: "Something went wrong, try again later!",
        });
      }
      //comparison of difference with mins.
      if (dayDiff > 15) {
        return res.status(ResponseStatus.FAILED_UPDATE).send({
          status: false,
          message:
            "OTP has been expired, click on resend OTP to generate a new OTP!",
        });
      }
      const userRepo = await queryRunner.manager.getRepository(User);
      const userObj = await userRepo.findOne(user.id);
      if (userObj) {
        userObj.is_verified = true;
        userObj.verified_at = new Date();
        await queryRunner.manager.save(userObj);
        return res.status(ResponseStatus.SUCCESS_UPDATE).send({
          status: true,
          message: "User verified successfully!",
        });
      }
      return res.status(ResponseStatus.API_ERROR).send({
        status: false,
        message: "Something went wrong, try again later!",
      });
    } catch (error) {
      throw new APIError(error.message, ResponseStatus.API_ERROR);
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
          message: "User is already verified!",
        });
      }
      const queryRunner = getConnection().createQueryRunner();
      const verificationRepo = getConnection().getRepository(UserVerification);
      const userVerificationObj: UserVerification | undefined =
        await verificationRepo.findOne({
          where: [
            {
              type: type,
              userId: user.id,
            },
          ],
        });
      if (userVerificationObj) {
        userVerificationObj.token = await generateOtp();
        await queryRunner.manager.save(userVerificationObj);

        const info = await sendMail({
          from: process.env.EMAIL_USER,
          to: user.email,
          subject: "Verification Code",
          html: `<strong>Your verification OTP is ${userVerificationObj.token}</strong>`,
        });
        console.log(info);
        return res.status(ResponseStatus.SUCCESS_UPDATE).send({
          status: true,
          message: "OTP generated successfully!",
        });
      } else {
        return res.status(ResponseStatus.API_ERROR).send({
          status: false,
          message: "Something went wrong, try again later!",
        });
      }
    } catch (error) {
      console.log(error);
      throw new APIError(error.message, ResponseStatus.API_ERROR);
    }
  }
}
