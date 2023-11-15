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
  readonly companyId: number;

  @Column({
    nullable: false,
  })
  companyName: string;

  @Column({
    nullable: false,
  })
  businessId: string;

  @Column({ nullable: false })
  businessIdImg: string;

  @Column({ nullable: false, default: true })
  isTrail: boolean;

  @UpdateDateColumn({ nullable: true })
  updatedAt?: Date;

  @CreateDateColumn()
  createdAt: Date;
}
