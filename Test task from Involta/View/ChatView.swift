//
//  ChatView.swift
//  Test task from Involta
//
//  Created by Виталий Троицкий on 26.07.2023.
//

import UIKit

protocol ChatViewDelegate: AnyObject {
    func newMassage(offset: Int)
}

/// view для chat сцены
class ChatView: UIView {
    
    private enum Constants {
        static var heightTextView: CGFloat = 40
    }
    
    //MARK: - Properties
    
    weak var delegate: ChatViewDelegate?
    
    var offset = 0
    
    var array2 = [String]()
    
    var canLoadMore = true
    
    lazy var heightTextViewConstraint = NSLayoutConstraint(item: self.textView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)
    
    private lazy var backgroundImage: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "background1")
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Тестовое задание"
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = Colors.textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var table: UITableView = {
        let table = UITableView()
        table.backgroundColor = .clear
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.layer.cornerRadius = 10
        textView.backgroundColor = Colors.mainCellColor
        textView.isScrollEnabled = false
        textView.font = UIFont.boldSystemFont(ofSize: 20)
        
        textView.text = "Сообщение"
        textView.textColor = Colors.placeholder
        //textView.becomeFirstResponder()
        textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    //MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupElements()
        setupConstraints()
        setupTable()
        textView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    
    private func setupElements() {
        addSubview(backgroundImage)
        addSubview(table)
        addSubview(headerLabel)
        addSubview(textView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: topAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            headerLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            headerLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            table.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 10),
            table.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            table.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            textView.topAnchor.constraint(equalTo: table.bottomAnchor, constant: 10),
            textView.leadingAnchor.constraint(equalTo: table.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: table.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: keyboardLayoutGuide.topAnchor, constant: -10),
            heightTextViewConstraint,
        ])
    }
    
    private func setupTable() {
        table.delegate = self
        table.dataSource = self
        table.register(CellForTable.self, forCellReuseIdentifier: CellForTable.identifier)
        table.transform = CGAffineTransformMakeScale(1, -1)
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
    }
    
    func setup(model: MessageModel) {
        
        if array2.isEmpty {
            array2 = model.message
            canLoadMore = model.canLoadMore
            table.reloadData()
        } else {
            let offset = array2.count
            array2 += model.message
            canLoadMore = model.canLoadMore
            
            var index = [IndexPath]()
            
            for i in offset..<(offset + model.message.count) {
                index.append(IndexPath(row: i, section: 0))
            }
            table.insertRows(at: index, with: .bottom)
        }
    }
}

//MARK: - Extension - UITableViewDataSource

extension ChatView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array2.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellForTable.identifier, for: indexPath) as? CellForTable else {
            return UITableViewCell()
        }
        cell.setupText(model: array2[indexPath.row])
        return cell
    }
}

//MARK: - Extension - UITableViewDelegate

extension ChatView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == array2.count - 1, canLoadMore {
            offset = array2.count
            delegate?.newMassage(offset: offset)
        }
    }
}

//MARK: - Extension - UITextViewDelegate

extension ChatView: UITextViewDelegate {
    /// изменяем высоту textView
    func textViewDidChange(_ textView: UITextView) {
        let size = textView.sizeThatFits(CGSize(width: textView.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        if size.height != heightTextViewConstraint.constant && size.height > textView.frame.size.height{
            heightTextViewConstraint.constant = size.height
            textView.setContentOffset(CGPoint.zero, animated: false)
            return
        }
        if size.height != heightTextViewConstraint.constant && size.height < textView.frame.size.height{
            heightTextViewConstraint.constant = size.height
            textView.setContentOffset(CGPoint.zero, animated: false)
        }
    }
    
    /// Добавляем Placeholder
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText: String = textView.text
        let updateText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        if updateText.isEmpty {
            textView.text = "Сообщение"
            textView.textColor = Colors.placeholder
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        } else if textView.textColor == Colors.placeholder && !text.isEmpty {
            textView.textColor = Colors.textColor
            textView.text = text
        } else {
            return true
        }
        return false
    }
    
    /// Запрещаем пользователю перемещать ползунок по Placeholder
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.window != nil {
            if textView.textColor == Colors.placeholder {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
}
