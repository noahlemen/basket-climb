//
//  GameScene.m
//  basketclimb
//
//  Created by Noah Lemen on 11/11/14.
//  Copyright (c) 2014 nyu.edu. All rights reserved.
//

#import "GameScene.h"
const float FORCE_MULT = 0.2;
const float MIN_INPUT = 35.0;

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
    
    ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ball.frame.size.width/2.5];
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
    

    [touchline removeFromParent];
    [touchline2 removeFromParent];
    [[self childNodeWithName:@"arrow"] removeFromParent];
    
    
    if ([self distanceFrom:touchBegan to:touchPoint] > MIN_INPUT){
        
        SKSpriteNode *arrow = [SKSpriteNode spriteNodeWithImageNamed:@"arrow"];
        
        GLKVector2 direction = GLKVector2Normalize(GLKVector2Make(touchPoint.x - touchBegan.x, touchPoint.y - touchBegan.y));
        GLKVector2 frontLineBegin =  GLKVector2Subtract(GLKVector2Make(touchBegan.x, touchBegan.y), GLKVector2MultiplyScalar(direction, MIN_INPUT-20));
        GLKVector2 backLineBegin = GLKVector2Add(GLKVector2Make(touchBegan.x, touchBegan.y), GLKVector2MultiplyScalar(direction, MIN_INPUT-20));
        
        CGMutablePathRef pathToDraw = CGPathCreateMutable();
        CGPathMoveToPoint(pathToDraw, NULL, frontLineBegin.x, frontLineBegin.y);
        CGPathAddLineToPoint(pathToDraw, NULL, 2*touchBegan.x-touchPoint.x, 2*touchBegan.y-touchPoint.y);
        CGPathCloseSubpath(pathToDraw);
        
        CGMutablePathRef pathToDraw2 = CGPathCreateMutable();
        CGPathMoveToPoint(pathToDraw2, NULL, backLineBegin.x, backLineBegin.y);
        CGPathAddLineToPoint(pathToDraw2, NULL, touchPoint.x, touchPoint.y);
        CGPathCloseSubpath(pathToDraw2);
        
        touchline = [SKShapeNode node];
        touchline.lineWidth = 1;
        touchline.path = pathToDraw;
        CGPathRelease(pathToDraw);
        [touchline setStrokeColor:[UIColor blackColor]];
        [self addChild:touchline];
        
        touchline2 = [SKShapeNode node];
        touchline2.path = pathToDraw2;
        CGPathRelease(pathToDraw2);
        [touchline2 setStrokeColor:[UIColor colorWithWhite:0 alpha:.1]];
        [self addChild:touchline2];
        
        arrow.position = CGPointMake(2*touchBegan.x-touchPoint.x,
                                    2*touchBegan.y-touchPoint.y);
        arrow.xScale = .5f;
        arrow.yScale = .5f;
        arrow.zRotation = atan2f(direction.y, direction.x);
        
        arrow.name = @"arrow";
        [self addChild:arrow];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [touchline removeFromParent];
    [touchline2 removeFromParent];
    [[self childNodeWithName:@"arrow"] removeFromParent];
    
    UITouch *touch = [touches anyObject];
    touchEnd = [touch locationInNode:self];
    
    float distance = [self distanceFrom:touchBegan to:touchEnd];
    if (distance > MIN_INPUT){
        GLKVector2 direction = GLKVector2Normalize(GLKVector2Make(touchEnd.x - touchBegan.x, touchEnd.y - touchBegan.y));
        GLKVector2 force = GLKVector2MultiplyScalar(direction, FORCE_MULT * -distance);
        [[self childNodeWithName:@"ball"].physicsBody applyForce:CGVectorMake(force.x, force.y)];
    }
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
}

-(float)distanceFrom:(CGPoint)from to:(CGPoint)to{
    float dx = to.x - from.x;
    float dy = to.y - from.y;
    return sqrtf(dx*dx + dy*dy);
}


@end
