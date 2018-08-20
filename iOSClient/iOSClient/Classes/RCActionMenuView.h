//
//  RCActionMenuView.h
//  iOSClient
//
//  Created by Eugene Zozulya on 1/5/15.
//  Copyright (c) 2015 Eugene Zozulya. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RCActionMenuDelegate;

@interface RCActionMenuView : UIView

@property (nonatomic, weak) id<RCActionMenuDelegate> actionMenuDelegate;

+ (instancetype)createActionMenu;
- (void)setupView;
- (void)finishHideAnimation;

@end

@protocol RCActionMenuDelegate <NSObject>

- (void)turnOffPressedActionMenu:(RCActionMenuView*)actionMenu;
- (void)sleepPressedActionMenu:(RCActionMenuView*)actionMenu;
- (void)cancelPressedActionMenu:(RCActionMenuView*)actionMenu;
    
@end
