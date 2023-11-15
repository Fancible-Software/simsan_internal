import { config } from "dotenv-safe";
config();

import express, { Request } from "express";
import actuator from "express-actuator";
import jwt, { TokenExpiredError } from "jsonwebtoken";
import morgan from "morgan";
import path from "path";
import { Action, useExpressServer } from "routing-controllers";
import { getConnection } from "typeorm";
import { AdminController } from "./controller/admin";
import { AuthController } from "./controller/auth";
import { ConfigurationController } from "./controller/configuration";
import { DashboardController } from "./controller/dashboard";
import { EmailController } from "./controller/EmailController";
import { FormController } from "./controller/forms";
import { InvoiceController } from "./controller/invoice";
import { LocationController } from "./controller/location";
import { QuoteController } from "./controller/quote";
import { ServicesController } from "./controller/services";
import { UserController } from "./controller/user";
import { User } from "./entity/User";
import { CustomErrorHandler } from "./middleware/errorHandler";
import { TokenData } from "./types";
import { APIError } from "./utils/APIError";
import { createDbConnection } from "./utils/createDbConnection";
import logger from "./utils/logger";
import { CompanyController } from "./controller/company";

async function run() {
  try {
    await createDbConnection();

    const app = express();
    app.all("/*", (req, res, next) => {
      const allowedDomains = process.env.CORS_DOMAINS.split(",");
      if (allowedDomains.includes(req.headers.origin || "")) {
        res.header("Access-Control-Allow-Origin", req.headers.origin || "");
      }
      res.header("Access-Control-Allow-Methods", "GET,PUT,POST,DELETE,PATCH");
      res.header("Access-Control-Allow-Headers", "*");

      next();
    });

    app.use(express.json());
    app.use(express.urlencoded({ extended: true }));
    app.use(express.static(path.join(__dirname, "../public")));

    app.use(
      morgan("combined", {
        stream: {
          write(text: string) {
            logger.info(text);
          },
        },
      })
    );
    app.use(actuator());

    useExpressServer(app, {
      cors: {
        origin: process.env.CORS_DOMAINS?.split(","),
        credentials: true,
      },
      defaultErrorHandler: false,
      controllers: [
        UserController,
        AuthController,
        AdminController,
        ServicesController,
        FormController,
        LocationController,
        ConfigurationController,
        DashboardController,
        InvoiceController,
        EmailController,
        QuoteController,
        CompanyController,
      ],
      middlewares: [CustomErrorHandler],
      authorizationChecker: (action: Action): boolean => {
        const { authorization } = (action.request as Request).headers || {};
        const { token: queryToken } = (action.request as Request).query || {};

        if (!authorization && typeof queryToken !== "string") return false;
        let token = authorization?.split("Bearer ")[1];
        if (!token) token = queryToken as string;
        if (!token) return false;

        try {
          const userData = jwt.verify(
            token,
            process.env.JWT_SECRET
          ) as TokenData;
          if (!userData) return false;
        } catch (error) {
          if (error instanceof TokenExpiredError) {
            throw new APIError("JWT expired", 401);
          } else {
            throw new APIError("Something went wrong", 500);
          }
        }
        return true;
      },
      currentUserChecker: (action: Action) => {
        const { authorization } = (action.request as Request).headers || {};
        const { token: queryToken } = (action.request as Request).query || {};

        if (!authorization && typeof queryToken !== "string") return;
        let token = authorization?.split("Bearer ")[1];
        if (!token) token = queryToken as string;
        if (!token) return;

        try {
          const userData = jwt.verify(
            token,
            process.env.JWT_SECRET
          ) as TokenData;
          if (!userData) return;
          // console.log(userData);
          return getConnection()
            .getRepository(User)
            .findOne({ email: userData.email });
        } catch (error) {
          if (error instanceof TokenExpiredError) {
            throw new APIError("JWT expired", 401);
          } else {
            throw new APIError("Something went wrong", 500);
          }
        }
      },
    });

    let port = process.env.PORT ? +process.env.PORT : NaN;
    port = isNaN(port) ? 4000 : port;
    app.listen(port, () => {
      logger.info(`env is ${process.env.NODE_ENV}`);
      logger.info(`Listening on http://localhost:${port}`);
    });
  } catch (error) {
    console.log(error);
    logger.error(error);
    process.exit(1);
  }
}

run();
