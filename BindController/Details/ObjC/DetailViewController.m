//
//  DetailViewController.m
//  BindController
//
//  Created by lidan on 2021/5/20.
//

#import "DetailViewController.h"
#import "DetailViewModel.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (nonatomic, strong) DetailViewModel *viewModel;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentLabel.text = @"内容-ObjC";
    self.viewModel = [[DetailViewModel alloc] init];
    self.navigationItem.title = @"Detail";
}

- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
}

#pragma mark - KVC

- (IBAction)clickUpdateButton:(UIButton *)sender {
    [self.viewModel updateContent];
//    [self updateContent];
}

#pragma mark - KVC & KVO
#pragma mark 方法一

//- (void)updateContent {
////    self.contentLabel.text = self.viewModel.content;
//    [self.contentLabel setValue:self.viewModel.content forKey:@"text"];
//}

#pragma mark 方法二

//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    [self addObserver:self forKeyPath:@"viewModel.content" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:NULL];
//}
//
//- (void)viewDidDisappear:(BOOL)animated {
//    [super viewDidDisappear:animated];
//    [self removeObserver:self forKeyPath:@"viewModel.content" context:NULL];
//}
//
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
//    if ([keyPath isEqualToString:@"viewModel.content"]) {
//        [self.contentLabel setValue:self.viewModel.content forKey:@"text"];
//    } else {
//        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//    }
//}

#pragma mark 方法三

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self.viewModel bind:@"content" to:self.contentLabel at:@"text"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.viewModel dispose];
}

@end
