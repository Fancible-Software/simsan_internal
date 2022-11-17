import { Response } from "express";
import { Authorized, Body, Controller, Delete, Get, Params, Post, Put, Res, CurrentUser } from "routing-controllers";
import { getConnection, In, QueryRunner, Repository } from "typeorm";
import { EntityId, FormToServiceType, FormType, ResponseStatus, UserPermissions, SkipLimitURLParams } from "../types";
import { Form } from "../entity/Form";
import logger from "../utils/logger";
import { APIError } from "../utils/APIError";
import { FormToServices } from "src/entity/FormToServices";
import { Service } from "../entity/Services";
import { User } from '../entity/User'
import generateInvoice from "../utils/generateInvoice";

@Controller("/form")
export class FormController {

    @Authorized(UserPermissions.admin || UserPermissions.sub_admin)
    @Get("/all/:skip/:limit")
    async getAllForms(
        @Params()
        { skip, limit }: SkipLimitURLParams,
        @Res() res: Response
    ) {
        try {
            const formRepository: Repository<Form> = getConnection().getRepository(Form);
            const forms: Form[] = await formRepository.find({
                order: {
                    formId: "DESC"
                },
                skip: +skip,
                take: +limit
            });

            const formCount = await formRepository.count()

            return res.status(ResponseStatus.SUCCESS_FETCH).send({
                status: true,
                count: formCount,
                data: forms
            })
        }
        catch (err) {
            console.log(err.message);
            logger.error(err.message);
            return new APIError(err.message, ResponseStatus.API_ERROR);
        }
    }

    @Authorized(UserPermissions.admin || UserPermissions.sub_admin)
    @Get("/:id")
    async getFormById(
        @Res() res: Response,
        @Params() { id }: EntityId
    ) {
        try {
            const formRepository: Repository<Form> = getConnection().getRepository(Form);
            const formRecord: Form | undefined = await formRepository.findOne(id, {
                relations: ["formToServices"]
            });

            if (formRecord) {
                return res.status(ResponseStatus.SUCCESS_UPDATE).send({
                    status: true,
                    data: formRecord
                })
            } else {
                return res.status(ResponseStatus.API_ERROR).send({
                    status: false,
                    message: "Could not find form record with given id"
                })
            }
        }
        catch (err) {
            console.log(err.message);
            logger.error(err.message);
            return new APIError(err.message, ResponseStatus.API_ERROR);
        }
    }

    @Authorized(UserPermissions.admin)
    @Post("/create")
    async createForm(
        @Res() res: Response,
        @CurrentUser() user: User,
        @Body() body: FormType
    ) {
        try {
            const queryRunner: QueryRunner = getConnection().createQueryRunner();
            const serviceRepository: Repository<Service> = getConnection().getRepository(Service);
            const services = await serviceRepository.find({
                where: {
                    serviceId: In(body.services.map((service: FormToServiceType) => service.serviceId))
                }
            });
            const serviceMap: Map<number, Service> = new Map<number, Service>();
            services.forEach((service: Service) => serviceMap.set(service.serviceId, service));
            const newFormRecord: Form = body.toForm(user.id.toString());
            await queryRunner.manager.save(newFormRecord);
            await queryRunner.manager.save(newFormRecord.formToServices.map((service: FormToServices) => {
                service.form = newFormRecord
                return service;
            }));

            return res.status(ResponseStatus.SUCCESS_UPDATE).send({
                status: true,
                messsage: "Successfully created form record"
            })
        }
        catch (err) {
            console.log(err.message);
            logger.error(err.message);
            return new APIError(err.message, ResponseStatus.API_ERROR);
        }
    }

    @Authorized(UserPermissions.admin)
    @Put("/:id")
    async updateForm(
        @Res() res: Response,
        @Params() { id }: EntityId,
        @Body() body: FormType
    ) {
        try {
            const formRepository: Repository<Form> = getConnection().getRepository(Form);
            const queryRunner: QueryRunner = getConnection().createQueryRunner();
            const formRecord: Form | undefined = await formRepository.findOne(id);

            if (formRecord) {
                queryRunner.manager.save(body.updateForm(formRecord));
                return res.status(ResponseStatus.SUCCESS_UPDATE).send({
                    status: true,
                    messsage: "Successfully updated form record"
                })
            } else {
                return res.status(ResponseStatus.API_ERROR).send({
                    status: false,
                    message: "Could not find form record with given id"
                })
            }
        }
        catch (err) {
            console.log(err.message);
            logger.error(err.message);
            return new APIError(err.message, ResponseStatus.API_ERROR);
        }
    }

