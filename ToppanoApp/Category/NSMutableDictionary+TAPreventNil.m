//
//  NSMutableDictionary+TAPreventNil.m
//  ToppanoApp
//
//  Created by papayabird on 2015/10/27.
//  Copyright © 2015年 papayabird. All rights reserved.
//

#import "NSMutableDictionary+TAPreventNil.h"

@implementation NSMutableDictionary (TAPreventNil)

-(void)setObjectPreventNil:(NSString *)key object:(id)obj
{
    if (obj == nil) {
        NSLog(@"注意 %@ is nil",key);
    }
    else {
        [self setObject:obj forKey:key];
    }
}

-(void)setObjectxNil:(id)obj forKey:(NSString *)key
{
    [self setObjectPreventNil:key object:obj];
}

-(void)setObjectEmptyStringIfNil:(id)obj forKey:(NSString *)key
{
    if (obj) {
        [self setObject:obj forKey:key];
    }
    else {
        [self setObject:@"" forKey:key];
    }
}

@end
