//
//  SKTitleScrollNavigationView.swift
//  Xitu
//
//  Created by ShevaKuilin on 2019/1/16.
//  Copyright © 2019 XiTu Inc. All rights reserved.
//

import UIKit

@objc public protocol SKTitleScrollNavigationViewDelagete {
    /** 点击导航栏标题
     *
     *  @parama itemIndex   被点击的标题位置
     *
     */
    @objc optional func selectTitleItem(index: Int)
}

@objc
public enum SKAligmentType: Int {
    case left = 0       // 左对齐
    case center = 1     // 居中
    //case right          // 右对齐 [暂不支持]
}

@objc
public enum SKLineWidthType: Int {
    case titleWidth = 0 // 与标题文字同宽
    case fullLine = 1   // 与标题视图同宽
    case custom         // 自定义宽度
}

@objc
public enum SKBadgeLocation: Int {
    case left = 0   // 左侧
    case right = 1  // 右侧
}

public class SKTitleScrollNavigationView: UIView {
    
    @objc weak public var delegate: SKTitleScrollNavigationViewDelagete? // 协议代理
    
    private var aligmentType: SKAligmentType!   // 导航栏对准类型
    private var titles: [String] = []           // 标题数组
    private var selectedTitleFont: UIFont!      // 选中标题字体
    private var normalTitleFont: UIFont!        // 默认标题字体
    private var selectedTitleColor: UIColor!    // 选中的标题颜色
    private var normalTitleColor: UIColor!      // 默认标题颜色
    private var lineColor: UIColor!             // 下划线颜色
    private var lineHeight: CGFloat!            // 下划线高度
    private var customLineWidth: CGFloat!       // 自定义下划线宽度
    private var defaultSelectedIndex: Int!      // 默认选中标题
    private var leftMargin: CGFloat!            // 左边距
    private var rightMargin: CGFloat!           // 右边距
    private var borderColor: UIColor!           // 底边框颜色
    private var titleSpacing: CGFloat!          // 标题间距
    private var lineWidthType: SKLineWidthType! // 下划线宽度类型
    private var badgeColor: UIColor!            // 气泡颜色
    private var badgeSize: CGSize!              // 气泡尺寸
    private var badgeLocation: SKBadgeLocation! // 气泡位置
    private var badgeContentFont: UIFont!       // 气泡内容字体
    private var badgeContentColor: UIColor!     // 气泡内容颜色
    
    private var selectedIndex: Int!                 // 当前选中的标题位置
    private var titleMargin: CGFloat = 10           // 标题两边的边距
    private var bottomLayerHeight: CGFloat = 0.3    // 底边框高度
    private var screenWidth: CGFloat = UIScreen.main.bounds.size.width
    
