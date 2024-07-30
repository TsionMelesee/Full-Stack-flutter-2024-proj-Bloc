import { Module } from '@nestjs/common';
import { AuthService } from './auth.service';
import { AuthController } from './auth.controller';
import { JwtModule } from '@nestjs/jwt';
import { JwtStrategy } from './strategy/jwt.strategy';
import { APP_GUARD } from '@nestjs/core';

import { JwtAuthGuard } from './guard/auth.guard';
import { PrismaModule } from 'src/prisma/prisma.module';
import { ConfigModule } from '@nestjs/config';

@Module({
  providers: [
    AuthService,
    JwtStrategy,
    { provide: APP_GUARD, useClass: JwtAuthGuard }
  ],
  controllers: [AuthController],
  imports: [
    JwtModule.register({
      global: true,
    }),
    PrismaModule, // Include PrismaModule here
    ConfigModule, // Include ConfigModule here
  ],
})
export class AuthModule {}
