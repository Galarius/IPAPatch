//
//  SwizzlingHelper.m
//  IPAPatch
//

#import "SwizzlingHelper.h"
#import <objc/runtime.h>

@implementation SwizzlingHelper

+ (void) swizzleOriginalClass:(Class)originalClass
             originalSelector:(SEL)originalSelector
                swizzledClass:(Class)swizzledClass
             swizzledSelector:(SEL)swizzledSelector
                 classMethods:(BOOL)classMethods {
    if (!originalClass) {
        NSLog(@"Error: Original class '%@' not found", NSStringFromClass(originalClass));
        return;
    }

    Method originalMethod;
    Method swizzledMethod;

    if(classMethods) {
        originalMethod = class_getClassMethod(originalClass, originalSelector);
        swizzledMethod = class_getClassMethod(swizzledClass, swizzledSelector);
    } else {
        originalMethod = class_getInstanceMethod(originalClass, originalSelector);
        swizzledMethod = class_getInstanceMethod(swizzledClass, swizzledSelector);
    }

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

// NimbleApplicationEnvironmentImpl

- (NSString *)swizzled_getApplicationBundleId {
    NSLog(@"Swizzled method -[NimbleApplicationEnvironmentImpl getApplicationBundleId] called");
    return @"com.ea.simpsonssocial.bv2";    // Original bundleID
}

+ (void) swizzleGetApplicationBundleId {
    Class originalClass = NSClassFromString(@"NimbleApplicationEnvironmentImpl");
    SEL originalSelector = NSSelectorFromString(@"getApplicationBundleId");
    SEL swizzledSelector = @selector(swizzled_getApplicationBundleId);
    [self swizzleOriginalClass:originalClass originalSelector:originalSelector swizzledClass:self swizzledSelector:swizzledSelector classMethods:NO];
}

// FBSDK

+ (void *)swizzled_instance {
    NSLog(@"[Swizzling] Swizzled method +[IOSFacebookManager instance] called");
    return (void *)nil;
}

+ (void)swizzleFacebookInstance {
    Class originalClass = NSClassFromString(@"IOSFacebookManager");
    SEL originalSelector = NSSelectorFromString(@"instance");
    SEL swizzledSelector = @selector(swizzled_instance);
    [self swizzleOriginalClass:originalClass originalSelector:originalSelector swizzledClass:self swizzledSelector:swizzledSelector classMethods:YES];
}

@end
