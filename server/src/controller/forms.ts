import { Response } from "express";
import {
  Authorized,
  Body,
  Controller,
  Delete,
  Get,
  Params,
  Post,
  Res,
  CurrentUser,
  QueryParams,
  Patch,
} from "routing-controllers";
import { Brackets, getConnection, In, QueryRunner, Repository } from "typeorm";
import {
  EntityId,
  FormToServiceType,
  FormType,
  ResponseStatus,
  UserPermissions,
  SkipLimitURLParams,
  formTypes,
  AnalyticsDate,
} from "../types";
import { Form } from "../entity/Form";
import logger from "../utils/logger";
import { APIError } from "../utils/APIError";
import { FormToServices } from "../entity/FormToServices";
import { Service } from "../entity/Services";
import { User } from "../entity/User";
import generateInvoice from "../utils/generateInvoice";
import date from "date-and-time";
import { Configurations } from "../entity/Configurations";
import sendMail from "../utils/sendMail";
import { getInvoiceHtml, sendFormEmail } from "../utils/htmlTemplateUtil";

@Controller("/form")
export class FormController {
  @Authorized(UserPermissions.admin || UserPermissions.sub_admin)
  @Get("/all/:skip/:limit")
  async getAllForms(
    @Params()
    { skip, limit }: SkipLimitURLParams,
    @QueryParams({ validate: true })
    { type, searchTerm }: { type: string; searchTerm?: string },
    @Res() res: Response
  ) {
    try {
      if (searchTerm) {
        searchTerm = searchTerm.trim();
        if (!searchTerm) {
          searchTerm = undefined;
        }
      }
      const conn = getConnection();
      const qb = conn.createQueryBuilder(Form, "form");

      qb.where("form.type = :type", { type: type });

      if (searchTerm) {
        qb.andWhere(
          new Brackets((q) => {
            q.where("form.customerName ilike :searchTerm", {
              searchTerm: `%${searchTerm}%`,
            })
              .orWhere("form.customerEmail ilike :searchTerm", {
                searchTerm: `%${searchTerm}%`,
              })
              .orWhere("form.customerPhone ilike :searchTerm", {
                searchTerm: `%${searchTerm}%`,
              })
              .orWhere("form.customerAddress ilike :searchTerm", {
                searchTerm: `%${searchTerm}%`,
              })
              .orWhere("form.customerCity ilike :searchTerm", {
                searchTerm: `%${searchTerm}%`,
              })
              .orWhere("form.customerPostalCode ilike :searchTerm", {
                searchTerm: `%${searchTerm}%`,
              });
          })
        );
      }

      const formCount = await qb
        .clone()
        .select("COUNT(1) as count")
        .getRawOne<{ count: string }>();

      const forms = await qb
        .leftJoin(User, "creator", "creator.id = CAST(form.createdBy AS DECIMAL)")
        .select([
          'form."formId" as "formId", form."customerName" as "customerName",form."customerEmail" as "customerEmail", form."customerPhone" as "customerPhone", form."createdAt" as "createdAt", form."customerAddress" as "customerAddress",form."customerPostalCode" as "customerPostalCode", form."customerCity" as "customerCity",form."customerProvince" as "customerProvince", form."customerCountry" as "customerCountry", form."total" as "total", form."discount" as "discount", form."discount_percent" as "discount_percent", form."type" as "type", form."invoiceUuid" as "invoiceUuid",form."final_amount" as "final_amount", form."invoiceNumber" as "invoiceNumber", "creator"."first_name" as "first_name", "creator"."last_name" as "last_name"',
        ])
        .orderBy("form.formId", "DESC")
        .offset(+skip)
        .limit(+limit)
        .getRawMany<Form[]>();

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

  @Authorized(UserPermissions.admin)
  @Post("/analytics")
  async getAnalytics(@Res() res: Response, @Body() input: AnalyticsDate) {
    try {
      const conn = getConnection();
      let startDate = new Date(Date.parse(input.startDate));
      let endDate = new Date(Date.parse(input.endDate));
      endDate.setUTCHours(23, 59, 59, 999);

      const forms = await conn
        .createQueryBuilder(Form, "form")
        .leftJoin(User, "creator", "creator.id = CAST(form.\"createdBy\" AS DECIMAL)")
        .select([
          'form."formId" as "formId", form."customerName" as "customerName", form."customerEmail" as "customerEmail", form."customerPhone" as "customerPhone", form."createdAt" as "createdAt", form."customerAddress" as "customerAddress", form."customerPostalCode" as "customerPostalCode", form."customerCity" as "customerCity", form."customerProvince" as "customerProvince", form."customerCountry" as "customerCountry", form."total" as "total", form."discount" as "discount", form."discount_percent" as "discount_percent", form."type" as "type", form."invoiceUuid" as "invoiceUuid", form."final_amount" as "final_amount", form."invoiceNumber" as "invoiceNumber", form."createdBy" as "createdBy", form."createdAt" as "creationDate", CONCAT(creator."first_name", \' \', creator."last_name") as "createdByName"',
        ])
        .where("form.createdAt >= :startDate", {
          startDate: startDate.toUTCString(),
        })
        .andWhere("form.createdAt <= :endDate", {
          endDate: endDate.toUTCString(),
        })
        .andWhere("form.type = :type", { type: input.type })
        .getRawMany<Form>();

      const uniqueCustomers = await conn
        .createQueryBuilder(Form, "form")
        .select(['distinct form."customerEmail" as "customerEmail"'])
        .where("form.createdAt >= :startDate", {
          startDate: startDate.toUTCString(),
        })
        .andWhere("form.createdAt <= :endDate", {
          endDate: endDate.toUTCString(),
        })
        .andWhere("form.type = :type", { type: input.type })
        .getCount();

      const total = forms.reduce(
        (total: number, record: Form) =>
          total + parseFloat(record.final_amount),
        0
      );

      return res.status(ResponseStatus.SUCCESS_FETCH).send({
        status: true,
        "Number Of Sales": forms.length,
        data: forms,
        "Total Sales in $": total,
        "Average Sales in $": total / forms.length,
        "Number of Unique Customers": uniqueCustomers,
      });
    } catch (err) {
      console.log(err);
      logger.error(err.message);
      return new APIError(err.message, ResponseStatus.API_ERROR);
    }
  }

  @Authorized(UserPermissions.admin || UserPermissions.sub_admin)
  @Get("/:id")
  async getFormById(@Res() res: Response, @Params() { id }: EntityId) {
    try {
      const conn = getConnection();
      const formRepository: Repository<Form> = conn.getRepository(Form);
      const formRecord: Form | undefined = await formRepository.findOne(id, {
        relations: ["formToServices", "formToServices.service"],
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
    const conn = getConnection();
    const queryRunner: QueryRunner = conn.createQueryRunner();
    try {
      const serviceRepository: Repository<Service> =
        conn.getRepository(Service);
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
      const formRepository: Repository<Form> = conn.getRepository(Form);
      const formRecord: Form | undefined = await formRepository.findOne(
        formAdded.formId,
        {
          relations: ["formToServices", "formToServices.service"],
        }
      );

      if (formRecord) {
        const htmlInvoice = await getInvoiceHtml(
          formRecord.formId,
          formRecord.invoiceUuid
        );
        const formType =
          formRecord.type.toLocaleLowerCase() === formTypes.form
            ? "Invoice"
            : "Quote";
        if (formType === "Quote") {
          await sendMail({
            from: process.env.EMAIL_USER,
            to: body.customerEmail,
            html: `<html><head></head><body><div>Click on the below link to check your ${formType} <br/> <a href="${process.env.BACKEND_URI}/quote/${formRecord.formId}/${formRecord.invoiceUuid}">Link to ${formType}</a></div> <br/> <br/> ${htmlInvoice}</body></html>`,
            subject: `${formType} - Simsan Fraser Maintenance`,
          });

          await sendMail({
            from: process.env.EMAIL_USER,
            to: "simsanfrasermain@gmail.com",
            html: `<html><head></head><body><div>Click on the below link to check your ${formType} <br/> <a href="${process.env.BACKEND_URI}/quote/${formRecord.formId}/${formRecord.invoiceUuid}">Link to ${formType}</a></div> <br/> <br/> ${htmlInvoice}</body></html>`,
            subject: `${formType} - Simsan Fraser Maintenance`,
          });
        } else {
          await sendMail({
            from: process.env.EMAIL_USER,
            to: body.customerEmail,
            html: `<html><head></head><body><div>Click on the below link to check your ${formType} <br/> <a href="${process.env.BACKEND_URI}/invoice/${formRecord.formId}/${formRecord.invoiceUuid}">Link to ${formType}</a></div> <br/> <br/> ${htmlInvoice}</body></html>`,
            subject: `${formType} - Simsan Fraser Maintenance`,
          });

          await sendMail({
            from: process.env.EMAIL_USER,
            to: "simsanfrasermain@gmail.com",
            html: `<html><head></head><body><div>Click on the below link to check your ${formType} <br/> <a href="${process.env.BACKEND_URI}/invoice/${formRecord.formId}/${formRecord.invoiceUuid}">Link to ${formType}</a></div> <br/> <br/> ${htmlInvoice}</body></html>`,
            subject: `${formType} - Simsan Fraser Maintenance`,
          });
        }
      }

      return res.status(ResponseStatus.SUCCESS_UPDATE).send({
        status: true,
        messsage: "Successfully created form record",
      });
    } catch (err) {
      console.log(err);
      logger.error(err.message);
      return new APIError(err.message, ResponseStatus.API_ERROR);
    } finally {
      await queryRunner.release();
    }
  }

  @Authorized(UserPermissions.admin)
  @Patch("/update/:id")
  async updateForm(
    @Res() res: Response,
    @Params() { id }: EntityId,
    @Body() body: FormType
  ) {
    const conn = getConnection();
    const queryRunner: QueryRunner = conn.createQueryRunner();
    try {
      const formRepository: Repository<Form> = conn.getRepository(Form);

      const formRecord: Form | undefined = await formRepository.findOne(id);

      if (formRecord) {
        await queryRunner.startTransaction();
        queryRunner.manager.update(Form, id, {
          customerName: body.customerName,
          customerEmail: body.customerEmail,
          customerAddress: body.customerAddress,
          customerCity: body.customerCity,
          customerCountry: body.customerCountry,
          customerPostalCode: body.customerPostalCode,
          customerPhone: body.customerPhone,
          customerProvince: body.customerProvince,
          discount: body.discount,
          total: body.total,
          is_taxable: body.is_taxable,
          final_amount: body.final_amount,
          discount_percent: body.discount_percent,
          type: body.type,
          comment: body.comment,
        });
        queryRunner.manager.update(Form, id, body);

        await queryRunner.manager.delete(FormToServices, {
          formId: id,
        });

        const updateServiceRecord = body.updateFormServices();

        const serviceRepository: Repository<Service> =
          conn.getRepository(Service);
        const services = await serviceRepository.find({
          where: {
            serviceId: In(
              body.services.map(
                (service: FormToServiceType) => service.serviceId
              )
            ),
          },
        });

        const serviceMap: Map<number, Service> = new Map<number, Service>();
        services.forEach((service: Service) =>
          serviceMap.set(service.serviceId, service)
        );
        await queryRunner.manager.save(
          updateServiceRecord.formToServices.map((service: FormToServices) => {
            service.form = formRecord;
            return service;
          })
        );
        await queryRunner.commitTransaction();
        const updatedFormRecord: Form | undefined =
          await formRepository.findOne(id);
        if (updatedFormRecord) {
          await sendFormEmail(updatedFormRecord);
        }
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
      queryRunner.rollbackTransaction();

      console.log(err.message);
      logger.error(err.message);
      return new APIError(err.message, ResponseStatus.API_ERROR);
    } finally {
      await queryRunner.release();
    }
  }

  @Authorized(UserPermissions.admin)
  @Delete("/:id")
  async deleteFormById(@Res() res: Response, @Params() { id }: EntityId) {
    const conn = getConnection();
    const queryRunner: QueryRunner = conn.createQueryRunner();
    try {
      const formRepository: Repository<Form> = conn.getRepository(Form);
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
    } finally {
      await queryRunner.release();
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
      const conn = getConnection();
      const today = date.format(new Date(), "YYYY-MM-DD");
      const formRepository: Repository<Form> = conn.getRepository(Form);
      const formRecord: Form | undefined = await formRepository.findOne(id, {
        relations: ["formToServices", "formToServices.service"],
      });
      if (formRecord) {
        const createdBy: Repository<User> = getConnection().getRepository(User);
        const createdByRecord = await createdBy.findOne({
          where: { id: formRecord.createdBy },
          select: ["first_name", "last_name"],
        });
        // console.log(formRecord)
        const configRepo: Repository<Configurations> =
          conn.getRepository(Configurations);
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
            soldBy:
              createdByRecord?.first_name + " " + createdByRecord?.last_name,
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
            "tax-notation": "GST",
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
