//
//  ViewController.swift
//  RxHooksExample
//
//  Created by Bálint Barczi on 2020. 03. 12..
//  Copyright © 2020. Bálint Barczi. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var subscribeButton: UIButton!
    @IBOutlet weak var doButton: UIButton!

    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }

    private func setupBindings() {
        loginButton.rx.tap
        	.flatMap { [unowned self] _ in self.login() }
            .subscribe()
        	.disposed(by: bag)

        doButton.rx.tap
            .flatMap { [unowned self] _ in self.login() }
            .do(onError: { [weak self] error in
                if error is CustomError {
                    self?.showCustomAlert()
                }
            })
            .subscribe()
            .disposed(by: bag)

        subscribeButton.rx.tap
            .flatMap { [unowned self] _ in self.loginCustomError() }
            .subscribe(onError: { [weak self] error in
                if error is CustomError {
                    self?.showCustomAlert()
                }
            })
            .disposed(by: bag)
    }

    private func login() -> Observable<Void> {
        return Observable.error(GeneralError())
    }

    private func loginCustomError() -> Observable<Void> {
		return Observable.error(CustomError())
    }

    private func showCustomAlert() {
        let alert = UIAlertController(title: "Hi",
                                      message: "This is a custom error!",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alert, animated: true)
    }
}

struct GeneralError: Error {
    let localizedDescription: String
    public init() {
        self.localizedDescription = "General Error"
    }
}

struct CustomError: Error {
    let localizedDescription: String
    public init() {
        self.localizedDescription = "Custom Error"
    }
}

