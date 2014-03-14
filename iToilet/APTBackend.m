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

@property (strong, nonatomic) NSDateFormatter *sessionDurationFormatter;
@property (assign, nonatomic) NSTimeInterval previousSessionStartDate;
@property (assign, nonatomic) NSTimeInterval currentSessionStartDate;

/**
 *  Returns NSData generated from backend response
 *
 *  @return UTF-8 encoded backend response as NSData object
 */
- (NSData *)toiletResponse;

- (id)responseObjectFromData:(NSData *)responseData;

/**
 *  Parses NSData object (by serializing it as JSON string) retrieved from - (NSData *)toiletResponse.
 *  Gets APToiletStatus value based on light_status key in response.
 *
 *  @param responseData UTF-8 encoded data retrieved from backend.
 *
 *  @return APToiletStatus value
 */
- (APToiletStatus)statusFromResponseObject:(id)responseObject;

- (void)updateSessionDurationFromResponseObject:(id)responseObject;

/* Tools */
- (NSString *)stringDurationForTimeInterval:(NSTimeInterval)interval;

@end

@implementation APTBackend

+ (instancetype)newBackend
{
    APTBackend *backend = [[APTBackend alloc] init];
    
    backend.previousSessionStartDate = 0;
    backend.currentSessionStartDate = 0;
    
    backend.sessionDurationFormatter = [[NSDateFormatter alloc] init];
    [backend.sessionDurationFormatter setDateFormat:@"m:ss"];
    [backend.sessionDurationFormatter setLocale:[NSLocale currentLocale]];
    [backend.sessionDurationFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    
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
    return [self statusFromResponseObject:[self responseObjectFromData:[self toiletResponse]]];
}

- (NSString *)previousSessionDurationString
{
    id responseObject = [self responseObjectFromData:[self toiletResponse]];
    [self updateSessionDurationFromResponseObject:responseObject];
    
    return [self stringDurationForTimeInterval:self.previousSessionStartDate];
}

- (NSString *)currentSessionDurationString
{
    id responseObject = [self responseObjectFromData:[self toiletResponse]];
    [self updateSessionDurationFromResponseObject:responseObject];
    
    return [self stringDurationForTimeInterval:self.currentSessionStartDate];
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
        ZZLog(LL_NETWORK, @"Bad request info: %@", requestError.userInfo);
        
        return nil;
    }
    
    return responseData;
}

- (id)responseObjectFromData:(NSData *)responseData
{
    if (!responseData) return nil;
    
    NSError *serializationError = nil;
    id responseObject = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&serializationError];
    
    return responseObject;
}

- (APToiletStatus)statusFromResponseObject:(id)responseObject
{
    if (!responseObject) return APToiletStatusUndefined;
    
    ZZLog(LL_NETWORK, @"Response: %@", responseObject);
    ZZLog(LL_NETWORK, @"Session duration: %@", [self currentSessionDurationString]);
    
    NSInteger lightStatus = [responseObject[@"light_status"] integerValue];
    if (lightStatus == 0) {
        return APToiletStatusFree;
    } else {
        return APToiletStatusBusy;
    }
}

- (void)updateSessionDurationFromResponseObject:(id)responseObject
{
    NSTimeInterval duration = [responseObject[@"light_change"] integerValue];
    if (self.currentSessionStartDate != duration) {
        self.previousSessionStartDate = self.currentSessionStartDate;
    }
    
    self.currentSessionStartDate = duration;
}

#pragma mark - Tools

- (NSString *)stringDurationForTimeInterval:(NSTimeInterval)interval
{
    NSTimeInterval sessionDurationInterval = [[NSDate date] timeIntervalSince1970] - interval;
    NSDate *sessionDurationDate = [NSDate dateWithTimeIntervalSince1970:sessionDurationInterval];
    
    ZZLog(LL_UI, @"Session duration: %f sec", sessionDurationInterval);
    
    return [self.sessionDurationFormatter stringFromDate:sessionDurationDate];
}

@end
