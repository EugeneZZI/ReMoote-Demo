//
//  RCMacInfoLabel.h
//  iOSClient
//
//  Created by Eugene Zozulya on 12/29/14.
//  Copyright (c) 2014 Eugene Zozulya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCMacInfoLabel : UILabel

- (void)setMacName:(NSString*)macName available:(BOOL)flag;
- (void)setAvailable:(BOOL)flag;

@end
