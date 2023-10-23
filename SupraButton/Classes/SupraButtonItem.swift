//
//  SupraButtonItem.swift
//  SupraButton
//
//  Created by pulei yu on 2023/10/23.
//

import Foundation
import UIKit

public protocol SupraButtonItem: Equatable {
    var title4Normal: String? { get }
    var icon4Normal: UIImage? { get }
    var titleColor4Normal: UIColor { get }

    var title4Selected: String? { get }
    var icon4Selected: UIImage? { get }
    var titleColor4Seleted: UIColor? { get }

    var title4Disable: String? { get }
    var icon4Disable: UIImage? { get }
    var titleColor4Disable: UIColor? { get }

    var titleFont: UIFont { get }
    var iconSize: CGSize { get }
    var iconTintColor: UIColor?{get}
}

public extension SupraButtonItem {
    var title4Normal: String? { nil }
    var icon4Normal: UIImage? { nil }
    var titleColor4Normal: UIColor { .black }

    var title4Selected: String? { nil }
    var icon4Selected: UIImage? { nil }
    var titleColor4Seleted: UIColor? { .black }

    var title4Disable: String? { nil }
    var icon4Disable: UIImage? { nil }
    var titleColor4Disable: UIColor? { nil }
    
    var titleFont: UIFont { UIFont.systemFont(ofSize: 12) }
    var iconSize: CGSize { CGSize(width: 22, height: 22) }
    var iconTintColor: UIColor?{nil}
}
