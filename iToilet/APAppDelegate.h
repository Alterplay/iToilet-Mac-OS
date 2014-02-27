//
//  APAppDelegate.h
//  iToilet
//
//  Created by Deszip on 15.02.14.
//  Copyright (c) 2014 Alterplay. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "APTDefinitions.h"
#import "APTBackend.h"
#import "APTNotificationController.h"

@interface APAppDelegate : NSObject <NSApplicationDelegate, NSPopoverDelegate> {
    
}

@property (strong, nonatomic) NSTimer *durationUpdateTimer;

/* State */
@property (assign, nonatomic) APToiletStatus currentStatus;
@property (strong, nonatomic) NSTimer *updateTimer;

/* Data */
@property (strong, nonatomic) APTBackend *backend;
@property (strong, nonatomic) APTNotificationController *notificationController;

/* UI */
@property (weak) IBOutlet NSMenu *theMenu;
@property (strong, nonatomic) NSStatusItem *theItem;
@property (weak) IBOutlet NSPopover *popover;
@property (weak) IBOutlet NSButton *notificationsSwitch;
@property (weak) IBOutlet NSTextField *sessionDurationLabel;

/* Setup */
- (void)activateStatusMenu;
- (void)setupTimers;

/* UI */
- (IBAction)sendTestNotification:(NSButton *)sender;
- (IBAction)togglePopover:(id)sender;
- (void)hidePopover;
- (void)updateStatus;
- (void)setStatus:(APToiletStatus)newStatus;
- (void)handleStatusChangeFromStatus:(APToiletStatus)oldStatus toStatus:(APToiletStatus)newStatus;
- (void)updateSessionDurationLabel;

/* Actions */
- (IBAction)toggleNotifications:(NSButton *)sender;

@end
