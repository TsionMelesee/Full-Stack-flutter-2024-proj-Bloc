import { Body, Controller, Post, UseGuards, Request, Get, ParseIntPipe, Param, } from '@nestjs/common';
import { AuthService } from './auth.service';
import { AuthDto,  UserDto } from './dto';
import { JwtAuthGuard } from './guard/auth.guard';

import { Role } from '@prisma/client';
import { Public } from './decorator/public.decorator';
import { RolesGuard } from './guard/role.guard';
import { Roles } from './decorator/roles.decorator';

@Public()
@Controller('auth')
export class AuthController {
    constructor(private authService: AuthService) {}

    @Post('signup')
    async Signup(@Body() dto: UserDto) {
        let response =  await this.authService.userSignup(dto);
        return response;
    }

    @Post('signin')
    login(@Body() dto: AuthDto) {
        console.log("signing in");
        return this.authService.signin(dto);
    }

    

    @UseGuards(JwtAuthGuard, RolesGuard)
    @Roles(Role.ADMIN, Role.USER)
    @Get('profile')
    getProfile(@Request() req){
        return req.user
    }

  
    

    @UseGuards(JwtAuthGuard)
    @Post('logout')
    async logout(@Body('token') token: string, @Body('userId') userId: number) {
      localStorage.removeItem('accessToken');
      localStorage.removeItem(userId.toString());
  
      return { message: 'Logout successful' };
    }

   
}