    private var containerScrollView: UIScrollView!  // 滚动容器
    private var lineView: UIView!                   // 下划线
    
    
    /** 初始化导航栏
     *
     *  @parama frame                   导航栏的frame
     *  @param  aligmentType            导航栏对准类型
     *  @param  titles                  标题数组
     *  @param  selectedTitleFont       选中标题字体，默认kFont(16, true)
     *  @param  normalTitleFont         默认标题字体，默认kFont(16)
     *  @param  titleSpacing            标题间距，默认30
     *  @param  selectedTitleColor      选中的标题颜色, 默认RGB - 0/127/255
     *  @param  normalTitleColor        默认标题颜色, 默认RGB - 138/154/169
     *  @param  customLineWidth         自定义下划线宽度，可选
     *  @param  lineColor               下划线颜色, 默认RGB - 0/127/255
     *  @param  lineHeight              下划线高度，默认2
     *  @param  defaultSelectedIndex    默认选中标题，默认0
     *  @param  leftMargin              左边距，默认15，居中模式设置此属性无效
     *  @param  rightMargin             右边距，默认15，居中模式设置此属性无效
     *  @param  borderColor             底边框颜色，默认RGB - 182/186/193
     *  @param  badgeColor              气泡颜色，默认红色
     *  @param  badgeSize               气泡尺寸，默认 15*15
     *  @param  badgeLocation           气泡位置，默认右侧
     *  @param  badgeContentFont        气泡内容字体，默认kFont(12)
     *  @param  badgeContentColor       气泡内容颜色，默认白色
     *
     */
    @objc public init(frame: CGRect,
                      aligmentType: SKAligmentType,
                      titles: [String],
                      selectedTitleFont: UIFont = kFont(16, true),
                      normalTitleFont: UIFont = kFont(16),
                      titleSpacing: CGFloat = 30,
                      selectedTitleColor: UIColor = kColor(0, 127, 255),
                      normalTitleColor: UIColor = kColor(138, 154, 169),
                      lineWidthType: SKLineWidthType,
                      lineColor: UIColor = kColor(0, 127, 255),
                      lineHeight: CGFloat = 2,
                      customLineWidth: CGFloat = 0,
                      defaultSelectedIndex: Int = 0,
                      leftMargin: CGFloat = 15,
                      rightMargin: CGFloat = 15,
                      borderColor: UIColor = kColor(182, 186, 193),
                      badgeColor: UIColor = .red,
                      badgeSize: CGSize = CGSize(width: 15, height: 15),
                      badgeLocation: SKBadgeLocation = .right,
                      badgeContentFont: UIFont = kFont(9),
                      badgeContentColor: UIColor = .white) {
        self.enableDebugCenterLine = false
        super.init(frame: frame)
        self.aligmentType = aligmentType
        self.titles = titles
        self.selectedTitleFont = selectedTitleFont
        self.normalTitleFont = normalTitleFont
        self.titleSpacing = titleSpacing
        self.selectedTitleColor = selectedTitleColor
        self.normalTitleColor = normalTitleColor
        self.lineWidthType = lineWidthType
        self.lineColor = lineColor
        self.lineHeight = lineHeight
        self.customLineWidth = customLineWidth
        self.defaultSelectedIndex = defaultSelectedIndex
        self.leftMargin = leftMargin
        self.rightMargin = rightMargin
        self.borderColor = borderColor
        self.selectedIndex = defaultSelectedIndex
        self.bottomLayerHeight = self.borderColor != .clear ? self.bottomLayerHeight:0
        self.badgeColor = badgeColor
        self.badgeSize = badgeSize
        self.badgeLocation = badgeLocation
        self.badgeContentFont = badgeContentFont
        self.badgeContentColor = badgeContentColor
        addBorderLayer()
        initLayoutElements()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 开启debug辅助中心线
    @objc public var enableDebugCenterLine: Bool {
        didSet {
            enableDebug()
        }
    }
    
    /** 更新导航栏标题
     *
     *  @param  titles 标题数组
     *
     */
    @objc public func updateNavigationView(titles: [String]) {
        updateLayoutElements(updateTitles: titles)
    }
    
    /** 联动导航栏标题
     *
     *  @param  offsetValue 偏移量
     *
     */
    @objc public func linkageNavigationTitle(offsetValue: CGFloat) {
        moveNavigationSelectedLine(scrollValue: offsetValue)
    }
    
    /** 显示标题气泡红点
     *
     *  @param  itemIndex   标题位置
     *  @param  content     显示内容 [未读数]
     *
     */
    @objc public func showTitleBadge(itemIndex: Int, content: String) {
        addBadge(index: itemIndex, content: content)
    }
    
    /** 更新标题气泡红点
     *
     *  @param  itemIndex   标题位置
     *  @param  content     显示内容 [未读数]
     *
     */
    @objc public func updateTitleBadge(itemIndex: Int, content: String) {
        updateBadge(index: itemIndex, content: content)
    }
    
    /** 隐藏标题气泡红点
     *
     *  @parama itemIndex   标题位置
     *
     */
    @objc public func hiddenTitleBadge(itemIndex: Int) {
        removeBadge(index: itemIndex)
    }
    
    /** 查询标题气泡显示状态
     *
     *  @parama itemIndex   标题位置
     *  @return status      true正在显示/fasle已隐藏
     *
     */
    @objc public func queryTitleBadgeStatus(itemIndex: Int) -> Bool {
        return queryExistBadge(index: itemIndex)
    }
}

private extension SKTitleScrollNavigationView {
    // MARK: 初始化布局标题等元素
    private func initLayoutElements() {
        #if DEBUG
        assert(titles.count > 0, "导航栏的标题数组不能为空")
        assert(defaultSelectedIndex < titles.count, "默认选中下标越界，defaultSelectedIndex = \(String(describing: defaultSelectedIndex)) titles.count = \(titles.count)")
        #else
        guard titles.count > 0 else {
            return
        }
        guard defaultSelectedIndex < titles.count else {
            return
        }
        #endif
        let contentWidth = calculateScrollViewContentWidth()
        printLog("导航栏宽度：\(contentWidth)")
        
        containerScrollView = UIScrollView()
        containerScrollView.frame = kFrame(0, 0, self.frame.size.width, self.frame.size.height)
        containerScrollView.backgroundColor = self.backgroundColor
        containerScrollView.contentSize = CGSize(width: contentWidth, height: self.frame.size.height)
        containerScrollView.isPagingEnabled = false
        containerScrollView.bounces = true
        containerScrollView.scrollsToTop = false
        containerScrollView.showsHorizontalScrollIndicator = false
        containerScrollView.showsVerticalScrollIndicator = false
        self.addSubview(containerScrollView)
        
        updateLeftRightMargin()
        let titleContainerHeight = containerScrollView.frame.size.height - lineHeight
        var titleLocation: CGFloat = leftMargin
        for title in titles {
            guard let currentIndex = titles.firstIndex(of: title) else {
                return
            }
            let isSelected = currentIndex == defaultSelectedIndex ? true:false
            let titleWidth = calculateWidth(title: title, isSelected: isSelected)
            if currentIndex > 0 {
                titleLocation += titleSpacing + calculateWidth(title: titles[currentIndex - 1], isSelected: isSelected)
            }
            let titleContainerWidth = titleWidth + titleMargin
            let titleBtn = UIButton()
            titleBtn.frame = kFrame(titleLocation, 0, titleContainerWidth, titleContainerHeight)
            titleBtn.setTitle(title, for: .normal)
            titleBtn.setTitle(title, for: .selected)
            titleBtn.setTitleColor(normalTitleColor, for: .normal)
            titleBtn.setTitleColor(selectedTitleColor, for: .selected)
            titleBtn.setTitleColor(selectedTitleColor, for: [.selected, .highlighted]) // 添加复合状态，取消长按恢复normal颜色的效果
            titleBtn.tag = currentIndex
            titleBtn.isSelected = isSelected
            titleBtn.titleLabel?.font = titleBtn.isSelected ? selectedTitleFont:normalTitleFont
            titleBtn.addTarget(self, action: #selector(tapTitleAction(sender:)), for: .touchUpInside)
            containerScrollView.addSubview(titleBtn)
            
            if currentIndex == defaultSelectedIndex {
                layoutSelectedLine(target: titleBtn, titleWidth: calculateWidth(title: title, isSelected: isSelected), titleContainerWidth: titleContainerWidth)
            }
        }
    }
    
    // 布局下划线
    private func layoutSelectedLine(target: UIButton, titleWidth: CGFloat, titleContainerWidth: CGFloat) {
        let lineAttributes = gainSelectedLineAttributes(titleWidth: titleWidth, titleContainerWidth: titleContainerWidth)
        lineView = UIView()
        lineView.backgroundColor = lineColor
        lineView.layer.masksToBounds = true
        lineView.layer.cornerRadius = lineHeight/2
        lineView.frame = kFrame(target.frame.origin.x + lineAttributes.0, containerScrollView.frame.size.height - lineHeight/* - bottomLayerHeight*/, lineAttributes.1, lineHeight)
        containerScrollView.addSubview(lineView)
    }
    
    // 添加边界
    private func addBorderLayer() {
        guard borderColor != .clear else {
            return
        }
        let bottomLayer = CALayer()
        bottomLayer.frame = kFrame(0, self.frame.size.height - bottomLayerHeight, self.frame.size.width, bottomLayerHeight)
        bottomLayer.backgroundColor = borderColor.cgColor
        self.layer.addSublayer(bottomLayer)
    }
    
    // 开启debug辅助
    private func enableDebug() {
        #if DEBUG
        if enableDebugCenterLine {
            let debugCenterLine = UIImageView()
            debugCenterLine.backgroundColor = .purple
            debugCenterLine.frame = CGRect(x: self.center.x - 1, y: 0, width: 2, height: self.frame.size.height)
            self.addSubview(debugCenterLine)
        }
        #endif
    }
    
    // 更新布局
    private func updateLayoutElements(updateTitles: [String]) {
        #if DEBUG
        assert(updateTitles.count > 0, "导航栏的标题数组不能为空")
        #endif
        guard updateTitles.count > 0 else {
            return
        }
        
        self.titles = updateTitles
        let currentOffset = containerScrollView.contentOffset
        let lineViewRange = self.lineView.frame.origin.x + self.lineView.frame.size.width
        containerScrollView.removeFromSuperview()
        defaultSelectedIndex = selectedIndex > self.titles.count - 1 ? self.titles.count - 1:selectedIndex
        initLayoutElements()
        let contentSize = containerScrollView.frame.size
        if lineViewRange > contentSize.width {
            var contenOffsetX: CGFloat = currentOffset.x > contentSize.width ? currentOffset.x : 0
            contenOffsetX = contenOffsetX > containerScrollView.contentSize.width ? 0 : contenOffsetX
            containerScrollView.setContentOffset(CGPoint(x: contenOffsetX, y: currentOffset.y), animated: false)
        }
    }
}

private extension SKTitleScrollNavigationView {
    // MARK: 计算scrollView content宽度
    private func calculateScrollViewContentWidth() -> CGFloat {
        var contentWidth: CGFloat = 0.0
        for title in titles {
            guard let currentIndex = titles.firstIndex(of: title) else {
                return contentWidth
            }
            let isSelected = currentIndex == defaultSelectedIndex ? true:false
            let titleWidth = calculateWidth(title: title, isSelected: isSelected)
            contentWidth += titleWidth
        }
        contentWidth += titleSpacing * CGFloat(titles.count - 1) + leftMargin + rightMargin
        return contentWidth
    }
    
