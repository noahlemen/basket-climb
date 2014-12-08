//
//  GameScene.h
//  basketclimb
//

//  Copyright (c) 2014 nyu.edu. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Ball.h"
#import "Map.h"

typedef enum : uint8_t {
    CollisionTypeBasket = 1,
    CollisionTypeBall = 2,
    CollisionTypeFloor = 4,
    CollisionTypeWall = 8
}ClimbColliderType;

@interface GameScene : SKScene

@property (nonatomic) SKNode *world;
@property (nonatomic) Map *map;
@property (nonatomic) SKNode *camera;
@property (nonatomic) Ball *ball;

@end
