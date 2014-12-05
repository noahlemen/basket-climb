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

    }
    
    return self;
}

@end
