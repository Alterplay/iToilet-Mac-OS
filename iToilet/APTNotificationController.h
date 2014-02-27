//
//  APTNotificationController.h
//  iToilet
//
//  Created by Deszip on 16.02.14.
//  Copyright (c) 2014 Alterplay. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "APTDefinitions.h"

#define kBusyNotificationText           @"Туалет занят"
#define kFreeNotificationText           @"Туалет освободился"
#define kUndefinedNotificationText      @"Что-то с бекендом"

#define kBusySessionTitle               @"Был занят: "
#define kFreeSessionTitle               @"Был свободен: "
#define kUndefinedSessionTitle          @"Был недоступен: "

@interface APTNotificationController : NSObject <NSUserNotificationCenterDelegate> {
    
}

+ (instancetype)newController;

/* Accessors */
- (BOOL)userNotificationsAllowed;
- (void)setUserNotificationsAllowed:(BOOL)notificationsAllowed;

/* Delivering notifications */
- (void)deliverNotificationWithTitle:(NSString *)title andText:(NSString *)text;

@end
