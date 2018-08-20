//
//  RCServerSetupInfoViewController.m
//  iOSClient
//
//  Created by Eugene Zozulya on 12/24/14.
//  Copyright (c) 2014 Eugene Zozulya. All rights reserved.
//

#import "RCServerSetupInfoViewController.h"
#import "UIColor+RCColor.h"
#import <MessageUI/MessageUI.h>

@interface RCServerSetupInfoViewController () <MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIButton *shareLinkButton;

@end

@implementation RCServerSetupInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)shareLinkButtonPressed:(UIButton *)sender
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

#pragma mark - Private Methods

- (void)setupLocalization
{
    self.infoLabel.text = NSLocalizedString(@"RCServerSetupInfoViewController.infoLabel.text", @"");
    [self.shareLinkButton setTitle:NSLocalizedString(@"RCServerSetupInfoViewController.shareLinkButton.text", @"") forState:UIControlStateNormal];
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
