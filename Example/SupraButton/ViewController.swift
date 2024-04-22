//
//  ViewController.swift
//  SupraButton
//
//  Created by HippieFox on 10/23/2023.
//  Copyright (c) 2023 HippieFox. All rights reserved.
//

import UIKit
import SupraButton

enum Items: SupraButtonItem,CaseIterable{
    func icon(for state: UIControl.State) -> UIImage? {
        switch self{
        case .keyboard: return UIImage.init(systemName: "keyboard")
        case .printer: return UIImage.init(systemName: "printer")
        case .display:  return UIImage.init(systemName: "display")
        }
    
    }
    
    func text(for state: UIControl.State) -> String? {
        switch self{
        case .keyboard: return "键盘"
        case .printer: return "打印机"
        case .display:  return "显示器"
        }
    }
    
    func textColor(for state: UIControl.State) -> UIColor? {
        switch state{
        case .selected:return .green
        default:    return .systemPink
        }
    }
    
    case keyboard
    case printer
    case display
    
}

class ViewController: UIViewController {
    
    private lazy var toolBar: SupraToolBar = {
        let t = SupraToolBar<Items>.init(frame: .zero)
        t.items = Items.allCases
        t.tapItemBlock = { [weak self] item in
        }
        return t
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var layout = SupraToolLayout()
        layout.column = 0
        toolBar.layoutConfig = layout
        view.addSubview(toolBar)
        toolBar.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-toolBar._contentHeight)
        }
        
        
     
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

