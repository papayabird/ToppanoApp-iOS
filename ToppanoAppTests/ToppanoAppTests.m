//
//  ToppanoAppTests.m
//  ToppanoAppTests
//
//  Created by papayabird on 2015/10/15.
//  Copyright (c) 2015年 papayabird. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface ToppanoAppTests : XCTestCase

@end

@implementation ToppanoAppTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testReturnMetadataPlistPath
{
    NSString *metadataDir = [[AppDelegate sharedAppDelegate] returnMetadataPlistPath];
    
    XCTAssert(!metadataDir,@"metadataDir create failed");
}

- (void)testReturnPhotoFilePath
{
    NSString *photodataDir = [[AppDelegate sharedAppDelegate] returnPhotoFilePath];
    
    XCTAssert(!photodataDir,@"photodataDir create failed");
}

@end
