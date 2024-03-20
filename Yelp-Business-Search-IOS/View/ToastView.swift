//
//  ToastCiew.swift
//  Assignment9
//
//  Created by Kiara Lei on 12/5/22.
//

import SwiftUI

// reference : https://stackoverflow.com/questions/56550135/swiftui-global-overlay-that-can-be-triggered-from-any-view

struct Toast<Presenting, Content>: View where Presenting: View, Content: View {
    @Binding var isPresented: Bool
    let presenter: () -> Presenting
    let content: () -> Content
    let delay: TimeInterval = 2

    var body: some View {
        if self.isPresented {
            DispatchQueue.main.asyncAfter(deadline: .now() + self.delay) {
                withAnimation {
                    self.isPresented = false
                }
            }
        }

        return GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                self.presenter()

                ZStack {
                    if #available(iOS 15.0, *) {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(Color(uiColor: UIColor.systemGray2))
                    } else {
                        // Fallback on earlier versions
                    }

                    self.content()
                } //ZStack (inner)
                .frame(width: geometry.size.width / 1.25, height: geometry.size.height / 7)
                .opacity(self.isPresented ? 0.6 : 0)
            } //ZStack (outer)
//            .padding(.bottom)
            
        } //GeometryReader
    } //body
} //Toast


extension View {
    func toast<Content>(isPresented: Binding<Bool>, content: @escaping () -> Content) -> some View where Content: View {
        Toast(
            isPresented: isPresented,
            presenter: { self },
            content: content
        )
    }
}
//struct ToastView_Previews: PreviewProvider {
//    static var previews: some View {
//        ToastView()
//    }
//}
