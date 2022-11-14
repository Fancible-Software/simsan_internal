import { Response } from "express";
import { Authorized, Body, Controller, Delete, Get, Params, Post, Put, Res } from "routing-controllers";
import { getConnection, In, QueryRunner, Repository } from "typeorm";
import { EntityId, FormToServiceType, FormType, ResponseStatus, UserPermissions } from "../types";
import { Form } from "../entity/Form";
import logger from "../utils/logger";
import { APIError } from "../utils/APIError";
import { FormToServices } from "src/entity/FormToServices";
import { Service } from "../entity/Services";

@Controller("/form")
export class FormController{

    @Authorized(UserPermissions.admin || UserPermissions.sub_admin)
    @Get("/all")
    async getAllForms(
        @Res() res : Response
    ){
        try{
            const formRepository : Repository<Form> =  getConnection().getRepository(Form);
            const forms : Form[] = await formRepository.find({
                relations : ["formToServices","formToServices.service"]
            });

            return res.status(ResponseStatus.SUCCESS_FETCH).send({
                status: true,
                count : forms.length,
                data : forms
            })
        }
        catch (err){
            console.log(err.message);
            logger.error(err.message);
            return new APIError(err.message,ResponseStatus.API_ERROR);
        }
    }

    @Authorized(UserPermissions.admin || UserPermissions.sub_admin)
    @Get("/:id")
    async getFormById(
        @Res() res : Response,
        @Params() { id } : EntityId
    ){
        try{
            const formRepository : Repository<Form> =  getConnection().getRepository(Form);
            const formRecord : Form | undefined = await formRepository.findOne(id,{
                relations : ["formToServices"]
            });
            
            if(formRecord){
                return res.status(ResponseStatus.SUCCESS_UPDATE).send({
                    status: true,
                    data : formRecord
                }) 
            }else{
                return res.status(ResponseStatus.API_ERROR).send({
                    status: false,
                    message : "Could not find form record with given id"
                })
            } 
        }
        catch (err){
            console.log(err.message);
            logger.error(err.message);
            return new APIError(err.message,ResponseStatus.API_ERROR);
        }
    }

    @Authorized(UserPermissions.admin)
    @Post("/create")
    async createForm(
        @Res() res : Response,
        @Body() body : FormType
    ){
        try{
            const queryRunner : QueryRunner = getConnection().createQueryRunner();
            const serviceRepository : Repository<Service> =  getConnection().getRepository(Service);
            const services = await serviceRepository.find({
                where:{
                    serviceId : In(body.services.map((service : FormToServiceType)=> service.serviceId))
                }
            });
            const serviceMap : Map<number,Service> = new Map<number,Service>();
            services.forEach((service : Service)=>serviceMap.set(service.serviceId,service));
            const newFormRecord : Form = body.toForm();
            await queryRunner.manager.save(newFormRecord);
            await queryRunner.manager.save(newFormRecord.formToServices.map((service : FormToServices)=> {
                service.form = newFormRecord
                return service;
            }));

            return res.status(ResponseStatus.SUCCESS_UPDATE).send({
                status: true,
                messsage : "Successfully created form record"
            }) 
        }
        catch (err){
            console.log(err.message);
            logger.error(err.message);
            return new APIError(err.message,ResponseStatus.API_ERROR);
        }
    }

    @Authorized(UserPermissions.admin)
    @Put("/:id")
    async updateForm(
        @Res() res : Response,
        @Params() { id } : EntityId,
        @Body() body : FormType
    ){
        try{
            const formRepository : Repository<Form> =  getConnection().getRepository(Form);
            const queryRunner : QueryRunner = getConnection().createQueryRunner();
            const formRecord : Form | undefined = await formRepository.findOne(id);
            
            if(formRecord){
                queryRunner.manager.save(body.updateForm(formRecord));
                return res.status(ResponseStatus.SUCCESS_UPDATE).send({
                    status: true,
                    messsage : "Successfully updated form record"
                }) 
            }else{
                return res.status(ResponseStatus.API_ERROR).send({
                    status: false,
                    message : "Could not find form record with given id"
                })
            } 
        }
        catch (err){
            console.log(err.message);
            logger.error(err.message);
            return new APIError(err.message,ResponseStatus.API_ERROR);
        }
    }

    @Authorized(UserPermissions.admin)
    @Delete("/:id")
    async deleteFormById(
        @Res() res : Response,
        @Params() { id } : EntityId
    ){
        try{
            const formRepository : Repository<Form> =  getConnection().getRepository(Form);
            const queryRunner : QueryRunner = getConnection().createQueryRunner();
            const formRecord : Form | undefined = await formRepository.findOne(id);
            
            if(formRecord){
                queryRunner.manager.remove(formRecord);
                return res.status(ResponseStatus.SUCCESS_UPDATE).send({
                    status: true,
                    messsage : "Successfully deleted form record"
                }) 
            }else{
                return res.status(ResponseStatus.API_ERROR).send({
                    status: false,
                    message : "Could not find form record with given id"
                })
            } 
        }
        catch (err){
            console.log(err.message);
            logger.error(err.message);
            return new APIError(err.message,ResponseStatus.API_ERROR);
        }
    }
    
}