import {
  Authorized,
  Body,
  Controller,
  Get,
  Params,
  Post,
  Res,
  CurrentUser,
  UploadedFile,
  Put,
} from "routing-controllers";
import logger from "../utils/logger";
import {
  UserPermissions,
  ResponseStatus,
  SkipLimitURLParams,
  ConfigurationParams,
  EntityId,
  UpdateConfigurationRequest,
} from "../types";
import { APIError } from "../utils/APIError";
import { getConnection, QueryRunner, Repository } from "typeorm";
import { Configurations } from "../entity/Configurations";
import { Response } from "express";
import { User } from "../entity/User";
import { fileUploadOptions } from "../utils/fileUploadOptions";
import { removeFile } from "../utils/removeFile";

@Controller("/configuration")
export class ConfigurationController {
  @Authorized(UserPermissions.admin)
  @Get("/all/:skip/:limit")
  async getAllSettings(
    @Params()
    { skip, limit }: SkipLimitURLParams,
    @Res() res: Response
  ) {
    try {
      const configRepository: Repository<Configurations> =
        getConnection().getRepository(Configurations);
      const settings: Configurations[] = await configRepository.find({
        order: {},
        skip: +skip,
        take: +limit,
      });
      const configCount = await configRepository.count();
      return res.status(ResponseStatus.SUCCESS_FETCH).send({
        status: true,
        count: configCount,
        data: settings,
      });
    } catch (error) {
      logger.log(error.message);
      return new APIError(error.message, ResponseStatus.API_ERROR);
    }
  }

  @Authorized(UserPermissions.admin)
  @Post("/create")
  async createSettings(
    @Body()
    body: ConfigurationParams,
    @CurrentUser() user: User,
    @Res() res: Response
  ) {
    try {
      const queryRunner: QueryRunner = getConnection().createQueryRunner();
      const configRepository: Repository<Configurations> =
        getConnection().getRepository(Configurations);
      const ifConfigExist = await configRepository.count({
        where: {
          key: body.key.toLowerCase(),
        },
      });

      if (ifConfigExist) {
        return res.status(ResponseStatus.ALREADY_EXISTS).send({
          status: true,
          message: "",
        });
      }

      const newConfigRecord: Configurations = body.toConfiguration(
        user.id.toString()
      );
      await queryRunner.manager.save(newConfigRecord);

      return res.status(ResponseStatus.SUCCESS_UPDATE).send({
        status: true,
        messsage: "Successfully created configuration record",
      });
    } catch (error) {
      logger.log(error.message);
      return new APIError(error.message, ResponseStatus.API_ERROR);
    }
  }

  @Authorized(UserPermissions.admin)
  @Post("/upload/image")
  async uploadImage(
    @UploadedFile("file", {
      required: true,
      options: fileUploadOptions,
    })
    file: Express.Multer.File,
    @Res() res: Response
  ) {
    try {
      return res.status(ResponseStatus.SUCCESS_FETCH).send({
        status: true,
        message: "File uploaded successfully!",
        data: {
          file_name: file.filename,
        },
      });
    } catch (err) {
      await removeFile(file.path);
      return new APIError(err.message, ResponseStatus.API_ERROR);
    }
  }

  @Authorized(UserPermissions.admin)
  @Get("/:id")
  async getDetail(@Params() { id }: EntityId, @Res() res: Response) {
    try {
      const configRepository: Repository<Configurations> =
        getConnection().getRepository(Configurations);
      const configObj: Configurations | undefined =
        await configRepository.findOne(id);

      if (configObj) {
        return res.status(ResponseStatus.SUCCESS_FETCH).send({
          status: true,
          data: configObj,
        });
      } else {
        return res.status(ResponseStatus.API_ERROR).send({
          status: false,
          message: "Service with provided id does not exist",
        });
      }
    } catch (error) {
      logger.log(error.message);
      return new APIError(error.message, ResponseStatus.API_ERROR);
    }
  }

  @Authorized(UserPermissions.admin)
  @Put("/update")
  async updateConfig(
    @Body()
    body: UpdateConfigurationRequest,
    @Res() res: Response
  ) {
    try {
      const queryRunner: QueryRunner = getConnection().createQueryRunner();
      const newConfigRecord: Configurations = body.toConfiguration();
      await queryRunner.manager.save(newConfigRecord);

      return res.status(ResponseStatus.SUCCESS_UPDATE).send({
        status: true,
        messsage: "Successfully updated configuration record",
      });
    } catch (error) {
      throw new APIError(error.message, ResponseStatus.API_ERROR);
    }
  }
}
