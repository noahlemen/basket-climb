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
#import "Ball.h"

@implementation Map {
    SKColor *wallColor;
    int numBaskets;
    wallType highestBasket;
    BOOL firstLevel;
}
@synthesize prevHeightBuilt;
@synthesize screenWidth;
@synthesize screenHeight;
@synthesize madeBasketHeight;
@synthesize currBasketHeight;

-(id) init
{
    if (( self = [super init] ))
    {
        // Seed numBaskets for procedural generation
        srandom((unsigned int)time(NULL));
        highestBasket = random() % 2;
        screenHeight = CGRectGetHeight([UIScreen mainScreen].bounds);
        screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
        prevHeightBuilt = 0.0f;
        firstLevel = YES;
        madeBasketHeight = 0.0f;
        
        // Get size of screen
        CGRect screenRect = [UIScreen mainScreen].bounds;
        
        //Set ball start and wall color
        wallColor = [SKColor colorWithRed:0.184 green:0.36 blue:0.431 alpha:1.0];
        
        // Bottom
        SKShapeNode *floor = [SKShapeNode shapeNodeWithRect:CGRectMake(0.0f, 0.0f, CGRectGetWidth(screenRect), 10.0f)];
        floor.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(0.0f, 0.0f, CGRectGetWidth(screenRect), 10.0f)];
        floor.strokeColor = wallColor;
        floor.fillColor = wallColor;
        floor.physicsBody.categoryBitMask = CollisionTypeFloor;
        floor.physicsBody.collisionBitMask = CollisionTypeBall;
        [self addChild:floor];

        // Initialize level with walls and baskets
        [self createNextGameSection];

    }
    return self;
}

-(void)createNextGameSection
{
    // If this is the first time a section is being made, make two
    if (firstLevel) {
        [self drawWall:left_wall];
        [self drawWall:right_wall];
        [self createBasketsforNewSection];
        [self drawWall:left_wall];
        [self drawWall:right_wall];
        [self createBasketsforNewSection];
    }
    else { // just make 1 level
        [self drawWall:left_wall];
        [self drawWall:right_wall];
        [self createBasketsforNewSection];
    }
}

-(void)drawWall:(wallType)wallSide
{
    CGMutablePathRef path = [self createPathWithPoints:0 onWall:wallSide];
    SKShapeNode *wall = [[SKShapeNode alloc] init];
    if (wallSide == left_wall) {
        wall.position = CGPointMake(0, prevHeightBuilt);
    }
    else {
        wall.position = CGPointMake(screenWidth - 10.0f, prevHeightBuilt);
    }
    wall.path = path;
    wall.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:path];
    wall.physicsBody.dynamic = NO;
    wall.physicsBody.categoryBitMask = CollisionTypeWall;
    wall.strokeColor = wallColor;
    wall.fillColor = wallColor;
    [self addChild:wall];
    [self releasePath:path];
}

