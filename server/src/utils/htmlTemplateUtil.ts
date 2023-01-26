import * as ejs from 'ejs';
import path from 'path';
import { Configurations } from '../entity/Configurations';
import { Form } from '../entity/Form';
import { EmailDays, formTypes, ResponseStatus } from '../types';
import { getConnection, Repository } from 'typeorm';
import { APIError } from './APIError';
import logger from './logger';
import date from "date-and-time";

export const getInvoiceHtml = async (formId : number , formUUID : string) => {
    try {
        const today = date.format(new Date(), "YYYY-MM-DD");
        const formRepository: Repository<Form> =
          getConnection().getRepository(Form);
        const formRecord: Form | undefined = await formRepository.findOne(formId, {
          relations: ["formToServices", "formToServices.service"],
        });
  
        // @ts-ignore: Unreachable code error
        if (formRecord && formUUID) {
          // console.log(formRecord)
          const configRepo: Repository<Configurations> =
            getConnection().getRepository(Configurations);
          const configRecord = await configRepo.find();
          // console.log(configRecord)
          const invoiceNumber = Date.now();
  
          let products: any = [];
  
          // security check
          if (formRecord.invoiceUuid !== formUUID) {
            return ejs.renderFile(
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
              gst_no: taxDetails,
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
              tax: formRecord.is_taxable,
            },
            products: products,
            // "bottom-notice": "Kindly pay your invoice within 15 days.",
            // Settings to customize your invoice
            settings: {
              currency: "CAD",
              "tax-notation": "gst",
            },
          };
          console.log("rendering html");
          return ejs.renderFile(
            path.join(__dirname, "/../../public/views/", formRecord.type.toLocaleLowerCase() === formTypes.form ? "invoiceEmail.ejs" : "quoteEmail.ejs"),
            {
              ...data,
              img_path: `${process.env.BACKEND_URI}/assets/logo.png`,
            }
          );
        } else {
          return new APIError("No invoice found", ResponseStatus.API_ERROR);
        }
      } catch (error) {
        console.log(error);
        logger.log(error.message);
        return new APIError(error.message, ResponseStatus.API_ERROR);
      }
}

export const getPromotionalEmailHtml = (day : EmailDays)=>{
  let emailPath = "genericEmail.ejs";
  if(day === EmailDays.CanadaDay) emailPath = "canadaDayEmail.ejs";
  else if(day === EmailDays.Christmas) emailPath = "christmasEmail.ejs";
  else if(day === EmailDays.Thanksgiving) emailPath = "thanksgivingEmail.ejs";
  else if(day === EmailDays.Summer) emailPath = "summerEmail.ejs";
  else if(day === EmailDays.Winter) emailPath = "winterEmail.ejs";
  else emailPath = "genericEmail.ejs";

  return ejs.renderFile(path.join(__dirname, "/../../public/views/", emailPath));
}

export const getPromotiomalEmailSubject = (day : EmailDays)=>{
  let emailSubject= "Need some maintenance at home ?";
  if(day === EmailDays.CanadaDay) emailSubject = "A very happy Canada Day !";
  else if(day === EmailDays.Christmas) emailSubject = "Wishing you Merry Christmas and a very happy new year";
  else if(day === EmailDays.Thanksgiving) emailSubject = "This Thanksgiving, let's give your home a cleanup !";
  else if(day === EmailDays.Summer) emailSubject = "Summer is here. Don't miss out on offers ! ";
  else if(day === EmailDays.Winter) emailSubject = "Winter is here. Don't miss out on offers !";
  else emailSubject = "Need some maintenance at home ?";

  return emailSubject;
}