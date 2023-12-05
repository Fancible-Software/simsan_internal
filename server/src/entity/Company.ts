import {
  Column,
  Entity,
  PrimaryGeneratedColumn,
  UpdateDateColumn,
  CreateDateColumn,
  OneToMany,
} from "typeorm";
import { Configurations } from "./Configurations";
import { User } from "./User";

@Entity()
export class Company {
  @PrimaryGeneratedColumn()
  companyId: number;

  @Column({
    nullable: false,
  })
  companyName: string;

  @Column({
    nullable: false,
    unique: true,
  })
  governmentBusinessId: string;

  @Column({ nullable: false })
  governmentBusinessIdImg: string;

  @Column({ nullable: false, default: true })
  isTrail: boolean;

  @Column({ nullable: false, default: false })
  isConfigured: boolean;

  @OneToMany(() => User, (usr) => usr.companyId)
  userId: User;

  @OneToMany(() => Configurations, (config) => config.companyId)
  configId: Configurations;

  @UpdateDateColumn({ nullable: true })
  updatedAt?: Date;

  @CreateDateColumn()
  createdAt: Date;
}
