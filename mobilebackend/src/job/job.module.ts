import { Global, Module } from '@nestjs/common';
import { JobService } from './job.service';
import { JobController } from './job.controller';
import { AuthModule } from '../auth/auth.module';
import { PrismaService } from 'src/prisma/prisma.service';
import { ConfigService } from '@nestjs/config';


@Global()
@Module({
  imports: [AuthModule], 
  controllers: [JobController],
  providers: [JobService,PrismaService, ConfigService],
})
export class JobModule {}