    // MARK: 计算scrollView中心点
    private func calculateScrollViewCenter() {
        let containerWidth = self.frame.size.width
        let scrollContentWidth = containerScrollView.contentSize.width
        guard containerWidth < scrollContentWidth else {
            return
        }
        var scrollChangeValue: CGFloat = 0.0
        let visibleCenter = self.center.x
        let moveMaxRange = scrollContentWidth - containerWidth
        let titleButtons = gainTitleButtons()
        for button in titleButtons {
            if button.tag == selectedIndex {
                let buttonFrame = button.convert(button.bounds, to: nil)
                let targetCenter = visibleCenter - (buttonFrame.size.width / 2)
                let distance = buttonFrame.origin.x - targetCenter // 中心点偏移量
                if (button.frame.origin.x > targetCenter) {
                    scrollChangeValue = containerScrollView.contentOffset.x + distance
                    if (scrollChangeValue >= moveMaxRange) {
                        scrollChangeValue = moveMaxRange
                    }
                } else {
                    scrollChangeValue = 0
                }
                let resultValue = CGFloat(fabsf(Float(scrollChangeValue)))
                containerScrollView.setContentOffset(CGPoint(x: resultValue, y: 0), animated: true)
                break
            }
        }
    }
    
    // MARK: 计算title宽度
    private func calculateWidth(title: String, isSelected: Bool) -> CGFloat {
        guard let titleFont = isSelected ? selectedTitleFont:normalTitleFont else {
            return title.width(fontSize: selectedTitleFont.pointSize)
        }
        return title.width(fontSize: titleFont.pointSize)
    }
    
