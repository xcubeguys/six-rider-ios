//
//  CrashlyticsBridge.m
//  Arcane Driver
//
//  Created by Admin on 1/28/16.
//  Copyright © 2016 Cogzidel-iOS. All rights reserved.
//

#import "CrashlyticsBridge.h"
#import <Crashlytics/Crashlytics.h>

@implementation CrashlyticsBridge

+ (void)log:(NSString *)message {
    CLS_LOG(@"%@", message);
}

@end
