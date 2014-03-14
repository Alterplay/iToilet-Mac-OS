//
//  APAppLauncher.m
//  Mio
//
//  Created by Deszip on 14/03/14.
//  Copyright (c) 2014 Igor Asharenkov. All rights reserved.
//

#import "APAppLauncher.h"

@interface APAppLauncher ()

+ (LSSharedFileListItemRef)itemRefInLoginItems;

@end

@implementation APAppLauncher

+ (BOOL)isLaunchAtStartup
{
    LSSharedFileListItemRef itemRef = [APAppLauncher itemRefInLoginItems];
    BOOL isInList = itemRef != nil;
    if (itemRef) {
        CFRelease(itemRef);
    }
    
    return isInList;
}

+ (void)setLaunchAtStartup:(BOOL)launch
{
    BOOL shouldBeAdded = [APAppLauncher isLaunchAtStartup] != launch;
    if (!shouldBeAdded) {
        return;
    }
    
    LSSharedFileListRef loginItemsRef = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
    if (loginItemsRef == nil) {
        return;
    }
    if (launch) {
        CFURLRef appUrl = (__bridge CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
        LSSharedFileListItemRef itemRef = LSSharedFileListInsertItemURL(loginItemsRef, kLSSharedFileListItemLast, NULL, NULL, appUrl, NULL, NULL);
        if (itemRef) {
            CFRelease(itemRef);
        }
    } else {
        LSSharedFileListItemRef itemRef = [APAppLauncher itemRefInLoginItems];
        LSSharedFileListItemRemove(loginItemsRef,itemRef);
        if (itemRef != nil) {
            CFRelease(itemRef);
        }
    }
    
    CFRelease(loginItemsRef);
}

+ (LSSharedFileListItemRef)itemRefInLoginItems
{
    LSSharedFileListItemRef itemRef = nil;
    CFURLRef itemUrl = nil;
    
    NSURL *appUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    LSSharedFileListRef loginItemsRef = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
    if (loginItemsRef == nil) {
        return nil;
    }
    
    NSArray *loginItems = (__bridge NSArray *)LSSharedFileListCopySnapshot(loginItemsRef, nil);
    
    NSLog(@"Login items: %@", loginItems);
    
    for (NSInteger currentIndex = 0; currentIndex < [loginItems count]; currentIndex++) {
        LSSharedFileListItemRef currentItemRef = (__bridge LSSharedFileListItemRef)loginItems[currentIndex];
        if (LSSharedFileListItemResolve(currentItemRef, 0, &itemUrl, NULL) == noErr) {

            NSLog(@"Testing item url: %@", (__bridge NSURL *)itemUrl);
            
            if ([(__bridge NSURL *)itemUrl isEqual:appUrl]) {
                itemRef = currentItemRef;
            }
        }
    }

    if (itemRef != nil) CFRetain(itemRef);
    CFRelease(loginItemsRef);
    
    return itemRef;
}

@end
