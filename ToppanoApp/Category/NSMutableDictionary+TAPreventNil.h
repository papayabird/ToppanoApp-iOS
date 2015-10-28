//
//  NSMutableDictionary+TAPreventNil.h
//  ToppanoApp
//
//  Created by papayabird on 2015/10/27.
//  Copyright © 2015年 papayabird. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (TAPreventNil)

-(void)setObjectPreventNil:(NSString *)key object:(id)obj;
-(void)setObjectxNil:(id)obj forKey:(NSString *)key;
-(void)setObjectEmptyStringIfNil:(id)obj forKey:(NSString *)key;

@end
