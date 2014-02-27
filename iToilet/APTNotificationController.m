//
//  APTNotificationController.m
//  iToilet
//
//  Created by Deszip on 16.02.14.
//  Copyright (c) 2014 Alterplay. All rights reserved.
//

#import "APTNotificationController.h"

@interface APTNotificationController () {
    
}

@property (strong, nonatomic) NSUserNotificationCenter *userNotificationCenter;

@end

@implementation APTNotificationController

+ (instancetype)newController
{
    APTNotificationController *controller = [[APTNotificationController alloc] init];
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:kNotificationsFlag]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kNotificationsFlag];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return controller;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _userNotificationCenter = [NSUserNotificationCenter defaultUserNotificationCenter];
        [_userNotificationCenter setDelegate:self];
    }
    
    return self;
}

#pragma mark - Accessors

- (BOOL)userNotificationsAllowed
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kNotificationsFlag]) {
        return [[NSUserDefaults standardUserDefaults] boolForKey:kNotificationsFlag];
    }
    
    return YES;
}

- (void)setUserNotificationsAllowed:(BOOL)notificationsAllowed
{
    [[NSUserDefaults standardUserDefaults] setBool:notificationsAllowed forKey:kNotificationsFlag];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Delivering notifications

- (void)deliverNotificationWithTitle:(NSString *)title andText:(NSString *)text
{
    ZZLog(LL_UI, @"Trying to deliver notification: %@", title);

    if (![self userNotificationsAllowed]) return;
    
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    [notification setTitle:title];
    [notification setInformativeText:text];
    [notification setSoundName:NSUserNotificationDefaultSoundName];

    [self.userNotificationCenter deliverNotification:notification];
}

#pragma mark - NSUserNotificationCenterDelegate

- (void)userNotificationCenter:(NSUserNotificationCenter *)center didActivateNotification:(NSUserNotification *)notification
{
    ZZLog(LL_UI, @"user didActivateNotification: %@", notification);
}

- (void)userNotificationCenter:(NSUserNotificationCenter *)center didDeliverNotification:(NSUserNotification *)notification
{
    ZZLog(LL_UI, @"user didDeliverNotification: %@", notification);
}

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification
{
    return YES;
}

@end
