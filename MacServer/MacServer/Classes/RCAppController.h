//
//  AppController.h
//  MacServer
//
//  Created by Eugene Zozulya on 12/9/14.
//  Copyright (c) 2014 Eugene Zozulya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCAppController : NSObject

- (void)startProcesses;
- (void)stopProcesses;
- (BOOL)isProcessRun;

@end
