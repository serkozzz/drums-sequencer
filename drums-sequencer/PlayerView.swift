//
//  PlayingControlPanel.swift
//  drums-sequencer
//
//  Created by Sergey Kozlov on 18.02.2025.
//

import UIKit

protocol PlayerViewDelegate: AnyObject {
    func play(sender: PlayerView)
    func stop(sender: PlayerView)
}

private let borderColor = UIColor.black.cgColor
private let borderWidth: CGFloat = 2
private let cornerRadius: CGFloat = 8

class PlayerView: UIView {

    weak var delegate: PlayerViewDelegate?
    
    lazy var playerStack: UIStackView =  {
    
        var play = UIButton(systemImgName: "play.fill")
        play.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            delegate?.play(sender: self)
        }, for: .touchUpInside)
        
        var bpmLabel = UILabel()
        bpmLabel.text = "bpm"
        
        var bpmTextField = UITextField()
        bpmTextField.text = "120"
        bpmTextField.backgroundColor = UIColor.white
        bpmTextField.layer.borderColor = borderColor
        bpmTextField.layer.borderWidth = borderWidth
        bpmTextField.layer.cornerRadius = cornerRadius
        bpmTextField.textAlignment = .center
        NSLayoutConstraint.activate([
            bpmTextField.widthAnchor.constraint(equalToConstant: 50)
        ])

        
        var stop = UIButton(systemImgName: "stop.fill")
        stop.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            delegate?.stop(sender: self)
        }, for: .touchUpInside)
        
        var bpmStackView = UIStackView(arrangedSubviews: [ bpmLabel, bpmTextField])
        bpmStackView.spacing = 15
        
        var stack = UIStackView(arrangedSubviews: [stop, play, UIView(), bpmStackView])
        
        //stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(playerStack)
        NSLayoutConstraint.activate([
            playerStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            playerStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            playerStack.topAnchor.constraint(equalTo: topAnchor),
            playerStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

private extension UIButton {
    convenience init(systemImgName: String) {
        self.init(type: .system)
        var conf = UIButton.Configuration.filled()
        conf.image = UIImage(systemName: systemImgName)
        conf.baseBackgroundColor = .white
        conf.baseForegroundColor = .black
        self.configuration = conf
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.layer.borderColor = borderColor
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = cornerRadius
    }
}
