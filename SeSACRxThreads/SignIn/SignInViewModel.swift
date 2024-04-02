//
//  SignInViewModel.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import Foundation
import RxCocoa
import RxSwift

class SignInViewModel {
    
    let emailValid = BehaviorSubject(value: false)
    let passwordValid = BehaviorSubject(value: false)
    let signInButtonValid = BehaviorSubject(value: false)
    
    private let disposeBag = DisposeBag()
    
    /// BINDING
    init() {
        Observable.combineLatest(emailValid, passwordValid) { $0 && $1 }
            .bind(to: signInButtonValid)
            .disposed(by: disposeBag)
    }
    
    /// INPUT
    func passwordInput(_ inputValue: String) {
        let valid = checkPasswordValid(inputValue)
        passwordValid.onNext(valid)
    }
    
    func emailInput(_ inputValue: String) {
        let valid = checkEmailValid(inputValue)
        emailValid.onNext(valid)
    }
    
    
    /// BUSINESS LOGIC
    private func checkPasswordValid(_ password: String) -> Bool {
        return password.count >= 8
    }
    
    private func checkEmailValid(_ email: String) -> Bool {
        return email.count >= 8 && email.contains("@")
    }
}
