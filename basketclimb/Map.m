//
//  Map.m
//  basketclimb
//
//  Created by Tom Longabaugh on 11/26/14.
//  Copyright (c) 2014 nyu.edu. All rights reserved.
//

#import "Map.h"
#import "GameScene.h"

@implementation Map {
    SKColor *wallColor;
}

- (id) init
{
    if (( self = [super init] ))
    {
        // Get size of screen
        CGRect screenRect = [UIScreen mainScreen].bounds;
        
        //Set ball start and wall color
        wallColor = [SKColor colorWithRed:0.184 green:0.36 blue:0.431 alpha:1.0];
        
        // Set border (will need to be changed later)
        SKPhysicsBody* borderBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:screenRect];
        self.physicsBody = borderBody;
        self.physicsBody.friction = 0.5f;
        
        // Bottorm
        SKShapeNode *floor = [SKShapeNode shapeNodeWithRect:CGRectMake(0.0f, 0.0f, CGRectGetWidth(screenRect), 10.0f)];
        floor.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(0.0f, 0.0f, CGRectGetWidth(screenRect), 10.0f)];
        floor.strokeColor = wallColor;
        floor.fillColor = wallColor;
        [self addChild:floor];
        
        // Left Wall
        SKShapeNode *leftWall = [SKShapeNode shapeNodeWithRect:CGRectMake(0.0f, 0.0f, 10.0f, CGRectGetHeight(screenRect))];
        leftWall.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(0.0f, 0.0f, 10.0f, CGRectGetHeight(screenRect))];
        leftWall.strokeColor = wallColor;
        leftWall.fillColor = wallColor;
        [self addChild:leftWall];
        
        // Right Wall
        SKShapeNode *rightWall = [SKShapeNode shapeNodeWithRect:CGRectMake(CGRectGetWidth(screenRect) - 10.0f, 0.0f, 10.0f, CGRectGetHeight(screenRect))];
        rightWall.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(CGRectGetWidth(screenRect) - 10.0f, 0.0f, 10.0f, CGRectGetHeight(screenRect))];
        rightWall.strokeColor = wallColor;
        rightWall.fillColor = wallColor;
        [self addChild:rightWall];
    }
    return self;
}

/*
+ (instancetype) mapWithGridSize:(CGSize)gridSize
{
    return [[self alloc] initWithGridSize:gridSize];
}

- (instancetype) initWithGridSize:(CGSize)gridSize
{
    if (( self = [super init] ))
    {
        self.gridSize = gridSize;
        _spawnPoint = CGPointZero;
    }
    return self;
}*/
@end
