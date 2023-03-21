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
import { Service } from "../entity/Services";
import { User } from "../entity/User";
import {
  EntityId,
  ResponseStatus,
  ServiceType,
  UserPermissions,
  SkipLimitURLParams,
} from "../types";
import { APIError } from "../utils/APIError";
import logger from "../utils/logger";
import {
  getConnection,
  QueryRunner,
  Repository,
  Not,
  Connection,
} from "typeorm";

@Controller("/services")
export class ServicesController {
  @Authorized(UserPermissions.sub_admin)
  @Get("/service/:id")
  async getServiceById(@Res() res: Response, @Params() { id }: EntityId) {
    try {
      Connection;
      const serviceRepository: Repository<Service> =
        getConnection().getRepository(Service);
      const serviceObj: Service | undefined = await serviceRepository.findOne(
        id
      );

      if (serviceObj) {
        return res.status(ResponseStatus.SUCCESS_FETCH).send({
          status: true,
          data: serviceObj,
        });
      } else {
        return res.status(ResponseStatus.API_ERROR).send({
          status: false,
          message: "Service with provided id does not exist",
        });
      }
    } catch (err) {
      // console.log(err.message);
      logger.error(err);
      return new APIError(err.message, 500);
    }
  }

  // for admin listing - fetching all services (is Active flag removed)
  @Authorized(UserPermissions.sub_admin || UserPermissions.admin)
  @Get("/all/:skip/:limit")
  async getAllServices(
    @Params()
    { skip, limit }: SkipLimitURLParams,
    @Res() res: Response
  ) {
    try {
      const serviceRepository: Repository<Service> =
        getConnection().getRepository(Service);
      const services: Service[] = await serviceRepository.find({
        select: [
          "serviceId",
          "serviceName",
          "price",
          "isActive",
          "priority",
          "createdAt",
          "createdBy",
          "isDeleted",
        ],
        skip: +skip,
        take: +limit,
        order: {
          priority: "ASC",
        },
      });
      const total = await serviceRepository.count();
      return res.status(200).send({
        status: true,
        message: "Services Fetched !",
        data: {
          total: total,
          rows: services,
        },
      });
    } catch (err) {
      console.log(err.message);
      logger.error(err);
      return new APIError(err.message, 500);
    }
  }

  @Authorized(UserPermissions.admin)
  @Put("/update/:id")
  async updateService(
    @Res() res: Response,
    @Params() { id }: EntityId,
    @Body() body: ServiceType
  ) {
    try {
      const conn = getConnection();
      const serviceRepository: Repository<Service> =
        conn.getRepository(Service);

      const serviceObj: Service | undefined = await serviceRepository.findOne(
        id
      );
      if (serviceObj) {
        const uniqueService: Service[] | undefined =
          await serviceRepository.find({
            where: {
              serviceName: body.serviceName,
              serviceId: Not(id),
            },
          });
        if (uniqueService.length) {
          return res.status(ResponseStatus.ALREADY_EXISTS).send({
            status: false,
            message: "Service with this name already exist!",
          });
        }
        // console.log(serviceObj)
        serviceObj.serviceName = body.serviceName;
        serviceObj.price = body.price;
        serviceObj.isActive = +body.isActive;
        serviceObj.priority = body.priority;
        serviceRepository.save(serviceObj);
        return res.status(ResponseStatus.SUCCESS_UPDATE).send({
          status: true,
          message: "Service successfully updated",
        });
      } else {
        return res.status(ResponseStatus.API_ERROR).send({
          status: false,
          message: "Service with provided id does not exist",
        });
      }
    } catch (err) {
      logger.error(err);
      return new APIError(err.message, 500);
    }
  }

  @Authorized(UserPermissions.admin)
  @Delete("/:id")
  async deleteService(
    @Res() res: Response,
    @Params() { id }: EntityId,
    @CurrentUser() user: User
  ) {
    const conn = getConnection();
    const queryRunner: QueryRunner = conn.createQueryRunner();
    try {
      const serviceRepository: Repository<Service> =
        conn.getRepository(Service);
      const serviceObj: Service | undefined = await serviceRepository.findOne(
        id
      );

      if (serviceObj) {
        serviceObj.isDeleted = !serviceObj.isDeleted;
        serviceObj.deletedBy = user.email;
        await serviceRepository.update(
          { serviceId: serviceObj.serviceId },
          serviceObj
        );
        // await queryRunner.manager.remove(serviceObj);
        return res.status(ResponseStatus.SUCCESS_UPDATE).send({
          status: true,
          message: "Service successfully deleted",
        });
      } else {
        return res.status(ResponseStatus.API_ERROR).send({
          status: false,
          message: "Service with provided id does not exist",
        });
      }
    } catch (err) {
      console.log(err.message);
      logger.error(err);
      return new APIError(err.message, ResponseStatus.API_ERROR);
    } finally {
      await queryRunner.release();
    }
  }

  @Authorized(UserPermissions.admin)
  @Post("/create")
  async createService(
    @Res() res: Response,
    @Body() body: ServiceType,
    @CurrentUser() user: User
  ) {
    try {
      const conn = getConnection();
      const serviceRepository: Repository<Service> =
        conn.getRepository(Service);
      // const queryRunner: QueryRunner = getConnection().createQueryRunner();
      const isExisting: Service[] = await serviceRepository.find({
        where: {
          serviceName: body.serviceName,
        },
      });

      if (isExisting.length > 0) {
        return res.status(ResponseStatus.ALREADY_EXISTS).send({
          status: false,
          message: "Service with similar name already exists",
        });
      }

      let service = new Service();
      service.price = body.price;
      service.serviceName = body.serviceName;
      service.isActive = +body.isActive;
      service.createdBy = user.first_name + " " + user.last_name;
      service.priority = body.priority;

      await serviceRepository.save(service);

      return res.status(ResponseStatus.SUCCESS_UPDATE).send({
        status: true,
        message: "Service created successfully!",
      });
    } catch (err) {
      console.log(err.message);
      logger.error(err);
      return new APIError(err.message, ResponseStatus.API_ERROR);
    }
  }

  @Get("/all-services")
  async getServices(@Res() res: Response) {
    try {
      const serviceRepository: Repository<Service> =
        getConnection().getRepository(Service);
      const services: Service[] = await serviceRepository.find({
        select: ["serviceId", "serviceName", "price", "isActive"],
        where: {
          isActive: 1,
          isDeleted: false,
        },
        order: {
          priority: "ASC",
        },
      });
      const total = await serviceRepository.count({ isActive: 1 });
      return res.status(200).send({
        status: true,
        message: "Services Fetched !",
        data: {
          total: total,
          rows: services,
        },
      });
    } catch (err) {
      // console.log(err.message);
      logger.error(err);
      return new APIError(err.message, 500);
    }
  }
}
