import { Controller, Post, Delete, Get, Param, Body, UseGuards, Patch,  InternalServerErrorException, Req, UnauthorizedException, ParseIntPipe } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { ReviewService } from './review.service';
import { CreateReviewDto, UpdateReviewDto } from './dto';
import { JwtAuthGuard } from 'src/auth/guard/auth.guard';
import { Request as ExpressRequest } from 'express';
import { GetUser } from 'src/auth/decorator';



@Controller('review')
@UseGuards(JwtAuthGuard)
export class ReviewController {
  constructor(private readonly reviewService: ReviewService) {}
 
    @Post()

    async createReview(
        @Body('userId') userId: number,
        @Body('jobId') jobId: string,
        @Body() dto: CreateReviewDto
    ) {
        return this.reviewService.createReview(userId, jobId, dto);
    }

    

    @Get('job/:jobId')
    async getReviewsForJob(@Param('jobId') jobId: string) {
        return this.reviewService.getReviewsForJob(jobId);
    }
   
    @Patch()
    updateReview(
      @Body() dto: UpdateReviewDto,
      @GetUser('Id') authorId: number,
    ) {
      return this.reviewService.updateReview(
        (dto = dto),
        (authorId = authorId),
      );
    }
  
   
    @Delete(':id')
    deleteReview(
      @GetUser('Id') userId: number,
      @Param('id') reviewId: string,
    ) {
      return this.reviewService.deleteReviews(
        reviewId, userId
      );
    }
   
  @Get('user/:userId')
  async getReviewsByUser(@Param('userId', ParseIntPipe) userId: number) {
    try {
      const reviews = await this.reviewService.getReviewsByUser(userId);
      return reviews;
    } catch (error) {
      // You can handle errors here or let NestJS handle them globally
      throw error;
    }
  }
}




