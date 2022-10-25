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
  user_type: string

  @Column({ nullable: false })
  first_name: string

  @Column({ nullable: false })
  last_name: string

  @Column({ nullable: false, unique: true })
  email!: string

  @Column({ nullable: false })
  mobile_no: string

  @Column({ nullable: true })
  profile_pic_url: string

  @Column({ nullable: true })
  profile_pic: string

  @Column({ nullable: false })
  password: string

  @Column({ nullable: false, default: 0 })
  is_login: UserLogin

  @Column({ nullable: false, default: 0 })
  is_approved: number

  @Column({ nullable: false, default: 1 })
  is_active: number

  @Column({ nullable: false, default: 0 })
  is_mobile_verified: number

  @Column({ nullable: false, default: 0 })
  is_email_verified: number

  @Column({ nullable: true })
  forget_pwd_otp: number

  @Column({ nullable: true })
  forget_pwd_otp_generated_at: number

  @Column({ nullable: true })
  is_forget_pwd_otp_verified: number

  @UpdateDateColumn({ nullable: true })
  updatedAt?: Date;

  @CreateDateColumn()
  createdAt: Date;
}
