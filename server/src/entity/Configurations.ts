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

  @JoinColumn({ name: "companyId" })
  @ManyToOne(() => Company, (c) => c.configId)
  company: Company;

  @Column({ nullable: false })
  companyId: number;

  @UpdateDateColumn({ nullable: true })
  updatedAt?: Date;

  @CreateDateColumn()
  createdAt: Date;

  @Column({ nullable: false })
  createdBy: string;
}
