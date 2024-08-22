//
//  UIKitKeyBoard.swift
//  RandomKeyboard
//
//  Created by Jae hyung Kim on 8/22/24.
//

import UIKit

final class UIKitKeyBoard: UIViewController {
    
    private let contentView = UIKitKeyBoardView()
    
    private var numberList = ""
    
    override func loadView() {
        view = contentView
        view.backgroundColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logic()
    }

    
    private func logic() {
        contentView.keyboardView.onNumberButtonTapped = { [weak self] num in
            self?.numberList += String(num)
            self?.viewUpdate()
        }
        contentView.keyboardView.onDeleteTapped = { [weak self] in
            if !(self?.numberList.isEmpty ?? true) {
                self?.numberList.removeLast()
                self?.viewUpdate()
            }
        }
        contentView.keyboardView.onCancelTapped = { [weak self] in
            self?.numberList = ""
            self?.viewUpdate()
        }
    }
    
    private func viewUpdate() {
        contentView.setModel(with: numberList)
    }
    
    
    deinit {
        
    }
}

final class UIKitKeyBoardView: UIView {
    
    private let label1 = UILabel()
    
    let keyboardView = KeyboardView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureH()
        configureL()
    }
    
    private func configureH() {
        addSubview(label1)
        addSubview(keyboardView)
    }
    private func configureL() {
        label1.translatesAutoresizingMaskIntoConstraints = false
        keyboardView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label1.topAnchor.constraint(equalTo: topAnchor, constant: 160),
            label1.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            label1.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -60),
            label1.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            keyboardView.topAnchor.constraint(equalTo: label1.bottomAnchor, constant: 0),
            keyboardView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 30),
            keyboardView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            keyboardView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30)
        ])
    }
    
    func setModel(with text: String) {
        label1.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        
    }
}


final class KeyboardView: UIView {
    
    var onNumberButtonTapped: ((Int) -> Void)?
    var onCancelTapped: (() -> Void)?
    var onDeleteTapped: (() -> Void)?
    
    private let numbers: [Int] = Array(0...9).shuffled()
    
    private let mainStackView = UIStackView()
    private let hStackView1 = UIStackView()
    private let hStackView2 = UIStackView()
    private let hStackView3 = UIStackView()
    
    private lazy var cancelButton = createButton(with: "Cancel")
    private lazy var deleteButton = createButton(with: "Delete")
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureStack()
        configureH()
        configureL()
    }
    
    private func configureStack() {
        mainStackView.axis = .vertical
        hStackView1.axis = .horizontal
        hStackView2.axis = .horizontal
        hStackView3.axis = .horizontal
        
        [mainStackView, hStackView1, hStackView2, hStackView3].forEach { view in
            view.alignment = .fill
            view.distribution = .fillEqually
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func configureH() {
        for i in 0..<6 {
            let button = createButton(with: String(numbers[i]))
            button.tag = numbers[i]
            button.addTarget(self, action: #selector(numberButtonTapped), for: .touchUpInside)
            if i < 3 {
                hStackView1.addArrangedSubview(button)
            } else {
                hStackView2.addArrangedSubview(button)
            }
        }
    
        let numberButton = createButton(with: String(numbers[6]))
        numberButton.tag = numbers[6]
        
        numberButton.addTarget(self, action: #selector(numberButtonTapped), for: .touchUpInside)
        
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        
        hStackView3.addArrangedSubview(cancelButton)
        hStackView3.addArrangedSubview(numberButton)
        hStackView3.addArrangedSubview(deleteButton)
        
        mainStackView.addArrangedSubview(hStackView1)
        mainStackView.addArrangedSubview(hStackView2)
        mainStackView.addArrangedSubview(hStackView3)
        
        addSubview(mainStackView)
    }
    
    private func createButton(with title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        button.setTitleColor(.black, for: .normal)
        return button
    }
    
    private func configureL() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }
    
    @objc private func numberButtonTapped(_ sender: UIButton) {
        onNumberButtonTapped?(sender.tag)
    }
    
    @objc private func cancelButtonTapped() {
        onCancelTapped?()
    }
    
    @objc private func deleteButtonTapped() {
        onDeleteTapped?()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        
    }
}


#if DEBUG
@available(iOS 17.0, *)
#Preview {
    UIKitKeyBoard()
}
#endif
