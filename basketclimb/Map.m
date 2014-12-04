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
    wallType highestBasket;
    CGFloat screenHeight;
}

- (id) init
{
    if (( self = [super init] ))
    {
        // Seed numBaskets for procedural generation
        srandom(time(NULL));
        highestBasket = random() % 2;
        screenHeight = CGRectGetHeight([UIScreen mainScreen].bounds);
        
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
        CGMutablePathRef leftPath = [self createPathWithPoints:0 andScreenBounds:screenRect onWall:left_wall];
        SKShapeNode *leftWall = [[SKShapeNode alloc] init];
        leftWall.path = leftPath;
        leftWall.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:leftPath];
        leftWall.physicsBody.dynamic = NO;
        leftWall.strokeColor = wallColor;
        leftWall.fillColor = wallColor;
        [self addChild:leftWall];
        
        // Right Wall
        CGMutablePathRef rightPath = [self createPathWithPoints:0 andScreenBounds:screenRect onWall:right_wall];
        SKShapeNode *rightWall = [[SKShapeNode alloc] init];
        rightWall.path = rightPath;
        rightWall.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:rightPath];
        rightWall.physicsBody.dynamic = NO;
        rightWall.strokeColor = wallColor;
        rightWall.fillColor = wallColor;
        [self addChild:rightWall];
        
        [self createBasketsforNextSection];
        //[self addBasketOnWall:left_wall atPosition:CGPointMake(0.0f, CGRectGetMidY(screenRect)) withSize:1.5];
        //[self addBasketOnWall:right_wall atPosition:CGPointMake(CGRectGetWidth(screenRect), CGRectGetMidY(screenRect)+250) withSize:1.5];
        
    }
    return self;
}

