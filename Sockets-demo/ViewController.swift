//
//  ViewController.swift
//  Sockets-demo
//
//  Created by Prakhar Tripathi on 02/02/20.
//  Copyright © 2020 Prakhar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupSocketConnection()
    }
    
    func setupSocketConnection() {
        let urlSession = URLSession(configuration: .default)
        let webSocketTask = urlSession.webSocketTask(with: URL(string: "ws://127.0.0.1:5678/")!)
        webSocketTask.resume()
        self.receiveMessages(webSocketTask: webSocketTask)
    }
    
    func receiveMessages(webSocketTask: URLSessionWebSocketTask) {
        webSocketTask.receive { result in
          switch result {
          case .failure(let error):
            print("Error in receiving message: \(error)")
          case .success(let message):
            switch message {
            case .string(let text):
              print("Received string: \(text)")
            case .data(let data):
              print("Received data: \(data)")
            @unknown default:
                print("Unknown case")
            }
          }
            self.receiveMessages(webSocketTask: webSocketTask)
        }
    }
}
