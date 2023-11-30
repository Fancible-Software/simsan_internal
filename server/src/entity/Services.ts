import {
  Column,
  CreateDateColumn,
  Entity,
  JoinColumn,
  ManyToOne,
  OneToMany,
  PrimaryGeneratedColumn,
  UpdateDateColumn,
} from "typeorm";
import { FormToServices } from "./FormToServices";
import { User } from "./User";

@Entity()
export class Service {
  @PrimaryGeneratedColumn()
  serviceId: number;

  @Column({ nullable: false })
  serviceName: string;

  @Column({ nullable: false, default: 1 })
  isActive: number;

  @Column({ nullable: false, default: "0" })
  price: string;

  @OneToMany(
    () => FormToServices,
    (formToServices: FormToServices) => formToServices.service
  )
  formToServices: FormToServices[];

  @Column({ nullable: true, default: 0 })
  priority?: number;

  @UpdateDateColumn({ nullable: true })
  updatedAt?: Date;

  @CreateDateColumn()
  createdAt: Date;

  @JoinColumn({ name: "createdBy" })
  @ManyToOne(() => User, (c) => c.serviceCreatedBy)
  created: User;

  @Column({ nullable: false })
  createdBy: number;

  @Column({ default: false })
  isDeleted: boolean;

  @Column({ nullable: true })
  deletedBy: string;
}
