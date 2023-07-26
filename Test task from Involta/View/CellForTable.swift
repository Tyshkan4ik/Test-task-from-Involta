//
//  CellForTable.swift
//  Test task from Involta
//
//  Created by Виталий Троицкий on 26.07.2023.
//

import UIKit

/// Ячейка для таблицы чата
class CellForTable: UITableViewCell {
    
    //MARK: - Properties
    
    static var identifier: String {
        return String(describing: self)
    }
    
    private let messageFrame: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "355271")
        view.alpha = 0.94
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let message: UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubview()
        setupConstraints()
        backgroundColor = .clear
        contentView.transform = CGAffineTransformMakeScale(1, -1)
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    
    private func setupSubview() {
        contentView.addSubview(messageFrame)
        messageFrame.addSubview(message)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            messageFrame.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            messageFrame.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            messageFrame.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            messageFrame.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            message.leadingAnchor.constraint(equalTo: messageFrame.leadingAnchor, constant: 5),
            message.trailingAnchor.constraint(equalTo: messageFrame.trailingAnchor, constant: -5),
            message.centerYAnchor.constraint(equalTo: messageFrame.centerYAnchor)
        ])
    }
    
    func setupText(model: String) {
        message.text = model
    }
}
