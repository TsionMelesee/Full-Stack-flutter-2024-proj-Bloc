import { Module } from '@nestjs/common';
import { UserController } from './user.controller';
import { UserService } from './user.service';
import { PrismaService } from 'src/prisma/prisma.service';
import { ConfigModule, ConfigService } from '@nestjs/config';

@Module({
    controllers: [UserController],
    providers: [UserService, PrismaService, ConfigService],
})
export class UserModule {}
