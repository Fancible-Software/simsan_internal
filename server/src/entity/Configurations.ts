import { Column, CreateDateColumn, Entity, PrimaryGeneratedColumn, UpdateDateColumn } from "typeorm";

@Entity()
export class Configurations {
    @PrimaryGeneratedColumn()
    readonly id: number;

    @Column({ nullable: false })
    key: string;

    @Column({ nullable: false })
    value: string;

    @Column({ nullable: false, default: false })
    isImage: Boolean;

    @UpdateDateColumn({ nullable: true })
    updatedAt?: Date;

    @CreateDateColumn()
    createdAt: Date;

    @Column({ nullable: false })
    createdBy: string
}