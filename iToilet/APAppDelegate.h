//
//  APAppDelegate.h
//  iToilet
//
//  Created by Deszip on 15.02.14.
//  Copyright (c) 2014 Alterplay. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define kRequestTimeout     3.0
#define kToiletURLString    @"http://test.mockup.io:88/"
#define kMockedResponse     @"{\"light_value\":\"4095\",\"light_status\":null}"

typedef NS_ENUM(NSInteger, APToiletStatus) {
    APToiletStatusFree = 0,
    APToiletStatusBusy,
    APToiletStatusUndefined
};

@interface APAppDelegate : NSObject <NSApplicationDelegate> {
    
}

/* State */
@property (assign, nonatomic) APToiletStatus currentStatus;
@property (strong, nonatomic) NSTimer *updateTimer;

/* UI */
@property (weak) IBOutlet NSMenu *theMenu;
@property (strong, nonatomic) NSStatusItem *theItem;

- (void)activateStatusMenu;
- (void)setupTimer;

- (void)updateStatus;
- (void)setStatus:(APToiletStatus)newStatus;

- (NSData *)toiletResponse;
- (APToiletStatus)statusFromResponse:(NSData *)responseData;
@end
