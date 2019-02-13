//
//  UIAlertController+Additions.swift
//  NetFlux
//
//  Created by Shahin on 2019-02-04.
//  Copyright © 2019 98%Chimp. All rights reserved.
//

import UIKit

extension UIAlertController
{
    func show()
    {
        present(animated: true, completion: nil)
    }
    
    func present(animated: Bool, completion: (() -> Void)?)
    {
        if let rootVC = UIApplication.shared.keyWindow?.rootViewController
        {
            presentFromController(controller: rootVC, animated: animated, completion: completion)
        }
    }
    
    private func presentFromController(controller: UIViewController, animated: Bool, completion: (() -> Void)?)
    {
        if let navVC = controller as? UINavigationController, let visibleVC = navVC.visibleViewController
        {
            presentFromController(controller: visibleVC, animated: animated, completion: completion)
        }
        else if let tabVC = controller as? UITabBarController, let selectedVC = tabVC.selectedViewController
        {
            presentFromController(controller: selectedVC, animated: animated, completion: completion)
        }
        else
        {
            controller.present(self, animated: animated, completion: completion);
        }
    }
    
    func addAction(withTitle title: String?, style: UIAlertAction.Style = .default, handler: (() -> Void)? = nil)
    {
        addAction(UIAlertAction(title: title, style: style, handler: { _ in
            handler?()
        }))
    }
    
    func addCancelAction() {
        addAction(UIAlertAction(title: Constants.Alerts.ActionTitles.cancel, style: .cancel, handler: nil))
    }
}

