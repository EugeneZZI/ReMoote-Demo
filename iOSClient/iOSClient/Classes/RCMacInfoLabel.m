//
//  RCMacInfoLabel.m
//  iOSClient
//
//  Created by Eugene Zozulya on 12/29/14.
//  Copyright (c) 2014 Eugene Zozulya. All rights reserved.
//

#import "RCMacInfoLabel.h"
#import "UIColor+RCColor.h"
#import <QuartzCore/QuartzCore.h>

@interface RCMacInfoLabel()
{
    BOOL                     _isAvailable;
    NSString                *_macName;
    NSString                *_availabilityString;
    UIEdgeInsets             _edgeInsets;
}

@end

@implementation RCMacInfoLabel

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        self.layer.cornerRadius     = 8.0;
        self.layer.masksToBounds    = YES;
        _edgeInsets = UIEdgeInsetsMake(0, 8, 0, 8);
    }
    
    return self;
}

- (void)setMacName:(NSString*)macName available:(BOOL)flag
{
    _macName        = macName;
    _isAvailable    = flag;
    _availabilityString = [self getAvailabilityString:flag];
    self.attributedText = [self getInfoString];
}

- (void)setAvailable:(BOOL)flag
{
    _isAvailable    = flag;
    _availabilityString = [self getAvailabilityString:flag];
    self.attributedText = [self getInfoString];
}

#pragma mark - Private Methods

- (NSString*)getAvailabilityString:(BOOL)flag
{
    if(flag)
        return NSLocalizedString(@"RCMacInfoLabel.available.YES", @"");
    
    return NSLocalizedString(@"RCMacInfoLabel.available.NO", @"");
}

- (NSAttributedString*)getInfoString
{
    NSString *infoString    = [NSString stringWithFormat:@"%@ - %@", _macName, _availabilityString];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:infoString];
    NSRange range;
    
    UIColor *availabilityColor = _isAvailable ? [UIColor rcGreenColor] : [UIColor rcRedColor];
    range = NSMakeRange((infoString.length-_availabilityString.length), _availabilityString.length);
    [attrString addAttribute:NSForegroundColorAttributeName value:availabilityColor range:range];
    
    range = NSMakeRange(0, (infoString.length-_availabilityString.length));
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor mainTextColor] range:range];
    
    return attrString;
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
{
    UIEdgeInsets insets = _edgeInsets;
    CGRect rect = [super textRectForBounds:UIEdgeInsetsInsetRect(bounds, insets)
                    limitedToNumberOfLines:numberOfLines];
    
    rect.origin.x    -= insets.left;
    rect.origin.y    -= insets.top;
    rect.size.width  += (insets.left + insets.right);
    rect.size.height += (insets.top + insets.bottom);
    
    return rect;
}

- (void)drawTextInRect:(CGRect)rect
{
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, _edgeInsets)];
}

@end
