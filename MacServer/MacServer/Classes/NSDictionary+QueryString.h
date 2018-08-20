//
//  NSDictionary+QueryString.h
//  MacServer
//
//  Created by Eugene Zozulya on 12/11/14.
//  Copyright (c) 2014 Eugene Zozulya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (QueryString)

+ (NSDictionary *)dictionaryWithQueryString:(NSString *)queryString;
- (NSString *)queryStringValue;

@end
