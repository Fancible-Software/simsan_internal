import { Column, CreateDateColumn, Entity, PrimaryGeneratedColumn, UpdateDateColumn } from "typeorm";

@Entity()
export class Contact {
    @PrimaryGeneratedColumn()
    readonly id: number;

    @Column({ nullable: false })
    name: string;

    @Column({ nullable: false })
    email: string;

    @Column({ nullable: false })
    phone: string;

    @Column({ nullable: false })
    service: string;

    @Column({ nullable: false })
    message: string;

    @UpdateDateColumn({ nullable: true })
    updatedAt?: Date;

    @CreateDateColumn()
    createdAt: Date;
}