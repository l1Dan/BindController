//
//  SwiftDetailViewController.swift
//  BindController
//
//  Created by lidan on 2021/5/21.
//

import UIKit
import RxSwift
import RxCocoa

class SwiftDetailViewController: UIViewController {
    
    @IBOutlet weak var contentLabel: UILabel!
    
    private lazy var viewModel = SwiftDetailViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // [self.viewModel bind:@"content" to:self.contentLabel at:@"text"];
        // [self.viewModel dispose];
        viewModel.content.bind(to: contentLabel.rx.text).disposed(by: disposeBag)
        
    }
    
    deinit {
        print(#function)
    }
    
    @IBAction func clickUpdateButton(_ button: UIButton) {
        viewModel.updateContent()
    }

}
