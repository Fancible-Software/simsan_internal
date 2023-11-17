import {
  Column,
  Entity,
  PrimaryGeneratedColumn,
  UpdateDateColumn,
  CreateDateColumn,
} from "typeorm";

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
    unique : true
  })
  governmentBusinessId: string;

  @Column({ nullable: false })
  governmentBusinessIdImg: string;

  @Column({ nullable: false, default: true })
  isTrail: boolean;

  @UpdateDateColumn({ nullable: true })
  updatedAt?: Date;

  @CreateDateColumn()
  createdAt: Date;
}
