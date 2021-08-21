//
//  ViewController.swift
//  ExampleMoyaPulse
//
//  Created by Bagus andinata on 21/08/21.
//

import UIKit
import UIKit
import PulseUI

class ViewController: UIViewController {

    private let provider = ExampleProvider
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        provider.request(ExampleEndpoints.getDummyProduct(id: 3)) { result in
            debugPrint("\(result)")
        }
    }


}

extension UIDevice {
    static let deviceDidShakeNotification = Notification.Name(rawValue: "deviceDidShakeNotification")
}

extension UIWindow {
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            let vc = MainViewController(store: .default)
            UIApplication.shared.windows.first?.rootViewController?.present(vc, animated: true)
        }
    }
}
