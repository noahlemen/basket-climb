//
//  ParallaxSpriteNode.h
//  Basket Climb
//
//  Created by Noah Lemen on 12/11/14.
//  Copyright (c) 2014 nyu.edu. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Cloud : SKSpriteNode

- (Cloud *)initWithPosition:(CGPoint)position;

- (void)updatePositionFromCamera:(SKNode *)camera;

@end
