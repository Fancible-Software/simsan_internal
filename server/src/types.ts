import { IsEmail, IsNotEmpty, IsString, IsNumber, Matches, IsNotIn } from 'class-validator';


export interface TokenData {
  email: string;
  roles: string
}

export enum UserPermissions {
  admin = "admin",
  sub_admin = "sub_admin"
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

  // @IsEnum(UserPermissions, { each: true })
  @IsString()
  @IsNotEmpty()
  roles: UserPermissions;

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
