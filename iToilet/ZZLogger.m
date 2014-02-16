//
//  ZZLogger.m
//  Chiboco
//
//  Created by Zar doz on 30.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ZZLogger.h"

@implementation ZZLogger

static ZZLogger *defaultLogger = nil;

@synthesize currentLogLevel, showHUD;
//@synthesize hud;

#pragma mark -
#pragma mark - Init

+ (id)defaultLogger
{
    if (defaultLogger == nil) {
        defaultLogger = [[self alloc] init];
        [defaultLogger setCurrentLogLevel:LL_NONE];
        //defaultLogger.hud = nil;
        //defaultLogger.showHUD = NO;
    }
    
    return defaultLogger;
}
        
#pragma mark -
#pragma mark - Disabling instantiation
        
+ (id)hiddenAlloc
{
    return [super alloc];
}

+ (id)new
{
    return [self alloc];
}

#pragma mark -
#pragma mark - Logging

+ (void)logFile:(char *)sourceFile lineNumber:(int)lineNumber format:(NSString *)format, ...
{    
    if ([[ZZLogger defaultLogger] currentLogLevel] & LL_NONE) return;
    
    va_list args;
    va_start(args, format);
    NSString *fileName = [[NSString alloc] initWithBytes:sourceFile length:strlen(sourceFile) encoding:NSUTF8StringEncoding];
    NSString *logMessage = [[NSString alloc] initWithFormat:format arguments:args];
    
    NSLog(@"%s:%d %@", [[fileName lastPathComponent] UTF8String], lineNumber, logMessage);
    //NSLogv(@"%s:%d %@", args);
    va_end(args);
}

+ (void)logLevel:(ZZLogLevel)level file:(char *)sourceFile lineNumber:(int)lineNumber format:(NSString *)format, ...
{
    //printf("logLevel\n");
    //[ZZLogger logAsBin:defaultLogger.currentLogLevel];
    //[ZZLogger logAsBin:level];
    //[ZZLogger logAsBin:[[ZZLogger defaultLogger] currentLogLevel] & level];
    
    if (([[ZZLogger defaultLogger] currentLogLevel] & level) == 0) return;
    
    //[ZZLogger logFile:sourceFile lineNumber:lineNumber format:format];
    
    va_list args;
    va_start(args, format);
    NSString *fileName = [[NSString alloc] initWithBytes:sourceFile length:strlen(sourceFile) encoding:NSUTF8StringEncoding];
    NSString *logMessage = [[NSString alloc] initWithFormat:format arguments:args];
    
    NSLog(@"%s:%d %@", [[fileName lastPathComponent] UTF8String], lineNumber, logMessage);
    va_end(args);
}

#pragma mark -
#pragma mark - HUD
/*
+ (void)setShowHUD:(BOOL)__showHUD
{
    defaultLogger.showHUD = __showHUD;
    if (defaultLogger.showHUD && !defaultLogger.hud) {
        [defaultLogger setHud:[[ZZLoggerHUD alloc] initWithFrame:CGRectMake(20.0, -400.0, 280.0, 400.0)]];
        [[[UIApplication sharedApplication] keyWindow] addSubview:defaultLogger.hud];
        [defaultLogger.hud becomeFirstResponder];
    }
}
*/
#pragma mark -
#pragma mark - Tools

+ (void)logAsBin:(NSUInteger)input
{
    for (int i = 0; i < 8; i++) {
        int mask = 1 << i;
        int masked = input & mask;
        printf("%d", masked >> i);
    }
    printf("\n");
}

+ (NSString *)logCGRect:(CGRect)__rect
{
    return [NSString stringWithFormat:@"x:%f, y:%f, width:%f, height:%f", __rect.origin.x, __rect.origin.y, __rect.size.width, __rect.size.height];
}

@end
