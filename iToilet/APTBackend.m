//
//  APTBackend.m
//  iToilet
//
//  Created by Deszip on 16.02.14.
//  Copyright (c) 2014 Alterplay. All rights reserved.
//

#import "APTBackend.h"

@interface APTBackend () {
    
}

@property (assign, nonatomic) BOOL mockRequests;

/**
 *  Returns NSData generated from backend response
 *
 *  @return UTF-8 encoded backend response as NSData object
 */
- (NSData *)toiletResponse;

/**
 *  Parses NSData object (by serializing it as JSON string) retrieved from - (NSData *)toiletResponse.
 *  Gets APToiletStatus value based on light_status key in response.
 *
 *  @param responseData UTF-8 encoded data retrieved from backend.
 *
 *  @return APToiletStatus value
 */
- (APToiletStatus)statusFromResponse:(NSData *)responseData;

@end

@implementation APTBackend

+ (instancetype)newBackend
{
    APTBackend *backend = [[APTBackend alloc] init];
    
    return backend;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _mockRequests = NO;
    }
    
    return self;
}

#pragma mark - Accessors

- (APToiletStatus)toiletStatus
{
    return [self statusFromResponse:[self toiletResponse]];
}

#pragma mark - Requests

- (NSData *)toiletResponse
{
    if (self.mockRequests) {
        return [kMockedResponse dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    NSURL *toiletURL = [NSURL URLWithString:kToiletURLString];
    NSError *requestError = nil;
    NSData *responseData = [NSData dataWithContentsOfURL:toiletURL options:NSDataReadingUncached error:&requestError];
    
    if (!responseData) {
        ZZLog(LL_NETWORK, @"Bad request: %@", requestError);
        
        return nil;
    }
    
    return responseData;
}

- (APToiletStatus)statusFromResponse:(NSData *)responseData
{
    if (!responseData) return APToiletStatusUndefined;
    
    NSError *serializationError = nil;
    id responseObject = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&serializationError];
    
    ZZLog(LL_NETWORK, @"Response: %@", responseObject);
    ZZLog(LL_NETWORK, @"Error: %@", serializationError);
    
    NSInteger lightStatus = [responseObject[@"light_status"] integerValue];
    if (lightStatus == 0) {
        return APToiletStatusFree;
    } else {
        return APToiletStatusBusy;
    }
}

@end
