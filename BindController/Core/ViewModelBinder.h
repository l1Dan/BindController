//
//  ViewModelBinder.h
//  BindController
//
//  Created by lidan on 2021/5/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^Callback)(id value);

@protocol ViewModelBinder <NSObject>

@optional
- (void)bind:(nullable NSString *)sourceKeyPath to:(id)target at:(nullable NSString *)targetKeyPath;

- (void)dispose;

@end

NS_ASSUME_NONNULL_END
