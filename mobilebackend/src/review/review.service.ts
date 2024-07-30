import {
  Body,
    Injectable,
    InternalServerErrorException,
    NotFoundException,
    Param,
    Req,
    UnauthorizedException,
  } from '@nestjs/common'
import { PrismaService } from 'src/prisma/prisma.service'
import { CreateReviewDto, UpdateReviewDto } from './dto'
  
  @Injectable()
  export class ReviewService  {
    constructor(private db: PrismaService) {}
  
    async createReview(userId: number, jobId: string, dto: CreateReviewDto) {
      try {
        const Review = await this.db.review.create({
          data: { authorId: userId, jobId, ...dto },
        })
        return Review
      } catch (error) {
        throw new InternalServerErrorException('Something went wrong')
      }
    }
  
    

    async getReviewsForJob(jobId: string) {
        try {
            const reviews = await this.db.review.findMany({
                where: { jobId },
            });
            if (!reviews) {
                throw new NotFoundException('Reviews not found for the specified job');
            }
            return reviews;
        } catch (error) {
            throw new InternalServerErrorException('Something went wrong');
        }
    }

   
  
    
  async deleteReviews(reviewId: string, customer: number) {
    try {
      const review = await this.db.review.findUnique({
        where: { id: reviewId },
      });

      if (review == null) {
        throw 'Review not found';
      }
      if (review.authorId != customer) {
        throw `Not your review to delete ${customer} ${review.authorId}`;
      }

      await this.db.review.delete({ where: { id: review.id } });
      return {
        message: 'Deleted review successfully',
      };
    } catch (e) {
      return {
        message: e,
      };
    }
  }
  async updateReview(dto: UpdateReviewDto, authorId: number) {
    try {
      if (dto.rate > 5) {
        dto.rate = 5;
      }
      if (dto.rate < 0) {
        dto.rate = 0;
      }
      const review = await this.db.review.findUnique({
        where: { id: dto.id },
      });
      if (review == null) {
        return {
          message: 'doesnt exist',
        };
      }
      if (review.authorId != authorId) {
        return {
          message: 'not your review to edit',
        };
      }
      const editedReview = await this.db.review.update({
        where: { id: review.id },
        data: {
          rate: dto.rate ? dto.rate : review.rate,
          content: dto.content ? dto.content : review.content,
        },
      });
      return { editedReview };
    } catch (e) {
      console.log(e);
      return {
        message: e,
      };
    }
  }
  async getReviewsByUser(userId: number) {
    try {
      const reviews = await this.db.review.findMany({
        where: { authorId: userId },
      });
      if (!reviews) {
        throw new NotFoundException('Reviews not found for the specified user');
      }
      return reviews;
    } catch (error) {
      throw new InternalServerErrorException('Something went wrong');
    }
  }
}
  
  