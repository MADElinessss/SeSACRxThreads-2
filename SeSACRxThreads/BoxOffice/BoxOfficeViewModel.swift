//
//  BoxOfficeViewModel.swift
//  SeSACRxThreads
//
//  Created by jack on 2024/04/05.
//

import Foundation
import RxSwift
import RxCocoa

class BoxOfficeViewModel {
     
    let disposeBag = DisposeBag()
    
    var recent = ["테스트", "테스트1", "테스트2"]
    let movie = ["테스트10", "테스트11", "테스트12"]
    
    struct Input {
        let searchButtonTapped: ControlEvent<Void>
        let searchText: ControlProperty<String>
        let recentText: PublishSubject<String>
    }
    
    struct Output {
        let recent: BehaviorRelay<[String]>
        let movie: PublishSubject<[DailyBoxOfficeList]>
    }
    
    func transform(input: Input) -> Output {
        let recentList = BehaviorRelay(value: recent)
        let boxOfficeList = PublishSubject<[DailyBoxOfficeList]>()
        
        input.searchButtonTapped
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.searchText)
            .map {
                guard let intText = Int($0) else { return 20240101 }
                return intText
            }
            .map { return String($0) }
            .flatMap {
                BoxOfficeNetwork.fetchBoxOfficeData(date: $0)
            }
            .subscribe(with: self) { owner, value in
                let data = value.boxOfficeResult.dailyBoxOfficeList
                boxOfficeList.onNext(data)
            } onError: { _, _ in
                print("Transform Error")
            } onCompleted: { _ in
                print("Transform completed")
            } onDisposed: { _ in
                print("Transform disposed")
            }
            .disposed(by: disposeBag)

        input.recentText
            .subscribe(with: self) { owner, value in
                owner.recent.append(value)
                recentList.accept(owner.recent)
            }
            .disposed(by: disposeBag)
        
        return Output(recent: recentList, movie: boxOfficeList)
    }
    
    
}




