//
//  RCMacState.m
//  MacServer
//
//  Created by Eugene Zozulya on 12/9/14.
//  Copyright (c) 2014 Eugene Zozulya. All rights reserved.
//

#import "RCMacState.h"
#import <AudioToolbox/AudioServices.h>
#include <CoreServices/CoreServices.h>
#include <Carbon/Carbon.h>

@interface RCMacState()
{
    float               _volumeBeforeMute;
}

@property (nonatomic, readonly) AudioDeviceID       defaultOutputDeviceID;

@end

@implementation RCMacState

@synthesize defaultOutputDeviceID = _defaultOutputDeviceID;

#pragma mark - Public Methods

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        _defaultOutputDeviceID  = kAudioObjectUnknown;
        _volumeBeforeMute       = -1;
    }
    
    return self;
}

- (float)getCurrentSystemVolumeValue
{
    Float32 outputVolume;
    int var = 0;
    UInt32 propertySize = 0;
    OSStatus status = noErr;
    AudioObjectPropertyAddress propertyAOPA;
    propertyAOPA.mElement = kAudioObjectPropertyElementMaster;
    propertyAOPA.mSelector = kAudioHardwareServiceDeviceProperty_VirtualMasterVolume;
    propertyAOPA.mScope = kAudioDevicePropertyScopeOutput;
    
    AudioDeviceID outputDeviceID = self.defaultOutputDeviceID;
    if (outputDeviceID == kAudioObjectUnknown) {
        DLog(@"Unknown default device");
        return 0.0f;
    }
    
    if (!AudioHardwareServiceHasProperty(outputDeviceID, &propertyAOPA)) {
        DLog(@"No volume returned for device 0x%0x", outputDeviceID);
        return 0.0f;
    }
    
    propertySize = (UInt32) sizeof(Float32);
    status = AudioHardwareServiceGetPropertyData(outputDeviceID, &propertyAOPA, 0, &var, &propertySize, &outputVolume);
    
    if (status) {
        DLog(@"No volume returned for device 0x%0x", outputDeviceID);
        return 0.0f;
    }
    
    if (outputVolume < 0.0f) return 0;
    if (outputVolume > 1.0f) return 100;
    
    return (outputVolume * 100);
}

- (BOOL)isSystemVolumeMuted
{
    Float32 outputVolume;
    int var = 0;
    UInt32 propertySize = 0;
    OSStatus status = noErr;
    AudioObjectPropertyAddress propertyAOPA;
    propertyAOPA.mElement = kAudioObjectPropertyElementMaster;
    propertyAOPA.mSelector = kAudioDevicePropertyMute;
    propertyAOPA.mScope = kAudioDevicePropertyScopeOutput;
    
    AudioDeviceID outputDeviceID = self.defaultOutputDeviceID;
    if (outputDeviceID == kAudioObjectUnknown) {
        DLog(@"Unknown default device");
        return NO;
    }
    
    if (!AudioHardwareServiceHasProperty(outputDeviceID, &propertyAOPA)) {
        DLog(@"No volume returned for device 0x%0x", outputDeviceID);
        return NO;
    }
    
    propertySize = (UInt32) sizeof(Float32);
    status = AudioHardwareServiceGetPropertyData(outputDeviceID, &propertyAOPA, 0, &var, &propertySize, &outputVolume);
    
    if (status) {
        DLog(@"No volume returned for device 0x%0x", outputDeviceID);
        return NO;
    }
    
    DLog(@"---> mute - %f --- volume %f", outputVolume, [self getCurrentSystemVolumeValue]);
    if(outputVolume > 0 && ([self getCurrentSystemVolumeValue] > 0))
    {
        if(_volumeBeforeMute == -1)
            _volumeBeforeMute = [self getCurrentSystemVolumeValue];
        return YES;
    }
    
    return NO;
}

