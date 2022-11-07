import { Response } from "express";
import { Authorized, Body, Controller, Delete, Get, Params, Post, Put, Res } from "routing-controllers";
import { Service } from "../entity/Services";
import { EntityId, ResponseStatus, ServiceType, UserPermissions } from "../types";
import { APIError } from "../utils/APIError";
import logger from "../utils/logger";
import { getConnection, QueryRunner, Repository } from "typeorm";

@Controller("/services")
export class ServicesController {
    @Authorized(UserPermissions.sub_admin)
    @Get("/:id")
    async getServiceById(
        @Res() res: Response,
        @Params() { id }: EntityId
    ) {
        try {
            const serviceRepository: Repository<Service> = getConnection().getRepository(Service);
            const serviceObj: Service | undefined = await serviceRepository.findOne(id);

            if (serviceObj) {
                return res.status(ResponseStatus.SUCCESS_FETCH).send({
                    status: true,
                    data: serviceObj
                })
            } else {
                return res.status(ResponseStatus.API_ERROR).send({
                    status: false,
                    message: "Service with provided id does not exist"
                })
            }
        }
        catch (err) {
            console.log(err.message);
            logger.error(err);
            return new APIError(err.message, 500);
        }
    }



    @Authorized(UserPermissions.sub_admin)
    @Get("/all")
    async getAllServices(
        @Res() res: Response
    ) {
        try {
            const serviceRepository: Repository<Service> = getConnection().getRepository(Service);
            const services: Service[] = await serviceRepository.find({
                where: {
                    isActive: 1
                }
            });
            return res.status(200).send({
                status: true,
                message: "Services Fetched !",
                data: {
                    total: services.length,
                    rows: services
                }
            });
        }
        catch (err) {
            console.log(err.message);
            logger.error(err);
            return new APIError(err.message, 500);
        }
    }

    @Authorized(UserPermissions.admin)
    @Put("/update")
    async updateService(
        @Res() res: Response,
        @Params() { id }: EntityId,
        @Body() body: ServiceType
    ) {
        try {
            const serviceRepository: Repository<Service> = getConnection().getRepository(Service);
            const queryRunner: QueryRunner = getConnection().createQueryRunner();
            const serviceObj: Service | undefined = await serviceRepository.findOne(id);
            if (serviceObj) {
                serviceObj.serviceName = body.serviceName;
                serviceObj.price = body.price;
                queryRunner.manager.save(serviceObj);
                return res.status(ResponseStatus.SUCCESS_UPDATE).send({
                    status: true,
                    message: "Service successfully updated"
                })
            } else {
                return res.status(ResponseStatus.API_ERROR).send({
                    status: false,
                    message: "Service with provided id does not exist"
                })
            }
        }
        catch (err) {
            console.log(err.message);
            logger.error(err);
            return new APIError(err.message, 500);
        }
    }

    @Authorized(UserPermissions.admin)
    @Delete("/:id")
    async deleteService(
        @Res() res: Response,
        @Params() { id }: EntityId
    ) {
        try {
            const serviceRepository: Repository<Service> = getConnection().getRepository(Service);
            const queryRunner: QueryRunner = getConnection().createQueryRunner();
            const serviceObj: Service | undefined = await serviceRepository.findOne(id);

            if (serviceObj) {
                queryRunner.manager.remove(serviceObj);
                return res.status(ResponseStatus.SUCCESS_UPDATE).send({
                    status: true,
                    message: "Service successfully deleted"
                })
            } else {
                return res.status(ResponseStatus.API_ERROR).send({
                    status: false,
                    message: "Service with provided id does not exist"
                })
            }
        }
        catch (err) {
            console.log(err.message);
            logger.error(err);
            return new APIError(err.message, ResponseStatus.API_ERROR);
        }
    }

    @Authorized(UserPermissions.admin)
    @Post("/create")
    async createService(
        @Res() res: Response,
        @Body() body: ServiceType
    ) {
        try {
            const serviceRepository: Repository<Service> = getConnection().getRepository(Service);
            const queryRunner: QueryRunner = getConnection().createQueryRunner();
            const isExisting: Service[] = await serviceRepository.find({
                where: {
                    serviceName: body.serviceName
                }
            });

            if (isExisting.length > 0) {
                return res.status(ResponseStatus.ALREADY_EXISTS).send({
                    status: false,
                    message: "Service with similar name already exists"
                })
            }

            let service = new Service();
            service.price = body.price;
            service.serviceName = body.serviceName;

            await queryRunner.manager.save(service);

            return res.status(ResponseStatus.SUCCESS_UPDATE).send({
                status: true,
                message: "User created successfully!"
            });
        }
        catch (err) {
            console.log(err.message);
            logger.error(err);
            return new APIError(err.message, ResponseStatus.API_ERROR);
        }
    }
}