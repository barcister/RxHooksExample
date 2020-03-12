//
//  AppDelegate.swift
//  RxHooksExample
//
//  Created by Bálint Barczi on 2020. 03. 12..
//  Copyright © 2020. Bálint Barczi. All rights reserved.
//

import UIKit
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		setupGeneralErrorHandling()
        return true
    }

    private func setupGeneralErrorHandling() {
        Hooks.recordCallStackOnError = true
        Hooks.defaultErrorHandler = { [unowned self] callback, error in
            if let inner = error as? GeneralError {
                print("Default error handling: \(inner.localizedDescription)")
                print("CALLBACK: \(callback)")
                UIApplication.shared.windows.first?.rootViewController?.present(self.getAlert(), animated: true)
            }
        }
    }

    private func getAlert() -> UIAlertController {
		let alert = UIAlertController(title: "Hi",
                                      message: "This is a general error handled by Hooks",
                                      preferredStyle: .alert)
    	alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        return alert
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

