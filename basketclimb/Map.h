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
/*
+ (id) mapWithGridSize:(CGSize)gridSize;
- (id) initWithGridSize:(CGSize)gridSize;
*/
@end
