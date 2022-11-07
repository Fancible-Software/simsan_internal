import { IsEmail, IsNotEmpty, IsString, IsNumber, IsEnum, IsArray, Matches, IsNotIn } from 'class-validator';
import { Form } from './entity/Form';


export interface TokenData {
  email: string;
  roles: string
}

export enum UserPermissions {
  admin = "admin",
  sub_admin = "sub_admin"
}

export enum ResponseStatus {
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

export class ServiceType {
  @IsString()
  @IsNotEmpty()
  serviceName: string;

  @IsString()
  @IsNotEmpty()
  @Matches(/^\d+\.?\d*$/)
  price: string;
}

export class SkipLimitURLParams {
  @Matches(/^\d+$/)
  skip: string;

  @Matches(/^\d+$/)
  @IsNotIn(["0"])
  limit: string;
}

export class FormType {
  @IsNotEmpty()
  @IsString()
  customerName: string;

  @IsNotEmpty()
  @IsString()
  customerEmail: string;

  @IsNotEmpty()
  @IsString()
  customerPhone: string;

  @IsNotEmpty()
  @IsString()
  customerAddress: string;

  @IsNotEmpty()
  @IsString()
  customerPostalCode: string;

  @IsNotEmpty()
  @IsString()
  customerCity: string;

  @IsNotEmpty()
  @IsString()
  customerProvince: String;

  @IsString()
  customerCountry: string;

  public toForm(): Form {
    const form: Form = new Form();
    form.customerName = this.customerName;
    form.customerEmail = this.customerEmail;
    form.customerAddress = this.customerAddress;
    form.customerCity = this.customerCity;
    form.customerCountry = this.customerCountry;
    form.customerPostalCode = this.customerPostalCode;
    form.customerPhone = this.customerPhone;
    form.customerProvince = this.customerProvince;
    return form;
  }

  public updateForm(formRecord: Form): Form {
    formRecord.customerName = this.customerName;
    formRecord.customerEmail = this.customerEmail;
    formRecord.customerAddress = this.customerAddress;
    formRecord.customerCity = this.customerCity;
    formRecord.customerCountry = this.customerCountry;
    formRecord.customerPostalCode = this.customerPostalCode;
    formRecord.customerPhone = this.customerPhone;
    formRecord.customerProvince = this.customerProvince;
    return formRecord;
  }
}

export class EntityId {
  @IsNotEmpty()
  id: number | string;
}
