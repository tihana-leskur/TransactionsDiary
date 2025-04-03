//
//  SwiftUI+Extensions.swift
//  TransactionsDiary
//
//  Created by tihana leskur on 3/31/25.
//

import SwiftUI
import UIKit

// MARK: - Optional Modifier
extension View {
    func `if`<Content: View>(_ conditional: Bool, content: (Self) -> Content) -> some View {
         if conditional {
             return AnyView(content(self))
         } else {
             return AnyView(self)
         }
     }

    func `if`<Content: View>(
        _ conditional: Bool,
        content: (Self) -> Content,
        `else`: (Self) -> Content
    ) -> some View {
         if conditional {
             return AnyView(content(self))
         } else {
            return AnyView(`else`(self))
         }
     }
}

// MARK: - View Lifecycle
extension View {
    func onWillAppear(_ perform: @escaping () -> Void) -> some View {
        modifier(WillAppearModifier(callback: perform))
    }
    
    func onWillDisappear(_ perform: @escaping () -> Void) -> some View {
        modifier(WillDisappearModifier(callback: perform))
    }
}

struct WillAppearModifier: ViewModifier {
    let callback: () -> Void

    func body(content: Content) -> some View {
        content.background(UIViewLifeCycleHandler(onWillAppear: callback))
    }
}

struct WillDisappearModifier: ViewModifier {
    let callback: () -> Void

    func body(content: Content) -> some View {
        content.background(UIViewLifeCycleHandler(onWillDisappear: callback))
    }
}

struct UIViewLifeCycleHandler: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController

    var onWillAppear: () -> Void = { }
    var onWillDisappear: () -> Void = { }

    func makeUIViewController(context: UIViewControllerRepresentableContext<Self>) -> UIViewControllerType {
        context.coordinator
    }

    func updateUIViewController(
        _: UIViewControllerType,
        context _: UIViewControllerRepresentableContext<Self>
    ) { }

    func makeCoordinator() -> Self.Coordinator {
        Coordinator(
            onWillAppear: onWillAppear,
            onWillDisappear: onWillDisappear
        )
    }

    class Coordinator: UIViewControllerType {
        let onWillAppear: () -> Void
        let onWillDisappear: () -> Void

        init(
            onWillAppear: @escaping () -> Void,
            onWillDisappear: @escaping () -> Void
        ) {
            self.onWillAppear = onWillAppear
            self.onWillDisappear = onWillDisappear
            super.init(nibName: nil, bundle: nil)
        }

        required init?(coder _: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            onWillAppear()
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            onWillDisappear()
        }
    }
}

// MARK: - View + Dismiss Keyboard on Tap
extension View {
    func endTextEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
    }
}
