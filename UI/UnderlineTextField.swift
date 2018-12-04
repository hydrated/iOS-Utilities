//
//  UnderlineTextField.swift
//  Barracuda-remote
//
//  Created by hydra on 2018/10/31.
//  Copyright © 2018 Roam & Wander. All rights reserved.
//

import UIKit
import RxSwift
import RxGesture

class UnderlineTextField: UITextField {

    static let Under_Line_Tag = 6666
    var normalColor = UIColor(hexString: "8690ad", withAlpha: 0.25)
    var normalTextColor = UIColor(hexString: "015090")
    let errorColor = UIColor(hexString: "fe0013")
    private let disposeBag = DisposeBag()
    private let errorLabel = UILabel()
    private let correctMark = UIImageView()
    private var counter = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInstance()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupInstance()
    }

    func setupInstance() {
        self.clipsToBounds = false
        addUnderLine()
        addMark()
        addErrorIndicator()

        self.rx.controlEvent(.editingDidEnd)
            .asObservable()
            .subscribe(onNext: { [unowned self] _ in
                self.setHighLight(color: self.normalColor)
            })
            .disposed(by: disposeBag)

        self.rx.controlEvent(.editingDidBegin)
            .asObservable()
            .subscribe(onNext: { [unowned self] _ in
                self.setHighLight(color: self.tintColor)
            })
            .disposed(by: disposeBag)

        self.rx.controlEvent(.editingDidEndOnExit)
            .asObservable()
            .subscribe(onNext: { [unowned self] _ in
                self.resignFirstResponder()
            })
            .disposed(by: disposeBag)

    }

    private func addUnderLine() {
        let line = UIView()
        self.addSubview(line)
        line.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(2)
        }
        line.backgroundColor = normalColor
        line.layer.cornerRadius = 1
        line.tag = UnderlineTextField.Under_Line_Tag
    }

    private func addErrorIndicator() {
        self.addSubview(errorLabel)
        errorLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().inset(-22)
            $0.height.equalTo(20)
        }
        errorLabel.textColor = errorColor
        errorLabel.font = UIFont.museoSans500(withSize: 13)
        errorLabel.backgroundColor = UIColor.clear
    }

    private func addMark() {
        self.addSubview(correctMark)
        correctMark.image = UIImage(named: "accepted")?.withRenderingMode(.alwaysTemplate)
        correctMark.tintColor = UIColor(hexString: "00d2a0")
        correctMark.isHidden = true
        correctMark.snp.makeConstraints {
            $0.right.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }

    func setHighLight(color: UIColor?) {
        if let line = subviews
            .filter({$0.tag == UnderlineTextField.Under_Line_Tag}).first {
            line.backgroundColor = color
        }
    }

    func errorIndicator(error: String) {
        if counter != 0 { return }

        counter += 1
        self.errorLabel.text = error

        setHighLight(color: errorColor)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.counter -= 1
            self?.setHighLight(color: self?.normalColor)
            self?.errorLabel.text = ""
        }
    }

}
