import { Controller, Res, Get, Authorized } from "routing-controllers";
import { APIError } from "../utils/APIError";
import { ResponseStatus, UserPermissions } from "../types";
import { getConnection } from "typeorm";
import { Service } from "../entity/Services";
import { Response } from "express";
import { Form } from "../entity/Form";
import { User } from "../entity/User";
import DateAndTime from "date-and-time";

@Controller("/dashboard")
export class DashboardController {
  @Authorized(UserPermissions.admin || UserPermissions.sub_admin)
  @Get("/count")
  async users(@Res() res: Response) {
    try {
      const servicesRepo = getConnection().getRepository(Service);
      const serviceCount = await servicesRepo.count({ where: { isActive: 1 } });

      const feedbackRepo = getConnection().getRepository(Form);
      const feedbackCount = await feedbackRepo.count({
        where: { type: "FORM" },
      });

      const adminRepo = getConnection().getRepository(User);
      const adminCount = await adminRepo.count({
        where: { is_verified: true },
      });

      const { sum } = await feedbackRepo
        .createQueryBuilder("form")
        .where({ type: "FORM" })
        .select("SUM(CAST(form.final_amount AS DECIMAL))", "sum")
        .getRawOne();
      return res.status(ResponseStatus.SUCCESS_FETCH).send({
        status: true,
        message: "Count fetched successfully!!",
        data: {
          active_services_count: serviceCount,
          feedback_count: feedbackCount,
          revenue_count: sum,
          verified_admin_count: adminCount,
        },
      });
    } catch (error) {
      throw new APIError(error.message, ResponseStatus.API_ERROR);
    }
  }

  @Authorized(UserPermissions.admin)
  @Get("/graph")
  async graph(@Res() res: Response) {
    try {
      let today = new Date();
      today = new Date(today.setMonth(today.getMonth() - 1));
      let formattedDate = DateAndTime.format(today, "DD-MM-YYYY");

      const feedbackRepo = getConnection().getRepository(Form);
      const feedbackResult = await feedbackRepo
        .createQueryBuilder("form")
        .select("COUNT(form.formId)", "x")
        .addSelect("to_char(form.createdAt,'DD-MM-YYYY')", "y")
        .groupBy("to_char(form.createdAt,'DD-MM-YYYY')")
        .andWhere("to_char(form.createdAt,'DD-MM-YYYY') >= :date", {
          date: formattedDate,
        })
        .getRawMany();

      return res.status(ResponseStatus.SUCCESS_FETCH).send({
        status: true,
        message: "Successfully fetched!",
        data: feedbackResult,
      });
    } catch (error) {
      throw new APIError(error.message, ResponseStatus.API_ERROR);
    }
  }
}
