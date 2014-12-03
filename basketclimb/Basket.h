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

@property (nonatomic, assign) int wallSide; // 0 is left, 1, is right.
@property (nonatomic, assign) CGFloat size;

@property (nonatomic, assign) SKShapeNode *bottom;
@property (nonatomic, assign) SKShapeNode *side;


-(Basket*)createBasketOnSide:(BOOL)leftSide
                   withColor:(SKColor*)color
                    andAngle:(CGFloat)angle
                     andSize:(CGFloat)size;
@end
