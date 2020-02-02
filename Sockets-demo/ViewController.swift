//
//  ViewController.swift
//  Sockets-demo
//
//  Created by Prakhar Tripathi on 02/02/20.
//  Copyright © 2020 Prakhar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var webSocketTask: URLSessionWebSocketTask?
    var notificationSent = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.green
        UNUserNotificationCenter.current().delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupSocketConnection()
    }
    
    func setupSocketConnection() {
        let urlSession = URLSession(configuration: .default)
        webSocketTask = urlSession.webSocketTask(with: URL(string: "ws://127.0.0.1:5678/")!)
        webSocketTask?.resume()
        self.receiveMessages()
    }
    
    func receiveMessages() {
        webSocketTask?.receive { result in
            switch result {
            case .failure:
                print("Error")
            case .success(let message):
                switch message {
                case .string(let text):
                    print("Received string: \(text)")
                    if text == "DANGER" {
                        DispatchQueue.main.async {
                            self.view.backgroundColor = UIColor.red
                            if !self.notificationSent {
                                self.sendNotifications()
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.view.backgroundColor = UIColor.green
                        }
                    }
                case .data(let data):
                    print("Received data: \(data)")
                @unknown default:
                    print("Unknown case")
                }
            }
            self.receiveMessages()
        }
    }
    
    func sendNotifications() {
        let content = UNMutableNotificationContent()
        let requestIdentifier = "sampleNotification"

        content.badge = 1
        content.title = "Signal changed"
        content.body = "DANGER! DANGER!"
        content.categoryIdentifier = "actionCategory"
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 0.1, repeats: false)

        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error:Error?) in

            if error != nil {
                print(error?.localizedDescription ?? "some unknown error")
            }
            print("Notification Register Success")
        }
        notificationSent = true
    }
}

extension ViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }

    // For handling tap and user actions
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

        switch response.actionIdentifier {
        case "action1":
            print("Action First Tapped")
        case "action2":
            print("Action Second Tapped")
        default:
            break
        }
        completionHandler()
    }

}
