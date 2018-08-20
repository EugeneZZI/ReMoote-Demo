//
//  RCMacState.h
//  MacServer
//
//  Created by Eugene Zozulya on 12/9/14.
//  Copyright (c) 2014 Eugene Zozulya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCMacState : NSObject

- (float)getCurrentSystemVolumeValue;
- (BOOL)isSystemVolumeMuted;
- (BOOL)setNewSystemVolumeValue:(float)newValue;
- (void)muteSystemVolume;
- (void)unmuteSystemVolume;
- (void)sleepSystem;
- (void)shutdownSystem;

@end
