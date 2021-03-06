//
//  APTBackend.h
//  iToilet
//
//  Created by Deszip on 16.02.14.
//  Copyright (c) 2014 Alterplay. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "APTDefinitions.h"

#define kToiletURLString    @"http://demo.alterplay.com:8000/"
#define kMockedResponse     @"{\"light_status\" = 0; \"light_value\" = 3412; \"sensor_status\" = 1;}"

@interface APTBackend : NSObject {
    
}

@property (assign, nonatomic, readonly) APToiletStatus toiletStatus;
@property (assign, nonatomic, readonly) NSString *previousSessionDurationString;
@property (assign, nonatomic, readonly) NSString *currentSessionDurationString;

+ (instancetype)newBackend;

@end
