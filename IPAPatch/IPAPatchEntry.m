//
//  IPAPatchEntry.m
//  IPAPatch
//
//  Created by wutian on 2017/3/17.
//  Copyright © 2017年 Weibo. All rights reserved.
//

#import "IPAPatchEntry.h"
#import "Utils.h"
#import "SwizzlingHelper.h"

#import <Foundation/Foundation.h>


@implementation IPAPatchEntry

+ (void)load {
    @autoreleasepool {
        // Return the original bundleID instead of the real one,
        // otherwise the server doesn't respond.
        [SwizzlingHelper swizzleGetApplicationBundleId];
        // Return nil Facebook instance (also removed all FB settings from Info.plist)
        [SwizzlingHelper swizzleFacebookInstance];
    }
}

@end
