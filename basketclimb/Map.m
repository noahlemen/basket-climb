//
//  Map.m
//  basketclimb
//
//  Created by Tom Longabaugh on 11/26/14.
//  Copyright (c) 2014 nyu.edu. All rights reserved.
//

#import "Map.h"
#import "GameScene.h"
#import "Basket.h"

@implementation Map {
    SKColor *wallColor;
    //NSMutableArray *leftWallPoints;
    //NSMutableArray *rightWallPoints;
    int numBaskets;
}

- (id) init
{
    if (( self = [super init] ))
    {
        // Seed numBaskets for procedural generation
        srandom(numBaskets);
        
        // Get size of screen
        CGRect screenRect = [UIScreen mainScreen].bounds;
        
        //Set ball start and wall color
        wallColor = [SKColor colorWithRed:0.184 green:0.36 blue:0.431 alpha:1.0];
        
        // Bottom
        SKShapeNode *floor = [SKShapeNode shapeNodeWithRect:CGRectMake(0.0f, 0.0f, CGRectGetWidth(screenRect), 10.0f)];
        floor.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(0.0f, 0.0f, CGRectGetWidth(screenRect), 10.0f)];
        floor.strokeColor = wallColor;
        floor.fillColor = wallColor;
        [self addChild:floor];
        
        // Left Wall
        CGMutablePathRef leftPath = [self createPathWithPoints:0 andScreenBounds:screenRect isLeftWall:YES];
        SKShapeNode *leftWall = [[SKShapeNode alloc] init];
        leftWall.path = leftPath;
        leftWall.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:leftPath];
        leftWall.physicsBody.dynamic = NO;
        leftWall.strokeColor = wallColor;
        leftWall.fillColor = wallColor;
        [self addChild:leftWall];
        
        // Right Wall
        CGMutablePathRef rightPath = [self createPathWithPoints:0 andScreenBounds:screenRect isLeftWall:NO];
        SKShapeNode *rightWall = [[SKShapeNode alloc] init];
        rightWall.path = rightPath;
        rightWall.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:rightPath];
        rightWall.physicsBody.dynamic = NO;
        rightWall.strokeColor = wallColor;
        rightWall.fillColor = wallColor;
        [self addChild:rightWall];
        
        [self addBasketOnWall:left_wall atPosition:CGPointMake(0.0f, CGRectGetMidY(screenRect)) withSize:1.5];
        [self addBasketOnWall:right_wall atPosition:CGPointMake(CGRectGetWidth(screenRect), CGRectGetMidY(screenRect)+250) withSize:1.5];
        
    }
    return self;
}

/* creates a path with number of visible "jutting out" points */
-(CGMutablePathRef)createPathWithPoints:(int)numPoints
                        andScreenBounds:(CGRect)screenRect
                             isLeftWall:(BOOL)leftWall
{
    
    // This will somehow need to be procedurally done
    int totalPoints = numPoints + 4;
    CGPoint points[totalPoints];
    
    if(leftWall) {
        for(int i = 0; i < numPoints; i++) {
            points[i] = CGPointMake(25.0f + i*5.0f, CGRectGetMidY(screenRect) + i*50.0f);
        }
        points[totalPoints-4] = CGPointMake(10.0f, CGRectGetHeight(screenRect)*3.0f);
        points[totalPoints-3] = CGPointMake(0.0f, CGRectGetHeight(screenRect)*3.0f);
        points[totalPoints-2] = CGPointMake(0.0f, 0.0f);
        points[totalPoints-1] = CGPointMake(10.0f, 0.0f);
    }
    else { // Right wall
        for(int i = 0; i < numPoints; i++) {
            points[i] = CGPointMake(CGRectGetWidth(screenRect) - 25.0f - i*10.0f, CGRectGetMidY(screenRect) - 80.0f + i*70.0f);
        }
        points[totalPoints-4] = CGPointMake(CGRectGetWidth(screenRect) - 10.0f, CGRectGetHeight(screenRect)*3.0f);
        points[totalPoints-3] = CGPointMake(CGRectGetWidth(screenRect), CGRectGetHeight(screenRect)*3.0f);
        points[totalPoints-2] = CGPointMake(CGRectGetWidth(screenRect), 0.0f);
        points[totalPoints-1] = CGPointMake(CGRectGetWidth(screenRect) - 10.0f, 0.0f);
    }
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddLines(path, NULL, points, totalPoints);
        
    
    return path;
    
}

-(void)releasePath:(CGMutablePathRef)path
{
    CGPathCloseSubpath(path);
    CGPathRelease(path);
}

-(SKShapeNode*)drawWall:(SKShapeNode*)wall
          withNumPoints:(int)numPoints
             andSpacing:(CGFloat)spacing
            andInsetMax:(CGFloat)insetMax
{
    return wall;
}

-(void)addBasketOnWall:(wallType)wall
            atPosition:(CGPoint)position
                 withSize:(CGFloat)size
{
    Basket *aBasket = [Basket createBasketOnWall:wall withColor:wallColor andAngle:0 andSize:size];
    aBasket.position = position;
    [self addChild:aBasket];
    
}

-(void)createNextGameSection
{
    
}

-(void)numBasketsforNextSection
{
    // most baskets in one scene is 4
    numBaskets = random() % 4;
}

//-(CGPoint)createRandomPosition

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






