import { Response } from "express";
import {
  Authorized,
  Body,
  Controller,
  Delete,
  Get,
  Params,
  Post,
  Put,
  Res,
  CurrentUser,
} from "routing-controllers";
import { getConnection, In, QueryRunner, Repository } from "typeorm";
import {
  EntityId,
  FormToServiceType,
  FormType,
  ResponseStatus,
  UserPermissions,
  SkipLimitURLParams,
} from "../types";
import { Form } from "../entity/Form";
import logger from "../utils/logger";
import { APIError } from "../utils/APIError";
import { FormToServices } from "src/entity/FormToServices";
import { Service } from "../entity/Services";
import { User } from "../entity/User";
import generateInvoice from "../utils/generateInvoice";
import date from "date-and-time";
import { Configurations } from "../entity/Configurations";
import sendMail from "../utils/sendMail";

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
      const formRepository: Repository<Form> =
        getConnection().getRepository(Form);
      const forms: Form[] = await formRepository.find({
        order: {
          formId: "DESC",
        },
        skip: +skip,
        take: +limit,
      });

      const formCount = await formRepository.count();

      return res.status(ResponseStatus.SUCCESS_FETCH).send({
        status: true,
        count: formCount,
        data: forms,
      });
    } catch (err) {
      console.log(err.message);
      logger.error(err.message);
      return new APIError(err.message, ResponseStatus.API_ERROR);
    }
  }

  @Authorized(UserPermissions.admin || UserPermissions.sub_admin)
  @Get("/:id")
  async getFormById(@Res() res: Response, @Params() { id }: EntityId) {
    try {
      const formRepository: Repository<Form> =
        getConnection().getRepository(Form);
      const formRecord: Form | undefined = await formRepository.findOne(id, {
        relations: ["formToServices"],
      });

      if (formRecord) {
        return res.status(ResponseStatus.SUCCESS_UPDATE).send({
          status: true,
          data: formRecord,
        });
      } else {
        return res.status(ResponseStatus.API_ERROR).send({
          status: false,
          message: "Could not find form record with given id",
        });
      }
    } catch (err) {
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
      const serviceRepository: Repository<Service> =
        getConnection().getRepository(Service);
      const services = await serviceRepository.find({
        where: {
          serviceId: In(
            body.services.map((service: FormToServiceType) => service.serviceId)
          ),
        },
      });
      const serviceMap: Map<number, Service> = new Map<number, Service>();
      services.forEach((service: Service) =>
        serviceMap.set(service.serviceId, service)
      );
      const newFormRecord: Form = body.toForm(user.id.toString());
      const formAdded = await queryRunner.manager.save(newFormRecord);

      await queryRunner.manager.save(
        newFormRecord.formToServices.map((service: FormToServices) => {
          service.form = newFormRecord;
          return service;
        })
      );
      const formRepository: Repository<Form> =
        getConnection().getRepository(Form);
      const formRecord: Form | undefined = await formRepository.findOne(
        formAdded.formId,
        {
          relations: ["formToServices", "formToServices.service"],
        }
      );
      if (formRecord) {
        const info = await sendMail({
          from: process.env.EMAIL_USER,
          to: body.customerEmail,
          html: `<html><head></head><body><div>Click on the below link to check your invoice <br/> <a href="/invoice/${formRecord.formId}/${formRecord.invoiceUuid}">Link to Invoice</a></div></body></html>`,
          subject: "Invoice - SimsanFraserMain",
        });
        // console.log(info);
      }

      return res.status(ResponseStatus.SUCCESS_UPDATE).send({
        status: true,
        messsage: "Successfully created form record",
      });
    } catch (err) {
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
      const formRepository: Repository<Form> =
        getConnection().getRepository(Form);
      const queryRunner: QueryRunner = getConnection().createQueryRunner();
      const formRecord: Form | undefined = await formRepository.findOne(id);

      if (formRecord) {
        queryRunner.manager.save(body.updateForm(formRecord));
        return res.status(ResponseStatus.SUCCESS_UPDATE).send({
          status: true,
          messsage: "Successfully updated form record",
        });
      } else {
        return res.status(ResponseStatus.API_ERROR).send({
          status: false,
          message: "Could not find form record with given id",
        });
      }
    } catch (err) {
      console.log(err.message);
      logger.error(err.message);
      return new APIError(err.message, ResponseStatus.API_ERROR);
    }
  }

  @Authorized(UserPermissions.admin)
  @Delete("/:id")
  async deleteFormById(@Res() res: Response, @Params() { id }: EntityId) {
    try {
      const formRepository: Repository<Form> =
        getConnection().getRepository(Form);
      const queryRunner: QueryRunner = getConnection().createQueryRunner();
      const formRecord: Form | undefined = await formRepository.findOne(id);

      if (formRecord) {
        queryRunner.manager.remove(formRecord);
        return res.status(ResponseStatus.SUCCESS_UPDATE).send({
          status: true,
          messsage: "Successfully deleted form record",
        });
      } else {
        return res.status(ResponseStatus.API_ERROR).send({
          status: false,
          message: "Could not find form record with given id",
        });
      }
    } catch (err) {
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
      const today = date.format(new Date(), "YYYY-MM-DD");
      const formRepository: Repository<Form> =
        getConnection().getRepository(Form);
      const formRecord: Form | undefined = await formRepository.findOne(id, {
        relations: ["formToServices", "formToServices.service"],
      });
      if (formRecord) {
        // console.log(formRecord)
        const configRepo: Repository<Configurations> =
          getConnection().getRepository(Configurations);
        const configRecord = await configRepo.find();
        // console.log(configRecord)
        const invoiceNumber = Date.now();
        let products: any = [];
        formRecord.formToServices.map((element) => {
          let obj = {
            quantity: 1,
            description: element.service.serviceName,
            price: +element.service.price,
          };
          products.push(obj);
        });

        let logoDetails = "";
        let taxDetails = "";
        let companyName = "";
        let companyAddress = "";
        let companyCity = "";
        let companyCountry = "";
        let companyZip = "";

        configRecord.filter((element) => {
          if (element.key === "logo") {
            logoDetails = element.value;
          } else if (element.key === "gst") {
            taxDetails = element.value;
          } else if (element.key === "company_name") {
            companyName = element.value;
          } else if (element.key === "company_address") {
            companyAddress = element.value;
          } else if (element.key === "company_city") {
            companyCity = element.value;
          } else if (element.key === "company_country") {
            companyCountry = element.value;
          } else if (element.key === "company_zip") {
            companyZip = element.value;
          }
        });

        let data = {
          images: {
            logo: logoDetails,
          },
          company_details: {
            name: companyName,
            address: companyAddress,
            zip: companyZip,
            city: companyCity,
            country: companyCountry,
          },
          client: {
            name: formRecord.customerName,
            address: formRecord.customerAddress,
            zip: formRecord.customerPostalCode,
            city: formRecord.customerCity,
            country: formRecord.customerCountry,
          },
          information: {
            invoice_number: invoiceNumber,
            date: today,
            total: formRecord.final_amount,
            sub_total: formRecord.total,
            discount: formRecord.discount,
            tax: taxDetails,
          },
          products: products,
          // "bottom-notice": "Kindly pay your invoice within 15 days.",
          // Settings to customize your invoice
          settings: {
            currency: "CAD",
            "tax-notation": "gst",
          },
        };
        let invoiceDetails: any = {};
        invoiceDetails = await generateInvoice(data);
        if (invoiceDetails) {
          // const formObj: Form | undefined = await formRepository.findOne(id);
          formRecord.invoice_id = invoiceDetails?.invoice_id;
          formRecord.invoice_path = invoiceDetails?.path;
          formRecord.is_invoice_generated = true;
          formRepository.manager.save(formRecord);
        }
        return res.status(ResponseStatus.SUCCESS_UPDATE).send({
          status: true,
          data: formRecord,
        });
      } else {
        return res.status(ResponseStatus.API_ERROR).send({
          status: false,
          message: "Could not find form record with given id",
        });
      }
    } catch (error) {
      logger.log(error.message);
      return new APIError(error.message, ResponseStatus.API_ERROR);
    }
  }
}
