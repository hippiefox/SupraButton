//
//  SupraButtonItem.swift
//  SupraButton
//
//  Created by pulei yu on 2023/10/23.
//

import Foundation
import UIKit

public protocol SupraButtonItem: Equatable {
    func icon(for state: UIControl.State) -> UIImage?

    func text(for state: UIControl.State) -> String?

    func textColor(for state: UIControl.State) -> UIColor?

    var font: UIFont { get }
    var iconSize: CGSize { get }
    var iconTextGap: CGFloat { get }
    var iconDirection: SupraButton.Direction { get }
}

public extension SupraButtonItem {
    var font: UIFont { UIFont.systemFont(ofSize: 12) }
    var iconSize: CGSize { CGSize(width: 22, height: 22) }
    var iconTextGap: CGFloat { 0 }
    var iconDirection: SupraButton.Direction { .top }
}
