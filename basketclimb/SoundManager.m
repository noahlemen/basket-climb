//
//  SoundManager.m
//  Basket Climb
//
//  Created by Tom Longabaugh on 12/15/14.
//  Copyright (c) 2014 nyu.edu. All rights reserved.
//

#import "SoundManager.h"

@implementation SoundManager

+ (id)sharedManager {
    //Singleton setup
    static SoundManager *sharedSoundManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSoundManager = [[self alloc] init];
    });
    return sharedSoundManager;
}

-(void)stopSound{
    [audioPlayer stop];
}

-(void)playSound:(NSString *)fileName ofType:(NSString *)type {
    // Only play if nothing is playing
    if ([audioPlayer isPlaying]) {
        return;
    }
    // Create URL, play sound once
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:fileName ofType:type]];
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    audioPlayer.numberOfLoops = 0;
    [audioPlayer play];
}

@end


