//
//  GameScene.m
//  basketclimb
//
//  Created by Noah Lemen on 11/11/14.
//  Copyright (c) 2014 nyu.edu. All rights reserved.
//

#import "GameScene.h"
const float FORCE_MULT = .2;

@implementation GameScene{
    CGPoint touchBegan;
    CGPoint touchEnd;
    SKShapeNode *touchline;
    SKShapeNode *touchline2;
}


-(void)didMoveToView:(SKView *)view {
    
    self.physicsWorld.gravity = CGVectorMake(0.0f, -9.8f);

    self.backgroundColor = [SKColor colorWithRed:0.769 green:0.945 blue:1.0 alpha:1.0];
    
    SKPhysicsBody* borderBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsBody = borderBody;
    self.physicsBody.friction = 0.5f;
    
    SKSpriteNode *ball = [SKSpriteNode spriteNodeWithImageNamed:@"ball"];
    ball.xScale = .25;
    ball.yScale = .25;
    ball.name = @"ball";
    ball.position = CGPointMake(CGRectGetMidX(self.frame),
                                CGRectGetMidY(self.frame));
    [self addChild:ball];
    
    ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ball.frame.size.width/2];
    ball.physicsBody.allowsRotation = NO;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    UITouch *touch = [touches anyObject];
    touchBegan = [touch locationInNode:self];
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInNode:self];
    
    // TODO: establish minimum magnitude of toss, offset line indicators from touch point by that amount ?
    // offset will need to be circular, remember to use RMS if needed - also subtract that offset from the length of the indicator?
    // ideally if touching at or less than minimal magnitude, no lines are shown
    
    if ([self childNodeWithName:@"ball"].physicsBody.resting){
        [touchline removeFromParent];
        [touchline2 removeFromParent];
        
        CGMutablePathRef pathToDraw = CGPathCreateMutable();
        CGPathMoveToPoint(pathToDraw, NULL, touchBegan.x, touchBegan.y);
        CGPathAddLineToPoint(pathToDraw, NULL, 2*touchBegan.x-touchPoint.x, 2*touchBegan.y-touchPoint.y);
        CGPathCloseSubpath(pathToDraw);
        
        CGMutablePathRef pathToDraw2 = CGPathCreateMutable();
        CGPathMoveToPoint(pathToDraw2, NULL, touchBegan.x, touchBegan.y);
        CGPathAddLineToPoint(pathToDraw2, NULL, touchPoint.x, touchPoint.y);
        CGPathCloseSubpath(pathToDraw2);
        
        touchline = [SKShapeNode node];
        touchline.lineWidth = 3;
        touchline.path = pathToDraw;
        CGPathRelease(pathToDraw);
        [touchline setStrokeColor:[UIColor whiteColor]];
        [self addChild:touchline];
        
        touchline2 = [SKShapeNode node];
        touchline2.path = pathToDraw2;
        CGPathRelease(pathToDraw2);
        [touchline2 setStrokeColor:[UIColor colorWithWhite:1 alpha:.5]];
        [self addChild:touchline2];
    }
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if ([self childNodeWithName:@"ball"].physicsBody.resting){
        [touchline removeFromParent];
        [touchline2 removeFromParent];
        UITouch *touch = [touches anyObject];
        touchEnd = [touch locationInNode:self];
        [[self childNodeWithName:@"ball"].physicsBody applyForce:CGVectorMake((touchBegan.x-touchEnd.x)*FORCE_MULT, (touchBegan.y-touchEnd.y)*FORCE_MULT)];
    }
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
}

@end
