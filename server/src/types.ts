import { IsEmail, IsNotEmpty, IsString, IsNumber, IsEnum, IsArray, Matches, IsNotIn, isString } from 'class-validator';


export interface TokenData {
  email: string;
  roles: UserPermissions[]
}

export enum UserPermissions {
  admin = "admin",
  read = "read",
  write = "write"
}

export enum ResponseStatus{
  ALREADY_EXISTS = 409,
  SUCCESS_FETCH = 200,
  SUCCESS_UPDATE = 201,
  FAILED_UPDATE = 400,
  API_ERROR = 500,
}

export class customerSigninRequest {

  @IsString()
  @IsEmail()
  @IsNotEmpty()
  email: string;

  @IsString()
  @IsNotEmpty()
  password: string;

}

export class customerSignupRequest {
  @IsNotEmpty()
  @IsString()
  first_name: string;

  @IsString()
  @IsNotEmpty()
  last_name: string;

  @IsString()
  @IsEmail()
  @IsNotEmpty()
  email: string;

  @IsNumber()
  @IsNotEmpty()
  mobile_no: string;

  @IsString()
  @IsNotEmpty()
  password: string;

  @IsEnum(UserPermissions, { each: true })
  @IsArray()
  roles: UserPermissions[];

}

export class ServiceType{
  @IsString()
  @IsNotEmpty()
  serviceName : string;

  @IsString()
  @IsNotEmpty()
  @Matches(/^\d+\.?\d*$/)
  price : string;
}

export class SkipLimitURLParams {
  @Matches(/^\d+$/)
  skip: string;

  @Matches(/^\d+$/)
  @IsNotIn(["0"])
  limit: string;
}
