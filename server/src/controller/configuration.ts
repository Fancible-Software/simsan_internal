import { Authorized, Body, Controller, Get, Params, Post, Res } from "routing-controllers";
import logger from "../utils/logger";
import { UserPermissions, ResponseStatus, SkipLimitURLParams, ConfigurationParams } from "../types";
import { APIError } from "../utils/APIError";
import { getConnection, Repository } from "typeorm";
import { Configurations } from "../entity/Configurations";
import { Response } from "express";

@Controller("/confiuration")
export class ConfigurationController {

    @Authorized(UserPermissions.admin)
    @Get("/all/:skip/:limit")
    async getAllSettings(
        @Params()
        { skip, limit }: SkipLimitURLParams,
        @Res() res: Response
    ) {
        try {
            const configRepository: Repository<Configurations> = getConnection().getRepository(Configurations)
            const settings: Configurations[] = await configRepository.find({
                order: {

                },
                skip: +skip,
                take: +limit
            })
            const formCount = await configRepository.count()
            return res.status(ResponseStatus.SUCCESS_FETCH).send({
                status: true,
                count: formCount,
                data: settings
            })
        }
        catch (error) {
            logger.log(error.message)
            return new APIError(error.message, ResponseStatus.API_ERROR);

        }
    }

    @Authorized(UserPermissions.admin)
    @Post("/create")
    async createSettings(
        @Body()
        body: ConfigurationParams,
        @Res() res: Response
    ) {
        try {

        }
        catch (error) {
            logger.log(error.message)
        }
    }

    @Authorized(UserPermissions.admin)
    @Post('/upload/image')
    async uploadImage() {
        
    }
}