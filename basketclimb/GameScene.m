//
//  GameScene.m
//  basketclimb
//
//  Created by Noah Lemen on 11/11/14.
//  Copyright (c) 2014 nyu.edu. All rights reserved.
//

#import "GameScene.h"
#import "Map.h"

const float FORCE_MULT = 2;
const float MIN_INPUT = 35.0;

@implementation GameScene{
    CGPoint touchBegan;
    CGPoint touchEnd;
    SKShapeNode *touchline;
    SKShapeNode *touchline2;
    float basketHeight;
}

-(id)initWithSize:(CGSize)size {
    if(self = [super initWithSize:size]){
        // Set background color and gravity
        self.backgroundColor = [SKColor colorWithRed:0.769 green:0.945 blue:1.0 alpha:1.0];
        self.physicsWorld.gravity = CGVectorMake(0.0f, -9.8f);
        
        // Add node for game world
        self.world = [SKNode node];
        
        // Initialize and set-up the map node
        self.map = [[Map alloc] init];
        //[self.map addBasketOnWall:left_wall atPosition:CGPointMake(0.0f, CGRectGetHeight(self.frame)) withSize:1.5];
        
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
        
        [self.world addChild:self.map];
        [self.world addChild:self.camera];
        [self addChild:self.world];
        
        self.anchorPoint = CGPointMake(.5, .5);
        
        [self centerOnNode:self.camera];
        
    }
    return self;
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
        [self.ball.physicsBody applyForce:CGVectorMake(force.x, force.y)];
    }
        
    // TO DO: disable touching until ball stops moving
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    if ([self.ball isResting]){
        // go above ball if its resting
        float ydistance = self.ball.position.y - self.camera.position.y + self.frame.size.height*.45;
        self.camera.position = CGPointMake(self.camera.position.x, (float)MAX(self.camera.position.y + ydistance *.1, self.frame.size.height/2));
    }else{
        float ydistance = self.ball.position.y - self.camera.position.y;
        if (fabsf(ydistance) > self.frame.size.height/3){
            self.camera.position = CGPointMake(self.camera.position.x, (float)MAX(self.camera.position.y + ydistance *.05, self.frame.size.height/2));
        }
    }

}

-(void)didFinishUpdate{
    [self centerOnNode: self.camera];
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


-(void)extendMap
{
    // call 
}

@end
