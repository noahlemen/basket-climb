//
//  Basket.h
//  Basket Climb
//
//  Created by Tom Longabaugh on 12/2/14.
//  Copyright (c) 2014 nyu.edu. All rights reserved.
//
//  Class for creating baskets

#import <SpriteKit/SpriteKit.h>

@interface Basket : SKNode

@property (nonatomic) SKShapeNode *bottom;
@property (nonatomic) SKShapeNode *side;

/* Class constructor */
+(Basket*)createBasketOnLeft:(BOOL)leftSide
             withColor:(SKColor*)color
              andAngle:(CGFloat)angle
               andSize:(CGFloat)size;

/* Initializes basket on specific side */
-(Basket*)initBasketOnLeft:(BOOL)leftSide
                 withColor:(SKColor*)color
                  andAngle:(CGFloat)angle
                   andSize:(CGFloat)size;
@end