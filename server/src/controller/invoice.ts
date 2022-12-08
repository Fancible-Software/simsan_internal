import { Controller, Get, Params, Res } from "routing-controllers";
import { Configurations } from "../entity/Configurations";
import { Form } from "../entity/Form";
import { InvoiceParams, ResponseStatus } from "../types";
import { APIError } from "../utils/APIError";
// import ejs from 'ejs';
import logger from "../utils/logger";
import { Repository, getConnection } from "typeorm";
import date from 'date-and-time';
import { Response } from "express";
import path from "path";
// import {create} from "html-pdf";

@Controller("/invoice")
export class InvoiceController{
    @Get("/:id/:uuid")
    // @ts-ignore: Unreachable code error
    async generateInvoice(
        @Res() res: Response,
        @Params()
        { id , uuid}: InvoiceParams
    ) {
        try {
            const today = date.format(new Date(), 'YYYY-MM-DD')
            const formRepository: Repository<Form> = getConnection().getRepository(Form);
            const formRecord: Form | undefined = await formRepository.findOne(id, {
                relations: ["formToServices", "formToServices.service"]
            });

            // @ts-ignore: Unreachable code error
            if (formRecord && uuid) {
                // console.log(formRecord)
                const configRepo: Repository<Configurations> = getConnection().getRepository(Configurations)
                const configRecord = await configRepo.find();
                // console.log(configRecord)
                const invoiceNumber = Date.now();

                let products: any = [];

                // security check
                if(formRecord.invoiceUuid !== uuid){
                    return res.render(path.join(__dirname, "/../../public/views/", "invoice_unauthorized.ejs"));
                }

                formRecord.formToServices.map(element => {
                    let obj = {
                        "quantity": 1,
                        "description": element.service.serviceName,
                        "price": +element.service.price,
                    }
                    products.push(obj)
                })

                let logoDetails = ""
                let taxDetails = ""
                let companyName = ""
                let companyAddress = ""
                let companyCity = ""
                let companyCountry = ""
                let companyZip = ""

                configRecord.filter(element => {
                    if (element.key === "logo") {
                        logoDetails = element.value
                    }
                    else if (element.key === "gst") {
                        taxDetails = element.value
                    }
                    else if (element.key === "company_name") {
                        companyName = element.value
                    }
                    else if (element.key === "company_address") {
                        companyAddress = element.value
                    }
                    else if (element.key === "company_city") {
                        companyCity = element.value
                    }
                    else if (element.key === "company_country") {
                        companyCountry = element.value
                    }
                    else if (element.key === "company_zip") {
                        companyZip = element.value
                    }
                })

                let data = {
                    "images": {
                        "logo": logoDetails
                    },
                    "company_details": {
                        "name": companyName,
                        "address": companyAddress,
                        "zip": companyZip,
                        "city": companyCity,
                        "country": companyCountry
                    },
                    "client": {
                        "name": formRecord.customerName,
                        "address": formRecord.customerAddress,
                        "zip": formRecord.customerPostalCode,
                        "city": formRecord.customerCity,
                        "country": formRecord.customerCountry
                    },
                    "information": {
                        "invoice_number": invoiceNumber,
                        "date": today,
                        "total": formRecord.final_amount,
                        "sub_total": formRecord.total,
                        "discount": formRecord.discount,
                        "tax": taxDetails
                    },
                    "products": products,
                    // "bottom-notice": "Kindly pay your invoice within 15 days.",
                    // Settings to customize your invoice
                    "settings": {
                        "currency": "CAD",
                        "tax-notation": "gst",
                    },
                };

                return res.render(path.join(__dirname, "/../../public/views/", "invoice.ejs"),{
                        ...data,
                        img_path : `http://localhost:4000/assets/logo.png`
                });

                // console.log(data);
                // console.log(path.join(__dirname, "/../../public/views/", "invoice.ejs"));
                // // Render ejs file into static html
                // let tempData : any = await ejs.renderFile(
                //     path.join(__dirname, "/../../public/views/", "invoice.ejs"),
                //     {
                //     ...data,
                //     img_path : `http://localhost:4000/download.jpeg`
                //     }
                // );
                // console.log("After");
            
                // // pdf conversion options
                // let pdfOptions = {
                //     border: "1cm",
                //     childProcessOptions: {
                //         env: {
                //           OPENSSL_CONF: '/dev/null',
                //         },
                //     }
                // };
            
                // // create pdf stream and pipe it to response
                // // @ts-ignore: Unreachable code error
                // create(tempData, pdfOptions).toBuffer((err : Error, buffer : any) => {
                //     if (err) {
                //         console.log("SOMETHING WRONG WITH FILE PDF",err);
                //         return res.send(err);
                //     }
                //     else{
                //         return res.end(buffer, 'binary');
                //     }
                    
                    
                    // if (err) {
                    //     // handle error and return a error response code
                    //     console.log("ERROR",err);
                    //     return res.status(500).json({
                    //         status: false,
                    //         message: "Error occured when converting html to pdf file",
                    //     });
                    // } else {
                    //     console.log("WE ARE HERE !");
                    //     // once we are done reading end the response
                    //     pdfStream.on("error",(err:any)=>{
                    //         console.log('STREAMERROR',err);
                    //     });

                    //     pdfStream.on("end", () => {
                    //         // done reading
                    //         res.end();
                    //     });
            
                    //     // pipe the contents of the PDF directly to the response
                    //     // res.attachment('invoice.pdf');
                    //     pdfStream.pipe(res);
                    // }
                // });
            } else {
                console.log("CANNOT FIND");
                return res.status(ResponseStatus.API_ERROR).send({
                    status: false,
                    message: "Could not find form record with given id"
                })
            }
        }
        catch (error) {
            console.log("OOPS");
            console.log(error);
            logger.log(error.message)
            return new APIError(error.message, ResponseStatus.API_ERROR)
        }
    }
}