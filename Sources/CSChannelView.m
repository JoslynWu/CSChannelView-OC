//
//  CSChannelView.m
//  CSChannelView
//
//  Created by Joslyn Wu on 2017/6/13.
//  Copyright © 2017年 joslyn. All rights reserved.
//

#import "CSChannelView.h"
#import "CSChannelButton.h"

static const CGFloat CS_BUTTON_BASE_TAG = 123321;

@interface CSChannelView ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray<CSChannelButtonDataInfo *> *channelData;
@property (nonatomic, strong) NSMutableArray<CSChannelButton *> *buttonArray;
@property (nonatomic, strong) NSMutableArray<UIView *> *pageArr;
@property (nonatomic, assign) CSChannelType channelType;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageCtl;
@property (nonatomic, assign) BOOL isAutoScale;

@end

@implementation CSChannelView

#pragma mark  -  public
- (void)loadDataInfoWithImages:(nullable NSArray<NSString *> *)imageGroup tittls:(nullable NSArray<NSString *> *)titleGroup tagImages:(nullable NSArray<NSString *> *)tagImageGroup {
    NSInteger count = MAX(MAX(imageGroup.count, titleGroup.count), tagImageGroup.count);
    
    CSChannelType type = CSChannelTypeNormal;
    if (titleGroup.count <= 0) {
        type = CSChannelTypeImageOnly;
    } else {
        if (imageGroup.count <= 0 ) {
            type = CSChannelTypeTitleOnly;
        }
    }
    self.channelType = type;
    
    NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        CSChannelButtonDataInfo *dataInfo = [CSChannelButtonDataInfo new];
        dataInfo.imgUrl = ((i < imageGroup.count ) ? [imageGroup objectAtIndex:i] : @"");
        dataInfo.title = ((i < titleGroup.count ) ? [titleGroup objectAtIndex:i] : @"");
        dataInfo.tagImgUrl = ((i < tagImageGroup.count ) ? [tagImageGroup objectAtIndex:i] : @"");
        [mArr addObject:dataInfo];
    }
    self.channelData = mArr.copy;
    
    [self refreshUI];
    
    [self.channelData enumerateObjectsUsingBlock:^(CSChannelButtonDataInfo *dataInfo, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx >= self.buttonArray.count) { return; }
        CSChannelButton *button = [self.buttonArray objectAtIndex:idx];
        button.dataInfo = dataInfo;
    }];
}

#pragma mark  -  lifecycle
- (instancetype)initWithFrame:(CGRect)frame placeholderImage:(UIImage *)placeholderImage autoScale:(BOOL)enable {
    CGRect rect = frame;
    if (enable) {
        CGFloat scale = [UIScreen mainScreen].bounds.size.width / 375.0;
        CGFloat width = frame.size.width * ((frame.size.width == [UIScreen mainScreen].bounds.size.width) ? 1 : scale);
        CGFloat height = frame.size.height * ((frame.size.height == [UIScreen mainScreen].bounds.size.height) ? 1 : scale);
        rect = CGRectMake(frame.origin.x * scale, frame.origin.y * scale, width, height);
    }
    self = [super initWithFrame:rect];
    if (self) {
        self.isAutoScale = enable;
        self.placeholderImage = placeholderImage;
        [self initialization];
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame autoScale:(BOOL)enable {
    return [self initWithFrame:frame placeholderImage:nil autoScale:enable];
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame placeholderImage:nil autoScale:true];
}

#pragma mark  -  action
- (void)initialization {
    self.backgroundColor = [UIColor whiteColor];
    self.numberOfItemInRow = 4;
    self.numberOfRowInPage = 2;
    self.imageSize = CGSizeMake(50.0, 50.0);
    self.distanceInItem = 0.0;
    self.distanceOfRow = 8.0;
    self.distanceOfTop = 8.0;
    self.distanceOfbottom = 8.0;
    self.distanceOfCol = 0.0;
    self.titleFont = [UIFont systemFontOfSize:13];
    self.titleColor = [UIColor colorWithRed:70/255.0 green:70/255.0 blue:70/255.0 alpha:1];
    self.tagImageSize = CGSizeMake(40, 20);
    self.tagImagePoint = CGPointMake(-15, 0);
    self.pageDotColor = [UIColor lightGrayColor];
    self.currentPageDotColor = [UIColor darkGrayColor];
    self.pageDotBottomMargin = 6;
    self.hidesForSinglePage = true;
}

-(void)setupUI {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    
    UIPageControl *pageCtl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 0, 7)];
    self.pageCtl = pageCtl;
    [self addSubview:pageCtl];
    
    self.buttonArray = [[NSMutableArray alloc] init];
    self.pageArr = [[NSMutableArray alloc] init];
}

