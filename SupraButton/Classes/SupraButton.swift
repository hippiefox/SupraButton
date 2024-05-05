//
//  SupraButton.swift
//  SupraButton
//
//  Created by pulei yu on 2023/10/23.
//

import Foundation
import UIKit

public extension SupraButton {
    enum Direction {
        case top
        case bottom
        case left
        case right
    }
}

extension UIControl.State: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}

open class SupraButton: UIControl {
    public var allSupportedState: [UIControl.State] = [.normal, .disabled, .selected]

    public var icons: [UIControl.State: UIImage] = [:] {
        didSet {
            iconImageView.image = icons[.normal]
        }
    }

    public var textColors: [UIControl.State: UIColor] = [:] {
        didSet {
            textLabel.textColor = textColors[.normal]
        }
    }

    public var texts: [UIControl.State: String] = [:] {
        didSet {
            textLabel.text = texts[.normal]
            setNeedsLayout()
        }
    }

    public func icon(for state: UIControl.State) -> UIImage? {
        var t = icons[state]
        if t == nil {
            t = icons[.normal]
        }
        return t
    }

    public func text(for state: UIControl.State) -> String? {
        var t = texts[state]
        if t == nil {
            t = texts[.normal]
        }
        return t
    }

    public func textColor(for state: UIControl.State) -> UIColor? {
        var t = textColors[state]
        if t == nil {
            t = textColors[.normal]
        }
        return t
    }

    public var font: UIFont = .systemFont(ofSize: 12) {
        didSet {
            textLabel.font = font
            setNeedsLayout()
        }
    }

    public var iconDirection: Direction = .top {
        didSet {
            setNeedsLayout()
        }
    }

    /// 图片和文字之间的间距
    public var iconTextGap: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }

    public var iconSize: CGSize = .zero {
        didSet {
            setNeedsLayout()
        }
    }

    public lazy var textLabel: UILabel = {
        let label = UILabel()
        label.font = font
        return label
    }()

    public lazy var iconImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()

    override open var isSelected: Bool {
        didSet {
            if isSelected {
                textLabel.text = text(for: .selected)
                textLabel.textColor = textColor(for: .selected)
                iconImageView.image = icon(for: .selected)
            } else {
                textLabel.text = text(for: .normal)
                textLabel.textColor = textColor(for: .normal)
                iconImageView.image = icon(for: .normal)
            }
            setNeedsLayout()
        }
    }

    override open var isEnabled: Bool {
        didSet {
            if isEnabled == false {
                textLabel.text = text(for: .disabled)
                textLabel.textColor = textColor(for: .disabled)
                iconImageView.image = icon(for: .disabled)
            } else {
                textLabel.text = text(for: .normal)
                textLabel.textColor = textColor(for: .normal)
                iconImageView.image = icon(for: .normal)
            }
            setNeedsLayout()
        }
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(textLabel)
        addSubview(iconImageView)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        calTitleSize(bounds)
        calIconSize(bounds)
        calTextOrigin(bounds)
        calIconOrigin(bounds)
    }

    public func config(item: any SupraButtonItem) {
        allSupportedState.forEach {
            texts[$0] = item.text(for: $0)
            textColors[$0] = item.textColor(for: $0)
            icons[$0] = item.icon(for: $0)
        }
        iconSize = item.iconSize
        iconDirection = item.iconDirection
        font = item.font
        iconTextGap = item.iconTextGap
    }
    
    public func update(state: UIControl.State){
        switch state {
        case .normal:
            isSelected = false
            isEnabled = true
        case .selected:
            isSelected = true
        case .disabled:
            isEnabled = false
        default:
            break
        }
    }
}

extension SupraButton {
    public func calTitleSize(_ rect: CGRect) {
        var rectWidth: CGFloat = 0

        switch iconDirection {
        case .top, .bottom: rectWidth = rect.width
        case .left, .right: rectWidth = rect.width - iconTextGap - iconSize.width
        }

        let text = textLabel.text ?? ""
        var textSize: CGSize = CGSize.zero

        if text.isEmpty == false {
            textSize = (text as NSString).boundingRect(with: .init(width: rectWidth, height: CGFloat.greatestFiniteMagnitude),
                                                       options: .usesLineFragmentOrigin,
                                                       attributes: [.font: font],
                                                       context: nil).size
            textSize = CGSize(width: ceil(textSize.width), height: ceil(textSize.height))
        }

        textLabel.frame.size = textSize
    }

    public func calIconSize(_ rect: CGRect) {
        iconImageView.frame.size = iconSize
    }

    public func calTextOrigin(_ rect: CGRect) {
        var x: CGFloat = 0, y: CGFloat = 0
        switch iconDirection {
        case .top:
            x = (rect.width - textLabel.frame.size.width) / 2
            y = (rect.height - iconSize.height - iconTextGap - textLabel.frame.height) / 2 + iconSize.height + iconTextGap
        case .bottom:
            x = (rect.width - textLabel.frame.size.width) / 2
            y = (rect.height - iconSize.height - iconTextGap - textLabel.frame.height) / 2
        case .left:
            x = (rect.width - textLabel.frame.size.width - iconSize.width - iconTextGap) / 2 + iconSize.width + iconTextGap
            y = (rect.height - textLabel.frame.size.height) / 2
        case .right:
            x = (rect.width - textLabel.frame.size.width - iconSize.width - iconTextGap) / 2
            y = (rect.height - textLabel.frame.size.height) / 2
        }

        textLabel.frame.origin = CGPoint(x: x, y: y)
    }

    public func calIconOrigin(_ rect: CGRect) {
        var x: CGFloat = 0, y: CGFloat = 0
        switch iconDirection {
        case .top:
            x = (rect.width - iconSize.width) / 2
            y = (rect.height - iconSize.height - iconTextGap - textLabel.frame.height) / 2
        case .bottom:
            x = (rect.width - iconSize.width) / 2
            y = (rect.height - iconSize.height - iconTextGap - textLabel.frame.height) / 2 + iconTextGap + textLabel.frame.size.height
        case .left:
            x = (rect.width - textLabel.frame.size.width - iconSize.width - iconTextGap) / 2
            y = (rect.height - iconSize.height) / 2
        case .right:
            x = (rect.width - textLabel.frame.size.width - iconSize.width - iconTextGap) / 2 + textLabel.frame.size.width + iconTextGap
            y = (rect.height - iconSize.height) / 2
        }

        iconImageView.frame.origin = CGPoint(x: x, y: y)
    }
}
