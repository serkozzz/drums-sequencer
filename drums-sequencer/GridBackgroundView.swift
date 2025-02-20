//
//  GridBackground.swift
//  drums-sequencer
//
//  Created by Sergey Kozlov on 19.02.2025.
//
import UIKit


class GridBackgroundView : UIView {
    private var stackView: UIStackView!
    
    func setColumns(columns: Int){
        stackView.arrangedSubviews.forEach{ $0.removeFromSuperview() }
        for i in 0..<columns / 4 {
            print("i = \(i)")
            let view = createQuarterBackground(quarterNumber: i)
            stackView.addArrangedSubview(view)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func createQuarterBackground(quarterNumber: Int) -> UIView {
        let view = UIView()
        //view.backgroundColor = quarterNumber % 2 == 0 ? .systemGray6 : .systemGray5
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        return view
    }
    
    func setupView() {
        stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        insertSubview(stackView, at: 0)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
