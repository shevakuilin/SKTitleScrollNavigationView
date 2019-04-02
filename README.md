# SKTitleScrollNavigationView

![](https://img.shields.io/badge/platform-iOS-green.svg)
![](https://img.shields.io/badge/pod-v1.6.0.beta.1-blue.svg)
![](https://img.shields.io/badge/language-Swift-purple.svg)
![](https://img.shields.io/badge/moduleVersion-v0.2.0-red.svg)


# 简述

SKTitleScrollNavigationView是一个可定制化的滚动导航栏，支持红点气泡，可自定义下划线宽度，支持居中及左对齐等，使用简单方便

# 特性

- 支持导航栏内容的左对齐、居中、右对齐 [暂未开放]
- 自由选择下划线的长度，支持与标题文字同宽、与标题视图同宽、以及自定义宽度
- 支持红点气泡，并且支持含未读消息的内容的展示与更新操作
- 红点气泡可自由选择左上角和右上角展示
- 提供 debug 辅助线调试
- 高度自定义，可支持自定义的内容
	- 导航栏对准类型
	- 标题内容 
	- 选中标题字体
	- 默认标题字体
	- 下划线颜色
	- 下划线高度
	- 自定义下划线宽度
	- 默认选中标题
	- 左右边距
	- 底边框颜色
	- 标题间距
	- 下划线宽度类型
	- 气泡颜色
	- 气泡尺寸
	- 气泡位置
	- 气泡内容字体
	- 气泡内容颜色

# 效果图

<img src="https://github.com/shevakuilin/MyGithubPicture/raw/master/Pictures/SKTitleScrollNavigaionView_1.png" width="168" height ="300" />
<img src="https://github.com/shevakuilin/MyGithubPicture/raw/master/Pictures/SKTitleScrollNavigaionView_2.png" width="168" height ="300" />
<img src="https://github.com/shevakuilin/MyGithubPicture/raw/master/Pictures/SKTitleScrollNavigaionView_3.png" width="168" height ="300" />
<img src="https://github.com/shevakuilin/MyGithubPicture/raw/master/Pictures/SKTitleScrollNavigaionView_4.png" width="168" height ="300" />
<img src="https://github.com/shevakuilin/MyGithubPicture/raw/master/Pictures/SKTitleScrollNavigaionView_5.png" width="168" height ="300" />
<img src="https://github.com/shevakuilin/MyGithubPicture/raw/master/Pictures/SKTitleScrollNavigaionView_6.gif" width="168" height ="300" />

# 如何开始


1. `git@github.com:shevakuilin/SKTitleScrollNavigationView.git`，查看示例工程 Example

2. 直接将目录下的 SKTitleScrollNavigationView 拷贝到你的工程中，或在Podfile文件中添加 ```pod 'SKTitleScrollNavigationView'```

3. [在 Objective-C 项目中使用 Swift 库](https://www.jianshu.com/p/a342fba7f418)，记得导入#import "工程名-Swift.h"

# 初始化

#### Swift
```swift
private var pagerNavigationView: SKTitleScrollNavigaionView!

// Swift可以使用默认值特性，这里省略了默认值参数
self.pagerNavigationView = SKTitleScrollNavigaionView(frame: kFrame(0, XituGlobalConst.navBarHeight() - 44, UIScreenAttribute.width, 44),
                                                              aligmentType: .left,
                                                              titles: ["推荐", "综合", "沸点"],
                                                              lineWidthType: .titleWidth)
self.pagerNavigationView.backgroundColor = kColor(247, 247, 249)
self.pagerNavigationView.delegate = self // 实现协议
self.view.addSubview(self.pagerNavigationView)
```
#### Objective-C

```Objectivec
@property (nonatomic, strong, readwrite) SKTitleScrollNavigaionView *navigationTitleView;

self.navigationTitleView = [[SKTitleScrollNavigaionView alloc] initWithFrame:CGRectMake(0, topSeparateViewHeight, kScreenWidth, 44)
                                                                    aligmentType:SKAligmentTypeCenter
                                                                          titles:@[@"用户消息", @"系统消息"]
                                                               selectedTitleFont:kFontBold(16)
                                                                 normalTitleFont:kFont(16)
                                                                    titleSpacing:60
                                                              selectedTitleColor:kColor(0, 127, 255)
                                                                normalTitleColor:kColor(138, 154, 169)
                                                                   lineWidthType:SKLineWidthTypeTitleWidth
                                                                       lineColor:kColor(0, 127, 255)
                                                                      lineHeight:2
                                                                 customLineWidth:0
                                                            defaultSelectedIndex:0
                                                                      leftMargin:15
                                                                     rightMargin:15
                                                                     borderColor:kColor(182, 186, 193)
                                                                     badgeColor:[UIColor red]
                                                                     badgeSize:self.badgeSize
                                                                     badgeLocation: self.badgeLocation
                                                                     badgeContentFont: kFont(9)
                                                                     badgeContentColor: [UIColor white]];

self.navigationTitleView.backgroundColor = kColor(246, 247, 249);
self.navigationTitleView.delegate = self;
[self.view addSubview:self.navigationTitleView]
```

# 控制方法

#### SKTitleScrollNavigationViewDelagete 协议

```swift
extension YourViewController: SKTitleScrollNavigationViewDelagete {
    func selectTitleItem(index: Int) {
		// do something
    }
}
```

#### Debug

```swift
// 开启debug辅助中心线
self.pagerNavigationView.enableDebugCenterLine = true
```

#### 导航栏控制

```swift
// 更新导航栏标题
self.pagerNavigationView.updateNavigationView(titles: ["A", "B", "C"])
```
```swift
// 联动导航栏标题
extension YourViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        self.pagerNavigationView.linkageNavigationTitle(offsetValue: offset.x) // 传入偏移量
    }
}
```

#### 气泡红点

```swift
// 显示气泡 [如果不需要显示内容，content传空]
self.pagerNavigationView.showTitleBadge(itemIndex: 1, content: "99")
```
```swift
// 隐藏气泡
self.pagerNavigationView.hiddenTitleBadge(itemIndex: 1)
```
```swift
// 更新气泡内容
self.pagerNavigationView.updateTitleBadge(itemIndex: 1, content: "6")
```
```swift
// 查询标题气泡显示状态，true正在显示/fasle已隐藏
let isExist = self.pagerNavigationView.queryTitleBadgeStatus(itemIndex: 1)
```

### 感谢你花时间阅读以上内容, 如果这个项目能够帮助到你，记得告诉我


Email: shevakuilin@gmail.com
