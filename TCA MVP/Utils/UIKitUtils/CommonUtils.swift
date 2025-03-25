//
//  CommonUtils.swift
//  TCA MVP
//
//  Created by Salvador on 3/25/25.
//

import UIKit
import SwiftUI

extension UITableView {
    func register(_ cellClass: UITableViewCell.Type) { register(cellClass, forCellReuseIdentifier: cellClass.identifier) }
    
    /** Must set the `.xib` table view cell `identifier` to be the same as the name of the `.swift` file to work */
    func registerNib(_ cellClass: UITableViewCell.Type) {
        register(UINib(nibName: cellClass.identifier, bundle: nil), forCellReuseIdentifier: cellClass.identifier)
    }
    
    func dequeueReusableCell<CellType: UITableViewCell>() -> CellType? {
        dequeueReusableCell(withIdentifier: CellType.identifier) as? CellType
    }
    
    func dequeueReusableCell<CellType: UITableViewCell>(for indexPath: IndexPath) -> CellType {
        guard let cell = dequeueReusableCell(withIdentifier: CellType.identifier, for: indexPath) as? CellType
        else { fatalError("\(CellType.identifier) class is not registered") }
        return cell
    }
    
    /** `numberOfRows(inSection: Int)` is a count, we must consider the indices. Used for `UITableViewDataSourcePrefetching`'s `prefetchRowsAt` method */
    func hasLoadingCellAt(indexPath: IndexPath) -> Bool {
        let lastSectionRow = numberOfRows(inSection: indexPath.section) - 1
        return indexPath.row >= lastSectionRow
    }
}

extension UICollectionView {
    func register(_ cellClass: UICollectionViewCell.Type) { register(cellClass, forCellWithReuseIdentifier: cellClass.identifier) }
    
    // Must set the .xib collection view cell identifier to be the same as the name of the .swift file to work
    func registerNib(_ cellClass: UICollectionViewCell.Type) {
        register(UINib(nibName: cellClass.identifier, bundle: nil), forCellWithReuseIdentifier: cellClass.identifier)
    }
    
    func dequeueReusableCell<CellType: UICollectionViewCell>(for indexPath: IndexPath) -> CellType {
        guard let cell = dequeueReusableCell(withReuseIdentifier: CellType.identifier, for: indexPath) as? CellType
        else { fatalError("\(CellType.identifier) class is not registered") }
        return cell
    }
}

extension UITableViewCell {
    static var identifier: String { String(describing: self) }
}

extension UICollectionViewCell {
    static var identifier: String { String(describing: self) }
}

extension Array {
    var isNotEmpty: Bool { !isEmpty }
}

extension String {
    var isNotEmpty: Bool { !isEmpty }
}

extension Dictionary {
    var isNotEmpty: Bool { !isEmpty }
}

extension UIViewController {
    static var identifier: String { String(describing: self) }
    
    // Must set the .xib file name to be the same as the name of the UIViewController .swift file to work
    static func instantiateAsNib() -> Self { Self(nibName: Self.identifier, bundle: Bundle.main) }
    static func instantiateFromNib(_ viewControllerClass: UIViewController.Type) -> Self { Self(nibName: viewControllerClass.identifier, bundle: Bundle.main) }
    
    func setSwiftUIView<Content: View>(_ content: Content) {
        // Create a UIHostingController with the SwiftUI View
        let uiHostingController = UIHostingController(rootView: content)

        // 1
        let swiftuiView = uiHostingController.view!
        
        // 2
        // Add the view controller to the destination view controller.
        addChild(uiHostingController)
        view.addSubview(swiftuiView)
        
        // 3
        // Create and activate the constraints for the swiftui's view.
        swiftuiView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            swiftuiView.topAnchor.constraint(equalTo: view.topAnchor),
            swiftuiView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            swiftuiView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            swiftuiView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        
        // 4
        // Notify the child view controller that the move is complete.
        uiHostingController.didMove(toParent: self)
    }
}

extension Array {
    mutating func mutableForEach(_ body: (inout Element) throws -> Void) rethrows { try mutableForEach(isIncluded: { _ in true }, body: body) }
    
    mutating func mutableForEach(isIncluded: (Element) throws -> Bool, body: (inout Element) throws -> Void) rethrows {
        for (index, element) in enumerated() where try isIncluded(element) { try body(&self[index]) }
    }
}
