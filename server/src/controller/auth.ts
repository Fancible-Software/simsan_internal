import { Controller } from "routing-controllers";

@Controller("/auth")
export class AuthController {

  // @Post("/customer/signup")
  // async customerSignup(
  //   @Res() res: Response,
  //   @Body()
  //   obj: customerSignupRequest
  // ) {
  //   try {
  //     const queryRunner = getConnection().createQueryRunner();

  //     const ifCustomerExist = await queryRunner.manager.getRepository(User).find({
  //       where: [
  //         { email: obj.email },
  //         { mobile_no: obj.mobile_no }
  //       ]
  //     })

  //     if (ifCustomerExist.length) {
  //       return res.status(409).send({
  //         status: false,
  //         message: "Email or Mobile Number already exist!"
  //       })
  //     }

  //     let newCustomer = new User()
  //     newCustomer.user_type = obj.user_type;
  //     newCustomer.first_name = obj.first_name;
  //     newCustomer.last_name = obj.last_name;
  //     newCustomer.email = obj.email;
  //     newCustomer.mobile_no = obj.mobile_no;
  //     newCustomer.country = obj.country_id;
  //     newCustomer.password = bcrypt.hashSync(obj.password);
  //     newCustomer.is_mobile_verified = obj.is_mobile_verified;
  //     newCustomer.is_email_verified = obj.is_email_verified;

  //     let isCustomerCreated = await queryRunner.manager.save(newCustomer)

  //     return res.status(200).send({
  //       status: true,
  //       message: "Customer created successfully!",
  //       data: isCustomerCreated
  //     })
  //   }
  //   catch (err) {
  //     throw new APIError(err.message, 500)
  //   }
  // }

  // @Post("/login")
  // async login(
  //   @Res() res: Response,
  //   @Body()
  //   obj: customerSigninRequest
  // ) {
  //   try {
  //     const queryRunner = getConnection().createQueryRunner();

  //     const ifUserExist = await queryRunner.manager.getRepository(User).findOne({
  //       where: [
  //         { email: obj.email },
  //       ],
  //       select: ["id", "first_name", "last_name", "user_type", "mobile_no", "email", "password", "is_active"]
  //     })
  //     if (!ifUserExist) {
  //       return res.status(200).send({
  //         status: false,
  //         message: 'Invalid email!'
  //       })
  //     }
  //     if (!ifUserExist.is_active) {
  //       return res.status(200).send({
  //         status: false,
  //         message: "User isn't active, please contact admin!"
  //       })
  //     }
  //     const isPasswordValid = bcrypt.compareSync(obj.password, ifUserExist.password)
  //     if (!isPasswordValid) {
  //       return res.status(200).send({
  //         status: false,
  //         message: "Invalid password!"
  //       })
  //     }
  //     const tokenData: TokenData = {
  //       email: ifUserExist.email
  //     }
  //     var auth_token = jwt.sign(tokenData, process.env.JWT_SECRET, {
  //       expiresIn: '2 days'
  //     })
  //     let user_details = {
  //       id: ifUserExist.id,
  //       user_type: ifUserExist.user_type,
  //       first_name: ifUserExist.first_name,
  //       last_name: ifUserExist.last_name,
  //       email: ifUserExist.email,
  //       mobile_no: ifUserExist.mobile_no,
  //       token: auth_token
  //     }

  //     return res.status(200).send({
  //       status: true,
  //       message: "Logged in successfully!",
  //       data: user_details
  //     })
  //   }
  //   catch (err) {
  //     throw new APIError(err.message, 500)
  //   }
  // }

  // @Post("/send-otp")
  // async sendOtp(
  //   @Res() res: Response
  //   // obj: sendOtpRequest
  // ) {
  //   const otp = Math.floor(100000 + Math.random() * 900000);
  //   // const message = otp + " is your Idowaz verification code. You need to enter this code in order to verify your account.";


  //   return res.status(200).send({
  //     status: true,
  //     message: "OTP sent successfully!",
  //     data: otp
  //   })
  // }


}
