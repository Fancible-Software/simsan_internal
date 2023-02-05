import {
  Column,
  Entity,
  JoinColumn,
  ManyToOne,
  PrimaryGeneratedColumn,
} from "typeorm";
import { Form } from "./Form";
import { Service } from "./Services";

@Entity()
export class FormToServices {
  @PrimaryGeneratedColumn()
  id: number;

  @ManyToOne(() => Form, (formRecord: Form) => formRecord.formToServices)
  @JoinColumn({ name: "formId" })
  form: Form;

  @Column({ nullable: false })
  formId: number;

  @ManyToOne(() => Service, (service: Service) => service.formToServices)
  @JoinColumn({ name: "serviceId" })
  service: Service;

  @Column({ nullable: false })
  serviceId: number;

  @Column({ nullable: false })
  price: string;
}
