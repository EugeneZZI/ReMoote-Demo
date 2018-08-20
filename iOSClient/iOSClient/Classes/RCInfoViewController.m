//
//  RCInfoViewController.m
//  iOSClient
//
//  Created by Eugene Zozulya on 12/24/14.
//  Copyright (c) 2014 Eugene Zozulya. All rights reserved.
//

#import "RCInfoViewController.h"
#import "RCAppInfo.h"
#import "UIColor+RCColor.h"
#import <MessageUI/MessageUI.h>

@interface RCInfoViewController () <MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendFeedbackButton;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UILabel *appVersion;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;

@end

@implementation RCInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupView];
    self.appVersion.text = [NSString stringWithFormat:NSLocalizedString(@"RCInfoViewController.appVersion.text", @""), [RCAppInfo appVersion]];
}

- (IBAction)sendFeedbackButtonPushed:(UIButton *)sender
{
    if([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController * mailComposer = [[MFMailComposeViewController alloc] init];
        mailComposer.mailComposeDelegate = self;
        [self presentViewController:mailComposer animated:YES completion:nil];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"MFMailComposeViewController.alert.title", @"")
                                    message:NSLocalizedString(@"MFMailComposeViewController.alert.errorcheck.message", @"")
                                   delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"MFMailComposeViewController.alert.button.ok", @"")
                          otherButtonTitles:nil] show];
    }
}

- (IBAction)backButtonPushed:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Private Methods

- (void)setupLocalization
{
    self.navigationBar.topItem.title        = NSLocalizedString(@"RCInfoViewController.navigationBar.title", @"");
    self.backButton.title                   = NSLocalizedString(@"RCInfoViewController.backButton.title", @"");
    self.infoLabel.text                     = NSLocalizedString(@"RCInfoViewController.infoLabel.text", @"");
    [self.sendFeedbackButton setTitle:NSLocalizedString(@"RCInfoViewController.sendFeedbackButton.title", @"") forState:UIControlStateNormal];
}

- (void)setupView
{
    self.backButton.tintColor    = [UIColor mainTextColor];
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if(error)
    {
        DLog(@"Error %@", error);
    }
    
    if(result == MFMailComposeResultFailed)
    {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"MFMailComposeViewController.alert.title", @"")
                                    message:NSLocalizedString(@"MFMailComposeViewController.alert.errorsending.message", @"")
                                   delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"MFMailComposeViewController.alert.button.ok", @"")
                          otherButtonTitles:nil] show];
    }
    else
    {
        [controller dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
