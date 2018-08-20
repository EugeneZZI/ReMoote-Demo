//
//  ViewController.m
//  iOSClient
//
//  Created by Eugene Zozulya on 11/26/14.
//  Copyright (c) 2014 Eugene Zozulya. All rights reserved.
//

#import "RCControlViewController.h"
#import "RCServersViewController.h"
#import "RCNetworkManager.h"
#import "RCServersStore.h"
#import "RCNetServiceResolver.h"
#import "RCKeysDefinition.h"
#import "RCServer.h"
#import "UIFont+RCFont.h"
#import "UIColor+RCColor.h"
#import "RCMacInfoLabel.h"
#import "RCControlButton.h"
#import "RCActionMenuView.h"
#import "RCSlider.h"
#import <libextobjc/extobjc.h>

typedef NS_ENUM(NSInteger, RCControlAlertViewTag)
{
    RCControlAlertViewTagServerError = 742,
    RCControlAlertViewTagShutDown,
    RCControlAlertViewTagSleep
};

@interface RCControlViewController () <RCNetworkManagerDelegate, RCActionMenuDelegate>
{
    BOOL            _stopCheckingVolume;
}

@property (weak, nonatomic) IBOutlet UILabel                *volumeValueLabel;
@property (weak, nonatomic) IBOutlet UINavigationBar        *navigationBar;
@property (weak, nonatomic) IBOutlet RCSlider               *volumeSlider;
@property (weak, nonatomic) IBOutlet RCControlButton        *muteButton;
@property (weak, nonatomic) IBOutlet RCControlButton        *shutdownButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem        *refreshButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem        *infoButton;
@property (weak, nonatomic) IBOutlet RCMacInfoLabel         *macInfo;

@property (nonatomic, strong) RCNetworkManager      *networkManager;
@property (nonatomic, strong) NSMutableArray        *services;
@property (nonatomic, strong) RCNetServiceResolver  *netServiceResolver;
@property (nonatomic, strong) RCActionMenuView      *actionMenu;

@end

@implementation RCControlViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupView];
    
    _stopCheckingVolume = NO;
    
    self.networkManager = [RCNetworkManager new];
    self.networkManager.delegate = self;
    
    [self.volumeSlider addTarget:self action:@selector(startChangingVolume) forControlEvents:UIControlEventTouchDown];
    [self.volumeSlider addTarget:self action:@selector(stopChangingVolume) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    RCServer *currentServer = [[RCServersStore sharedStore] currentServer];
    if(!currentServer)
    {
        [self showServersController];
    }
    else
    {
        @weakify(self);
        self.netServiceResolver = [RCNetServiceResolver resolveServer:currentServer withComplition:^(RCServer *server, NSError *error) {
            @strongify(self);
            if(server)
            {
                self.networkManager.currentServer = currentServer;
                [self.networkManager startCheckingServerState];
                [self.macInfo setMacName:currentServer.shortName available:YES];
            }
            else
                [self showServersController];
        }];
        [self.netServiceResolver startResolving];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.networkManager stopCheckingServerState];
    [self.networkManager cancelAllRequests];
}

- (RCActionMenuView*)actionMenu
{
    if(_actionMenu)
        return _actionMenu;
    
    _actionMenu = [RCActionMenuView createActionMenu];
    CGRect frame = _actionMenu.frame;
    frame.size.width = self.muteButton.frame.origin.x - self.shutdownButton.frame.origin.x + self.muteButton.frame.size.width;
    frame.origin = self.shutdownButton.frame.origin;
    _actionMenu.frame = frame;
    _actionMenu.actionMenuDelegate = self;
    [_actionMenu setupView];
    
    return _actionMenu;
}

- (IBAction)refreshButtonPushed:(UIBarButtonItem *)sender
{
    [self showServersController];
}

- (IBAction)volumeChanged:(UISlider *)sender
{
    [self updateVolumeValueLabel];
    [self.networkManager sendNewVolumeValue:sender.value];
}

- (IBAction)muteButtonPushed:(UIButton *)sender
{
    if(sender.selected)
    {
        [self.networkManager sendUnmute];
        [self setMuteState:NO];
    }
    else
    {
        if(self.volumeSlider.value)
        {
            [self.networkManager sendMute];
            [self setMuteState:YES];
        }
    }
}

-(IBAction)shutDownButtonPushed:(UIButton*)sender
{
    [self showActionMenu:YES];
}

- (IBAction)infoButtonPushed:(UIBarButtonItem *)sender
{
    UIViewController *infoVC = [UIViewController getInfoViewController];
    [self presentViewController:infoVC animated:YES completion:nil];
}

#pragma mark - Private Methods

- (void)showServersController
{
    [[RCServersStore sharedStore] setCurrentServer:nil];
    RCServersViewController *vc = [RCMainStoryboard() instantiateViewControllerWithIdentifier:@"RCServersViewController"];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)startChangingVolume
{
    _stopCheckingVolume = YES;
}

- (void)stopChangingVolume
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        _stopCheckingVolume = NO;
    });
}

- (void)setMuteState:(BOOL)flag
{
    self.muteButton.selected    = flag;
    self.volumeSlider.enabled   = !flag;
}

- (void)setupLocalization
{
    self.macInfo.text = @"";
    
    [self.refreshButton     setTitle:NSLocalizedString(@"RCControlViewController.refreshButton.title", @"")];
    [self.infoButton        setTitle:NSLocalizedString(@"RCControlViewController.infoButton.title", @"")];
}

