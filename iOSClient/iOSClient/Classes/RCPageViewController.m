//
//  RCPageViewController.m
//  iOSClient
//
//  Created by Eugene Zozulya on 12/24/14.
//  Copyright (c) 2014 Eugene Zozulya. All rights reserved.
//

#import "RCPageViewController.h"

@interface RCPageViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic, strong) NSArray           *viewControllersList;

@end

@implementation RCPageViewController

- (instancetype)init
{
    self = [super initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    if(self)
    {
        _viewControllersList = [self createViewControllersForPresentation];
        [self setViewControllers:@[[_viewControllersList firstObject]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        self.dataSource     = self;
        self.delegate       = self;
    }
    
    return self;
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index = [self.viewControllersList indexOfObject:viewController];
    if(index == 0)
        return nil;
    return [self.viewControllersList objectAtIndex:--index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger index = [self.viewControllersList indexOfObject:viewController];
    if(index == 2)
        return nil;
    return [self.viewControllersList objectAtIndex:++index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return self.viewControllersList.count;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

#pragma mark - Private Methods

- (NSArray*)createViewControllersForPresentation
{
    UIViewController *setupVC   = [UIViewController loadViewControllerFromStoryBoardWithIdentifier:@"RCServerSetupInfoViewController"];
    UIViewController *selectVC  = [UIViewController loadViewControllerFromStoryBoardWithIdentifier:@"RCServerSelectInfoViewController"];
    UIViewController *controlVC = [UIViewController loadViewControllerFromStoryBoardWithIdentifier:@"RCServerControlInfoViewController"];
    
    NSArray *retArr = @[setupVC, selectVC, controlVC];
    return retArr;
}

@end
