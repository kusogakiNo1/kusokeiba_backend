import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
} from "typeorm";

@Entity("users")
export class User {
  @PrimaryGeneratedColumn()
  id!: number;

  @Column({ length: 20 })
  username!: string;

  @Column()
  email!: string;

  @Column()
  password!: string;

  @Column()
  age!: number;

  @Column({ name: "deleted_flag", default: false })
  deletedFlag!: boolean;

  @CreateDateColumn({ name: "created_at" })
  createdAt!: Date;

  @UpdateDateColumn({ name: "updated_at" })
  updatedAt!: Date;

  @Column({ name: "deleted_at", type: "datetime", nullable: true })
  deletedAt!: Date | null;
}
