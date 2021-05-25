//
//  SwiftDetailViewModel.swift
//  BindController
//
//  Created by lidan on 2021/5/21.
//

import RxCocoa

class SwiftDetailViewModel {
    
    lazy var content = BehaviorRelay(value:"内容-Swift")
    
    deinit {
        print(#function)
    }
    
}

extension SwiftDetailViewModel {
    
    func updateContent() {
        content.accept("内容改变: \(Int.random(in: 1...100))")
    }
    
}
