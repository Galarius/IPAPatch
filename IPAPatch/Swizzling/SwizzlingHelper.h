//
//  SwizzlingHelper.h
//  IPAPatch
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SwizzlingHelper : NSObject

+ (void) swizzleGetApplicationBundleId;
+ (void) swizzleFacebookInstance;

@end

NS_ASSUME_NONNULL_END
