//
//  MainViewController.swift
//  SeSACRxThreads
//
//  Created by Madeline on 4/1/24.
//

import SnapKit
import RxCocoa
import RxSwift
import UIKit

class MainViewController: UIViewController {
    
    private let tableView: UITableView = {
        let view = UITableView()
        view.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.identifier)
        view.backgroundColor = .white
        view.rowHeight = 100
        view.separatorStyle = .none
        return view
    }()
    
    let searchBar = UISearchBar()
    
    var data = ["🍏Apple", "🥑Avocado", "🫒Olive", "🥗Salad", "🧃Juice", "🥬Cabbage", "🥒Cucumber", "🍋Lemon"]
    let disposeBag = DisposeBag()
    lazy var items = BehaviorSubject(value: data)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configure()
        bind()

    }
    
    func bind() {
        // MARK: TableView
        items
            .bind(to: tableView.rx.items(cellIdentifier: MainTableViewCell.identifier, cellType: MainTableViewCell.self)) { (row, element, cell) in
                
                cell.configure(element: element)
                
            }
            .disposed(by: disposeBag)
        
        Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(String.self))
            .bind(with: self) { owner, value in
                owner.showOKayAlert(on: self, title: "\(value.1)", message: "Tap!")
            }
            .disposed(by: disposeBag)
        
        searchBar.rx.text.orEmpty
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(with: self) { owner, value in
                let result = value.isEmpty ? owner.data : owner.data.filter { $0.contains(value) }
                owner.items.onNext(result)
            }
            .disposed(by: disposeBag)
        
    }
    func configure() {
        view.addSubview(tableView)
         view.addSubview(searchBar)
         navigationItem.rightBarButtonItem = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(plusButtonClicked))
         navigationItem.titleView = searchBar
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    @objc func plusButtonClicked() {
        let sample = ["A", "B", "C", "D", "E"]
        data.append(sample.randomElement()!)
        items.onNext(data)
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
