//
//  GameScene.m
//  basketclimb
//
//  Created by Noah Lemen on 11/11/14.
//  Copyright (c) 2014 nyu.edu. All rights reserved.
//

#import "GameScene.h"

const float FORCE_MULT = 1.5;
const float MIN_INPUT = 35.0;
const float SWIPE_FORCE = 2.0;

@interface GameScene() <SKPhysicsContactDelegate>

@end

@implementation GameScene
{
    CGPoint touchBegan;
    CGPoint touchEnd;
    SKShapeNode *touchline;
    SKShapeNode *touchline2;
    SKLabelNode *score;
    BOOL canShoot;
    BOOL canSwipe;
    BOOL gameOver;
}

-(id)initWithSize:(CGSize)size {
    if(self = [super initWithSize:size]){
        // Set background color and gravity
        self.backgroundColor = [SKColor colorWithRed:0.769 green:0.945 blue:1.0 alpha:1.0];
        self.physicsWorld.gravity = CGVectorMake(0.0f, -9.8f);
        [GameState sharedInstance].score = 0;
        gameOver = NO;
        
        /*
        score = [SKLabelNode labelNodeWithFontNamed:@"Futura-Medium"];
        score.fontSize = 30;
        score.fontColor = [SKColor colorWithRed:0.184 green:0.36 blue:0.431 alpha:1.0];
        score.position = CGPointMake(CGRectGetWidth(self.frame)-20.0f, CGRectGetHeight(self.frame)-40);
        score.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
        [score setText:@"0"];
        [self addChild:score];*/
        
        // Add node for game world
        self.world = [SKNode node];
        
        // Initialize and set-up the map node
        self.map = [[Map alloc] init];
        
        self.camera = [SKNode node];
        self.camera.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        
        // Create ball
        self.ball = [[Ball alloc] init];
        self.ball.xScale = .25;
        self.ball.yScale = .25;
        self.ball.name = @"ball";
        self.ball.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self.world addChild:self.ball];
        self.ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.ball.frame.size.width/2.5];
        self.ball.physicsBody.allowsRotation = NO;
        self.ball.physicsBody.categoryBitMask = CollisionTypeBall;
        self.ball.physicsBody.contactTestBitMask = CollisionTypeBasket;
        
        [self.world addChild:self.map];
        [self.world addChild:self.camera];
        [self addChild:self.world];
        
        self.anchorPoint = CGPointMake(.5, .5);
        
        [self centerOnNode:self.camera];
        
        self.physicsWorld.contactDelegate = self;
    }
    return self;
}
/*
-(void)startNewGame {
    // Set background color and gravity
    self.backgroundColor = [SKColor colorWithRed:0.769 green:0.945 blue:1.0 alpha:1.0];
    self.physicsWorld.gravity = CGVectorMake(0.0f, -9.8f);
    
    // Add node for game world
    self.world = [SKNode node];
    
    // Initialize and set-up the map node
    self.map = [[Map alloc] init];
    
    self.camera = [SKNode node];
    self.camera.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    
    // Create ball
    self.ball = [[Ball alloc] init];
    self.ball.xScale = .25;
    self.ball.yScale = .25;
    self.ball.name = @"ball";
    self.ball.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self.world addChild:self.ball];
    self.ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.ball.frame.size.width/2.5];
    self.ball.physicsBody.allowsRotation = NO;
    self.ball.physicsBody.categoryBitMask = CollisionTypeBall;
    self.ball.physicsBody.contactTestBitMask = CollisionTypeBasket;
    
    [self.world addChild:self.map];
    [self.world addChild:self.camera];
    [self addChild:self.world];
    
    self.anchorPoint = CGPointMake(.5, .5);
    
    [self centerOnNode:self.camera];
    
    self.physicsWorld.contactDelegate = self;
}*/


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    canShoot = [self.ball isResting] ? YES : NO;
    
    UITouch *touch = [touches anyObject];
    touchBegan = [touch locationInNode:self];
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInNode:self];
    
    if (canSwipe) {
        GLKVector2 direction = GLKVector2Normalize(GLKVector2Make(touchPoint.x - touchBegan.x, touchPoint.y - touchBegan.y));
        GLKVector2 force = GLKVector2MultiplyScalar(direction, SWIPE_FORCE);
        if (direction.y <= 0) self.ball.physicsBody.velocity = CGVectorMake(0, 0);
        [self.ball.physicsBody applyImpulse:CGVectorMake(force.x, force.y)];
        canSwipe = NO;
        return;
    }
    else if (!canShoot) return;
    

    [touchline removeFromParent];
    [touchline2 removeFromParent];
    [[self childNodeWithName:@"arrow"] removeFromParent];
    
    float distance = [self distanceFrom:touchBegan to:touchPoint];
    
    if (distance > MIN_INPUT){
        
        distance = (distance > self.frame.size.height/3) ? self.frame.size.height/3 : distance;
        
        SKSpriteNode *arrow = [SKSpriteNode spriteNodeWithImageNamed:@"arrow"];
        
        GLKVector2 direction = GLKVector2Normalize(GLKVector2Make(touchPoint.x - touchBegan.x, touchPoint.y - touchBegan.y));
        GLKVector2 frontLineBegin =  GLKVector2Subtract(GLKVector2Make(touchBegan.x, touchBegan.y), GLKVector2MultiplyScalar(direction, MIN_INPUT-20));
        GLKVector2 backLineBegin = GLKVector2Add(GLKVector2Make(touchBegan.x, touchBegan.y), GLKVector2MultiplyScalar(direction, MIN_INPUT-20));
        
        CGMutablePathRef pathToDraw = CGPathCreateMutable();
        CGPathMoveToPoint(pathToDraw, NULL, frontLineBegin.x, frontLineBegin.y);
        GLKVector2 frontLineEnd = GLKVector2Add(GLKVector2Make(touchBegan.x, touchBegan.y), GLKVector2MultiplyScalar(direction, -distance));
        CGPathAddLineToPoint(pathToDraw, NULL, frontLineEnd.x, frontLineEnd.y);
        CGPathCloseSubpath(pathToDraw);
        
        CGMutablePathRef pathToDraw2 = CGPathCreateMutable();
        CGPathMoveToPoint(pathToDraw2, NULL, backLineBegin.x, backLineBegin.y);
        GLKVector2 backLineEnd = GLKVector2Add(GLKVector2Make(touchBegan.x, touchBegan.y), GLKVector2MultiplyScalar(direction, distance));
        CGPathAddLineToPoint(pathToDraw2, NULL, backLineEnd.x, backLineEnd.y);
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
        
        arrow.position = CGPointMake(frontLineEnd.x,
                                    frontLineEnd.y);
        arrow.xScale = .5f;
        arrow.yScale = .5f;
        arrow.zRotation = atan2f(direction.y, direction.x);
        
        arrow.name = @"arrow";
        [self addChild:arrow];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if (!canShoot) return;
    
    [touchline removeFromParent];
    [touchline2 removeFromParent];
    [[self childNodeWithName:@"arrow"] removeFromParent];
    
    UITouch *touch = [touches anyObject];
    touchEnd = [touch locationInNode:self];
    
    float distance = [self distanceFrom:touchBegan to:touchEnd];
    if (distance > MIN_INPUT){
        distance = (distance > self.frame.size.height/3) ? self.frame.size.height/3 : distance;
        GLKVector2 direction = GLKVector2Normalize(GLKVector2Make(touchEnd.x - touchBegan.x, touchEnd.y - touchBegan.y));
        float magnitude = -FORCE_MULT * powf(distance,.3);
        GLKVector2 force = GLKVector2MultiplyScalar(direction, magnitude);
        [self.ball.physicsBody applyImpulse:CGVectorMake(force.x, force.y)];
        canSwipe = YES;
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    if ([self.ball isResting]){
        canSwipe = NO;
        // go above ball if its resting
        float ydistance = self.ball.position.y - self.camera.position.y + self.frame.size.height*.45;
        self.camera.position = CGPointMake(self.camera.position.x, (float)MAX(self.camera.position.y + ydistance *.1, self.frame.size.height/2));
    }else{
        float ydistance = self.ball.position.y - self.camera.position.y;
        float distanceFromRest = self.ball.position.y - self.ball.lastRestingPosition.y;
        if (fabsf(ydistance) > self.frame.size.height/3
            && ((distanceFromRest > self.frame.size.height/3 && self.ball.physicsBody.velocity.dy > 0)
                || (self.ball.physicsBody.velocity.dy < 0))){
            self.camera.position = CGPointMake(self.camera.position.x, (float)MAX(self.camera.position.y + ydistance *.05, self.frame.size.height/2));
        }
    }

}

-(void)didFinishUpdate{
    if (gameOver) {
        return;
    }
    // Update camera
    [self centerOnNode: self.camera];
    
    //Check to see if a basket has been made (completed)
    if (self.ball.touchingBasket && [self.ball isResting]) {
        self.ball.basketMade = YES;
        self.ball.touchingBasket = NO; /* This is kinda dumb, it's still touching basket 
                                        but need to turn off so this doesn't get called again. */
        
        // Generate more map if we've moved up half a screen height since last level generation
        self.map.currBasketHeight = self.ball.position.y;
        [GameState sharedInstance].score += round(self.map.currBasketHeight / 19.0f);
        if ((self.map.currBasketHeight - self.map.madeBasketHeight) > self.map.screenHeight/2.0f) {
            [self generateHigherMap];
            
            // Delete nodes that are two "levels" down
            [self.map enumerateChildNodesWithName:@"*" usingBlock:^(SKNode *node, BOOL *stop) {
                if (node.position.y < (self.map.currBasketHeight - self.map.screenHeight*2.0f)) {
                    [node removeFromParent];
                }
            }];
        }
    }
    
    // Check to see if ball has fallen too far and player dies
    if(self.ball.touchingBasket == NO && self.ball.position.y < self.map.madeBasketHeight - self.map.screenHeight) {
        [self endGame];
    }
}

-(float)distanceFrom:(CGPoint)from to:(CGPoint)to{
    float dx = to.x - from.x;
    float dy = to.y - from.y;
    return sqrtf(dx*dx + dy*dy);
}

-(void)didSimulatePhysics{
    
}

-(void) centerOnNode:(SKNode *)node{
    CGPoint cameraPositionInScene = [node.scene convertPoint:node.position fromNode:node.parent];
    node.parent.position = CGPointMake(node.parent.position.x - cameraPositionInScene.x, node.parent.position.y - cameraPositionInScene.y);
}


-(void)generateHigherMap
{
    // Create next game section and set madeBasketheight to current basket height
    [self.map createNextGameSection];
    self.map.madeBasketHeight = self.map.currBasketHeight;
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody *firstBody, *secondBody;
    
    // Set bodies
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    // IF one body is the basket and the other is the ball, do something
    if ((firstBody.categoryBitMask & CollisionTypeBasket) != 0 && (secondBody.categoryBitMask & CollisionTypeBall) != 0)
    {
        // set ball touching basket
        self.ball.touchingBasket = YES;
    }
}

-(void)didEndContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody *firstBody, *secondBody;
    
    // Set bodies
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    // IF one body is the basket and the other is the ball, do something
    if ((firstBody.categoryBitMask & CollisionTypeBasket) != 0 && (secondBody.categoryBitMask & CollisionTypeBall) != 0)
    {
        // set ball no longer touching basket
        self.ball.touchingBasket = NO;
        self.ball.basketMade = NO;
    }
}

- (void) endGame
{
    // 1
    gameOver = YES;
    
    // 2
    // Save stars and high score
    [[GameState sharedInstance] saveState];
    
    // 3
    SKScene *endGameScene = [[EndGameScene alloc] initWithSize:self.size];
    SKTransition *reveal = [SKTransition fadeWithDuration:0.5];
    [self.view presentScene:endGameScene transition:reveal];
}

@end
