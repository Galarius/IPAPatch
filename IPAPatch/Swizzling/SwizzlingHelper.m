//
//  SwizzlingHelper.m
//  IPAPatch
//

#import "SwizzlingHelper.h"
#import <objc/runtime.h>

@implementation SwizzlingHelper

- (NSString *)swizzled_getApplicationBundleId {
    NSLog(@"Swizzled method called");
    return @"com.ea.simpsonssocial.bv2";    // Original bundleID
}

+ (void) swizzleGetApplicationBundleId {
    Class originalClass = NSClassFromString(@"NimbleApplicationEnvironmentImpl");
    if (!originalClass) {
        NSLog(@"Error: Original class '%@' not found", NSStringFromClass(originalClass));
        return;
    }
    SEL originalSelector = NSSelectorFromString(@"getApplicationBundleId");
    SEL swizzledSelector = @selector(swizzled_getApplicationBundleId);

    Method originalMethod = class_getInstanceMethod(originalClass, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);

    if (!originalMethod) {
        NSLog(@"Error: Original method %@ not found in class %@", NSStringFromSelector(originalSelector), NSStringFromClass(originalClass));
        return;
    }

    if (!swizzledSelector) {
        NSLog(@"Error: Swizzled method %@ not found in class %@", NSStringFromSelector(originalSelector), NSStringFromClass([self class]));
        return;
    }

    method_exchangeImplementations(originalMethod, swizzledMethod);
}

@end
