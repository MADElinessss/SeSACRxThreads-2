//
//  MainTableViewCell.swift
//  SeSACRxThreads
//
//  Created by Madeline on 4/1/24.
//

import SnapKit
import RxCocoa
import RxSwift
import UIKit

class MainTableViewCell: UITableViewCell {
    
    static let identifier = "MainTableViewCell"
    
    let appNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    let appIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemMint
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("삭제하기", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.isUserInteractionEnabled = true
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 16
        return button
    }()
    
    var disposeBag = DisposeBag()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        configureView()
        
    }
    
    func configure(element: String) {
        appNameLabel.text = element
        appIconImageView.backgroundColor = .orange
        
//        deleteButton.rx.tap
//            .bind(with: self) { owner, _ in
//                
//            }
//            .disposed(by: disposeBag)
    }
    
    func configureView() {
        contentView.addSubview(appNameLabel)
        contentView.addSubview(appIconImageView)
        contentView.addSubview(deleteButton)
        
        appIconImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(20)
            $0.size.equalTo(60)
        }
        
        appNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(appIconImageView)
            $0.leading.equalTo(appIconImageView.snp.trailing).offset(8)
            $0.trailing.equalTo(deleteButton.snp.leading).offset(-8)
        }
        
        deleteButton.snp.makeConstraints {
            $0.centerY.equalTo(appIconImageView)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(32)
            $0.width.equalTo(72)
        }
    }
    
    // MARK: Cell 재사용 막기 ⭐️
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
