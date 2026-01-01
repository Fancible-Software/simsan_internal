import { Body, Controller, Post, Res, UseBefore } from "routing-controllers";
import { ContactFormRequest, ResponseStatus } from "../types";
import { Contact } from "../entity/Contact";
import { getConnection } from "typeorm";
import { Response } from "express";
import { RateLimiterMiddleware } from "../middleware/rateLimiter";

@Controller("/contact")
export class ContactController {
    @Post("/create")
    @UseBefore(RateLimiterMiddleware)
    async createContact(@Body() body: ContactFormRequest, @Res() res: Response) {
        try {
            const contact = new Contact();
            contact.name = body.name;
            contact.email = body.email;
            contact.phone = body.phone;
            contact.service = body.service;
            contact.message = body.message;
            await getConnection().getRepository(Contact).save(contact);
            return res.status(ResponseStatus.SUCCESS_FETCH).send({
                status: true,
                message: "Thank you for contacting us. We will get back to you soon.",
            });
        } catch (error) {
            return res.status(ResponseStatus.API_ERROR).send({
                status: false,
                message: "Something went wrong. Please try again later.",
            });
        }
    }
}