- (void)setupView
{
    self.refreshButton.tintColor    = [UIColor mainTextColor];
    self.infoButton.tintColor       = [UIColor mainTextColor];
    
    [self.volumeSlider setThumbImage:[UIImage imageNamed:@"SliderThumbImage"] forState:UIControlStateNormal];
    [self.volumeSlider setThumbImage:[UIImage imageNamed:@"SliderThumbImage"] forState:UIControlStateHighlighted];
    [self.volumeSlider setMinimumTrackImage:[UIImage imageNamed:@"SliderTrackMin"] forState:UIControlStateNormal];
    self.volumeSlider.maximumTrackTintColor = [UIColor whiteColor];
}

- (void)showActionMenu:(BOOL)flag
{
    CGRect frame = self.actionMenu.frame;
    self.refreshButton.enabled  = !flag;
    self.infoButton.enabled     = !flag;
    self.volumeSlider.enabled   = !flag;
    
    if(flag)
    {
        self.actionMenu.frame = self.shutdownButton.frame;
        [self.view addSubview:self.actionMenu];
        self.actionMenu.alpha = 1.0;
        [UIView animateWithDuration:0.5 animations:^{
            self.actionMenu.frame = frame;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.5 animations:^{
            self.actionMenu.frame = self.shutdownButton.frame;
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.4 animations:^{
                self.actionMenu.alpha = 0.0;
            } completion:^(BOOL finished) {
                [self.actionMenu removeFromSuperview];
                self.actionMenu.frame = frame;
                [self.actionMenu finishHideAnimation];
            }];
        }];
    }
}

- (void)updateVolumeValueLabel
{
    self.volumeValueLabel.text = [NSString stringWithFormat:@"%d%%", (int)self.volumeSlider.value];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(_actionMenu.window != nil)
    {
        UITouch *touch = [touches anyObject];
        if(touch.view != _actionMenu)
            [self showActionMenu:NO];
    }
    
    [super touchesEnded:touches withEvent:event];
}

#pragma mark - RCActionMenuDelegate

- (void)turnOffPressedActionMenu:(RCActionMenuView *)actionMenu
{
    [self showActionMenu:NO];
    [self showAlertViewWithTag:RCControlAlertViewTagShutDown];
}

- (void)sleepPressedActionMenu:(RCActionMenuView *)actionMenu
{
    [self showActionMenu:NO];
    [self showAlertViewWithTag:RCControlAlertViewTagSleep];
}

- (void)cancelPressedActionMenu:(RCActionMenuView *)actionMenu
{
    [self showActionMenu:NO];
}

- (void)showAlertViewWithTag:(RCControlAlertViewTag)tag
{
    NSString *title = @"";
    NSString *message = @"";
    NSString *cancelButton = NSLocalizedString(@"RCControlViewController.alertView.cancelButton", @"");
    NSString *otherButton = nil;
    switch (tag) {
        case RCControlAlertViewTagServerError:
        {
            message     = NSLocalizedString(@"RCControlViewController.alertView.serverError.message", @"");
        } break;
        case RCControlAlertViewTagShutDown:
        {
            message     = NSLocalizedString(@"RCControlViewController.alertView.shutDown.message", @"");
            otherButton = NSLocalizedString(@"RCControlViewController.alertView.otherButton", @"");
        } break;
        case RCControlAlertViewTagSleep:
        {
            message     = NSLocalizedString(@"RCControlViewController.alertView.sleep.message", @"");
            otherButton = NSLocalizedString(@"RCControlViewController.alertView.otherButton", @"");
        } break;
        default: break;
    }
    
    UIAlertView *av;
    if(otherButton)
        av = [[UIAlertView alloc] initWithTitle:title
                                        message:message
                                       delegate:self
                              cancelButtonTitle:cancelButton
                              otherButtonTitles:otherButton, nil];
    else
        av = [[UIAlertView alloc] initWithTitle:title
                                        message:message
                                       delegate:self
                              cancelButtonTitle:cancelButton
                              otherButtonTitles:nil];
    
    av.tag = tag;
    [av show];
}

#pragma mark - RCNetworkManagerDelegate

// async invocation
- (void)networkManager:(RCNetworkManager*)networkManager serverState:(NSDictionary *)currentState
{
    if(_stopCheckingVolume) return;
    
    float currentVolume = [currentState[kRCServerStateVolumeValue] floatValue];
    BOOL serverMuted    = [currentState[kRCServerStateMuted] boolValue];
    
    float deltaVolume = fabsf(currentVolume - self.volumeSlider.value);
    if((currentVolume != self.volumeSlider.value) && (deltaVolume > 1.0f))
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            DLog(@"Change volume");
            [UIView animateWithDuration:0.2 animations:^{
                 [self.volumeSlider setValue:currentVolume animated:YES];
            }];
            [self updateVolumeValueLabel];
        });
    }
    if(serverMuted != self.muteButton.selected)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            DLog(@"Change volume");
            [self setMuteState:serverMuted];
        });
    }
}

- (void)networkManager:(RCNetworkManager*)networkManager serverRequestCompletedWithError:(NSError*)error;
{
    if(error)
        [self showAlertViewWithTag:RCControlAlertViewTagServerError];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSInteger tag = alertView.tag;
    switch (tag) {
        case RCControlAlertViewTagServerError:
        {
            [self showServersController];
        } break;
        case RCControlAlertViewTagShutDown:
        {
            if(buttonIndex == 0)
                [self.networkManager sendShutdown];
        } break;
        case RCControlAlertViewTagSleep:
        {
            if(buttonIndex == 0)
                [self.networkManager sendSleep];
        } break;
        default: break;
    }
}

@end