-(void)createBasketsforNewSection
{
    CGFloat height = prevHeightBuilt;
    CGFloat width = screenWidth;
    [self numBasketsforNextSection]; // set number of baskets for next section
    int d1, d2, d3, d4, maxDistance, side;
    side = random() % 3; // how to position baskets on sides
    maxDistance = (screenHeight - 250) / numBaskets;
    
    // get distances
    if (firstLevel) {
        d1 = random() % maxDistance + 100 + height;
        firstLevel = NO;
    }
    else {
        d1 = random() % 100 + 20 + height;
    }
    d2 = random() % maxDistance + 70 + d1;
    d3 = random() % maxDistance + 70 + d2;
    d4 = random() % maxDistance + 70 + d3;
    
    // If placing 3 baskets in the view
    if (numBaskets == 3) {
        //highest prev basket is right side, so next basket will be left wall
        if(highestBasket == right_wall) {
            // two baskets this side immediately following each other
            if (side == 0) {
                [self addBasketOnWall:left_wall atPosition:CGPointMake(0.0f, d1) withSize:1.5];
                [self addBasketOnWall:right_wall atPosition:CGPointMake(width, d3) withSize:1.5];
                [self addBasketOnWall:left_wall atPosition:CGPointMake(0.0f, d2) withSize:1.5];
                highestBasket = right_wall;
            }
            else if (side == 1) { // alternating baskets
                [self addBasketOnWall:left_wall atPosition:CGPointMake(0.0f, d1) withSize:1.5];
                [self addBasketOnWall:right_wall atPosition:CGPointMake(width, d2) withSize:1.5];
                [self addBasketOnWall:left_wall atPosition:CGPointMake(0.0f, d3) withSize:1.5];
                highestBasket = left_wall;
            }
            else { // two opposite side
                [self addBasketOnWall:left_wall atPosition:CGPointMake(0.0f, d1) withSize:1.5];
                [self addBasketOnWall:right_wall atPosition:CGPointMake(width, d3) withSize:1.5];
                [self addBasketOnWall:right_wall atPosition:CGPointMake(width, d2) withSize:1.5];
                highestBasket = right_wall;
            }
        }
        else { // highest basket is left side, so next basket on right wall
            // two baskets this side immediately following each other
            if (side == 0) {
                [self addBasketOnWall:right_wall atPosition:CGPointMake(width, d1) withSize:1.5];
                [self addBasketOnWall:left_wall atPosition:CGPointMake(0.0f, d3) withSize:1.5];
                [self addBasketOnWall:right_wall atPosition:CGPointMake(width, d2) withSize:1.5];
                highestBasket = left_wall;
            }
            else if (side == 1) { // alternating baskets
                [self addBasketOnWall:right_wall atPosition:CGPointMake(width, d1) withSize:1.5];
                [self addBasketOnWall:left_wall atPosition:CGPointMake(0.0f, d2) withSize:1.5];
                [self addBasketOnWall:right_wall atPosition:CGPointMake(width, d3) withSize:1.5];
                highestBasket = right_wall;
            }
            else { // two opposite side
                [self addBasketOnWall:right_wall atPosition:CGPointMake(width, d1) withSize:1.5];
                [self addBasketOnWall:left_wall atPosition:CGPointMake(0.0f, d3) withSize:1.5];
                [self addBasketOnWall:left_wall atPosition:CGPointMake(0.0f, d2) withSize:1.5];
                highestBasket = left_wall;
            }
        }
    }
    else { // four baskets
        // highest prev basket is right side
        if (highestBasket == right_wall) {
            // two baskets this side immediately following each other, then alternating
            if(side == 0) {
                [self addBasketOnWall:left_wall atPosition:CGPointMake(0.0f, d1) withSize:1.5];
                [self addBasketOnWall:right_wall atPosition:CGPointMake(width, d3) withSize:1.5];
                [self addBasketOnWall:left_wall atPosition:CGPointMake(0.0f, d2) withSize:1.5];
                [self addBasketOnWall:left_wall atPosition:CGPointMake(0.0f, d4) withSize:1.5];
                highestBasket = left_wall;
            }
            else if (side == 1) { // one basket this side, then two opposite side, then one this side
                [self addBasketOnWall:left_wall atPosition:CGPointMake(0.0f, d1) withSize:1.5];
                [self addBasketOnWall:right_wall atPosition:CGPointMake(width, d2) withSize:1.5];
                [self addBasketOnWall:right_wall atPosition:CGPointMake(width, d3) withSize:1.5];
                [self addBasketOnWall:left_wall atPosition:CGPointMake(0.0f, d4) withSize:1.5];
                highestBasket = left_wall;
            }
            else { // alternating
                [self addBasketOnWall:left_wall atPosition:CGPointMake(0.0f, d1) withSize:1.5];
                [self addBasketOnWall:right_wall atPosition:CGPointMake(width, d2) withSize:1.5];
                [self addBasketOnWall:left_wall atPosition:CGPointMake(0.0f, d3) withSize:1.5];
                [self addBasketOnWall:right_wall atPosition:CGPointMake(width, d4) withSize:1.5];
                highestBasket = right_wall;
            }
        }
        else { // highest prev basket was left side
            if(side == 0) {
                [self addBasketOnWall:right_wall atPosition:CGPointMake(width, d1) withSize:1.5];
                [self addBasketOnWall:left_wall atPosition:CGPointMake(0.0f, d3) withSize:1.5];
                [self addBasketOnWall:right_wall atPosition:CGPointMake(width, d2) withSize:1.5];
                [self addBasketOnWall:right_wall atPosition:CGPointMake(width, d4) withSize:1.5];
                highestBasket = right_wall;
            }
            else if (side == 1) { // one basket this side, then two opposite side, then one this side
                [self addBasketOnWall:right_wall atPosition:CGPointMake(width, d1) withSize:1.5];
                [self addBasketOnWall:left_wall atPosition:CGPointMake(0.0f, d2) withSize:1.5];
                [self addBasketOnWall:left_wall atPosition:CGPointMake(0.0f, d3) withSize:1.5];
                [self addBasketOnWall:right_wall atPosition:CGPointMake(width, d4) withSize:1.5];
                highestBasket = right_wall;
            }
            else { // alternating
                [self addBasketOnWall:right_wall atPosition:CGPointMake(width, d1) withSize:1.5];
                [self addBasketOnWall:left_wall atPosition:CGPointMake(0.0f, d2) withSize:1.5];
                [self addBasketOnWall:right_wall atPosition:CGPointMake(width, d3) withSize:1.5];
                [self addBasketOnWall:left_wall atPosition:CGPointMake(0.0f, d4) withSize:1.5];
                highestBasket = left_wall;
            }
        }
    }
    prevHeightBuilt = prevHeightBuilt + screenHeight;
}

