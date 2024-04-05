//
//  BirthdayViewModel.swift
//  SeSACRxThreads
//
//  Created by Madeline on 4/5/24.
//

import Foundation
import RxCocoa
import RxSwift

class BirthdayViewModel {
    
    let disposeBag = DisposeBag()
    
    /// Input
    struct Input {
        let birthday: ControlProperty<Date>
    }
    /// Output
    struct Output {
        let year: Driver<String>
        let month: Driver<String>
        let day: Driver<String>
    }
    
    /// BUSINESS LOGIC
    func transform(_ input: Input) -> Output {
        
        let year = PublishRelay<Int>()
        let month = PublishRelay<Int>()
        let day = PublishRelay<Int>()
        
        input.birthday
            .subscribe(with: self) { owner, date in
                let component = Calendar.current.dateComponents([.year, .month, .day], from: date)
                year.accept(component.year!)
                month.accept(component.month!)
                day.accept(component.day!)
            }
            .disposed(by: disposeBag)
        
        let y = year
            .map { "\($0)년" }
            .asDriver(onErrorJustReturn: "2024")
        let m = month
            .map { "\($0)월" }
            .asDriver(onErrorJustReturn: "3")
        let d = day
            .map { "\($0)일" }
            .asDriver(onErrorJustReturn: "8")
        
        return Output(year: y, month: m, day: d)
    }
}
