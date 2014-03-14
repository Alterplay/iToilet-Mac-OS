//
//  APSettingsManager.m
//  Mio
//
//  Created by Deszip on 14/03/14.
//  Copyright (c) 2014 Igor Asharenkov. All rights reserved.
//

#import "APTSettingsManager.h"

@implementation APTSettingsManager

- (BOOL)launchAtStartupState
{
    id savedStateObject = [[NSUserDefaults standardUserDefaults] objectForKey:kAutolaunchFlag];
    if (!savedStateObject) {
        [self saveLaunchAtStartupState:YES];
        return YES;
    }
    
    return [savedStateObject boolValue];
}

- (void)saveLaunchAtStartupState:(BOOL)state
{
    [APAppLauncher setLaunchAtStartup:state];
    
    [[NSUserDefaults standardUserDefaults] setBool:state forKey:kAutolaunchFlag];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
