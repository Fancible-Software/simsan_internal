import { Column, CreateDateColumn, Entity, PrimaryGeneratedColumn, UpdateDateColumn } from "typeorm";

@Entity()
export class Service{
    @PrimaryGeneratedColumn()
    readonly serviceId : number;

    @Column({nullable : false, unique : true})
    serviceName : string;

    @Column({nullable : false, default : 1})
    isActive : number;

    @Column({nullable : false, default : "0"})
    price : string;

    @UpdateDateColumn({ nullable: true })
    updatedAt?: Date;

    @CreateDateColumn()
    createdAt: Date;
}