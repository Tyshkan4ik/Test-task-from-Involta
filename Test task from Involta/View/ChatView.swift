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
    
    //MARK: - Properties
    
    weak var delegate: ChatViewDelegate?
    
    var offset = 0
    
    var array2 = [String]()
    
    var canLoadMore = true
    
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
    
    //MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupElements()
        setupConstraints()
        setupTable()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    
    private func setupElements() {
        addSubview(backgroundImage)
        addSubview(table)
        addSubview(headerLabel)
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
            table.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
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
