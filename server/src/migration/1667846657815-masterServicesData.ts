import { Service } from "../entity/Services";
import { MigrationInterface, QueryRunner } from "typeorm";

export class masterServicesData1667846657815 implements MigrationInterface {
    private metaData = [
        "Roof moss removal",
        "Gutter cleaning from inside",
        "Gutter cleaning from outside",
        "Window washing",
        "Awning washing",
        "Stylites washing",
        "Vinyl Sidings Soft wash",
        "Stucco pressure washing",
        "Side walk pressure washing",
        "Drive way pressure washing",
        "Front stairs pressure washing",
        "Backyard pressure washing",
        "Downspout fixin",
        "Leak fixing",
        "Tile replacement",
        "Tile repair",
        "Back patio pressure washing",
        "Garage roof moss removal",
        "Garage gutter cleaning from inside",
        "Garage gutter cleaning from outside",
        "Painting"
    ]

    public async up(queryRunner: QueryRunner): Promise<void> {
        for (let i = 0; i < this.metaData.length; i++) {
            const service = new Service()
            const serviceRepo = queryRunner.manager.getRepository(Service)
            const ifService = await serviceRepo.count({ serviceName: this.metaData[i] })
            if (!ifService) {
                service.serviceName = this.metaData[i]
                queryRunner.manager.save(service)
            }
        }
        // for (const [serviceName] of Object.entries(this.metaData)) {
        //     console.log(serviceName)
        // }
    }

    public async down(): Promise<void> {
    }

}
