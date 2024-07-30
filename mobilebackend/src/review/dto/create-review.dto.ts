import { IsInt, IsNotEmpty, IsString } from 'class-validator';

export class CreateReviewDto {
  @IsString()
  @IsNotEmpty()
  content: string;

  @IsInt()
  @IsNotEmpty()
  rate: number;

  @IsString()
  @IsNotEmpty()
  jobId: string; // This field is required to associate the review with a job

  @IsInt()
  @IsNotEmpty()
  authorId: number; // This field is required to associate the review with an author
}
