//
//  Basket.h
//  Basket Climb
//
//  Created by Tom Longabaugh on 12/2/14.
//  Copyright (c) 2014 nyu.edu. All rights reserved.
//
//  Class for creating baskets

#import <SpriteKit/SpriteKit.h>
#import "Map.h"

@interface Basket : SKNode

@property CGFloat yOffset;
@property (nonatomic) SKShapeNode *basket;

/* Class constructor */
+(Basket*)createBasketOnWall:(wallType)wall
                   withColor:(SKColor*)color
                   andOffset:(CGFloat)offset
                     andSize:(CGFloat)size;

/* Initializes basket on specific side */
-(Basket*)initBasketOnWall:(wallType)wall
                 withColor:(SKColor*)color
                 andOffset:(CGFloat)offset
                   andSize:(CGFloat)size;
@end