- (void)refreshUI {
    [self removeSubViewsOfScrollView];
    
    if (self.prettySingleRow) { self.numberOfRowInPage = 1; }
    NSUInteger itemCount = self.channelData.count;
    NSUInteger pageCount = (self.autoAdjustHeight ? 1 : ceil(itemCount / (self.numberOfItemInRow * self.numberOfRowInPage + 0.1)));
    CGFloat page_w = CGRectGetWidth(self.frame);
    CGFloat page_h = CGRectGetHeight(self.frame);
    
    self.pageArr = [NSMutableArray arrayWithCapacity:pageCount];
    for (int i = 0; i < pageCount; i++) {
        UIView *pageView = [[UIView alloc] init];
        [self.scrollView addSubview:pageView];
        [self.pageArr addObject:pageView];
    }
    
    CGFloat scale = (self.isAutoScale ? [UIScreen mainScreen].bounds.size.width / 375.0 : 1.0);
    self.distanceOfTop = self.distanceOfTop * scale;
    self.distanceOfbottom = self.distanceOfbottom * scale;
    self.distanceOfRow = self.distanceOfRow * scale;
    self.distanceOfCol = self.distanceOfCol * scale;
    
    self.buttonArray = [[NSMutableArray alloc] init];
    NSUInteger itemCountInOnePage = self.numberOfItemInRow * self.numberOfRowInPage;
    CGFloat button_h = [self calcButtonHeight] * scale;
    CGFloat button_w = ((page_w - (self.numberOfItemInRow + 1) * self.distanceOfCol) / self.numberOfItemInRow);
    
    CSChannelButtonConfigInfo *configInfo = [self makeAndAdjustConfigInfo];
    for (int i = 0; i < itemCount; i++) {
        NSUInteger currentPage = self.autoAdjustHeight ? 0 : i / itemCountInOnePage;
        NSInteger x = (i - (currentPage * itemCountInOnePage)) % self.numberOfItemInRow;
        NSInteger y = (i - (currentPage * itemCountInOnePage)) / self.numberOfItemInRow;
        CGFloat button_x = x * (button_w + self.distanceOfCol) + self.distanceOfCol;
        CGFloat button_y = y * (button_h + self.distanceOfRow);
        CGRect btnRect = CGRectMake(button_x, button_y, button_w, button_h);
        if (self.channelType == CSChannelTypeTitleOnly) {
            configInfo.titleMinSize = [self calcTitleSizeWithTitle:[self.channelData objectAtIndex:i].title];
        }
        CSChannelButton *button = [[CSChannelButton alloc] initWithFrame:btnRect configInfo:configInfo];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = CS_BUTTON_BASE_TAG + i;
        UIView *pageView = [self.pageArr objectAtIndex:currentPage];
        [pageView addSubview:button];
        [self.buttonArray addObject:button];
    }
    UIButton *lastBtnOfFirshPage = (UIButton *)self.pageArr.firstObject.subviews.lastObject;
    CGFloat page_h_max = CGRectGetMaxY(lastBtnOfFirshPage.frame);
    
    CGFloat distance_top = self.distanceOfTop;
    CGFloat distance_bottom = self.distanceOfbottom;
    CGFloat scrollView_h = page_h - distance_top - distance_bottom;
    CGFloat scrollView_w = page_w;
    
    if (self.autoAdjustHeight) {
        CGFloat changeH = page_h_max - scrollView_h;
        CGRect tempRect = self.frame;
        tempRect.size.height = CGRectGetHeight(self.frame) + changeH;
        self.frame = tempRect;
        scrollView_h = scrollView_h + changeH;
        self.hidesPageAlawys = YES;
    }
    
    self.scrollView.frame = CGRectMake(0, distance_top, scrollView_w, scrollView_h);
    self.scrollView.contentSize = CGSizeMake(pageCount * page_w, (self.verticalScrollActivated ? page_h_max : scrollView_h));
    
    for (int i = 0 ; i < self.scrollView.subviews.count; i++) {
        UIView *pageView = self.scrollView.subviews[i];
        pageView.frame = CGRectMake(i * scrollView_w, 0, scrollView_w, scrollView_h);
    }
    
    if (self.prettySingleRow) {
        for (CSChannelButton *btn in self.buttonArray) {
            CGPoint tempCenter = btn.center;
            tempCenter.y = CGRectGetHeight(self.scrollView.frame) * 0.5;
            btn.center = tempCenter;
        }
    }
    
    CGFloat pagCtl_center_y = CGRectGetHeight(self.frame) - CGRectGetHeight(self.pageCtl.frame) * 0.5 - self.pageDotBottomMargin;
    self.pageCtl.center = CGPointMake(self.scrollView.center.x, pagCtl_center_y);
    self.pageCtl.pageIndicatorTintColor = self.pageDotColor;
    self.pageCtl.currentPageIndicatorTintColor = self.currentPageDotColor;
    self.pageCtl.numberOfPages = pageCount;
    
    self.pageCtl.hidesForSinglePage = self.hidesForSinglePage;
    if (self.hidesPageAlawys) {
        self.pageCtl.hidesForSinglePage = false;
        self.pageCtl.hidden = YES;
    } else {
        if (self.hidesForSinglePage) {
            self.pageCtl.hidden = NO;
            self.pageCtl.hidesForSinglePage = YES;
        } else {
            self.pageCtl.hidesForSinglePage = false;
            self.pageCtl.hidden = NO;
        }
    }
}

