import { Body, Controller, Delete, Get, NotFoundException, Param, Patch, Post, Req, UseGuards } from '@nestjs/common';
import { JobService } from './job.service';
import { CreateJobDto } from './dto/create-job.dto';
import { UserType } from '@prisma/client';
import { UpdateJobDto } from './dto/update-job.dto';
import { JwtAuthGuard } from '../auth/guard/auth.guard';
import { Roles } from '../auth/decorator/roles.decorator';
import { Role, User } from '@prisma/client';
import { RolesGuard } from 'src/auth/guard/role.guard';


@Controller('jobs')
@UseGuards(JwtAuthGuard)
export class JobController {
  constructor(private readonly jobService: JobService) {}

  @Post()
  async createJob(@Body() dto: CreateJobDto) {
    const userId = parseInt(dto.createrId); // Explicitly parse the string to a number

    if (!userId || isNaN(userId)) {
      throw new NotFoundException('Invalid or missing user ID');
    }

    const user = await this.jobService.getUserById(userId);

    if (!user) {
      throw new NotFoundException(`User with ID ${userId} not found`);
    }

    return this.jobService.createJob(userId, dto);
  }


  @Get('forEmployees')

  async getJobsForEmployees() {
    try {
      const jobs = await this.jobService.getJobsByUserType(UserType.EMPLOYEE);
      return { success: true, jobs };
    } catch (error) {
      return { error: 'An error occurred while fetching jobs for employees', success: false };
    }
  }

  @Get('forJobSeekers')
  
  async getJobsForJobSeekers() {
    try {
      const jobs = await this.jobService.getJobsByUserType(UserType.JOB_SEEKER);
      return { success: true, jobs };
    } catch (error) {
      return { error: 'An error occurred while fetching jobs for job seekers', success: false };
    }
  }

  @Delete(':id')
  async deleteJob(@Param('id') jobId: string) {
    try {
      const result = await this.jobService.deleteJob(jobId);
      return { success: true, message: `Job with ID ${jobId} deleted successfully` };
    } catch (error) {
      return { error: `An error occurred while deleting job with ID ${jobId}`, success: false };
    }
  }

  @Patch(':id')
  async updateJob(@Param('id') jobId: string, @Body() updateJobDto: UpdateJobDto) {
    try {
      const updatedJob = await this.jobService.updateJob(jobId, updateJobDto);
      return { success: true, job: updatedJob };
    } catch (error) {
      return { error: `An error occurred while updating job with ID ${jobId}`, success: false };
    }
  }
  
  @Get('user-jobs/:userId')
  async getUserJobs(@Param('userId') userId: string) {
    try {
      const numericUserId = parseInt(userId); // Convert userId to a number
      if (isNaN(numericUserId)) {
        throw new Error(`Invalid user ID: ${userId}`);
      }

      console.log(`Fetching jobs for user with ID: ${numericUserId}`);
      const jobs = await this.jobService.getJobsByUserId(numericUserId);
      console.log('Fetched jobs:', jobs);
      return { success: true, jobs };
    } catch (error) {
      console.error(`Error fetching jobs for user with ID ${userId}:`, error);
      return { error: `An error occurred while fetching jobs for user with ID ${userId}`, success: false };
    }
  }
  


  
  @Get('getAllJobs')
  @UseGuards(RolesGuard)
  @Roles(Role.ADMIN)
  async getAllJobs() {
    try {
      const jobs = await this.jobService.getAllJobs();
      return { jobs, success: true };
    } catch (error) {
      return { error: 'An error occurred while fetching jobs', success: false };
    }
  }
} 




