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
        float random = arc4random()%5 + 1; // random int 1-5
        NSLog(@"%f", random);
        self.zPosition = -(random+2)/10; // (-0.3)-(-0.7) (near-far)
        self.alpha = -.3/self.zPosition; // 1.0-.42 (near-far)
        self.xScale = -.3/self.zPosition;
        self.yScale = -.3/self.zPosition;
        self.position = position;
        realY = position.y;
    }
    return self;
}

- (void)updatePositionFromCamera:(SKNode *)camera{
    self.position = CGPointMake(self.position.x, realY + camera.position.y * .1/self.zPosition);
}

@end
