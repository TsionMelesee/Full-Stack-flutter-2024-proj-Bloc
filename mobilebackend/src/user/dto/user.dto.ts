import { Role } from "@prisma/client"
import { IsBoolean, IsNotEmpty, IsOptional, IsString } from "class-validator"

export class UserUpdateDto{
    
    @IsString()
    email?: string


   

    
    @IsString()
    firstName?: string
    
    @IsString()
    username: string;

    @IsOptional()
    @IsString()
    lastName?: string;


}
export class UserDto{
    @IsNotEmpty()
    @IsString()
    password?: string

}


