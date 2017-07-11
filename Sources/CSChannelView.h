//
//  CSChannelView.h
//  CSChannelView
//
//  Created by Joslyn Wu on 2017/6/13.
//  Copyright © 2017年 joslyn. All rights reserved.
//
// https://github.com/JoslynWu/CSChannelView-OC.git
// 一个灵活的频道入口View。文字、图标可以单独显示；可以水平、竖直滚动；可以自动调整高度。
//

#import <UIKit/UIKit.h>

@interface CSChannelView : UIView

// ---------------- 初始化 ----------------
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


// ---------------- 加载或刷新数据 ----------------
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


// ---------------- 事件回调 ----------------
/** Item点击回调 */
@property (nonatomic, copy, nullable) void(^itemDidClickBlock)(NSInteger index);


// ---------------- 显示样式 ----------------
/** 每页有几行。默认为2. */
@property (nonatomic, assign) NSUInteger numberOfRowInPage;

/** 每行有几个。默认为4. */
@property (nonatomic, assign) NSUInteger numberOfItemInRow;

/** 漂亮的单行。开启后，一页只有一行，与容器水平中心对齐。默认false.  */
@property (nonatomic, assign) BOOL prettySingleRow;

/** 图片的尺寸。默认50*50 */
@property (nonatomic, assign) CGSize imageSize;

/** 文字字体。默认13常规。 */
@property (nonatomic, strong, nonnull) UIFont *titleFont;

/** 文字颜色。默认#464646 */
@property (nonatomic, strong, nonnull) UIColor *titleColor;

/** 文字高度。默认为文字最小显示高度 */
@property (nonatomic, assign) CGFloat titleHeight;

/** 每个Item中图片与文字的间距。默认为1。 */
@property (nonatomic, assign) CGFloat distanceInItem;

/** 中间行间距。默认为8. */
@property (nonatomic, assign) CGFloat distanceOfRow;

/** 列间距。默认为0.0. */
@property (nonatomic, assign) CGFloat distanceOfCol;

/** 顶部间距(第一行距顶部的距离)。默认为8.0。 */
@property (nonatomic, assign) CGFloat distanceOfTop;

/** 底部间距(每页最后一行距底部的距离)。默认为8.0。 */
@property (nonatomic, assign) CGFloat distanceOfbottom;

/** 占位图 */
@property (nonatomic, strong, nullable) UIImage *placeholderImage;

/** 角标图片的尺寸。默认40 * 20 */
@property (nonatomic, assign) CGSize tagImageSize;

/** 角标位置。有图片则相对图片右上角，默认(-15, 0)；只有文字则相对文字实际尺寸右上角，默认(0, 0) */
@property (nonatomic, assign) CGPoint tagImagePoint;

/** 对Item（UIButton）的其他设置 */
@property (nonatomic, copy, nullable) void(^otherConfig)(UIButton * _Nonnull item);

/** 自动调整高度（只显示一页） */
@property (nonatomic, assign) BOOL autoAdjustHeight;

/** 可以垂直滚动（高度超出时） */
@property (nonatomic, assign) BOOL verticalScrollActivated;


// ---------------- 分页控件
/** 始终隐藏分页控件。默认关闭 */
@property (nonatomic, assign) BOOL hidesPageAlawys;

/** 只有一页时隐藏分页控件。默认开启*/
@property (nonatomic, assign) BOOL hidesForSinglePage;

/** 当前分页控件小圆标颜色 */
@property (nonatomic, strong, nonnull) UIColor *currentPageDotColor;

/** 其他分页控件小圆标颜色 */
@property (nonatomic, strong, nonnull) UIColor *pageDotColor;

/** 分页控件小圆标底边距离容器底边的距离。默认为6. */
@property (nonatomic, assign) CGFloat pageDotBottomMargin;


@end
