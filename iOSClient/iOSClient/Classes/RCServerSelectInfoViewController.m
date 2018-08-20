//
//  RCServerSelectInfoViewController.m
//  iOSClient
//
//  Created by Eugene Zozulya on 12/24/14.
//  Copyright (c) 2014 Eugene Zozulya. All rights reserved.
//

#import "RCServerSelectInfoViewController.h"

@interface RCServerSelectInfoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@end

@implementation RCServerSelectInfoViewController

#pragma mark - Private Methods

- (void)setupLocalization
{
    self.infoLabel.text = NSLocalizedString(@"RCServerSelectInfoViewController.infoLabel.text", @"");
}

@end
