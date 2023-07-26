//
//  ViewController.swift
//  Test task from Involta
//
//  Created by Виталий Троицкий on 26.07.2023.
//

import UIKit

class ViewController: UIViewController {
    
    let chatView = ChatView()
    
    override func loadView() {
        view = chatView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    

}