/* creates a path with number of visible "jutting out" points */
-(CGMutablePathRef)createPathWithPoints:(int)numPoints
                        andScreenBounds:(CGRect)screenRect
                             onWall:(wallType)wall
{
    
    // This will somehow need to be procedurally done
    int totalPoints = numPoints + 4;
    CGPoint points[totalPoints];
    
    if(wall == left_wall) {
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
    Basket *aBasket = [Basket createBasketOnWall:wall withColor:wallColor andOffset:30.0f andSize:size];
    aBasket.position = position;
    [self addChild:aBasket];
    
}

-(void)createNextGameSection
{
    
}


-(void)createBasketsforNextSection
{
    [self numBasketsforNextSection]; // set number of baskets for next section
    CGRect screenRect = [UIScreen mainScreen].bounds; // size of screen
    //CGFloat screenHeight =
    int d1, d2, d3, d4, maxDistance, side;
    
    // Calculate distance
    maxDistance = (screenHeight - 250) / numBaskets;
    side = random() % 3;
    
    // If placing 3 baskets in the view
    if (numBaskets == 3) {
        d1 = random() % maxDistance + 100;
        d2 = random() % maxDistance + 70 + d1;
        d3 = random() % maxDistance + 70 + d2;
        //highest prev basket is right side, so next basket will be left wall
        if(highestBasket == right_wall) {
            // two baskets this side immediately following each other
            if (side == 0) {
                [self addBasketOnWall:left_wall atPosition:CGPointMake(0.0f, d1) withSize:1.5];
                [self addBasketOnWall:right_wall atPosition:CGPointMake(CGRectGetWidth(screenRect), d3) withSize:1.5];
                [self addBasketOnWall:left_wall atPosition:CGPointMake(0.0f, d2) withSize:1.5];
                highestBasket = right_wall;
            }
            else if (side == 1) { // alternating baskets
                [self addBasketOnWall:left_wall atPosition:CGPointMake(0.0f, d1) withSize:1.5];
                [self addBasketOnWall:right_wall atPosition:CGPointMake(CGRectGetWidth(screenRect), d2) withSize:1.5];
                [self addBasketOnWall:left_wall atPosition:CGPointMake(0.0f, d3) withSize:1.5];
                highestBasket = left_wall;
            }
            else { // two opposite side
                [self addBasketOnWall:left_wall atPosition:CGPointMake(0.0f, d1) withSize:1.5];
                [self addBasketOnWall:right_wall atPosition:CGPointMake(CGRectGetWidth(screenRect), d3) withSize:1.5];
                [self addBasketOnWall:right_wall atPosition:CGPointMake(CGRectGetWidth(screenRect), d2) withSize:1.5];
                highestBasket = right_wall;
            }
        }
        else { // highest basket is left side, so next basket on right wall
            // two baskets this side immediately following each other
            if (side == 0) {
                [self addBasketOnWall:right_wall atPosition:CGPointMake(CGRectGetWidth(screenRect), d1) withSize:1.5];
                [self addBasketOnWall:left_wall atPosition:CGPointMake(0.0f, d3) withSize:1.5];
                [self addBasketOnWall:right_wall atPosition:CGPointMake(CGRectGetWidth(screenRect), d2) withSize:1.5];
                highestBasket = left_wall;
            }
            else if (side == 1) { // alternating baskets
                [self addBasketOnWall:right_wall atPosition:CGPointMake(CGRectGetWidth(screenRect), d1) withSize:1.5];
                [self addBasketOnWall:left_wall atPosition:CGPointMake(0.0f, d2) withSize:1.5];
                [self addBasketOnWall:right_wall atPosition:CGPointMake(CGRectGetWidth(screenRect), d3) withSize:1.5];
                highestBasket = right_wall;
            }
            else { // two opposite side
                [self addBasketOnWall:right_wall atPosition:CGPointMake(CGRectGetWidth(screenRect), d1) withSize:1.5];
                [self addBasketOnWall:left_wall atPosition:CGPointMake(0.0f, d3) withSize:1.5];
                [self addBasketOnWall:left_wall atPosition:CGPointMake(0.0f, d2) withSize:1.5];
                highestBasket = left_wall;
            }
        }
    }
    else { // four baskets
        d1 = random() % maxDistance + 100;
        d2 = random() % maxDistance + 70 + d1;
        d3 = random() % maxDistance + 70 + d2;
        d4 = random() % maxDistance + 70 + d3;
        // highest prev basket is right side
        if (highestBasket == right_wall) {
            // two baskets this side immediately following each other, then alternating
            if(side == 0) {
                [self addBasketOnWall:left_wall atPosition:CGPointMake(0.0f, d1) withSize:1.5];
                [self addBasketOnWall:right_wall atPosition:CGPointMake(CGRectGetWidth(screenRect), d3) withSize:1.5];
                [self addBasketOnWall:left_wall atPosition:CGPointMake(0.0f, d2) withSize:1.5];
                [self addBasketOnWall:left_wall atPosition:CGPointMake(0.0f, d4) withSize:1.5];
                highestBasket = left_wall;
            }
            else if (side == 1) { // one basket this side, then two opposite side, then one this side
                [self addBasketOnWall:left_wall atPosition:CGPointMake(0.0f, d1) withSize:1.5];
                [self addBasketOnWall:right_wall atPosition:CGPointMake(CGRectGetWidth(screenRect), d2) withSize:1.5];
                [self addBasketOnWall:right_wall atPosition:CGPointMake(CGRectGetWidth(screenRect), d3) withSize:1.5];
                [self addBasketOnWall:left_wall atPosition:CGPointMake(0.0f, d4) withSize:1.5];
                highestBasket = left_wall;
            }
            else { // alternating
                [self addBasketOnWall:left_wall atPosition:CGPointMake(0.0f, d1) withSize:1.5];
                [self addBasketOnWall:right_wall atPosition:CGPointMake(CGRectGetWidth(screenRect), d2) withSize:1.5];
                [self addBasketOnWall:left_wall atPosition:CGPointMake(0.0f, d3) withSize:1.5];
                [self addBasketOnWall:right_wall atPosition:CGPointMake(CGRectGetWidth(screenRect), d4) withSize:1.5];
                highestBasket = right_wall;
            }
        }
        else { // highest prev basket was left side
            if(side == 0) {
                [self addBasketOnWall:right_wall atPosition:CGPointMake(CGRectGetWidth(screenRect), d1) withSize:1.5];
                [self addBasketOnWall:left_wall atPosition:CGPointMake(0.0f, d3) withSize:1.5];
                [self addBasketOnWall:right_wall atPosition:CGPointMake(CGRectGetWidth(screenRect), d2) withSize:1.5];
                [self addBasketOnWall:right_wall atPosition:CGPointMake(CGRectGetWidth(screenRect), d4) withSize:1.5];
                highestBasket = right_wall;
            }
            else if (side == 1) { // one basket this side, then two opposite side, then one this side
                [self addBasketOnWall:right_wall atPosition:CGPointMake(CGRectGetWidth(screenRect), d1) withSize:1.5];
                [self addBasketOnWall:left_wall atPosition:CGPointMake(0.0f, d2) withSize:1.5];
                [self addBasketOnWall:left_wall atPosition:CGPointMake(0.0f, d3) withSize:1.5];
                [self addBasketOnWall:right_wall atPosition:CGPointMake(CGRectGetWidth(screenRect), d4) withSize:1.5];
                highestBasket = right_wall;
            }
            else { // alternating
                [self addBasketOnWall:right_wall atPosition:CGPointMake(CGRectGetWidth(screenRect), d1) withSize:1.5];
                [self addBasketOnWall:left_wall atPosition:CGPointMake(0.0f, d2) withSize:1.5];
                [self addBasketOnWall:right_wall atPosition:CGPointMake(CGRectGetWidth(screenRect), d3) withSize:1.5];
                [self addBasketOnWall:left_wall atPosition:CGPointMake(0.0f, d4) withSize:1.5];
                highestBasket = left_wall;
            }
        }
    }
    
}

/* Randomly sets number of baskets for Next section */
-(void)numBasketsforNextSection
{
    // most baskets in one screen is 4, least is 2
    numBaskets = random() % 2 + 3;
}

@end






