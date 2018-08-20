//
//  RCControlButton.m
//  iOSClient
//
//  Created by Eugene Zozulya on 12/29/14.
//  Copyright (c) 2014 Eugene Zozulya. All rights reserved.
//

#import "RCControlButton.h"
#import "UIColor+RCColor.h"
#import <QuartzCore/QuartzCore.h>

@implementation RCControlButton

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        self.layer.cornerRadius     = 55.0;
        self.layer.masksToBounds    = YES;
        
        self.clipsToBounds          = NO;
        self.layer.shadowColor      = [[UIColor blackColor] CGColor];
        self.layer.shadowOpacity    = 0.1;
        self.layer.shadowRadius     = 10;
    }
    
    return self;
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    if(highlighted)
        self.backgroundColor = [UIColor buttonHighlightedColor];
    else
        self.backgroundColor = [UIColor whiteColor];
}

@end
