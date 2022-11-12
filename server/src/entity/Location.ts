import { Column, Entity, PrimaryGeneratedColumn } from "typeorm";

@Entity()
export class Location{
    @PrimaryGeneratedColumn()
    readonly locationId : number;

    @Column()
    city : string;

    @Column()
    city_ascii : string;

    @Column()
    province_id : string;

    @Column()
    province_name : string;

    @Column()
    lat : string;

    @Column()
    lng : string;

    @Column()
    population : string;

    @Column()
    density : string;

    @Column()
    timezone : string;

    @Column()
    ranking : number;

    @Column({length:4000})
    postal : string;

    @Column()
    id : String;
}