-(void)addBasketOnWall:(wallType)wall
            atPosition:(CGPoint)position
              withSize:(CGFloat)size
{
    size = size + ((float)rand()/RAND_MAX/2);
    Basket *aBasket = [Basket createBasketOnWall:wall withColor:wallColor andOffset:30.0f andSize:size];
    aBasket.position = position;
    [self addChild:aBasket];
    
}

/* Randomly sets number of baskets for Next section */
-(void)numBasketsforNextSection
{
    // most baskets in one screen is 4, least is 2
    numBaskets = random() % 2 + 3;
}


/* creates a path with number of visible "jutting out" points */
-(CGMutablePathRef)createPathWithPoints:(int)numPoints
                                 onWall:(wallType)wall
{
    // This will somehow need to be procedurally done
    int totalPoints = numPoints + 4;
    CGPoint points[totalPoints];
    int h = prevHeightBuilt;
    h++;// inc for correct generation
    
    if(wall == left_wall) {
        for(int i = 0; i < numPoints; i++) {
            //points[i] = CGPointMake(25.0f + i*5.0f, (screenHeight+prevHeightBuilt)/2.0f + i*50.0f));
        }
        points[totalPoints-4] = CGPointMake(10.0f, (screenHeight));
        points[totalPoints-3] = CGPointMake(0.0f, (screenHeight));
        points[totalPoints-2] = CGPointMake(0.0f, 0.0f);
        points[totalPoints-1] = CGPointMake(10.0f, 0.0f);
    }
    else { // Right wall
        for(int i = 0; i < numPoints; i++) {
            //points[i] = CGPointMake(screenWidth - 25.0f - i*10.0f, (screenHeight/2.0 - 80.0f + i*70.0f));
        }
        points[totalPoints-4] = CGPointMake(10.0f, (screenHeight));
        points[totalPoints-3] = CGPointMake(0.0f, (screenHeight));
        points[totalPoints-2] = CGPointMake(0.0f, 0.0f);
        points[totalPoints-1] = CGPointMake(10.0f, 0.0f);
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

@end






