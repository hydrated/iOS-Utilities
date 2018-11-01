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
    var normalColor = UIColor(hexString: "8690ad", withAlpha: 0.5)
    private let disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInstance()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupInstance()
    }

    func setupInstance() {
        addUnderLine()

        self.rx.controlEvent([.editingDidEnd])
            .asObservable()
            .subscribe(onNext: { [unowned self] _ in
                self.setHighLight(isHighLight: false)
            })
            .disposed(by: disposeBag)

        self.rx.controlEvent([.editingDidBegin])
            .asObservable()
            .subscribe(onNext: { [unowned self] _ in
                self.setHighLight(isHighLight: true)
            })
            .disposed(by: disposeBag)
    }

    func addUnderLine() {
        let line = UIView()
        self.addSubview(line)
        line.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(2)
        }
        line.backgroundColor = normalColor
        line.layer.cornerRadius = 1
        line.tag = UnderlineTextField.Under_Line_Tag
    }

    func setHighLight(isHighLight: Bool) {
        if let line = subviews
            .filter({$0.tag == UnderlineTextField.Under_Line_Tag}).first {
            line.backgroundColor = isHighLight ? tintColor : normalColor
        }
    }

}
