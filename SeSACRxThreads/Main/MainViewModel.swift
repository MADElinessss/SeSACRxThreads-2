//
//  MainViewModel.swift
//  SeSACRxThreads
//
//  Created by Madeline on 4/1/24.
//

import Foundation
import RxCocoa
import RxSwift

class MainViewModel {
    
    private let disposeBag = DisposeBag()
    
    // PublishSubject: 새로운 이벤트만 전달!
    let inputDeleteButtonTapped = PublishSubject<Int>()
    
    // BehaviorSubject: 초기값(테이블뷰 data) + 새로운 이벤트 전달!
    var items = BehaviorSubject<[String]>(value: [])
    
    init(data: [String]) {
        items.onNext(data)
        bind()
    }
    
    func bind() {
        inputDeleteButtonTapped
            .bind(with: self) { owner, row in
                guard var items = try? owner.items.value() else { return }
                items.remove(at: row)
                self.items.onNext(items)
            }
            .disposed(by: disposeBag)
    }
}
