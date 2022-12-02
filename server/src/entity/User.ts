import { UserPermissions } from "../types";
import { Column, CreateDateColumn, Entity, PrimaryGeneratedColumn, UpdateDateColumn } from "typeorm";


enum UserLogin {
  not_logged_in = "0",
  logged_in = "1"
}

@Entity()
export class User {
  @PrimaryGeneratedColumn()
  readonly id: number;

  @Column({ nullable: false })
  first_name: string

  @Column({ nullable: false })
  last_name: string

  @Column({ nullable: false, unique: true })
  email!: string

  @Column({ nullable: false })
  mobile_no: string

  @Column({ nullable: false })
  password: string

  @Column({ nullable: false, default: 0 })
  is_login: UserLogin

  @Column({ nullable: false, default: 1 })
  is_active: number

  @Column({
    default: UserPermissions.sub_admin,
    nullable: false
  })
  roles: UserPermissions;

  @Column({ nullable: false })
  createdBy: string

  @Column({ default: false })
  is_verified: Boolean

  @Column({ nullable: true })
  verified_at?: Date

  @UpdateDateColumn({ nullable: true })
  updatedAt?: Date;

  @CreateDateColumn()
  createdAt: Date;
}
