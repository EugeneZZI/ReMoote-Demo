//
//  NSDictionary+JSON.m
//  MacServer
//
//  Created by Eugene Zozulya on 12/11/14.
//  Copyright (c) 2014 Eugene Zozulya. All rights reserved.
//

#import "NSDictionary+JSON.h"

@implementation NSDictionary (JSON)

- (NSData*)JSONData
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
    if(error)
        DLog(@"Error: %@", error);
    
    return jsonData;
}

@end
