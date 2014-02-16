//
//  APAppDelegate.m
//  iToilet
//
//  Created by Deszip on 15.02.14.
//  Copyright (c) 2014 Alterplay. All rights reserved.
//

#import "APAppDelegate.h"

@implementation APAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self activateStatusMenu];
    [self setCurrentStatus:APToiletStatusUndefined];
    
    [self setupTimer];
}

#pragma mark - Setup

- (void)activateStatusMenu
{
    NSStatusBar *bar = [NSStatusBar systemStatusBar];
    self.theItem = [bar statusItemWithLength:NSVariableStatusItemLength];
    [self.theItem setMenu:self.theMenu];
}

- (void)setupTimer
{
    NSMethodSignature *updateSignature = [self methodSignatureForSelector:@selector(updateStatus)];
    NSInvocation *updateInvocation = [NSInvocation invocationWithMethodSignature:updateSignature];
    [updateInvocation setTarget:self];
    [updateInvocation setSelector:@selector(updateStatus)];
    
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:kRequestTimeout invocation:updateInvocation repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.updateTimer forMode:NSRunLoopCommonModes];
}

- (void)updateStatus
{
    APToiletStatus status = [self statusFromResponse:[self toiletResponse]];
    [self setStatus:status];
}

- (void)setStatus:(APToiletStatus)newStatus
{
    self.currentStatus = newStatus;

    switch (self.currentStatus) {
        case APToiletStatusFree:
            //[self.theItem setTitle:@"Туалет свободен"];
            [self.theItem setImage:[NSImage imageNamed:@"sb-green.png"]];
            break;
            
        case APToiletStatusBusy:
            //[self.theItem setTitle:@"Туалет занят"];
            [self.theItem setImage:[NSImage imageNamed:@"sb-red.png"]];
            break;
            
        case APToiletStatusUndefined:
            //[self.theItem setTitle:@"Непонятно"];
            [self.theItem setImage:[NSImage imageNamed:@"sb-grey.png"]];
            break;
            
        default:
            break;
    }
}

- (NSData *)toiletResponse
{
    //return [kMockedResponse dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *toiletURL = [NSURL URLWithString:kToiletURLString];
    NSError *requestError = nil;
    NSData *responseData = [NSData dataWithContentsOfURL:toiletURL options:NSDataReadingUncached error:&requestError];

    if (!responseData) {
        NSLog(@"Bad request: %@", requestError);
        
        return nil;
    }
    
    return responseData;
}

- (APToiletStatus)statusFromResponse:(NSData *)responseData
{
    if (!responseData) return APToiletStatusUndefined;
    
    NSError *serializationError = nil;
    id responseObject = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&serializationError];
    
#ifdef DEBUG
    NSLog(@"Response: %@", responseObject);
    NSLog(@"Error: %@", serializationError);
#endif
    
    NSInteger lightStatus = [responseObject[@"light_status"] integerValue];
    if (lightStatus == 0) {
        return APToiletStatusFree;
    } else {
        return APToiletStatusBusy;
    }
}

@end
