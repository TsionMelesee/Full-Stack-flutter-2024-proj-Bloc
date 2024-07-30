import { Injectable } from "@nestjs/common";
import { ConfigService } from "@nestjs/config";
import { PassportStrategy } from "@nestjs/passport";
import { ExtractJwt, Strategy } from "passport-jwt";
import { PrismaService } from "src/prisma/prisma.service";

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy, 'jwt'){
    constructor(      private configService: ConfigService, // Use ConfigService here
    private prisma: PrismaService
){
    super({
        jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
        ignoreExpiration: false,
        secretOrKey: configService.get<string>('JWT_SECRET'), // Access JWT_SECRET from configService
    });
}
    async validate(payload: {sub: number, email: string}){
        var user = await this.prisma.user.findUnique({
            where: {
                id: payload.sub,
            }
        })
        var type;
        user = await this.prisma.user.findUnique({
            where: {
                id: user.id,
            }
        })
        // delete user.hash

        return {
            userId: user.id,
            username: user.username,
            roles: user.role

        };
    }
}