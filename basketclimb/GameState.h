//
//  GameState.h
//  Basket Climb
//
//  Created by Tom Longabaugh on 12/8/14.
//  Copyright (c) 2014 nyu.edu. All rights reserved.
//
// This class is modified from the www.raywenderlich.com/63578/make-game-like-mega-jump-spritekit-part-22 tutorial

#import <Foundation/Foundation.h>

@interface GameState : NSObject
@property (nonatomic, assign) int score;
@property (nonatomic, assign) int highScore;

+ (instancetype)sharedInstance;

-(void)saveState;

@end
