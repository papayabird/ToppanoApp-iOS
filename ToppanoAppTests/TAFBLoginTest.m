//
//  TAFBLoginTest.m
//  ToppanoApp
//
//  Created by papayabird on 2015/10/20.
//  Copyright (c) 2015年 papayabird. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "TALoginViewController.h"
@interface TAFBLoginTest : XCTestCase

@property (strong, nonatomic) TALoginViewController *loginVC;

@end

@implementation TAFBLoginTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testLoginFB
{

}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
