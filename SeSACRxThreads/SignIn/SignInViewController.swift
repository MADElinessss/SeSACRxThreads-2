//
//  SignInViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class SignInViewController: UIViewController {

    let emailTextField = SignTextField(placeholderText: "이메일을 입력해주세요")
    let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해주세요")
    let passwordDescriptionaLabel = UILabel()
    let emailDescriptionaLabel = UILabel()
    let signInButton = PointButton(title: "로그인")
    let signUpButton = UIButton()
    
    let emailValidText = BehaviorSubject(value: "8자 이상 입력해주세요.")
    let passwordValidText = Observable.just("8자 이상 입력해주세요.")
    
    let disposeBag = DisposeBag()
    let viewModel = SignInViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        configure()
        bind()
    }
    
    func bind() {
        /// "회원아니냐" 버튼
        signUpButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(SignUpViewController(), animated: true)
            }
            .disposed(by: disposeBag)
        
        /// "로그인" 버튼
        signInButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.validationBind()
            }
            .disposed(by: disposeBag)
    }
    
    func validationBind() {
        /// 비밀번호 유효성 검사(8자 이상)
        passwordValidText
            .bind(to: passwordDescriptionaLabel.rx.text)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: viewModel.passwordInput)
            .disposed(by: disposeBag)
        
        viewModel.passwordValid
            .bind(with: self) { owner, value in
                owner.passwordDescriptionaLabel.isHidden = value ? true : false
            }
            .disposed(by: disposeBag)
        
        /// 이메일 유효성 검사(8자 이상 && '@'포함)
        emailValidText
            .bind(to: emailDescriptionaLabel.rx.text)
            .disposed(by: disposeBag)
        
        emailTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: viewModel.emailInput)
            .disposed(by: disposeBag)
        
        viewModel.emailValid
            .bind(with: self) { owner, value in
                owner.emailDescriptionaLabel.isHidden = value ? true : false
            }
            .disposed(by: disposeBag)
        
        viewModel.emailDescriptionText
            .bind(to: emailDescriptionaLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.signInButtonValid
            .bind(to: signInButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.signInButtonValid
            .map { $0 ? UIColor.black : UIColor.lightGray }
            .bind(to: signInButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        signInButton.rx.tap
            .bind(with: self) { owner, _ in
                let vc = MainViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    func configure() {
        signUpButton.setTitle("회원이 아니십니까?", for: .normal)
        signUpButton.setTitleColor(Color.black, for: .normal)
    }
    
    func configureLayout() {
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(passwordDescriptionaLabel)
        view.addSubview(emailDescriptionaLabel)
        view.addSubview(signInButton)
        view.addSubview(signUpButton)
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        emailDescriptionaLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(4)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(24)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(emailTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        passwordDescriptionaLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(4)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(24)
        }
        
        signInButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(signInButton.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        emailDescriptionaLabel.font = .systemFont(ofSize: 10, weight: .medium)
        passwordDescriptionaLabel.font = .systemFont(ofSize: 10, weight: .medium)
    }
    
    func showOKayAlert(on viewController: UIViewController,
                   title: String,
                   message: String,
                   confirmButtonText: String = "확인",
                   confirmAction: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: confirmButtonText, style: .default) { _ in
            confirmAction?()
        }
        alert.addAction(ok)
        
        DispatchQueue.main.async {
            viewController.present(alert, animated: true)
        }
    }
}
