import { Body, Controller, Param, Put, Res } from "routing-controllers";
import { Post, Get } from "routing-controllers";
import {
  CompanyRegisterRequest,
  CompanyUpdateRequest,
  ResponseStatus,
} from "../types";
import { getConnection } from "typeorm";
import { Company } from "../entity/Company";
import { Response } from "express";
import logger from "../utils/logger";
import { APIError } from "../utils/APIError";
import { User } from "../entity/User";

@Controller("/company")
export class CompanyController {
  /**
   * @param body {CompanyRegisterRequest} : Request body
   * @param res {Response} : ExpressJs Response object
   * @returns
   */
  @Post("/create")
  async createCompany(
    @Body()
    body: CompanyRegisterRequest,
    @Res() res: Response
  ) {
    const queryRunner = getConnection().createQueryRunner();

    try {
      await queryRunner.startTransaction();
      const companyRepository = getConnection().getRepository(Company);

      const registeredCompany = await companyRepository.findOne({
        governmentBusinessId: body.governmentBusinessId,
      });

      // If a company was already registered for given governmentBusinessId return companyId

      if (registeredCompany) {
        return res.status(ResponseStatus.SUCCESS_UPDATE).send({
          status: false,
          message: "A company already exists with given Government Business Id",
          data: {
            companyId: registeredCompany.companyId,
            is_existing: true,
          },
        });
      }

      const companyDetails = await queryRunner.manager.save(body.toCompany());

      const userRepo = getConnection().getRepository(User);

      const registeredUser = await userRepo.findOne({
        where: [{ mobile_no: body.mobile_no }, { email: body.email }],
      });

      if (registeredUser) {
        let message = "";
        if (registeredUser.mobile_no === body.mobile_no) {
          message = "Mobile already registered!";
        }
        if (registeredUser.email === body.email) {
          message = "Email already registered!";
        }
        return res.status(ResponseStatus.SUCCESS_UPDATE).send({
          status: false,
          message,
        });
      }

      await queryRunner.manager.save(body.toUser(companyDetails.companyId));
      await queryRunner.commitTransaction();
      // else register a new Company and return companyId
      return res.status(ResponseStatus.SUCCESS_UPDATE).send({
        status: true,
        message: "Successfully registered Company",
        data: {
          companyId: companyDetails.companyId,
          is_existing: false,
        },
      });
    } catch (err) {
      logger.error(err.message);
      queryRunner.rollbackTransaction();
      return new APIError(err.message, ResponseStatus.API_ERROR);
    }
  }

  /**
   * @param res {Response} : ExpressJs response object
   * @param body {CompanyUpdateRequest} : request body of type CompanyUpdateRequest
   * @returns
   */
  @Put("/update")
  async updateCompany(
    @Res() res: Response,
    @Body() body: CompanyUpdateRequest
  ) {
    try {
      let companyRepository = getConnection().getRepository(Company);

      let registeredCompany = await companyRepository.findOneOrFail({
        companyId: body.companyId,
      });

      registeredCompany = await companyRepository.save(body.toCompany());

      return res.status(ResponseStatus.SUCCESS_UPDATE).json({
        status: true,
        message: "Succesfully updated Company record",
        data: registeredCompany,
      });
    } catch (err) {
      logger.error(err.message);
      return new APIError(err.message, ResponseStatus.API_ERROR);
    }
  }

  /**
   * @param id {number} : CompanyId
   * @param res {Response} : ExpressJs response object
   * @returns
   */
  @Get("/:id")
  async getCompany(@Param("id") id: number, @Res() res: Response) {
    try {
      const companyRepository = getConnection().getRepository(Company);

      let registeredCompany = await companyRepository.findOne({
        companyId: id,
      });

      if (registeredCompany)
        return res.status(ResponseStatus.SUCCESS_FETCH).json({
          status: true,
          message: "Succesfully fetched company information",
          data: registeredCompany,
        });
      else
        return res.status(ResponseStatus.API_ERROR).json({
          status: false,
          message: "No Company found for given id",
          data: null,
        });
    } catch (err) {
      logger.error(err.message);
      return new APIError(err.message, ResponseStatus.API_ERROR);
    }
  }
}
