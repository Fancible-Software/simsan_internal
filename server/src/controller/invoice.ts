import { Controller, Get, Params, Res } from "routing-controllers";
import { Configurations } from "../entity/Configurations";
import { Form } from "../entity/Form";
import {
  formTypes,
  InvoiceParams,
  originalFormTypes,
  ResponseStatus,
  // UserPermissions,
} from "../types";
import { APIError } from "../utils/APIError";
// import ejs from 'ejs';
import logger from "../utils/logger";
import { Repository, getConnection } from "typeorm";
import date from "date-and-time";
import { Response } from "express";
import path from "path";
import { sendFormEmail } from "../utils/htmlTemplateUtil";
// import {create} from "html-pdf";

@Controller("/invoice")
export class InvoiceController {
  @Get("/:id/:uuid")
  // @ts-ignore: Unreachable code error
  async generateInvoice(
    @Res() res: Response,
    @Params()
    { id, uuid }: InvoiceParams
  ) {
    try {
      const conn = getConnection();
      const today = date.format(new Date(), "YYYY-MM-DD");
      const formRepository: Repository<Form> = conn.getRepository(Form);
      const formRecord: Form | undefined = await formRepository.findOne(id, {
        relations: ["formToServices", "formToServices.service"],
      });

      // @ts-ignore: Unreachable code error
      if (
        formRecord &&
        uuid &&
        formRecord.type.toLocaleLowerCase() === formTypes.form
      ) {
        const configRepo: Repository<Configurations> =
          conn.getRepository(Configurations);
        const configRecord = await configRepo.find();

        let products: any = [];

        // security check
        if (formRecord.invoiceUuid !== uuid) {
          return res.render(
            path.join(
              __dirname,
              "/../../public/views/",
              "invoice_unauthorized.ejs"
            )
          );
        }

        formRecord.formToServices.map((element) => {
          let obj = {
            quantity: 1,
            description: element.service.serviceName,
            price: +element.price,
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
            gst_no: taxDetails,
          },
          client: {
            name: formRecord.customerName,
            email: formRecord.customerEmail,
            address: formRecord.customerAddress,
            zip: formRecord.customerPostalCode,
            city: formRecord.customerCity,
            country: formRecord.customerCountry,
          },
          information: {
            invoice_number: formRecord.invoiceNumber,
            date: today,
            total: formRecord.final_amount,
            sub_total: formRecord.total,
            discount: formRecord.discount,
            tax: formRecord.is_taxable,
            comment: formRecord.comment,
          },
          products: products,
          // "bottom-notice": "Kindly pay your invoice within 15 days.",
          // Settings to customize your invoice
          settings: {
            currency: "CAD",
            "tax-notation": "gst",
          },
        };

        return res.render(
          path.join(__dirname, "/../../public/views/", "invoice.ejs"),
          {
            ...data,
            img_path: `/api/assets/logo.png`,
          }
        );
      } else {
        console.log("CANNOT FIND");
        return res.status(ResponseStatus.API_ERROR).send({
          status: false,
          message: "Could not find form record with given id",
        });
      }
    } catch (error) {
      console.log(error);
      logger.log(error.message);
      return new APIError(error.message, ResponseStatus.API_ERROR);
    }
  }

  @Get("/mark-as-invoice/:id/:uuid")
  async convertQuoteToInvoice(
    @Res() res: Response,
    @Params()
    { id, uuid }: InvoiceParams
  ) {
    try {
      const formRepository: Repository<Form> =
        getConnection().getRepository(Form);
      const formRecord: Form | undefined = await formRepository.findOne({
        where: {
          formId: id,
          invoiceUuid: uuid,
        },
      });

      if (formRecord) {
        formRecord.type = originalFormTypes.form;
        formRecord.createdAt = new Date(Date.now());
        await formRepository.save(formRecord);
        await sendFormEmail(formRecord);
        return res.status(ResponseStatus.SUCCESS_UPDATE).send({
          status: true,
          message: "Successfully converted quote to invoice",
        });
      }
      return res.status(ResponseStatus.FAILED_UPDATE).send({
        status: false,
        message: "Could not find form record!",
      });
    } catch (error) {
      throw new APIError(error.message, ResponseStatus.API_ERROR);
    }
  }
}
