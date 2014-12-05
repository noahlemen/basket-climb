//
//  Ball.m
//  Basket Climb
//
//  Created by Noah Lemen on 12/3/14.
//  Copyright (c) 2014 nyu.edu. All rights reserved.
//

#import "Ball.h"

const float RESTING_SPEED = 0.000001;

@implementation Ball
@synthesize lastRestingPosition;
@synthesize touchingBasket;

-(Ball *)init{
    self = [super initWithImageNamed:@"ball"];
    if (self){
        touchingBasket = NO;
    }
    return self;
}

-(bool)isResting{
    CGVector v = self.physicsBody.velocity;
    float speed = sqrtf(v.dx*v.dx+v.dy*v.dy);
    if (speed < RESTING_SPEED){
        self.lastRestingPosition = self.position;
        return YES;
    }else{
        return NO;
    }
}

@end
