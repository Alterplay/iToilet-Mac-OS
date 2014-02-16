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
#ifdef DEBUG
    [[ZZLogger defaultLogger] setCurrentLogLevel:(LL_NETWORK | LL_UI)];
#endif
    
    self.backend = [APTBackend newBackend];
    self.notificationController = [APTNotificationController newController];
    
    [self activateStatusMenu];
    [self setCurrentStatus:APToiletStatusUndefined];
    
    [self setupTimer];
}

- (void)applicationDidResignActive:(NSNotification *)notification
{
    [self hidePopover];
}

#pragma mark - Setup

- (void)activateStatusMenu
{
    NSStatusBar *bar = [NSStatusBar systemStatusBar];
    self.theItem = [bar statusItemWithLength:NSVariableStatusItemLength];
    [self.theItem setTarget:self];
    [self.theItem setAction:@selector(togglePopover:)];

    BOOL notificationsAllowed = [[NSUserDefaults standardUserDefaults] boolForKey:kNotificationsFlag];
    [self.notificationsSwitch setState:(NSCellStateValue)notificationsAllowed];
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

#pragma mark - UI

- (IBAction)togglePopover:(id)sender
{
    [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
    if ([self.popover isShown]) {
        [self hidePopover];
    } else {
        [self.popover showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSMaxYEdge];
    }
}

- (void)hidePopover
{
    if ([self.popover isShown]) {
        [self.popover close];
    }
}

- (void)updateStatus
{
    [self setStatus:[self.backend toiletStatus]];
}

- (void)setStatus:(APToiletStatus)newStatus
{
    [self handleStatusChangeFromStatus:self.currentStatus toStatus:newStatus];
    
    self.currentStatus = newStatus;

    switch (self.currentStatus) {
        case APToiletStatusFree:
            [self.theItem setImage:[NSImage imageNamed:kFreeStatusIconName]];
            break;
            
        case APToiletStatusBusy:
            [self.theItem setImage:[NSImage imageNamed:kBusyStatusIconName]];
            break;
            
        case APToiletStatusUndefined:
            [self.theItem setImage:[NSImage imageNamed:kUndefinedStatusIconName]];
            break;
            
        default:
            break;
    }
}

- (void)handleStatusChangeFromStatus:(APToiletStatus)oldStatus toStatus:(APToiletStatus)newStatus
{
    if (oldStatus == APToiletStatusBusy && newStatus == APToiletStatusFree) {
        [self.notificationController deliverNotificationWithTitle:kFreeNotificationText andText:@""];
    }
    
    if (oldStatus == APToiletStatusFree && newStatus == APToiletStatusBusy) {
        [self.notificationController deliverNotificationWithTitle:kBusyNotificationText andText:@""];
    }
    
    if (oldStatus != newStatus && newStatus == APToiletStatusUndefined) {
        [self.notificationController deliverNotificationWithTitle:kUndefinedNotificationText andText:@""];
    }
}

- (IBAction)toggleNotifications:(NSButton *)sender {
    BOOL notificationsAllowed = [[NSUserDefaults standardUserDefaults] boolForKey:kNotificationsFlag];
    [[NSUserDefaults standardUserDefaults] setBool:!notificationsAllowed forKey:kNotificationsFlag];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.notificationsSwitch setState:(NSCellStateValue)!notificationsAllowed];
}

@end
