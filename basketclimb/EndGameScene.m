//
//  EndGameScene.m
//  Basket Climb
//
//  Created by Tom Longabaugh on 12/8/14.
//  Copyright (c) 2014 nyu.edu. All rights reserved.
//

#import "EndGameScene.h"
#import "GameState.h"
#import "GameScene.h"

@implementation EndGameScene

- (id) initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor colorWithRed:0.769 green:0.945 blue:1.0 alpha:1.0];
        
        // Score
        SKLabelNode *score = [SKLabelNode labelNodeWithFontNamed:@"Futura-Medium"];
        score.fontSize = 60;
        score.fontColor = [SKColor colorWithRed:0.184 green:0.36 blue:0.431 alpha:1.0];;
        score.position = CGPointMake(160, 300);
        score.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        [score setText:[NSString stringWithFormat:@"%d", [GameState sharedInstance].score]];
        [self addChild:score];
        
        // High Score
        SKLabelNode *highScore = [SKLabelNode labelNodeWithFontNamed:@"Futura-Medium"];
        highScore.fontSize = 30;
        highScore.fontColor = [SKColor colorWithRed:0.184 green:0.36 blue:0.431 alpha:1.0];;
        highScore.position = CGPointMake(160, 150);
        highScore.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        [highScore setText:[NSString stringWithFormat:@"High Score: %d", [GameState sharedInstance].highScore]];
        [self addChild:highScore];
        
        // Try again
        SKLabelNode *tryAgain = [SKLabelNode labelNodeWithFontNamed:@"Futura-Medium"];
        tryAgain.fontSize = 30;
        tryAgain.fontColor = [SKColor blackColor];
        tryAgain.position = CGPointMake(160, 50);
        tryAgain.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        [tryAgain setText:@"Tap To Try Again"];
        [self addChild:tryAgain];
    }
    return self;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Transition back to the Game
    SKScene *myScene = [[GameScene alloc] initWithSize:self.size];
    SKTransition *reveal = [SKTransition fadeWithDuration:0.5];
    [self.view presentScene:myScene transition:reveal];
}

@end
