//
//  ZZLogger.h
//  Chiboco
//
//  Created by Zar doz on 30.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//#import "ZZLoggerHUD.h"

//#define ZZLog(LL_GENERAL, s,...) [ZZLogger logFile:__FILE__ lineNumber:__LINE__ format:(s),##__VA_ARGS__]
#define ZZLog(i,s,...) [ZZLogger logLevel:i file:__FILE__ lineNumber:__LINE__ format:(s),##__VA_ARGS__]

enum {
    LL_NONE             = 0,
    
    LL_NETWORK          = 1 << 0,
    LL_FS               = 1 << 1,
    LL_UI               = 1 << 2,
    LL_COREDATA         = 1 << 3,
    LL_CRASH            = 1 << 4
};
typedef NSUInteger ZZLogLevel;

@interface ZZLogger : NSObject {
    ZZLogLevel currentLogLevel;
    BOOL showHUD;
    
    //ZZLoggerHUD *hud;
}

@property (nonatomic, assign) ZZLogLevel currentLogLevel;
@property (nonatomic, assign) BOOL showHUD;

//@property (nonatomic, retain) ZZLoggerHUD *hud;

+ (id)defaultLogger;

//+ (void)setShowHUD:(BOOL)__showHUD;

+ (void)logFile:(char *)sourceFile lineNumber:(int)lineNumber format:(NSString *)format, ...;
+ (void)logLevel:(ZZLogLevel)level file:(char *)sourceFile lineNumber:(int)lineNumber format:(NSString *)format, ...;

/* Tools */
+ (void)logAsBin:(NSUInteger)input;
+ (NSString *)logCGRect:(CGRect)__rect;

@end
