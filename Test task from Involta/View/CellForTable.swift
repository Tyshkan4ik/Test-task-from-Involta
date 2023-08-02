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
    
    private lazy var messageFrame: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.mainCellColor
        view.alpha = 0.95
        
        view.layer.cornerRadius = 18
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let message: UILabel = {
        let label = UILabel()
        label.textColor = Colors.textColor
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
        message.setContentHuggingPriority(.required, for: .vertical)
        message.setContentCompressionResistancePriority(.required, for: .vertical)
        NSLayoutConstraint.activate([
            messageFrame.topAnchor.constraint(equalTo: contentView.topAnchor),
            messageFrame.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            messageFrame.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            message.topAnchor.constraint(equalTo: messageFrame.topAnchor, constant: 8),
            message.leadingAnchor.constraint(equalTo: messageFrame.leadingAnchor, constant: 12),
            message.trailingAnchor.constraint(equalTo: messageFrame.trailingAnchor, constant: -12),
            message.bottomAnchor.constraint(equalTo: messageFrame.bottomAnchor, constant: -8),
            message.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, constant:  -15)
        ])
    }
    
    func setupText(model: String) {
        message.text = model
    }
}
