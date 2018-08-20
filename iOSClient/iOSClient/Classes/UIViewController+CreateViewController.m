//
//  UIViewController+CreateViewController.m
//  iOSClient
//
//  Created by Eugene Zozulya on 12/24/14.
//  Copyright (c) 2014 Eugene Zozulya. All rights reserved.
//

#import "UIViewController+CreateViewController.h"
#import "RCInfoViewController.h"

@implementation UIViewController (CreateViewController)

+ (instancetype)loadViewControllerFromStoryBoardWithIdentifier:(NSString *)className
{
    UIViewController *retVC = [RCMainStoryboard() instantiateViewControllerWithIdentifier:className];
    NSAssert(retVC, @"View controller doesn't exist in story board");
    
    return retVC;
}

+ (instancetype)createViewControllerWithClassName:(NSString *)className
{
    Class vcClass = NSClassFromString(className);
    NSAssert(vcClass, @"View controller doesn't exist in project");
    
    UIViewController *retVC = [[vcClass alloc] init];
    return retVC;
}

+ (instancetype)getInfoViewController
{
    static RCInfoViewController *infoVC;
    if(infoVC)
        return infoVC;
    
    infoVC = (RCInfoViewController*)[UIViewController loadViewControllerFromStoryBoardWithIdentifier:@"RCInfoViewController"];
    return infoVC;
}

@end
