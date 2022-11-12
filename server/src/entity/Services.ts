import { Column, CreateDateColumn, Entity, OneToMany, PrimaryGeneratedColumn, UpdateDateColumn } from "typeorm";
import { FormToServices } from "./FormToServices";

@Entity()
export class Service {
    @PrimaryGeneratedColumn()
    readonly serviceId: number;

    @Column({ nullable: false, unique: true })
    serviceName: string;

    @Column({ nullable: false, default: 1 })
    isActive: number;

    @Column({ nullable: false, default: "0" })
    price: string;

    @OneToMany(()=>FormToServices,(formToServices:FormToServices)=>formToServices.service)
    formToServices : FormToServices[];

    @UpdateDateColumn({ nullable: true })
    updatedAt?: Date;

    @CreateDateColumn()
    createdAt: Date;

    @Column({ nullable: false, default: "default" })
    createdBy: string
}