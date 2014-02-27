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
    [[ZZLogger defaultLogger] setCurrentLogLevel:(LL_UI | LL_NETWORK)];
#endif
    
    self.backend = [APTBackend newBackend];
    self.notificationController = [APTNotificationController newController];
    
    [self activateStatusMenu];
    [self setCurrentStatus:APToiletStatusUndefined];
    
    [self setupTimers];
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

    BOOL notificationsAllowed = [self.notificationController userNotificationsAllowed];
    [self.notificationsSwitch setState:(NSCellStateValue)notificationsAllowed];
    
    ZZLog(LL_UI, @"Notifications: %i", notificationsAllowed);
}

- (void)setupTimers
{
    NSMethodSignature *updateSignature = [self methodSignatureForSelector:@selector(updateStatus)];
    NSInvocation *updateInvocation = [NSInvocation invocationWithMethodSignature:updateSignature];
    [updateInvocation setTarget:self];
    [updateInvocation setSelector:@selector(updateStatus)];
    
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:kRequestTimeout invocation:updateInvocation repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.updateTimer forMode:NSRunLoopCommonModes];
    
    NSMethodSignature *updateDurationSignature = [self methodSignatureForSelector:@selector(updateSessionDurationLabel)];
    NSInvocation *updateDurationInvocation = [NSInvocation invocationWithMethodSignature:updateDurationSignature];
    [updateDurationInvocation setTarget:self];
    [updateDurationInvocation setSelector:@selector(updateSessionDurationLabel)];
    self.durationUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 invocation:updateDurationInvocation repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.durationUpdateTimer forMode:NSRunLoopCommonModes];
}

#pragma mark - UI

- (IBAction)sendTestNotification:(NSButton *)sender
{
    [self handleStatusChangeFromStatus:APToiletStatusBusy toStatus:APToiletStatusFree];
    //[self toggleNotifications:nil];
}

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
    if (newStatus == oldStatus) return;
    
    ZZLog(LL_UI, @"Handling change from %i to %i", oldStatus, newStatus);
    
    if (oldStatus == APToiletStatusBusy && newStatus == APToiletStatusFree) {
        NSString *notificationText = [NSString stringWithFormat:@"%@ %@", kBusySessionTitle, [self.backend currentSessionDurationString]];
        [self.notificationController deliverNotificationWithTitle:kFreeNotificationText andText:notificationText];
    }
    
    if (oldStatus == APToiletStatusFree && newStatus == APToiletStatusBusy) {
        NSString *notificationText = [NSString stringWithFormat:@"%@ %@", kFreeSessionTitle, [self.backend currentSessionDurationString]];
        [self.notificationController deliverNotificationWithTitle:kBusyNotificationText andText:notificationText];
    }
    
    if (oldStatus != newStatus && newStatus == APToiletStatusUndefined) {
        [self.notificationController deliverNotificationWithTitle:kUndefinedNotificationText andText:@""];
    }
}

- (IBAction)toggleNotifications:(NSButton *)sender {
    [self.notificationController setUserNotificationsAllowed:![self.notificationController userNotificationsAllowed]];
    [self.notificationsSwitch setState:(NSCellStateValue)[self.notificationController userNotificationsAllowed]];
    
    ZZLog(LL_UI, @"Allowed: %i", [self.notificationController userNotificationsAllowed]);
}

- (void)updateSessionDurationLabel
{
    if ([self.backend toiletStatus] != APToiletStatusUndefined) {
        [self.sessionDurationLabel setStringValue:[self.backend currentSessionDurationString]];
    } else {
        [self.sessionDurationLabel setStringValue:@""];
    }
}

#pragma mark - NSPopoverDelegate

- (void)popoverWillShow:(NSNotification *)notification
{
    ZZLog(LL_UI, @"popoverWillShow");
}

- (void)popoverDidClose:(NSNotification *)notification
{
    ZZLog(LL_UI, @"popoverDidClose");
}

@end
