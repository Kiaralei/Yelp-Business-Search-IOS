//
//  UIView+Extension.swift
//  Popovers
//
//  Copyright © 2021 PSPDFKit GmbH. All rights reserved.
// reference : https://pspdfkit.com/blog/2022/presenting-popovers-on-iphone-with-swiftui/
//

import UIKit

extension UIView {
    func closestVC() -> UIViewController? {
        var responder: UIResponder? = self
        while responder != nil {
            if let vc = responder as? UIViewController {
                return vc
            }
            responder = responder?.next
        }
        return nil
    }
}
