import nodemailer, { SendMailOptions } from "nodemailer";
import logger from "./logger";

const transport = nodemailer.createTransport({
  port: 587,
  host: "smtp.gmail.com",
  secure: false,
  requireTLS: true,
  auth: {
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_PWD,
  },
});

export default async (opts: SendMailOptions) => {
  try {
    const resp = await transport.sendMail(opts);
    logger.info("mail resp: " + JSON.stringify(resp, null, 1));
    if (resp && resp.rejected?.length) {
      logger.error(resp);
    }
    // return resp;
  } catch (error) {
    console.error(error);
  }
};
