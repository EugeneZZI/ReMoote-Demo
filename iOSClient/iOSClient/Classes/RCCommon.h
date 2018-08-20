//
//  RCCommon.h
//  iOSClient
//
//  Created by Eugene Zozulya on 12/2/14.
//  Copyright (c) 2014 Eugene Zozulya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCAppDelegate.h"

UIStoryboard* RCMainStoryboard();
NSString* RCDocumentsPath();
RCAppDelegate* RCApplicationDelegate();

#ifdef DEBUG
#	define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#	define DLog(...)
#endif

@interface RCCommon : NSObject

@end

