//
//  View+Modifiers.swift
//  Popovers
//
//  Copyright © 2021 PSPDFKit GmbH. All rights reserved.
// reference : https://pspdfkit.com/blog/2022/presenting-popovers-on-iphone-with-swiftui/
//

import SwiftUI

extension View {
    public func alwaysPopover<Content>(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) -> some View where Content : View {
        self.modifier(AlwaysPopoverModifier(isPresented: isPresented, contentBlock: content))
    }
}
