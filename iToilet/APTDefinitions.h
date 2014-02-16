//
//  APTDefinitions.h
//  iToilet
//
//  Created by Deszip on 16.02.14.
//  Copyright (c) 2014 Alterplay. All rights reserved.
//

/* Status icons names */
#define kFreeStatusIconName         @"sb-green.png"
#define kBusyStatusIconName         @"sb-red.png"
#define kUndefinedStatusIconName    @"sb-grey.png"

#define kNotificationsFlag  @"kNotificationsFlag"
#define kRequestTimeout     3.0

typedef NS_ENUM(NSInteger, APToiletStatus) {
    APToiletStatusFree = 0,
    APToiletStatusBusy,
    APToiletStatusUndefined
};
