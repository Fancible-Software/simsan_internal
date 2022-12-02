import { Column, CreateDateColumn, Entity, JoinColumn, OneToOne, PrimaryGeneratedColumn, UpdateDateColumn } from "typeorm";
import { User } from './User'

@Entity()
export class UserVerification {
    @PrimaryGeneratedColumn()
    readonly id: number;

    @OneToOne(() => User)
    @JoinColumn()
    userId: User

    @Column({ nullable: false })
    token: string

    @Column({ nullable: false })
    type: string

    @UpdateDateColumn({ nullable: true })
    updatedAt?: Date;

    @CreateDateColumn()
    createdAt: Date;
}