    @Authorized(UserPermissions.admin)
    @Delete("/:id")
    async deleteFormById(
        @Res() res: Response,
        @Params() { id }: EntityId
    ) {
        try {
            const formRepository: Repository<Form> = getConnection().getRepository(Form);
            const queryRunner: QueryRunner = getConnection().createQueryRunner();
            const formRecord: Form | undefined = await formRepository.findOne(id);

            if (formRecord) {
                queryRunner.manager.remove(formRecord);
                return res.status(ResponseStatus.SUCCESS_UPDATE).send({
                    status: true,
                    messsage: "Successfully deleted form record"
                })
            } else {
                return res.status(ResponseStatus.API_ERROR).send({
                    status: false,
                    message: "Could not find form record with given id"
                })
            }
        }
        catch (err) {
            console.log(err.message);
            logger.error(err.message);
            return new APIError(err.message, ResponseStatus.API_ERROR);
        }
    }

    @Authorized(UserPermissions.admin)
    @Post("/generate/invoice")
    async generateInvoice(
        @Res() res: Response,
        @Body()
        { id }: EntityId
    ) {
        try {
            console.log(id)
            const formRepository: Repository<Form> = getConnection().getRepository(Form);
            const formRecord: Form | undefined = await formRepository.findOne(id, {
                relations: ["formToServices"]
            });

            if (formRecord) {
                let data = {
                    "images": {
                        "logo": "https://public.easyinvoice.cloud/img/logo_en_original.png",
                    },
                    "sender": {
                        "company": "Sample Corp",
                        "address": "Sample Street 123",
                        "zip": "1234 AB",
                        "city": "Sampletown",
                        "country": "Samplecountry"
                    },
                    "client": {
                        "company": "Client Corp",
                        "address": "Clientstreet 456",
                        "zip": "4567 CD",
                        "city": "Clientcity",
                        "country": "Clientcountry"
                    },
                    "information": {
                        // Invoice number
                        "number": "2021.0001",
                        // Invoice data
                        "date": "12-12-2021",
                        // Invoice due date
                        "due-date": "31-12-2021"
                    },
                    "products": [
                        {
                            "quantity": 2,
                            "description": "Product 1",
                            "tax-rate": 6,
                            "price": 33.87
                        },
                        {
                            "quantity": 4.1,
                            "description": "Product 2",
                            "tax-rate": 6,
                            "price": 12.34
                        },
                        {
                            "quantity": 4.5678,
                            "description": "Product 3",
                            "tax-rate": 21,
                            "price": 6324.453456
                        }
                    ],
                    // The message you would like to display on the bottom of your invoice
                    "bottom-notice": "Kindly pay your invoice within 15 days.",
                    // Settings to customize your invoice
                    "settings": {
                        "currency": "CAD", // See documentation 'Locales and Currency' for more info. Leave empty for no currency.
                        "tax-notation": "gst",
                        // "locale": "nl-NL", // Defaults to en-US, used for number formatting (See documentation 'Locales and Currency')
                        // "margin-top": 25, // Defaults to '25'
                        // "margin-right": 25, // Defaults to '25'
                        // "margin-left": 25, // Defaults to '25'
                        // "margin-bottom": 25, // Defaults to '25'
                        // "format": "A4", // Defaults to A4, options: A3, A4, A5, Legal, Letter, Tabloid
                        // "height": "1000px", // allowed units: mm, cm, in, px
                        // "width": "500px", // allowed units: mm, cm, in, px
                        // "orientation": "landscape", // portrait or landscape, defaults to portrait
                    },
                    // Translate your invoice to your preferred language
                    "translate": {
                        // "invoice": "FACTUUR",  // Default to 'INVOICE'
                        // "number": "Nummer", // Defaults to 'Number'
                        // "date": "Datum", // Default to 'Date'
                        // "due-date": "Verloopdatum", // Defaults to 'Due Date'
                        // "subtotal": "Subtotaal", // Defaults to 'Subtotal'
                        // "products": "Producten", // Defaults to 'Products'
                        // "quantity": "Aantal", // Default to 'Quantity'
                        // "price": "Prijs", // Defaults to 'Price'
                        // "product-total": "Totaal", // Defaults to 'Total'
                        // "total": "Totaal" // Defaults to 'Total'
                    },
                }
    
                await generateInvoice(data)
                return res.status(ResponseStatus.SUCCESS_UPDATE).send({
                    status: true,
                    data: formRecord
                })
            } else {
                return res.status(ResponseStatus.API_ERROR).send({
                    status: false,
                    message: "Could not find form record with given id"
                })
            }
            
        }
        catch (error) {
            logger.log(error.message)
            return new APIError(error.message, ResponseStatus.API_ERROR)
        }
    }

}