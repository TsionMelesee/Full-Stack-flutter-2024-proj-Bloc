import { Body, Controller, Delete, Get, InternalServerErrorException, NotFoundException, Param, Patch, Post, UseGuards, Req, UnauthorizedException } from '@nestjs/common';
import { UserService } from './user.service';
import { JwtAuthGuard } from '../auth/guard/auth.guard';
import { Roles } from '../auth/decorator/roles.decorator';
import { Role, User } from '@prisma/client';
import { UserUpdateDto } from './dto/user.dto';
import { RolesGuard } from 'src/auth/guard/role.guard';

@Controller('users')
@UseGuards(JwtAuthGuard)
export class UserController {
  constructor(private readonly userService: UserService) {}

  @Get()
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN)
  async getAllUsers(): Promise<{ userId: number; firstName: string; lastName: string | null; email: string; username?: string }[]> {
    try {
      const allUsers = await this.userService.getAllUsers();
  
      const formattedUsers = allUsers.map(user => ({
        userId: user.userId,
        firstName: user.firstName,
        lastName: user.lastName,
        email: user.email,
        username: user.username, // Include username if available
      }));
  
      console.log('Users fetched successfully:', formattedUsers);
  
      return formattedUsers;
    } catch (error) {
      console.error('Error getting all users:', error);
      throw new InternalServerErrorException('Could not fetch users');
    }
  }
  
  
 // For regular user deletion
 @Delete(':id')
 @UseGuards(JwtAuthGuard)
 async deleteUser(@Param('id') userId: string) {
  const parsedUserId = parseInt(userId, 10); // Convert string to number
   try {
     const result = await this.userService.deleteUser(parsedUserId);
     return result;
   } catch (error) {
     console.error('Error deleting user:', error);
     return { error: 'Something went wrong' };
   }
 }

// For admin deletion with blocking
@Delete(':id/block')
@UseGuards(RolesGuard)
@Roles(Role.ADMIN)
async blockUserByEmail(@Param('id') userId: string): Promise<any> {
    const parsedUserId = parseInt(userId, 10); // Convert string to number
    try {
        // Determine if the user is currently blocked
        const user = await this.userService.getUserById(parsedUserId);
        
        // Toggle the block status
        const isBlocked = !user.isBlocked;

        // Update the user's block status
        await this.userService.updateUserBlockStatus(parsedUserId, isBlocked);

        return { message: `User ${isBlocked ? 'blocked' : 'unblocked'} successfully.` };
    } catch (error) {
        console.error('Error blocking/unblocking user:', error);
        throw new InternalServerErrorException('Something went wrong');
    }
}

@Patch(':id')
  updateUser(@Param('id') userId: string, @Body() dto: UserUpdateDto) {
    const parsedUserId = parseInt(userId, 10); // Convert string to number
    return this.userService.updateUser(parsedUserId, dto);
  }



  @Get('profile/:userId')
  async getProfile(@Param('userId') userId: string) {
    const parsedUserId = parseInt(userId, 10); // Convert string to number
    return this.userService.getProfile(parsedUserId);
  }
  
  }
  
