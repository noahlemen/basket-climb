//
//  SoundManager.h
//  Basket Climb
//
//  Created by Tom Longabaugh on 12/15/14.
//  Copyright (c) 2014 nyu.edu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface SoundManager : NSObject {
    AVAudioPlayer *audioPlayer;
}

+(id)sharedManager;

// Plays a sound
-(void)playSound:(NSString *)fileName ofType:(NSString *)type;

-(void)stopSound;

@end