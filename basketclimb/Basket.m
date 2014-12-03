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

+(Basket*)createBasketOnLeft:(BOOL)leftSide
                   withColor:(SKColor*)color
                    andAngle:(CGFloat)angle
                     andSize:(CGFloat)size
{
    return [[Basket alloc] initBasketOnLeft:leftSide withColor:color andAngle:angle andSize:size];
}

-(Basket*)initBasketOnLeft:(BOOL)leftSide
                 withColor:(SKColor*)color
                  andAngle:(CGFloat)angle
                   andSize:(CGFloat)size
{
    if (self = [super init]) {
        // Bottom
        bottom = [SKShapeNode node];
        bottom.path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 30*size, 10)].CGPath;
        bottom.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(0, 0, 30*size, 10)];
        bottom.physicsBody.dynamic = NO;
        bottom.fillColor = color;
        bottom.strokeColor = color;
        [self addChild:bottom];
        
        // Side
        side = [SKShapeNode node];
        if(leftSide) {
            side.path = [UIBezierPath bezierPathWithRect:CGRectMake(30*size, 0, 10, 30)].CGPath;
            side.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(30*size, 0, 10, 30)];
        }
        else { // right side
            side.path = [UIBezierPath bezierPathWithRect:CGRectMake(0*size, 0, 10, 30)].CGPath;
            side.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(0*size, 0, 10, 30)];
        }
        side.physicsBody.dynamic = NO;
        side.fillColor = color;
        side.strokeColor = color;
        [self addChild:side];

    }

    return self;
}

@end
