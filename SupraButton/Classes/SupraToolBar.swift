//
//  SupraToolBar.swift
//  SupraButton
//
//  Created by pulei yu on 2023/10/23.
//

import Foundation
import SnapKit
import UIKit

public struct SupraToolLayout {
    /// 列数
    public var column = 0
    /// 单行的高度
    public var rowHeight: CGFloat = 44
    
    public init(){
        
    }
    
    public init(column: Int,rowHeight: CGFloat){
        self.column = column
        self.rowHeight = rowHeight
    }
}

open class SupraToolBar<Item: SupraButtonItem>: UIView {
    public var tapItemBlock: ((Item) -> Void)?

    open var items: [Item] = [] {
        didSet {
            reloadItems()
        }
    }

    public var _contentHeight: CGFloat {
        let _column = layoutConfig.column > 0 ? layoutConfig.column : items.count
        let _rowHeight = layoutConfig.rowHeight
        var _row = 1
        // 确认行数
        if layoutConfig.column > 0 {
            _row = items.count / _column
            if items.count % _column > 0 {
                _row += 1
            }
        }
        return CGFloat(_row) * _rowHeight
    }

    public lazy var contentView = UIView()

    public var layoutConfig = SupraToolLayout() {
        didSet {
            updateButtonsLayout()
        }
    }

    public var buttons: [SupraButton] = []

    override public init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(contentView)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func reloadItems() {
        buttons.forEach { $0.removeFromSuperview() }
        buttons.removeAll()

        for item in items {
            let btn = SupraButton()
            buttons.append(btn)
            btn.config(item: item)
            btn.addTarget(self, action: #selector(tapButton(_:)), for: .touchUpInside)
            contentView.addSubview(btn)
        }
        updateButtonsLayout()
    }

    open func updateButtonsLayout() {
        guard items.isEmpty == false else { return }

        let _column = layoutConfig.column > 0 ? layoutConfig.column : items.count
        let _rowHeight = layoutConfig.rowHeight
        var _row = 1
        // 确认行数
        if layoutConfig.column > 0 {
            _row = items.count / _column
            if items.count % _column > 0 {
                _row += 1
            }
        }
        // 排列
        var preview: UIView?
        for (i, btn) in buttons.enumerated() {
            btn.snp.removeConstraints()
            let nowRow = i / _column // 基于0index
            let nowColumn = i % _column
            if nowColumn == 0 {
                preview = nil
            }
            btn.snp.remakeConstraints {
                $0.height.equalTo(_rowHeight)
                $0.width.equalToSuperview().dividedBy(_column)
                $0.top.equalToSuperview().offset(CGFloat(nowRow) * _rowHeight)
                if preview == nil {
                    $0.left.equalToSuperview()
                } else {
                    $0.left.equalTo(preview!.snp.right)
                }
            }
            preview = btn
        }
        setNeedsLayout()
        contentView.snp.remakeConstraints {
            $0.height.equalTo(CGFloat(_row) * _rowHeight)
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            $0.left.equalTo(self.safeAreaLayoutGuide.snp.left)
            $0.right.equalTo(self.safeAreaLayoutGuide.snp.right)
        }
        layoutIfNeeded()
    }

    @objc open func tapButton(_ sender: SupraButton) {
        guard let idx = buttons.firstIndex(of: sender) else { return }
        tapItemBlock?(items[idx])
    }

    open func update(state: UIControl.State, at item: Item, selectedExclusive: Bool = false) {
        guard let idx = items.firstIndex(of: item) else { return }
        if selectedExclusive,
           case .selected = state {
            buttons.forEach { $0.isSelected = false }
        }
        buttons[idx].update(state: state)
    }
}
