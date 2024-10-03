//
//  Utils.h
//  IPAPatch
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Utils : NSObject

+ (void) showAlert;

+ (void) listMethodsOfClass:(Class)cls;

+ (void) listIvarsOfClass:(Class)cls;

+ (void) copyCachesToDocuments;

@end

NS_ASSUME_NONNULL_END
