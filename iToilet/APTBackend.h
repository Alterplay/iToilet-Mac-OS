//
//  APTBackend.h
//  iToilet
//
//  Created by Deszip on 16.02.14.
//  Copyright (c) 2014 Alterplay. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "APTDefinitions.h"

#define kToiletURLString    @"http://test.mockup.io:88/"
#define kMockedResponse     @"{\"light_status\" = 0; \"light_value\" = 3412; \"sensor_status\" = 1;}"

@interface APTBackend : NSObject {
    
}

@property (assign, nonatomic, readonly) APToiletStatus toiletStatus;

+ (instancetype)newBackend;

@end
