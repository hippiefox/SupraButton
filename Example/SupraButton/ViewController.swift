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
    case keyboard
    case printer
    case display
    
    var title4Normal: String?{
        switch self{
        case .keyboard: return "键盘"
        case .printer: return "打印机"
        case .display:  return "显示器"
        }
    }
    
    var icon4Normal: UIImage?{
        switch self{
        case .keyboard: return UIImage.init(systemName: "keyboard")
        case .printer: return UIImage.init(systemName: "printer")
        case .display:  return UIImage.init(systemName: "display")
        }
    }
    
    var titleColor4Normal: UIColor{
        return .systemPink
    }
    
    var titleColor4Seleted: UIColor?{
        return .green
    }
}

class ViewController: UIViewController {
    
    private lazy var toolBar: SupraToolBar = {
        let t = SupraToolBar<Items>.init(frame: .zero)
        t.items = Items.allCases
        t.tapItemBlock = { [weak self] item in
            t.toggleItem(item: item, state: .selected, isExclusive: true)
        }
        return t
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.addSubview(toolBar)
        toolBar.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-44)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

