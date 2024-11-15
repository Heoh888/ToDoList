//
//  ViewController.swift
//  ToDoList
//
//  Created by Алексей Ходаков on 15.11.2024.
//

import UIKit

class ViewController: UIViewController {
    
    let service = NetworkService()

    override func viewDidLoad() {
        super.viewDidLoad()
        service.fetchTasks { data in
            print(data)
        }
    }
}

