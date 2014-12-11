//
//  ParallaxSpriteNode.m
//  Basket Climb
//
//  Created by Noah Lemen on 12/11/14.
//  Copyright (c) 2014 nyu.edu. All rights reserved.
//

#import "Cloud.h"

@implementation Cloud{
    float realY;
}

- (Cloud *)initWithPosition:(CGPoint)position{
    self = [super initWithImageNamed:@"cloud"];
    if (self){
        float random = arc4random()%10 + 1; // random int 1-10
        NSLog(@"%f", random);
        self.zPosition = -random/10;
        self.alpha = .75/random;
        self.xScale = 1/random;
        self.yScale = 1/random;
        self.position = position;
        realY = position.y;
    }
    return self;
}

- (void)updatePositionFromCamera:(SKNode *)camera{
    self.position = CGPointMake(self.position.x, realY + camera.position.y * .1/self.zPosition);
}

@end
