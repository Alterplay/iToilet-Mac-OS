//
//  APAppLauncher.h
//  Mio
//
//  Created by Deszip on 14/03/14.
//  Copyright (c) 2014 Igor Asharenkov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APAppLauncher : NSObject {
    
}

+ (BOOL)isLaunchAtStartup;
+ (void)setLaunchAtStartup:(BOOL)launch;

@end
