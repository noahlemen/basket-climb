//
//  Map.h
//  basketclimb
//
//  Created by Tom Longabaugh on 11/26/14.
//  Copyright (c) 2014 nyu.edu. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Map : SKNode

@property (nonatomic) CGSize gridSize;
@property (nonatomic) CGPoint spawnPoint;

/* creates a path with number of visible "jutting out" points" */
-(CGMutablePathRef)createPathWithPoints:(int)numPoints
                        andScreenBounds:(CGRect)screenRect
                             isLeftWall:(BOOL)leftWall;

/* Releases CGMutabalePathRef resources */
-(void)releasePath:(CGMutablePathRef)path;

/*
+ (id) mapWithGridSize:(CGSize)gridSize;
- (id) initWithGridSize:(CGSize)gridSize;
*/
@end
