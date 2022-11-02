import { Column, CreateDateColumn, Entity, PrimaryGeneratedColumn, UpdateDateColumn } from "typeorm";

@Entity()
export class Form{
    @PrimaryGeneratedColumn()
    readonly formId : number;

    @Column({nullable : false})
    customerName : string;

    @Column({nullable : false})
    customerEmail : string;

    @Column({nullable : true})
    customerPhone : string;

    @Column({nullable : false})
    customerAddress : string;

    @Column({nullable : false})
    customerPostalCode : string;

    @Column({nullable : false})
    customerCity : string;

    @Column({nullable : false})
    customerProvince : String;

    @Column({nullable : false, default : "Canada"})
    customerCountry : string;

    @UpdateDateColumn({ nullable: true })
    updatedAt?: Date;

    @CreateDateColumn()
    createdAt: Date;
}