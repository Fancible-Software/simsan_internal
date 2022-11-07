import { Response } from "express";
import { Body, Controller, Delete, Get, Params, Post, Put, Res } from "routing-controllers";
import { getConnection, QueryRunner, Repository } from "typeorm";
import { EntityId, FormType, ResponseStatus } from "../types";
import { Form } from "../entity/Form";
import logger from "../utils/logger";
import { APIError } from "../utils/APIError";

@Controller("/form")
export class FormController{
    @Get("/all")
    async getAllForms(
        @Res() res : Response
    ){
        try{
            const formRepository : Repository<Form> =  getConnection().getRepository(Form);
            const forms : Form[] = await formRepository.find();
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

    @Get("/:id")
    async getFormById(
        @Res() res : Response,
        @Params() { id } : EntityId
    ){
        try{
            const formRepository : Repository<Form> =  getConnection().getRepository(Form);
            const formRecord : Form | undefined = await formRepository.findOne(id);
            
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

    @Post("/create")
    async createForm(
        @Res() res : Response,
        @Body() body : FormType
    ){
        try{
            const queryRunner : QueryRunner = getConnection().createQueryRunner();
            queryRunner.manager.save(body.toForm());

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