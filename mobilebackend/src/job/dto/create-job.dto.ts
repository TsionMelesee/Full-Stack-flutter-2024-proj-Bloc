import { IsString, IsNotEmpty, IsOptional, IsInt, Min, IsEnum, IsPhoneNumber } from 'class-validator';
import { UserType } from './enums';



export class CreateJobDto {
  @IsNotEmpty()
  @IsString()
  title: string = '';

  @IsNotEmpty()
  @IsString()
  description: string = '';

  @IsString()
  @IsNotEmpty()
  phonenumber?: string;

  @IsOptional()
  @IsInt()
  @Min(0)
  salary?: number = 0;

  @IsNotEmpty()
  @IsInt()
  createrId;

  @IsNotEmpty()
  @IsEnum(UserType, { message: 'Invalid userType. Must be either EMPLOYEE or JOB_SEEKER' })
  userType: UserType = UserType.EMPLOYEE;

 

}