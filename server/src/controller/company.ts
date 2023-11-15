import { Body, Controller } from "routing-controllers";
import { Post, Get } from "routing-controllers";
import { companyRegisterRequest } from "../types";
// import { Response } from "express";

@Controller("/company")
export class CompanyController {
  @Post("/test")
  async addCompany(
    @Body()
    body: companyRegisterRequest
  ) {
    console.log(body);
    return true;
  }

  @Get("/test")
  async company() {
    console.log("testing");
    return true;
  }
}
