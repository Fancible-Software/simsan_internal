import { Response } from "express";
import { Body, Controller, Get, Post, Res } from "routing-controllers";
import { Service } from "src/entity/Services";
import { ResponseStatus, ServiceType } from "src/types";
import { APIError } from "src/utils/APIError";
import logger from "src/utils/logger";
import { getConnection, QueryRunner, Repository } from "typeorm";

@Controller("/services")
export class ServicesController{
    @Get("/all")
    async getAllServices(
        @Res() res : Response
    ){
        try{
            const serviceRepository : Repository<Service> = getConnection().getRepository(Service);
            const services : Service[] = await serviceRepository.find({
                where : {
                    isActive : 1
                }
            });
            return res.status(200).send({
                status : true,
                message : "Services Fetched !",
                data : {
                    total : services.length,
                    rows : services
                }
            });
        }
        catch (err) {
            console.log(err.message);
            logger.error(err);
            return new APIError(err.message,500);
        }
    }

    @Post("/create")
    async createService(
        @Res() res : Response,
        @Body() body : ServiceType 
    ){
        try{
            const serviceRepository : Repository<Service> = getConnection().getRepository(Service);
            const queryRunner : QueryRunner = getConnection().createQueryRunner();
            const isExisting : Service[] = await serviceRepository.find({
                where : {
                    serviceName : body.serviceName
                }
            });

            if(isExisting.length > 0){
                return res.status(ResponseStatus.ALREADY_EXISTS).send({
                    status : false,
                    message : "Service with similar name already exists"
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
        catch (err){
            console.log(err.message);
            logger.error(err);
            return new APIError(err.message,ResponseStatus.API_ERROR);
        }
    }
}