    // MARK: 获取下划线位置及宽度
    private func gainSelectedLineAttributes(titleWidth: CGFloat, titleContainerWidth: CGFloat) -> (CGFloat, CGFloat){
        var lineWidth: CGFloat = 0.0
        var lineLocation: CGFloat = leftMargin
        switch lineWidthType {
        case .titleWidth?:
            lineWidth = titleWidth
            lineLocation = (titleContainerWidth - titleWidth) / 2
        case .fullLine?:
            lineWidth = titleContainerWidth
        case .custom?:
            lineWidth = customLineWidth
            lineLocation = customLineWidth > titleContainerWidth ? leftMargin:(titleContainerWidth - customLineWidth) / 2
        case .none:
            break
        }
        
        return (lineLocation, lineWidth)
    }
    
    // MARK: 更新导航栏左右边距
    private func updateLeftRightMargin() {
        let scrollContentWidth = containerScrollView.contentSize.width
        let containerWidth = containerScrollView.frame.size.width
        let limit = scrollContentWidth <= containerWidth
        if aligmentType == .center {
            #if DEBUG
            assert(limit, "导航栏内容过多，不适用于居中展示，请尝试缩小 titleSpacing 的值")
            #else
            guard limit else {
                return
            }
            #endif
            
            var titlesWidth: CGFloat = 0.0
            for title in titles {
                guard let currentIndex = titles.firstIndex(of: title) else {
                    return
                }
                let isSelected = currentIndex == defaultSelectedIndex ? true:false
                let titleWidth = calculateWidth(title: title, isSelected: isSelected)
                titlesWidth += titleWidth
            }
            let titlesMargin = titleMargin
            let titlesSpacing = CGFloat(titles.count - 1) * titleSpacing
            leftMargin = self.center.x - (titlesWidth + titlesMargin + titlesSpacing) / 2
            rightMargin = leftMargin
        }
    }
    
