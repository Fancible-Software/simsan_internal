import { Response } from "express";
import { Controller, Param, Post, Res } from "routing-controllers";
import { APIError } from "../utils/APIError";
import { EmailDays, formTypes, ResponseStatus } from "../types";
import logger from "../utils/logger";
import sendMail from "../utils/sendMail";
import { getPromotiomalEmailSubject, getPromotionalEmailHtml } from "../utils/htmlTemplateUtil";
import { getConnection } from "typeorm";
import { Form } from "../entity/Form";

@Controller("/email")
export class EmailController{
    @Post("/:day")
    async sendPromotionalEmail(
        @Param("day") day: EmailDays,
        @Res() res : Response
    ){
        try{
            const formRepository = getConnection().getRepository(Form);
            const customers = await formRepository.find();
            const emailPromises: Promise<any>[] = [];
            // Send Email
            customers.forEach(async customer=>{
                if(customer.type === formTypes.form){
                    emailPromises.push(
                        sendMail({
                            from: process.env.EMAIL_USER,
                            to: customer.customerEmail,
                            html: await getPromotionalEmailHtml(day),
                            subject: getPromotiomalEmailSubject(day),
                        })
                    );
                }
            });

            await Promise.all(emailPromises);
            return res.status(ResponseStatus.SUCCESS_UPDATE).send({
                status: true,
                messsage: "Successfully sent promotional emails",
            });
        }
        catch (err) {
            console.log(err.message);
            logger.error(err.message);
            return new APIError(err.message, ResponseStatus.API_ERROR);
          }
    }
}