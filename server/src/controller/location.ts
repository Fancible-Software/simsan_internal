import { Response } from "express";
import { Authorized, Controller, Get, Res } from "routing-controllers";
import { ResponseStatus, UserPermissions } from "../types";
import logger from "../utils/logger";
import { getConnection, Repository } from "typeorm";
import { Location } from "../entity/Location";
import { APIError } from "../utils/APIError";

@Controller("/location")
export class LocationController{

    @Get("/cities")
    @Authorized(UserPermissions.admin || UserPermissions.sub_admin)
    async getAllCities(
        @Res() res : Response
    ){
        try{
            const locationRepository : Repository<Location> = getConnection().getRepository(Location);
            const cities : Location[] = await locationRepository.createQueryBuilder("location")
            .select(["city","province_id"])
            .distinct(true)
            .getRawMany();

            return res.status(ResponseStatus.SUCCESS_FETCH).send({
                status: true,
                count : cities.length,
                data : cities
            })
        }
        catch (err){
            console.log(err.message);
            logger.error(err.message);
            return new APIError(err.message,ResponseStatus.API_ERROR);
        }
    }

    @Get("/provinces")
    @Authorized(UserPermissions.admin || UserPermissions.sub_admin)
    async getAllProvinces(
        @Res() res : Response
    ){
        try{
            const locationRepository : Repository<Location> = getConnection().getRepository(Location);
            const cities : Location[] = await locationRepository.createQueryBuilder("location")
            .select(["province_name","province_id"])
            .distinct(true)
            .getRawMany();

            return res.status(ResponseStatus.SUCCESS_FETCH).send({
                status: true,
                count : cities.length,
                data : cities
            })
        }
        catch (err){
            console.log(err.message);
            logger.error(err.message);
            return new APIError(err.message,ResponseStatus.API_ERROR);
        }
    }
}