- (CGFloat)calcButtonHeight {
    if (self.channelType == CSChannelTypeImageOnly) { return self.imageSize.height; }
    
    self.titleHeight = MAX([self calcTitleSizeWithTitle:@""].height, self.titleHeight);
    if (self.channelType == CSChannelTypeTitleOnly) { return self.titleHeight; }
    
    return self.imageSize.height + self.titleHeight + self.distanceInItem;
}

- (CGSize)calcTitleSizeWithTitle:(NSString *)title {
    CGFloat page_w = CGRectGetWidth(self.frame);
    CGFloat page_h = CGRectGetHeight(self.frame);
    CGFloat imge_total_h = (self.channelType == CSChannelTypeTitleOnly ? 0.0 : (self.imageSize.height + self.distanceInItem) * self.numberOfRowInPage);
    CGFloat title_h_max = (page_h - imge_total_h - self.distanceOfTop - self.distanceOfRow * (self.numberOfRowInPage - 1)) / self.numberOfRowInPage;
    CGSize titleSize = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, title_h_max)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName : self.titleFont}
                                           context:nil].size;
    CGFloat button_w = (page_w - (self.numberOfItemInRow + 1) * self.distanceOfCol) / self.numberOfItemInRow;
    CGFloat title_h = (title_h_max > ceil(titleSize.height) ? MIN(ceil(titleSize.height), title_h_max) : ceil(titleSize.height));
    CGFloat title_w = (button_w > ceil(titleSize.width) ? MIN(ceil(titleSize.width), button_w) : ceil(titleSize.width));
    return CGSizeMake(title_w, title_h);
}

- (void)removeSubViewsOfScrollView {
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
}

- (CSChannelButtonConfigInfo *)makeAndAdjustConfigInfo {
    CGFloat scale = (self.isAutoScale ? [UIScreen mainScreen].bounds.size.width / 375.0 : 1.0);
    
    CSChannelButtonConfigInfo *info = [CSChannelButtonConfigInfo new];
    info.imageSize = CGSizeMake(self.imageSize.width * scale, self.imageSize.height * scale);
    info.distanceInItem = self.distanceInItem * scale;
    info.titleHeight = self.titleHeight * scale;
    info.tagImagePoint = CGPointMake(self.tagImagePoint.x * scale, self.tagImagePoint.y * scale);
    info.tagImageSize = CGSizeMake(self.tagImageSize.width * scale, self.tagImageSize.height * scale);
    info.channelType = self.channelType;
    info.titleFont = self.titleFont;
    info.titleColor = self.titleColor;
    info.placeholderImage = self.placeholderImage;
    info.otherConfig = self.otherConfig;
    
    return info;
}

#pragma mark  -  UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat page_w = CGRectGetWidth(self.frame);
    self.pageCtl.currentPage = (self.scrollView.contentOffset.x + page_w * 0.5) / page_w;
}

#pragma mark  -  listen
-(void)buttonAction:(UIButton *)sender {
    if (self.itemDidClickBlock) {
        self.itemDidClickBlock(sender.tag - CS_BUTTON_BASE_TAG);
    }
}

@end
