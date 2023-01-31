import {
  Column,
  CreateDateColumn,
  Entity,
  Generated,
  OneToMany,
  PrimaryGeneratedColumn,
  UpdateDateColumn,
} from "typeorm";
import { FormToServices } from "./FormToServices";
import { originalFormTypes } from "../types";
@Entity()
export class Form {
  @PrimaryGeneratedColumn()
  readonly formId: number;

  @Generated("uuid")
  @Column()
  invoiceUuid: string;

  @Column({
    enum: originalFormTypes,
    nullable: false,
  })
  type: originalFormTypes;

  @Column({ nullable: false })
  customerName: string;

  @Column({ nullable: false })
  customerEmail: string;

  @Column({ nullable: true })
  customerPhone: string;

  @Column({ nullable: false })
  customerAddress: string;

  @Column({ nullable: false })
  customerPostalCode: string;

  @Column({ nullable: false })
  customerCity: string;

  @Column({ nullable: false })
  customerProvince: String;

  @Column({ nullable: false, default: "Canada" })
  customerCountry: string;

  @Column({ nullable: false })
  total: string;

  @Column({ nullable: false })
  discount: string;

  @Column({ nullable: false })
  discount_percent: string;

  @Column({ nullable: false })
  is_taxable: boolean;

  @Column({ nullable: false })
  final_amount: string;

  @Column({ nullable: true, default: false })
  is_invoice_generated: boolean;

  @Column({ nullable: true })
  invoice_id: string;

  @Column({ nullable: true })
  invoice_path: string;

  @Column({ nullable: true })
  comment: string;

  @OneToMany(
    () => FormToServices,
    (formToServices: FormToServices) => formToServices.form
  )
  formToServices: FormToServices[];

  @UpdateDateColumn({ nullable: true })
  updatedAt?: Date;

  @CreateDateColumn()
  createdAt: Date;

  @Column({ nullable: false })
  createdBy: string;
}
