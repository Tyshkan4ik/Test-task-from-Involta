//
//  ChatView.swift
//  Test task from Involta
//
//  Created by Виталий Троицкий on 26.07.2023.
//

import UIKit


/// view для chat сцены
class ChatView: UIView {
    
    //MARK: - Properties
    
    private lazy var backgroundImage: UIImageView = {
       let imageView = UIImageView()
        let image = UIImage(named: "background1")
        imageView.image = image
        imageView.alpha = 0.8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    //MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupElements()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    
    private func setupElements() {
        addSubview(backgroundImage)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: topAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
