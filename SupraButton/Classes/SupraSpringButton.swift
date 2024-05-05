//
//  SupraSpringButton.swift
//  SupraButton
//
//  Created by pulei yu on 2023/10/23.
//

import Foundation
import UIKit

open class SupraSpringButton: SupraButton {
    public var maxHeight: CGFloat = 0
    public var maxWidth: CGFloat = 0
    public var contentEdgesInset: UIEdgeInsets = .zero

    override open var isSelected: Bool {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override open var isEnabled: Bool {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override open var intrinsicContentSize: CGSize {
        var _text = text(for: .normal) ?? ""

        if isSelected,
           let t = text(for: .selected) {
            _text = t
        }

        if isEnabled == false,
           let t = text(for: .disabled) {
            _text = t
        }

        var _textSize: CGSize = .zero
        if _text.isEmpty == false {
            _textSize = (_text as NSString).boundingRect(with: .init(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude),
                                                         options: .usesLineFragmentOrigin,
                                                         attributes: [.font: font],
                                                         context: nil).size
            _textSize = .init(width: ceil(_textSize.width), height: ceil(_textSize.height))
        }

        var contentSize: CGSize = .zero

        switch iconDirection {
        case .top, .bottom:
            contentSize = .init(width: max(iconSize.width, _textSize.width),
                                height: iconSize.height + iconTextGap + _textSize.height)
        case .left, .right:
            contentSize = .init(width: iconSize.width + iconTextGap + _textSize.width,
                                height: max(iconSize.height, _textSize.height))
        }
        contentSize = .init(width: contentSize.width + contentEdgesInset.left + contentEdgesInset.right,
                            height: contentSize.height + contentEdgesInset.top + contentEdgesInset.bottom)

        if maxWidth > 0 {
            contentSize.width = maxWidth
        }

        if maxHeight > 0 {
            contentSize.height = maxHeight
        }

        return contentSize
    }
}
