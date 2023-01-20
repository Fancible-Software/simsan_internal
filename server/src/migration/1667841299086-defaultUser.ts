import { User } from "../entity/User";
import { UserPermissions } from "../types";
import { MigrationInterface, QueryRunner } from "typeorm";
const bcrypt = require("bcryptjs");

export class defaultUser1667841299086 implements MigrationInterface {
  private meta = {
    first_name: "admin",
    last_name: "admin",
    email: "admin@simsanfrasermain.com",
    mobile_no: "1234567890",
    password: "admin@123",
    roles: UserPermissions.admin,
    createdBy: "default",
    is_verified: true,
  };
  public async up(queryRunner: QueryRunner): Promise<void> {
    const userRepo = await queryRunner.manager.getRepository(User);
    const user = new User();
    user.first_name = this.meta.first_name;
    user.last_name = this.meta.last_name;
    user.email = this.meta.email;
    user.password = bcrypt.hashSync(this.meta.password);
    user.roles = this.meta.roles;
    user.mobile_no = this.meta.mobile_no;
    user.createdBy = this.meta.createdBy;
    user.is_verified = this.meta.is_verified;
    userRepo.save(user);
  }

  public async down(): Promise<void> {}
}
