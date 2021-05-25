//
//  DetailViewModel.h
//  BindController
//
//  Created by lidan on 2021/5/20.
//

#import <Foundation/Foundation.h>

#import "ViewModelBinder.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailViewModel : NSObject <ViewModelBinder>

@property (nonatomic, copy) NSString *content;

- (void)updateContent;

@end

NS_ASSUME_NONNULL_END
