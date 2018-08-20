//
//  UIViewController+CreateViewController.h
//  iOSClient
//
//  Created by Eugene Zozulya on 12/24/14.
//  Copyright (c) 2014 Eugene Zozulya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (CreateViewController)

+ (instancetype)loadViewControllerFromStoryBoardWithIdentifier:(NSString *)className;
+ (instancetype)createViewControllerWithClassName:(NSString *)className;
+ (instancetype)getInfoViewController;

@end
