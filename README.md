# CSChannelView-OC
一个灵活的频道入口View。文字、图标可以单独显示；可以水平、竖直滚动；可以自动调整高度。
本版本为[Objective-C版](https://github.com/JoslynWu/CSChannelView-OC.git)。

## Swift版入口：[CSChannelView](https://github.com/JoslynWu/CSChannelView)

## 效果图
![](/Effect/CSChannelView.png)

## 怎么接入

**一、CocoaPods**

```
pod 'CSChannelView-OC'
```

**二、手动添加**

直接将Sources文件夹拖入工程中。

## 怎么用

步骤：

一、初始化

```
/**
 初始化
 
 @param frame frame
 @param placeholderImage 占位图
 @param enable  以4.7寸屏幕为基准，自动适配其它屏幕。
                如果调用initWithFrame:默认开启autoScale。
                如果直接用屏幕尺寸设置某个frame值，则该值不做适配。
 @return CSChannelView实例
 */
- (nullable instancetype)initWithFrame:(CGRect)frame placeholderImage:(nullable UIImage *)placeholderImage autoScale:(BOOL)enable;

- (nullable instancetype)initWithFrame:(CGRect)frame autoScale:(BOOL)enable;
```

二、属性配置

```
/** 每页有几行。默认为2. */
@property (nonatomic, assign) NSUInteger numberOfRowInPage;

/** 每行有几个。默认为4. */
@property (nonatomic, assign) NSUInteger numberOfItemInRow;

/** 漂亮的单行。开启后，一页只有一行，与容器水平中心对齐。默认false.  */
@property (nonatomic, assign) BOOL prettySingleRow;

/** 对Item（UIButton）的其他设置 */
@property (nonatomic, copy, nullable) void(^otherConfig)(UIButton * _Nonnull item);

/** 自动调整高度（只显示一页） */
@property (nonatomic, assign) BOOL autoAdjustHeight;

/** 可以垂直滚动（高度超出时） */
@property (nonatomic, assign) BOOL verticalScrollActivated;

and so on.
```

三、加载或刷新数据

```
/**
 加载或刷新数据（* 需要最后调用 *）。
 传空部分将不显示。
    Example：
    [channelView loadDataInfoWithImages:nil tittls:titles tagImages:nil];
    表示只显示文字。
 
 @param imageGroup 图片数组(支持网络和本地图片)。传空（nil）则不显示。
 @param titleGroup 每张图片对应的文字数组。传空（nil）则不显示。
 @param tagImageGroup 每张图片对应的标记图片数组(支持网络和本地图片)。传空（nil）则不显示。
 */
- (void)loadDataInfoWithImages:(nullable NSArray<NSString *> *)imageGroup tittls:(nullable NSArray<NSString *> *)titleGroup tagImages:(nullable NSArray<NSString *> *)tagImageGroup;
```

四、处理回调

```
/** Item点击回调 */
@property (nonatomic, copy, nullable) void(^itemDidClickBlock)(NSInteger index);
```



