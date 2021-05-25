//
//  DetailViewModel.m
//  BindController
//
//  Created by lidan on 2021/5/20.
//

#import "DetailViewModel.h"

@implementation DetailViewModel

- (void)updateContent {
    self.content = [NSString stringWithFormat:@"内容改变: %d", arc4random() % 100];
}

- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
}

@end
