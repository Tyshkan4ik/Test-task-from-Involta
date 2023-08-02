//
//  ViewController.swift
//  Test task from Involta
//
//  Created by Виталий Троицкий on 26.07.2023.
//

import UIKit

class ViewController: UIViewController {
    
    let chatView = ChatView()
    
    let networkService = NetworkService()
    
    lazy var heightConstraintIndicator = NSLayoutConstraint(item: indicatorView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: .equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 0)
    
    var messageModel = MessageModel()
    
    var currentOffset = 0
    
    private var canLoadNewMessages = true
    
    private lazy var indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemRed
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var networkWaitingLabel: UILabel = {
        let label = UILabel()
        label.text = "Ожидание сети..."
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var refresIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .systemBlue
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    override func loadView() {
        view = chatView
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAround))
        view.addGestureRecognizer(tap)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMessage(offset: currentOffset)
        chatView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(showOfflineDeviceUI(notification:)), name: NSNotification.Name.connectivityStatus, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @objc
    func showOfflineDeviceUI(notification: Notification) {
        if NetworkMonitor.shared.isConnected {
            print("Connected")
            DispatchQueue.main.async {
                self.hideNetworkWaiting()
            }
        } else {
            print("Not connected")
            DispatchQueue.main.async {
                self.showNetworkWaiting()
                
            }
        }
    }
    
    private func getMessage(offset: Int) {
        canLoadNewMessages = false
        showLoader()
        networkService.getMessage(for: MessageRequest(offset: String(offset))) { [weak self] result in
            DispatchQueue.main.async {
                self?.canLoadNewMessages = true
                switch result {
                case let .success(model):
                    guard let result = model.result else {
                        return
                    }
                    
                    var intermediateModel = MessageModel()
                    intermediateModel.canLoadMore = !result.isEmpty
                    intermediateModel.message = result
                    
                    self?.messageModel.canLoadMore = !result.isEmpty
                    self?.messageModel.message += result
                    
                    self?.hideLoader()
                    
                    self?.chatView.setup(model: intermediateModel)
                    
                case .failure:
                    self?.getMessage(offset: offset)
                }
            }
        }
    }
    
    private func showLoader() {
        view.addSubview(refresIndicator)
        refresIndicator.startAnimating()
        NSLayoutConstraint.activate([
            refresIndicator.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            refresIndicator.widthAnchor.constraint(equalToConstant: 40),
            refresIndicator.heightAnchor.constraint(equalToConstant: 40),
            refresIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func hideLoader() {
        refresIndicator.stopAnimating()
        refresIndicator.removeFromSuperview()
    }
    
    
    private func showNetworkWaiting() {
        
        view.addSubview(indicatorView)
        indicatorView.addSubview(networkWaitingLabel)
        
        NSLayoutConstraint.activate([
            heightConstraintIndicator,
            indicatorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            indicatorView.widthAnchor.constraint(equalTo: view.widthAnchor),
            indicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            networkWaitingLabel.centerYAnchor.constraint(equalTo: indicatorView.centerYAnchor),
            networkWaitingLabel.centerXAnchor.constraint(equalTo: indicatorView.centerXAnchor)
        ])
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.5) {
            self.heightConstraintIndicator.constant = 30
            self.view.layoutIfNeeded()
        }
    }
    
    private func hideNetworkWaiting() {
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.5) {
            self.heightConstraintIndicator.constant = 0
            self.view.layoutIfNeeded()
        } completion: {_ in
            self.indicatorView.removeFromSuperview()
        }
    }
    
    @objc
    private func tapAround() {
        view.endEditing(true)
    }
}

extension ViewController: ChatViewDelegate {
    func newMassage(offset: Int) {
        if canLoadNewMessages {
            currentOffset = offset
            getMessage(offset: currentOffset)
        }
    }
}