- (BOOL)setNewSystemVolumeValue:(float)volume
{
    float newVolume = volume/100.0f;
    int var = 0;
    if (newVolume < 0.0f) newVolume = 0.0f;
    if (newVolume > 1.0f) newVolume = 1.0f;
    
    UInt32 propertySize = 0;
    OSStatus status = noErr;
    AudioObjectPropertyAddress propertyAOPA;
    propertyAOPA.mElement = kAudioObjectPropertyElementMaster;
    propertyAOPA.mScope = kAudioDevicePropertyScopeOutput;
    
    if (newVolume < 0.001) {
        DLog(@"Muting audio");
        propertyAOPA.mSelector = kAudioDevicePropertyMute;
    }     else {
        DLog(@"Setting audio volume to %d%%", (int) (newVolume * 100.0));
        propertyAOPA.mSelector = kAudioHardwareServiceDeviceProperty_VirtualMasterVolume;
    }
    
    AudioDeviceID outputDeviceID = [self defaultOutputDeviceID];
    if (outputDeviceID == kAudioObjectUnknown) {
        DLog(@"Unknown default audio device");
        return NO;
    }
    
    if (!AudioHardwareServiceHasProperty(outputDeviceID, &propertyAOPA)) {
        DLog(@"Device 0x%0x does not support volume control", outputDeviceID);
        return NO;
    }
    
    Boolean canSetVolume = NO;
    status = AudioHardwareServiceIsPropertySettable(outputDeviceID, &propertyAOPA, &canSetVolume);
    
    if (status || canSetVolume == NO)     {
        DLog(@"Device 0x%0x does not support volume control", outputDeviceID);
        return NO;
    }
    
    if (propertyAOPA.mSelector == kAudioDevicePropertyMute) {
        propertySize = (UInt32) sizeof(UInt32);
        UInt32 mute = 1;
        status = AudioHardwareServiceSetPropertyData(outputDeviceID, &propertyAOPA, 0, &var, propertySize, &mute);
    } else {
        propertySize = (UInt32) sizeof(Float32);
        status = AudioHardwareServiceSetPropertyData(outputDeviceID, &propertyAOPA, 0, &var, propertySize, &newVolume);
        
        if (status) {
            DLog(@"Unable to set volume for device 0x%0x", outputDeviceID);
        }
        
        propertyAOPA.mSelector = kAudioDevicePropertyMute;
        propertySize = (UInt32) sizeof(UInt32);
        UInt32 mute = 0;
        if (!AudioHardwareServiceHasProperty(outputDeviceID, &propertyAOPA)) {
            DLog(@"Device 0x%0x does not support muting", outputDeviceID);
            return NO;
        }
        
        Boolean canSetMute = NO;
        status = AudioHardwareServiceIsPropertySettable(outputDeviceID, &propertyAOPA, &canSetMute);
        if (status || !canSetMute) {
            DLog(@"Device 0x%0x does not support muting", outputDeviceID);
            return NO;
        }
        
        status = AudioHardwareServiceSetPropertyData(outputDeviceID, &propertyAOPA, 0, &var, propertySize, &mute);
    }
    
    if (status) {
        DLog(@"Unable to set volume for device 0x%0x", outputDeviceID);
        return NO;
    }
    
    return YES;
}

- (void)muteSystemVolume
{
    _volumeBeforeMute = [self getCurrentSystemVolumeValue];
    [self setNewSystemVolumeValue:0.0005];
}

- (void)unmuteSystemVolume
{
    if(_volumeBeforeMute != -1)
        [self setNewSystemVolumeValue:_volumeBeforeMute];
    _volumeBeforeMute = -1;
}

- (void)sleepSystem
{
    OSStatus error = noErr;
    error = [self sendAppleEventToSystemProcess:kAESleep];
    if (error == noErr)
    {printf("Computer is going to sleep!\n");}
    else
    {printf("Computer wouldn't sleep\n");}
}

- (void)shutdownSystem
{
    OSStatus error = noErr;
    error = [self sendAppleEventToSystemProcess:kAEShutDown];
    if (error == noErr)
    {printf("Computer is going to shutdown!\n");}
    else
    {printf("Computer wouldn't shutdown\n");}
}

#pragma mark - Private Methods

- (AudioDeviceID)defaultOutputDeviceID {
    if(_defaultOutputDeviceID != kAudioObjectUnknown)
        return _defaultOutputDeviceID;
    
    AudioDeviceID outputDeviceID = kAudioObjectUnknown;
    
    UInt32 propertySize = 0;
    int var = 0;
    OSStatus status = noErr;
    AudioObjectPropertyAddress propertyAOPA;
    propertyAOPA.mScope = kAudioObjectPropertyScopeGlobal;
    propertyAOPA.mElement = kAudioObjectPropertyElementMaster;
    propertyAOPA.mSelector = kAudioHardwarePropertyDefaultOutputDevice;
    
    if (!AudioHardwareServiceHasProperty(kAudioObjectSystemObject, &propertyAOPA)) {
        DLog(@"Cannot find default output device!");
        return outputDeviceID;
    }
    
    propertySize = (UInt32) sizeof(AudioDeviceID);
    status = AudioHardwareServiceGetPropertyData(kAudioObjectSystemObject, &propertyAOPA, 0, &var, &propertySize, &outputDeviceID);
    if (status) {
        DLog(@"Cannot find default output device!");
    }
    
    _defaultOutputDeviceID = outputDeviceID;
    
    return _defaultOutputDeviceID;
}

-(OSStatus)sendAppleEventToSystemProcess:(AEEventID)EventToSend
{
    AEAddressDesc targetDesc;
    static const ProcessSerialNumber kPSNOfSystemProcess = { 0, kSystemProcess };
    AppleEvent eventReply = {typeNull, NULL};
    AppleEvent appleEventToSend = {typeNull, NULL};
    
    OSStatus error = noErr;
    
    error = AECreateDesc(typeProcessSerialNumber, &kPSNOfSystemProcess,
                         sizeof(kPSNOfSystemProcess), &targetDesc);
    
    if (error != noErr)
    {
        return error;
    }
    
    error = AECreateAppleEvent(kCoreEventClass, EventToSend, &targetDesc,
                               kAutoGenerateReturnID, kAnyTransactionID, &appleEventToSend);
    
    AEDisposeDesc(&targetDesc);
    if (error != noErr)
    {
        return error;
    }
    
    error = AESend(&appleEventToSend, &eventReply, kAENoReply,
                   kAENormalPriority, kAEDefaultTimeout, NULL, NULL);
    
    AEDisposeDesc(&appleEventToSend);
    if (error != noErr)
    {
        return error;
    }
    
    AEDisposeDesc(&eventReply);
    
    return error;
}

@end
