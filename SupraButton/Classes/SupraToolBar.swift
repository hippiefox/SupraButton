//
//  SupraToolBar.swift
//  SupraButton
//
//  Created by pulei yu on 2023/10/23.
//

import Foundation
import SnapKit
import UIKit

open class SupraToolBar<Item: SupraButtonItem>: UIView {
    public var tapItemBlock: ((Item) -> Void)?

    open var items: [Item] = [] {
        didSet {
            reloadItems()
        }
    }

    public lazy var contentView = UIView()

    public var iconSize: CGSize = .init(width: 22, height: 22) {
        didSet {
            buttons.forEach { $0.iconSize = iconSize }
        }
    }

    public var contentHeight: CGFloat = 44 {
        didSet {
            contentView.snp.updateConstraints {
                $0.height.equalTo(contentHeight)
            }
        }
    }

    public var buttons: [SupraButton] = []

    override public init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.height.equalTo(contentHeight)
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            $0.left.equalTo(self.safeAreaLayoutGuide.snp.left)
            $0.right.equalTo(self.safeAreaLayoutGuide.snp.right)
        }
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func reloadItems() {
        buttons.forEach { $0.removeFromSuperview() }
        buttons.removeAll()

        var preview: UIView?
        for item in items {
            let btn = SupraButton()
            buttons.append(btn)
            btn.title4NormalState = item.title4Normal
            btn.icon4NormalState = item.icon4Normal
            btn.titleColor4NormalState = item.titleColor4Normal

            btn.title4SelectedState = item.title4Selected
            btn.icon4SelectedState = item.icon4Selected
            btn.titleColor4SelectedState = item.titleColor4Seleted

            btn.title4DisabledState = item.title4Disable
            btn.icon4DisabledState = item.icon4Disable
            btn.titleColor4DisabledState = item.titleColor4Disable

            btn.iconTitleSpace = item.iconTitleSpace
            btn.titleFont = item.titleFont
            btn.iconSize = item.iconSize
            btn.iconTintColor = item.iconTintColor
            btn.addTarget(self, action: #selector(tapButton(_:)), for: .touchUpInside)
            contentView.addSubview(btn)
            btn.snp.makeConstraints {
                $0.height.equalToSuperview()
                $0.width.equalToSuperview().dividedBy(items.count)
                $0.top.equalToSuperview()
                if preview == nil {
                    $0.left.equalToSuperview()
                } else {
                    $0.left.equalTo(preview!.snp.right)
                }
            }
            preview = btn
        }
    }

    @objc open func tapButton(_ sender: SupraButton) {
        guard let idx = buttons.firstIndex(of: sender) else { return }
        tapItemBlock?(items[idx])
    }

    open func toggleItem(item: Item, state: UIControlState, isExclusive: Bool) {
        guard let idx = items.firstIndex(of: item) else { return }
        switch state {
        case .normal:
            buttons[idx].isSelected = false
            buttons[idx].isEnabled = true
        case .selected:
            if isExclusive {
                buttons.forEach { $0.isSelected = false }
            }
            buttons[idx].isSelected = true
        case .disabled:
            buttons[idx].isEnabled = false
        default:
            break
        }
    }
}
