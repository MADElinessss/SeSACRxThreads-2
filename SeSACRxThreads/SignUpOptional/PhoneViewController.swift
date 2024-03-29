//
//  PhoneViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//
 
import UIKit
import RxSwift
import RxCocoa
import SnapKit

class PhoneViewController: UIViewController {
   
    let phoneTextField = SignTextField(placeholderText: "연락처를 입력해주세요")
    let nextButton = PointButton(title: "다음")
    let descriptionLabel = UILabel()
    
    let numberValidation = BehaviorSubject(value: "숫자만 입력할 수 있습니다.")
    let phoneNumber = Observable.just("010")
    // var phoneNumber = BehaviorSubject(value: "010") // 전달 할수도, 받을 수도 있음
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        
        bind()
    }
    
    func bind() {
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(NicknameViewController(), animated: true)
            }
            .disposed(by: disposeBag)
        
        phoneNumber
            .bind(to: phoneTextField.rx.text)
            .disposed(by: disposeBag)
        
//        numberValidation
//            .bind(to: descriptionLabel.rx.text)
//            .disposed(by: disposeBag)
//        
//        countValidation
//            .bind(to: descriptionLabel.rx.text)
//            .disposed(by: disposeBag)
//        
        
        let numberValid = phoneTextField.rx.text.orEmpty.map { $0.count >= 10 }
        let countValid = phoneTextField.rx.text.orEmpty.map { Int($0) }
        // let everythingValid = Observable.combineLatest(numberValid, countValid) { $0 && $1 }
        
        numberValid
            .bind(to: nextButton.rx.isEnabled, descriptionLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        
        countValid
//            .bind(to: nextButton.rx.isEnabled, description.onNext("10글자 이상"))
            .bind(with: self, onNext: { owner, value in
                owner.nextButton.isEnabled = true
                owner.numberValidation.onNext("10글자 이상")
            })
            .disposed(by: disposeBag)
        
        
        numberValid
            .bind(with: self) { owner, value in
                let color: UIColor = value ? .red : .lightGray
                owner.nextButton.backgroundColor = color
            }
            .disposed(by: disposeBag)
    }
    
    func configureLayout() {
        view.addSubview(phoneTextField)
        view.addSubview(nextButton)
        view.addSubview(descriptionLabel)
        
        descriptionLabel.font = .systemFont(ofSize: 12, weight: .medium)
         
        phoneTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(phoneTextField.snp.bottom).offset(8)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(phoneTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}
