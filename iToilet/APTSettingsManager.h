//
//  APSettingsManager.h
//  Mio
//
//  Created by Deszip on 14/03/14.
//  Copyright (c) 2014 Igor Asharenkov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "APTDefinitions.h"
#import "APAppLauncher.h"

@interface APTSettingsManager : NSObject {
    
}

- (BOOL)launchAtStartupState;
- (void)saveLaunchAtStartupState:(BOOL)state;

@end
