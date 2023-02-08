import { Response } from "express";
import {
  Controller,
  CurrentUser,
  Get,
  Param,
  Post,
  Res,
} from "routing-controllers";
import { APIError } from "../utils/APIError";
import {
  EmailDays,
  originalFormTypes,
  ResponseStatus,
  UserPermissions,
} from "../types";
import logger from "../utils/logger";
import sendMail from "../utils/sendMail";
import {
  getPromotiomalEmailSubject,
  getPromotionalEmailHtml,
} from "../utils/htmlTemplateUtil";
import { getConnection } from "typeorm";
import { Form } from "../entity/Form";
import { User } from "../entity/User";

@Controller("/email")
export class EmailController {
  @Post("/:day")
  async sendPromotionalEmail(
    @Param("day") day: EmailDays,
    @CurrentUser() user: User,
    @Res() res: Response
  ) {
    try {
      if (user.roles !== UserPermissions.admin) {
        throw new APIError(
          "Not authorized to send promotional emails",
          ResponseStatus.API_ERROR
        );
      }
      const formRepository = getConnection().getRepository(Form);
      const customers = await formRepository.find();
      const emailPromises: Promise<any>[] = [];
      const addedCustomer = new Set();
      // Send Email
      customers.forEach(async (customer) => {
        
        if (customer.type === originalFormTypes.form && !addedCustomer.has(customer.customerEmail)) {
          emailPromises.push(
            sendMail({
              from: process.env.EMAIL_USER,
              to: customer.customerEmail,
              html: await getPromotionalEmailHtml(day),
              subject: getPromotiomalEmailSubject(day),
            })
          );
        }
        addedCustomer.add(customer.customerEmail);
      });

      await Promise.all(emailPromises);
      return res.status(ResponseStatus.SUCCESS_UPDATE).send({
        status: true,
        messsage: "Successfully sent promotional emails",
      });
    } catch (err) {
      // console.log(err.message);
      logger.error(err.message);
      return new APIError(err.message, ResponseStatus.API_ERROR);
    }
  }

  @Get("/view/:day")
  async viewEmailTemplate(@Param("day") day: EmailDays) {
    try {
      return await getPromotionalEmailHtml(day);
    } catch (err) {
      throw new APIError(err.message, ResponseStatus.API_ERROR);
    }
  }
}
