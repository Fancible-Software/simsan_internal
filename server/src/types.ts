import { IsEmail, IsNotEmpty, IsString, IsNumber, Matches, IsNotIn, IsBoolean } from 'class-validator';
import { Configurations } from './entity/Configurations';
import { Form } from './entity/Form';
import { FormToServices } from './entity/FormToServices';
import { Service } from './entity/Services';

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

  @IsString()
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

  @IsNumber()
  isActive: string
}

export class FormToServiceType {
  serviceId: number;

  @IsNotEmpty()
  @IsString()
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

  @IsString()
  @IsNotEmpty()
  total: string;

  @IsString()
  @IsNotEmpty()
  final_amount: string;

  @IsString()
  discount: string;

  @IsString()
  discount_percent: string;

  @IsNotEmpty()
  services: FormToServiceType[];

  @IsBoolean()
  @IsNotEmpty()
  is_taxable: boolean;



  public toForm(userId: string): Form {
    const form: Form = new Form();
    form.customerName = this.customerName;
    form.customerEmail = this.customerEmail;
    form.customerAddress = this.customerAddress;
    form.customerCity = this.customerCity;
    form.customerCountry = this.customerCountry;
    form.customerPostalCode = this.customerPostalCode;
    form.customerPhone = this.customerPhone;
    form.customerProvince = this.customerProvince;
    form.discount = this.discount ? this.discount : '0';
    form.total = this.total;
    form.is_taxable = this.is_taxable
    form.final_amount = this.final_amount;
    form.discount_percent = this.discount_percent
    form.createdBy = userId
    form.formToServices = this.services.map((s: FormToServiceType) => {
      let obj: FormToServices = new FormToServices();
      obj.service = new Service();
      obj.service.serviceId = s.serviceId;
      obj.price = s.price;
      return obj;
    });
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


export class CityParams {
  @IsNotEmpty()
  province_id: string;
}

export class ConfigurationParams {
  @IsString()
  key: string;

  @IsString()
  value: string

  @IsBoolean()
  isImage: Boolean

  public toConfiguration(userId: string): Configurations {
    const config: Configurations = new Configurations()
    config.key = this.key.toLowerCase();
    config.value = this.value
    config.isImage = this.isImage
    config.createdBy = userId
    return config
  }
}

export class invoiceResp {
  path: string
  invoice_id: string
}

export enum tokenType {
  otp = "otp",
  forget_pwd = "forget_pwd"
}

export class verificationRequest {
  @IsString()
  @IsNotEmpty()
  type: string;

  @IsString()
  @IsNotEmpty()
  otp: string;

}

export class ResendOtpRequest {

  @IsString()
  @IsNotEmpty()
  type: string;

}

