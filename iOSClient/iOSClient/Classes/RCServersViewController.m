//
//  RCServersViewController.m
//  iOSClient
//
//  Created by Eugene Zozulya on 11/29/14.
//  Copyright (c) 2014 Eugene Zozulya. All rights reserved.
//

#import "RCServersViewController.h"
#import "RCNetworksTableViewCell.h"
#import "RCNetworkScaner.h"
#import "RCServer.h"
#import "RCServersStore.h"
#import "UIColor+RCColor.h"

NSString *kNetworkingCellIdentifier = @"networkingCellIdentifier";

@interface RCServersViewController () <UITableViewDelegate, UITableViewDataSource, RCNetworkScanerDelegate>

@property (weak, nonatomic) IBOutlet UINavigationBar    *navigationBar;
@property (weak, nonatomic) IBOutlet UITableView        *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem    *infoButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem    *refreshButton;

@property (nonatomic, strong) NSMutableArray            *serversList;
@property (nonatomic, strong) RCNetworkScaner           *networkScaner;

@end

@implementation RCServersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    
    self.serversList        = [NSMutableArray new];
    self.networkScaner      = [RCNetworkScaner new];
    
    self.networkScaner.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.networkScaner startScan];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.networkScaner stopScan];
}

- (IBAction)refreshButtonPushed:(UIBarButtonItem *)sender {
    [self.networkScaner stopScan];
    [self.serversList removeAllObjects];
    [self.tableView reloadData];
    [self.networkScaner startScan];
}
- (IBAction)infoButtonPushed:(UIBarButtonItem *)sender
{
    UIViewController *infoVC = [UIViewController getInfoViewController];
    [self presentViewController:infoVC animated:YES completion:nil];
}

#pragma mark - Private Methods

- (void)setupLocalization
{
    self.navigationBar.topItem.title    = NSLocalizedString(@"RCServersViewController.navigationBar.title", @"");
    self.infoButton.title               = NSLocalizedString(@"RCServersViewController.infoButton.title", @"");
}

- (void)setupView
{
    self.refreshButton.tintColor    = [UIColor mainTextColor];
    self.infoButton.tintColor       = [UIColor mainTextColor];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(self.serversList.count)
    {
        [[RCServersStore sharedStore] setCurrentServer:self.serversList[indexPath.row]];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.serversList.count ? self.serversList.count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCNetworksTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kNetworkingCellIdentifier];
    
    if(self.serversList.count)
    {
        RCServer *server        = self.serversList[indexPath.row];
        cell.serverName.text    = server.shortName;
    }
    else
    {
        cell.serverName.text    = @"No Servers Found";
    }
    
    return cell;
}

#pragma mark - RCNetworkScanerDelegate

- (void)networkScanerDidStoptSearch:(RCNetworkScaner*)networkScaner withError:(NSError*)error
{
    if(error)
    {
        DLog(@"Error: %@", error);
        [self.networkScaner stopScan];
        [self.networkScaner startScan];
    }
}

- (void)networkScaner:(RCNetworkScaner*)networkScaner didUpdateServersList:(NSArray*)serversList
{
    DLog(@"Update list with servers %@", serversList);
    self.serversList = [serversList mutableCopy];
    [self.tableView reloadData];
}

@end