    // MAKR: 获取已创建的标题按钮
    private func gainTitleButtons() -> [UIButton] {
        var buttons = [UIButton]()
        let subViews = containerScrollView.subviews
        for view in subViews {
            if view.isKind(of: UIButton.classForCoder()) {
                let button = view as! UIButton
                buttons.append(button)
            }
        }
        return buttons
    }
}

private extension SKTitleScrollNavigationView {
    // MARK: 点击标题
    @objc private func tapTitleAction(sender: UIButton) {
        let titleBtn = sender
        selectedIndex = titleBtn.tag
        selectedLineMoveAnimation(target: titleBtn)
        calculateScrollViewCenter()
        delegate?.selectTitleItem?(index: titleBtn.tag)
    }
    
    // MARK: 下划线移动动画
    private func selectedLineMoveAnimation(target: UIButton) {
        guard let title = target.titleLabel?.text else {
            return
        }
        let targetLocation = target.frame.origin.x
        let titleWidth = calculateWidth(title: title, isSelected: target.isSelected)
        let lineAttributes = gainSelectedLineAttributes(titleWidth: titleWidth, titleContainerWidth: target.frame.size.width)
        UIView.animate(withDuration: 0.3) {
            self.updateTitleButtonStatus()
            self.lineView.frame = kFrame(targetLocation + lineAttributes.0, self.lineView.frame.origin.y, lineAttributes.1, self.lineView.frame.size.height)
        }
    }
    
    // MARK: 更新标题按钮状态
    private func updateTitleButtonStatus() {
        let buttons = gainTitleButtons()
        for button in buttons {
            if selectedIndex == button.tag {
                button.isSelected = true
                button.titleLabel?.font = selectedTitleFont
            } else {
                button.isSelected = false
                button.titleLabel?.font = normalTitleFont
            }
        }
    }
    
