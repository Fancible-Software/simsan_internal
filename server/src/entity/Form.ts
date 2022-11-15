import { Column, CreateDateColumn, Entity, OneToMany, PrimaryGeneratedColumn, UpdateDateColumn } from "typeorm";
import { FormToServices } from "./FormToServices";

@Entity()
export class Form {
    @PrimaryGeneratedColumn()
    readonly formId: number;

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
    final_amount: string;

    @OneToMany(() => FormToServices, (formToServices: FormToServices) => formToServices.form)
    formToServices: FormToServices[];

    @UpdateDateColumn({ nullable: true })
    updatedAt?: Date;

    @CreateDateColumn()
    createdAt: Date;

    @Column({ nullable: false })
    createdBy: string
}