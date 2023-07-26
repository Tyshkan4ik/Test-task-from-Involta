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
    
    var array = ["Привет", "2", "3", "4", "Что скажешь? пошли гулять! Потом придем домой и будем программировать код. А завтра с утра пойдем в кино, а потом в мак. А на следующей неделе поедем серфить", "6", "7", "8"]
    
    private lazy var backgroundImage: UIImageView = {
       let imageView = UIImageView()
        let image = UIImage(named: "background1")
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: topAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            table.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
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
}

//MARK: - Extension - UITableViewDataSource

extension ChatView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellForTable.identifier, for: indexPath) as? CellForTable else {
            return UITableViewCell()
        }
        cell.setupText(model: array[indexPath.row])
        return cell
    }
}

//MARK: - Extension - UITableViewDelegate

extension ChatView: UITableViewDelegate {
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let cell = tableView.cellForRow(at: indexPath)
//        return 100
//    }
}
