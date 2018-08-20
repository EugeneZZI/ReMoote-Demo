//
//  RCActionMenuView.m
//  iOSClient
//
//  Created by Eugene Zozulya on 1/5/15.
//  Copyright (c) 2015 Eugene Zozulya. All rights reserved.
//

#import "RCActionMenuView.h"
#import "UIFont+RCFont.h"
#import "RCActionMenuTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

#define TABLE_VIEW_ROWS_COUNT                   3

typedef NS_ENUM(NSUInteger, RCActionMenuSendAction)
{
    RCActionMenuSendActioShutDown = 0,
    RCActionMenuSendActioSleep,
    RCActionMenuSendActioCancel
};

@interface RCActionMenuView() <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray                           *tableViewCells;
@property (weak, nonatomic) IBOutlet UITableView                *tableView;

@end

@implementation RCActionMenuView

static NSArray *views;

+ (instancetype)createActionMenu
{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"RCActionMenuView" owner:nil options:nil];
    NSUInteger index = [views indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        if([obj isKindOfClass:[RCActionMenuView class]])
        {
            *stop = YES;
            return YES;
        }
        return NO;
    }];
    
    RCActionMenuView *actionMenu = [views objectAtIndex:index];
    return actionMenu;
}

- (void)setupView
{
    self.clipsToBounds      = YES;
    self.layer.cornerRadius = 55.0;
    if([self.tableView respondsToSelector:@selector(layoutMargins)])
        self.tableView.layoutMargins = UIEdgeInsetsZero;
    else
        self.tableView.separatorInset = UIEdgeInsetsZero;
}

- (void)finishHideAnimation
{
    [self.tableView reloadData];
}

- (NSArray*)tableViewCells
{
    if(_tableViewCells)
        return _tableViewCells;
    
    UIView *selectionView = [[UIView alloc] init];
    selectionView.backgroundColor = [UIColor redColor];
    
    __block NSMutableArray *arr = [NSMutableArray arrayWithCapacity:3];
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"RCActionMenuView" owner:nil options:nil];
    [views enumerateObjectsUsingBlock:^(RCActionMenuTableViewCell *obj, NSUInteger idx, BOOL *stop) {
        NSUInteger tag = obj.tag;
        switch (tag) {
            case 0:
                obj.titleLabel.text = NSLocalizedString(@"RCActionMenuView.turnOffButton.title", @"");
                break;
            case 1:
                obj.titleLabel.text = NSLocalizedString(@"RCActionMenuView.sleepButton.title", @"");
                break;
            case 2:
                obj.titleLabel.text = NSLocalizedString(@"RCActionMenuView.cancelButton.title", @"");
                break;
            default:
                break;
        }
        if(tag < 3)
        {
            if([obj respondsToSelector:@selector(layoutMargins)])
                obj.layoutMargins = UIEdgeInsetsZero;
            
            UIView *selectionView = [[UIView alloc] init];
            selectionView.backgroundColor = [UIColor colorWithRed:214/255.0 green:187/255.0 blue:214/255.0 alpha:1.0];
            obj.selectedBackgroundView = selectionView;
            
            arr[tag] = obj;
        }
    }];
    
    _tableViewCells = (NSArray*)arr;
    return _tableViewCells;
}

#pragma mark - Private Methods

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
- (void)sendToDelegateMenuAction:(RCActionMenuSendAction)action
{
    SEL selector;
    switch (action) {
        case RCActionMenuSendActioShutDown:
            selector = @selector(turnOffPressedActionMenu:);
            break;
        case RCActionMenuSendActioSleep:
            selector = @selector(sleepPressedActionMenu:);
            break;
        case RCActionMenuSendActioCancel:
            selector = @selector(cancelPressedActionMenu:);
            break;
        default: return;
    }
    
    if([self.actionMenuDelegate respondsToSelector:selector])
        [self.actionMenuDelegate performSelector:selector withObject:self];
}
#pragma clang diagnostic pop

#pragma mark - UITabBarControllerDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.frame.size.height/TABLE_VIEW_ROWS_COUNT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self sendToDelegateMenuAction:indexPath.row];
}

#pragma mar - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return TABLE_VIEW_ROWS_COUNT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.tableViewCells[indexPath.row];
}

@end
