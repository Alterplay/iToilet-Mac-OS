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

@interface APTNotificationController : NSObject <NSUserNotificationCenterDelegate> {
    
}

+ (instancetype)newController;

/* Delivering notifications */
- (void)deliverNotificationWithTitle:(NSString *)title andText:(NSString *)text;

@end
