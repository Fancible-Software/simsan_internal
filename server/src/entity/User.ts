import { UserPermissions } from "../types";
import {
  Column,
  CreateDateColumn,
  Entity,
  JoinColumn,
  ManyToOne,
  PrimaryGeneratedColumn,
  UpdateDateColumn,
} from "typeorm";
import { Company } from "./Company";

enum UserLogin {
  not_logged_in = "0",
  logged_in = "1",
}

@Entity()
export class User {
  @PrimaryGeneratedColumn()
  readonly id: number;

  @Column({ nullable: false })
  first_name: string;

  @Column({ nullable: false })
  last_name: string;

  @Column({ nullable: false, unique: true })
  email!: string;

  @Column({ nullable: false })
  mobile_no: string;

  @Column({ nullable: false })
  password: string;

  @Column({ nullable: false, default: 0 })
  is_login: UserLogin;

  @Column({ nullable: false, default: 1 })
  is_active: number;

  @Column({
    enum: UserPermissions,
    nullable: false,
  })
  roles: UserPermissions;

  @Column({ nullable: false })
  createdBy: string;

  @Column({ default: false })
  is_verified: Boolean;

  @Column({ nullable: true })
  verified_at?: Date;

  @JoinColumn({ name: "companyId" })
  @ManyToOne(() => Company, (c) => c.userId)
  company: Company;

  @Column({ nullable: false })
  companyId: number;

  //for soft delete. 0=> Not deleted, 1=>deleted
  @Column({ nullable: false, default: 0 })
  is_deleted: number;

  @Column({ nullable: true })
  deleted_at?: Date;

  @Column({ nullable: true })
  deleted_by?: number;

  @UpdateDateColumn({ nullable: true })
  updatedAt?: Date;

  @CreateDateColumn()
  createdAt: Date;
}
