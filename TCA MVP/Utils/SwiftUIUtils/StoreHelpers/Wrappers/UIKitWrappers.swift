//
//  UIKitWrappers.swift
//  TCA MVP
//
//  Created by Salvador on 3/25/25.
//

import SwiftUI

/// `WrapperViews`: Intended for `UIKit` views that wrap `SwiftUI`'s `View`s. A bridging of sorts between the `SwiftUI` realm and the `UIKit` realm.

final class HostingTableViewCell<Content: View>: UITableViewCell {
    private var uiHostingController: UIHostingController<Content>?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }

    func configure(with swiftUIView: Content) {
        // 1
        // Remove the previous hosting controller's view from the contentView (if any)
        uiHostingController?.view.removeFromSuperview()

        // 2
        // Create a new UIHostingController with the provided SwiftUI view
        let uiHostingController = UIHostingController(rootView: swiftUIView)
        
        let swiftuiView = uiHostingController.view!
        swiftuiView.backgroundColor = .clear

        // 3
        // Add the hosting controller’s view to the UITableViewCell’s contentView
        contentView.addSubview(swiftuiView)

        // 4
        // Create and activate the constraints for the swiftui's view.
        swiftuiView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            swiftuiView.topAnchor.constraint(equalTo: contentView.topAnchor),
            swiftuiView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            swiftuiView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            swiftuiView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])

        // 5
        // Store a reference to the new hosting controller
        self.uiHostingController = uiHostingController
    }
}
