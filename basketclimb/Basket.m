//
//  Basket.m
//  Basket Climb
//
//  Created by Tom Longabaugh on 12/2/14.
//  Copyright (c) 2014 nyu.edu. All rights reserved.
//

#import "Basket.h"

@implementation Basket
@synthesize basket;
@synthesize yOffset;

+(Basket*)createBasketOnWall:(wallType)wall
                   withColor:(SKColor*)color
                    andOffset:(CGFloat)offset
                     andSize:(CGFloat)size
{
    return [[Basket alloc] initBasketOnWall:wall withColor:color andOffset:offset andSize:size];
}

-(Basket*)initBasketOnWall:(wallType)wall
                 withColor:(SKColor*)color
                  andOffset:(CGFloat)offset
                   andSize:(CGFloat)size
{
    if (self = [super init]) {
        yOffset = offset;
        
        basket = [SKShapeNode node];
        basket.fillColor = color;
        basket.strokeColor = color;
        
        UIBezierPath *basketPath = [UIBezierPath bezierPath];
        [basketPath moveToPoint:CGPointMake(0.0f, 0.0f)];
        if (wall == left_wall) {
            [basketPath addLineToPoint:CGPointMake(40.0f*size, yOffset-10.0f)];
            [basketPath addLineToPoint:CGPointMake(40.0f*size, yOffset)];
            [basketPath addLineToPoint:CGPointMake(0.0f, 10.0f)];
            
        }
        else {
            [basketPath addLineToPoint:CGPointMake(-40.0f*size, yOffset-10.0f)];
            [basketPath addLineToPoint:CGPointMake(-40.0f*size, yOffset)];
            [basketPath addLineToPoint:CGPointMake(0.0f, 10.0f)];
        }
        basket.path = basketPath.CGPath;
        basket.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:basketPath.CGPath];
        basket.physicsBody.dynamic = NO;
        [self addChild:basket];
        
        
        /*
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
        [self addChild:side];*/
    }
    
    return self;
}

@end
