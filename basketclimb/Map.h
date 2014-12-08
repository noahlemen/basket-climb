//
//  Map.h
//  basketclimb
//
//  Created by Tom Longabaugh on 11/26/14.
//  Copyright (c) 2014 nyu.edu. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum {
    left_wall,
    right_wall
} wallType;

@interface Map : SKNode

@property (nonatomic) CGFloat prevHeightBuilt;
@property (nonatomic) CGFloat screenHeight;
@property (nonatomic) CGFloat screenWidth;
@property (nonatomic) CGFloat madeBasketHeight;
@property (nonatomic) CGFloat currBasketHeight;

/* creates a path with number of visible "jutting out" points" */
-(CGMutablePathRef)createPathWithPoints:(int)numPoints
                             onWall:(wallType)wall;

/* Releases CGMutabalePathRef resources */
-(void)releasePath:(CGMutablePathRef)path;

/* Adds a basket to the map */
-(void)addBasketOnWall:(wallType)wall
            atPosition:(CGPoint)position
              withSize:(CGFloat)size;

/* Creates two screens worth of walls and baskets */
-(void)createNextGameSection;

/*
+ (id) mapWithGridSize:(CGSize)gridSize;
- (id) initWithGridSize:(CGSize)gridSize;
*/
@end
