//
//  RCServerControlInfoViewController.m
//  iOSClient
//
//  Created by Eugene Zozulya on 12/24/14.
//  Copyright (c) 2014 Eugene Zozulya. All rights reserved.
//

#import "RCServerControlInfoViewController.h"

@interface RCServerControlInfoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIButton *startButton;

@end

@implementation RCServerControlInfoViewController

- (IBAction)startButtonPushed:(UIButton *)sender
{
    RCAppDelegate *appDelegate = RCApplicationDelegate();
    UIViewController *controlVC = [UIViewController loadViewControllerFromStoryBoardWithIdentifier:@"RCControlViewController"];
    [UIView transitionWithView:appDelegate.window
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{ appDelegate.window.rootViewController = controlVC; }
                    completion:nil];
}

#pragma mark - Private Methods

- (void)setupLocalization
{
    self.infoLabel.text = NSLocalizedString(@"RCServerControlInfoViewController.infoLabel.text", @"");
    [self.startButton setTitle:NSLocalizedString(@"RCServerControlInfoViewController.startButton.text", @"") forState:UIControlStateNormal];
}

@end
