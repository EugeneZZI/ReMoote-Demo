//
//  RCCommon.m
//  iOSClient
//
//  Created by Eugene Zozulya on 12/2/14.
//  Copyright (c) 2014 Eugene Zozulya. All rights reserved.
//

#import "RCCommon.h"

UIStoryboard* RCMainStoryboard()
{
    static UIStoryboard *mainStoryboard;
    if(mainStoryboard)
        return mainStoryboard;
    mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    return mainStoryboard;
}

NSString* RCDocumentsPath()
{
    static NSString *docPath;
    if(docPath)
        return docPath;
    
    docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    return docPath;
}

RCAppDelegate* RCApplicationDelegate()
{
   return (RCAppDelegate *)[[UIApplication sharedApplication] delegate];
}

@implementation RCCommon

@end
