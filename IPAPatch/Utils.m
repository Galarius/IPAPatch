//
//  Utils.m
//  IPAPatch
//

#import "Utils.h"

#import <TargetConditionals.h>
#if TARGET_OS_OSX
#import <AppKit/AppKit.h>
#else
#import <UIKit/UIKit.h>
#endif

#import <objc/runtime.h>

@implementation Utils

+ (void) showAlert
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

#if TARGET_OS_OSX
        __auto_type alert = [[NSAlert alloc] init];
        alert.messageText = @"Hacked";
        alert.informativeText = @"Hacked with IPAPatch";
        [alert addButtonWithTitle:@"OK"];
        [alert runModal];
#else
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Hacked" message:@"Hacked with IPAPatch" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:NULL]];
        UIViewController * controller = [UIApplication sharedApplication].keyWindow.rootViewController;
        while (controller.presentedViewController) {
            controller = controller.presentedViewController;
        }
        [controller presentViewController:alertController animated:YES completion:NULL];
#endif
    });
}

+ (void) listMethodsOfClass:(Class)cls {
    unsigned int methodCount = 0;
    Method *methodList = class_copyMethodList(cls, &methodCount);
    NSLog(@"Listing methods for class: %s", class_getName(cls));
    for (unsigned int i = 0; i < methodCount; i++) {
        Method method = methodList[i];
        SEL methodName = method_getName(method);
        const char *methodNameStr = sel_getName(methodName);
        const char *methodTypeEncoding = method_getTypeEncoding(method);
        NSLog(@"Method #%d: %s (Type Encoding: %s)", i + 1, methodNameStr, methodTypeEncoding);
    }
    free(methodList);
}

+ (void) listIvarsOfClass:(Class)cls {
    unsigned int ivarCount = 0;
    Ivar *ivarList = class_copyIvarList(cls, &ivarCount);
    NSLog(@"Listing instance variables for class: %s", class_getName(cls));
    for (unsigned int i = 0; i < ivarCount; i++) {
        Ivar ivar = ivarList[i];
        const char *ivarName = ivar_getName(ivar);
        const char *ivarType = ivar_getTypeEncoding(ivar);
        NSLog(@"Ivar #%d: %s (Type Encoding: %s)", i + 1, ivarName, ivarType);
    }
    free(ivarList);
}

+ (void)copyCachesToDocuments {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *cachesPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = [cachesPaths firstObject];
    NSArray *documentsPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [documentsPaths firstObject];
    NSString *destinationFolder = [documentsDirectory stringByAppendingPathComponent:@"caches"];
    if (![fileManager fileExistsAtPath:destinationFolder]) {
        NSError *createDirError = nil;
        [fileManager createDirectoryAtPath:destinationFolder withIntermediateDirectories:YES attributes:nil error:&createDirError];
        if (createDirError) {
            NSLog(@"Error creating destination folder: %@", createDirError.localizedDescription);
            return;
        }
    }

    NSError *error = nil;
    NSArray *filesInCaches = [fileManager contentsOfDirectoryAtPath:cachesDirectory error:&error];
    if (error) {
        NSLog(@"Error fetching contents of Caches directory: %@", error.localizedDescription);
        return;
    }

    for (NSString *fileName in filesInCaches) {
        NSString *sourcePath = [cachesDirectory stringByAppendingPathComponent:fileName];
        NSString *destinationPath = [destinationFolder stringByAppendingPathComponent:fileName];
        NSError *copyError = nil;
        [fileManager copyItemAtPath:sourcePath toPath:destinationPath error:&copyError];
        if (copyError) {
            NSLog(@"Error copying file %@: %@", fileName, copyError.localizedDescription);
        } else {
            NSLog(@"Successfully copied %@ to %@", fileName, destinationPath);
        }
    }
}

@end
