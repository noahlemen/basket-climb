//
//  Ball.h
//  Basket Climb
//
//  Created by Noah Lemen on 12/3/14.
//  Copyright (c) 2014 nyu.edu. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Ball : SKSpriteNode

@property CGPoint lastRestingPosition;

- (Ball *) init;

- (bool) isResting;

@end