    // MARK: 跟随滚动偏移量移动selectedLine
    private func moveNavigationSelectedLine(scrollValue: CGFloat) {
        let titleButtons = gainTitleButtons()
        
        if scrollValue < 0 || scrollValue > CGFloat(titleButtons.count - 1) * screenWidth {
            return
        }
        
        let index: Int = Int(scrollValue/screenWidth)
        let page: CGFloat = scrollValue/screenWidth
        let rate: CGFloat = page - CGFloat(index)
        selectedIndex = Int(round(Float(scrollValue/screenWidth))) // 四舍五入取整 [标题预高亮效果]
        updateTitleButtonStatus()
        calculateScrollViewCenter()
        
        
        if index >= titleButtons.count {
            return
        }
        
        let currentBtn = titleButtons[index]
        let currentTitleWidth = calculateWidth(title: (currentBtn.titleLabel?.text)!, isSelected: currentBtn.isSelected)
        let currentLineAttributes = gainSelectedLineAttributes(titleWidth: currentTitleWidth, titleContainerWidth: currentBtn.frame.size.width)
        let currentLineWidth = currentLineAttributes.1
        
        var nextIndex = index + 1
        if nextIndex > titleButtons.count - 1 {
            nextIndex = titleButtons.count - 1
        } else if nextIndex < 0 {
            nextIndex = 0
        }
        let nextBtn = titleButtons[nextIndex]
        let nextTitleWidth = calculateWidth(title: (nextBtn.titleLabel?.text)!, isSelected: nextBtn.isSelected)
        let nextLineAttributes = gainSelectedLineAttributes(titleWidth: nextTitleWidth, titleContainerWidth: nextBtn.frame.size.width)
        let nextLineWidth = nextLineAttributes.1
        
        let moveDistance: CGFloat = (currentLineWidth + titleSpacing) * rate // 移动距离
        let leftRange = currentBtn.frame.origin.x + currentLineAttributes.0 + moveDistance // 左边距离范围
        let changeLineWidth = currentLineWidth + (nextLineWidth - currentLineWidth) * rate
        self.lineView.frame = kFrame(leftRange, self.lineView.frame.origin.y, changeLineWidth, self.lineView.frame.size.height)
    }
}

private extension SKTitleScrollNavigationView {
    private func addBadge(index: Int, content: String) {
        let titleButtons = gainTitleButtons()
        guard index < titleButtons.count else {
            return
        }
        removeBadge(index: index)
        let currentBtn = titleButtons[index]
        createBadge(button: currentBtn, badgeContent: content)
    }
    
    private func updateBadge(index: Int, content: String) {
        guard queryExistBadge(index: index) else {
            return
        }
        let titleButtons = gainTitleButtons()
        guard index < titleButtons.count else {
            return
        }
        let currentBtn = titleButtons[index]
        let subviews = currentBtn.subviews
        for subview in subviews {
            if subview.tag == currentBtn.tag + 10000 {
                for badgeSubview in subview.subviews {
                    if badgeSubview is UILabel {
                        let label = badgeSubview as! UILabel
                        label.text = content
                        break
                    }
                }
            }
        }
    }
    
    private func removeBadge(index: Int) {
        let titleButtons = gainTitleButtons()
        guard index < titleButtons.count else {
            return
        }
        let currentBtn = titleButtons[index]
        let subviews = currentBtn.subviews
        for subview in subviews {
            if subview.tag == currentBtn.tag + 10000 {
                subview.removeFromSuperview()
            }
        }
    }
    
    private func queryExistBadge(index: Int) -> Bool {
        var isExist = false
        let titleButtons = gainTitleButtons()
        guard index < titleButtons.count else {
            return isExist
        }
        let currentBtn = titleButtons[index]
        let subviews = currentBtn.subviews
        for subview in subviews {
            if subview.tag == currentBtn.tag + 10000 {
                isExist = true
                break
            }
        }
        return isExist
    }
    
    private func createBadge(button: UIButton, badgeContent: String) {
        let x: CGFloat = badgeLocation == .right ? button.frame.size.width - 5 : -(badgeSize.width - 3)
        let y: CGFloat = 5
        
        let badge = UIImageView()
        badge.tag = button.tag + 10000
        badge.frame = kFrame(x, y, badgeSize.width, badgeSize.height)
        badge.backgroundColor = badgeColor
        badge.layer.masksToBounds = true
        badge.layer.cornerRadius = badgeSize.width/2
        
        let contentLabel = UILabel()
        contentLabel.font = badgeContentFont
        contentLabel.textColor = badgeContentColor
        contentLabel.text = badgeContent
        contentLabel.textAlignment = .center
        contentLabel.frame = kFrame(0, 0, badgeSize.width, badgeSize.height)
        badge.addSubview(contentLabel)
        
        button.addSubview(badge)
    }
}

