//
//  Basket.m
//  Basket Climb
//
//  Created by Tom Longabaugh on 12/2/14.
//  Copyright (c) 2014 nyu.edu. All rights reserved.
//

#import "Basket.h"

@implementation Basket
@synthesize bottom;
@synthesize side;

+(Basket*)createBasketOnWall:(wallType)wall
                   withColor:(SKColor*)color
                    andAngle:(CGFloat)angle
                     andSize:(CGFloat)size
{
    return [[Basket alloc] initBasketOnWall:wall withColor:color andAngle:angle andSize:size];
}

-(Basket*)initBasketOnWall:(wallType)wall
                 withColor:(SKColor*)color
                  andAngle:(CGFloat)angle
                   andSize:(CGFloat)size
{
    if (self = [super init]) {
        // Bottom
        bottom = [SKShapeNode node];
        bottom.fillColor = color;
        bottom.strokeColor = color;
        
        // Side
        side = [SKShapeNode node];
        side.fillColor = color;
        side.strokeColor = color;
        
        // Draw shapes according to side that basket is on
        if(wall == left_wall) {
            bottom.path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 30*size, 10)].CGPath;
            bottom.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(0, 0, 30*size, 10)];

            side.path = [UIBezierPath bezierPathWithRect:CGRectMake(30*size, 0, 10, 30)].CGPath;
            side.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(30*size, 0, 10, 30)];
        }
        else { // right side
            bottom.path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, -30*size, 10)].CGPath;
            bottom.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(0, 0, -30*size, 10)];
            
            side.path = [UIBezierPath bezierPathWithRect:CGRectMake(-30*size, 0, -10, 30)].CGPath;
            side.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(-30*size, 0, -10, 30)];
        }
        bottom.physicsBody.dynamic = NO;
        side.physicsBody.dynamic = NO;
        [self addChild:bottom];
        [self addChild:side];
    }

    

    return self;
}

@end
