//
//  GameScene.h
//  basketclimb
//

//  Copyright (c) 2014 nyu.edu. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Map.h"

@interface GameScene : SKScene

@property (nonatomic) SKNode *world;
@property (nonatomic) Map *map;

@end
