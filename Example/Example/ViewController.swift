//
//  ViewController.swift
//  Example
//
//  Created by ShevaKuilin on 2019/4/2.
//  Copyright © 2019 ShevaKuilin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var pagerNavigationView: SKTitleScrollNavigationView!

    override func viewDidLoad() {
        super.viewDidLoad()
        initElements()
    }
}

private extension ViewController {
    private func initElements() {
        self.pagerNavigationView = SKTitleScrollNavigationView(frame: kFrame(0, 44, UIScreen.main.bounds.size.width, 44),
                                                               aligmentType: .center,
                                                               titles: ["用户消息", "系统消息"], selectedTitleFont: kFont(16, true), normalTitleFont: kFont(16),
                                                               titleSpacing: 30,
                                                               selectedTitleColor: kColor(0, 127, 255), normalTitleColor: kColor(138, 154, 169), lineWidthType: .custom,
                                                               lineColor: kColor(0, 127, 255),
                                                               lineHeight: 2,
                                                               customLineWidth: 40,
                                                               defaultSelectedIndex: 0,
                                                               leftMargin: 15,
                                                               rightMargin: 15,
                                                               borderColor: kColor(182, 186, 193), badgeLocation: .right)
        self.pagerNavigationView.backgroundColor = kColor(247, 247, 249)
        self.pagerNavigationView.delegate = self
        self.pagerNavigationView.showTitleBadge(itemIndex: 0, content: "5")
        self.pagerNavigationView.showTitleBadge(itemIndex: 1, content: "15")
        self.view.addSubview(self.pagerNavigationView)
    }
}

extension ViewController: SKTitleScrollNavigationViewDelagete {
    func selectTitleItem(index: Int) {
        if self.pagerNavigationView.queryTitleBadgeStatus(itemIndex: index) {
            self.pagerNavigationView.hiddenTitleBadge(itemIndex: index)
        } else {
            self.pagerNavigationView.showTitleBadge(itemIndex: index, content: "99")
        }
        //        self.pagerNavigationView.updateTitleBadge(itemIndex: index, content: "6") // 更新气泡文本内容
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        self.pagerNavigationView.linkageNavigationTitle(offsetValue: offset.x) // 联动导航栏
    }
}

