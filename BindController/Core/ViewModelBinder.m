//
//  ViewModelBinder.m
//  BindController
//
//  Created by lidan on 2021/5/21.
//

#import <objc/runtime.h>

#import "ViewModelBinder.h"

static inline void BinderSwizzleMethod(Class aClass, SEL originalSelector, SEL swizzledSelector) {
    Method originalMethod = class_getInstanceMethod(aClass, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(aClass, swizzledSelector);

    BOOL isSuccess = class_addMethod(aClass, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (isSuccess) {
        class_replaceMethod(aClass, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

static NSKeyValueObservingOptions const options = NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew;

@interface NSObject (Private) <ViewModelBinder>

@property (nonatomic, copy) NSMutableDictionary<NSString *, NSDictionary<NSString *, id> *> *keyPaths;

@end

@implementation NSObject (Private)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        BinderSwizzleMethod([NSObject class], @selector(observeValueForKeyPath:ofObject:change:context:), @selector(binder_observeValueForKeyPath:ofObject:change:context:));
    });
}

#pragma mark - Private

- (NSMutableDictionary<NSString *, NSDictionary<NSString *,id> *> *)keyPaths {
    NSMutableDictionary<NSString *, NSDictionary<NSString *, id> *> *object = objc_getAssociatedObject(self, _cmd);
    if (!object) {
        object = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, _cmd, object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return object;
}

- (void)setKeyPaths:(NSMutableDictionary<NSString *, NSDictionary<NSString *,id> *> *)keyPaths {
    objc_setAssociatedObject(self, @selector(keyPaths), keyPaths, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDictionary<NSString *, id> *)findTargetInfoWithKey:(NSString *)keyPath {
    for (NSString *oldKeyPath in self.keyPaths.allKeys) {
        if ([keyPath isEqualToString:oldKeyPath]) {
            return self.keyPaths[keyPath];
        }
    }
    return nil;
}

#pragma mark - Public & Core

- (void)bind:(NSString *)sourceKeyPath to:(id)target at:(NSString *)targetKeyPath {
    if (!sourceKeyPath || !target || !targetKeyPath) return;
    
    if ([self findTargetInfoWithKey:sourceKeyPath]) {
        NSLog(@"已经添加 %@，无需重复添加！", sourceKeyPath);
        return;
    }
    
    [self.keyPaths setValue:@{targetKeyPath: target} forKey:sourceKeyPath];
    [self addObserver:self forKeyPath:sourceKeyPath options:options context:NULL]; // 1.添加
}

// 2.监听
- (void)binder_observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSDictionary<NSString *, id> *targetInfo = [self findTargetInfoWithKey:keyPath];
    if (targetInfo) {
        NSString *keyPath = targetInfo.allKeys.firstObject;
        id target = targetInfo[keyPath];
        id value = change[NSKeyValueChangeNewKey];
        if (keyPath && target && value && ![value isKindOfClass:[NSNull class]]) [target setValue:value?:@"" forKey:keyPath];
    } else {
        [self binder_observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dispose {
    for (NSString *keyPath in self.keyPaths.allKeys) {
        [self removeObserver:self forKeyPath:keyPath context:NULL]; // 3.移除
    }
}

@end
