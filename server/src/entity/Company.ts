import {
  Column,
  Entity,
  PrimaryGeneratedColumn,
  UpdateDateColumn,
  CreateDateColumn,
  OneToMany,
} from "typeorm";
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

  @OneToMany(() => User, (usr) => usr.companyId)
  userId: User;

  @UpdateDateColumn({ nullable: true })
  updatedAt?: Date;

  @CreateDateColumn()
  createdAt: Date;
}
