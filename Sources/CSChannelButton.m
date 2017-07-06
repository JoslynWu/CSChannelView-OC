//
//  CSChannelButton.m
//  CSChannelView
//
//  Created by Joslyn Wu on 2017/6/14.
//  Copyright © 2017年 joslyn. All rights reserved.
//

#import "CSChannelButton.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIButton+WebCache.h>

@interface CSChannelButton ()

@property (nonatomic, strong) UIImageView *tagView;
@property (nonatomic, strong) CSChannelButtonConfigInfo *configInfo;

@end

@implementation CSChannelButton

- (instancetype)initWithFrame:(CGRect)frame configInfo:(CSChannelButtonConfigInfo *)configInfo {
    self = [super initWithFrame:frame];
    if (self) {
        self.configInfo = configInfo;
        [self setupUI];
        if (configInfo.otherConfig) { configInfo.otherConfig(self); }
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    if (self.configInfo.channelType == CSChannelTypeTitleOnly) {
        return CGRectZero;
    }
    
    CGFloat imgView_w = self.configInfo.imageSize.width;
    return CGRectMake((contentRect.size.width - imgView_w) / 2 , 0, imgView_w, self.configInfo.imageSize.height);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    if (self.configInfo.channelType == CSChannelTypeTitleOnly) {
        return contentRect;
    }
    
    if (self.configInfo.channelType == CSChannelTypeImageOnly) {
        return CGRectZero;
    }
    
    CGFloat title_y = CGRectGetMaxY(self.imageView.frame) + self.configInfo.distanceInItem;
    return CGRectMake(0, title_y , contentRect.size.width, self.configInfo.titleHeight);
}

- (void)setupUI {
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self setTitleColor:self.configInfo.titleColor forState:UIControlStateNormal];
    self.titleLabel.font = self.configInfo.titleFont;
    
    CGFloat x = CGRectGetMaxX(self.imageView.frame) + self.configInfo.tagImagePoint.x;
    CGFloat y = self.configInfo.tagImagePoint.y;
    if (self.configInfo.channelType == CSChannelTypeTitleOnly) {
        x = (self.frame.size.width - self.configInfo.titleMinSize.width) * 0.5 + self.configInfo.titleMinSize.width + self.configInfo.tagImagePoint.x;
        y = (self.frame.size.height - self.configInfo.titleMinSize.height) * 0.5 + self.configInfo.tagImagePoint.y;
    }
    self.tagView.frame = CGRectMake(x, y, self.configInfo.tagImageSize.width, self.configInfo.tagImageSize.height);
}

#pragma mark  -  setter/getter
- (UIImageView *)tagView {
    if (!_tagView) {
        _tagView = [[UIImageView alloc] init];
        [self addSubview:_tagView];
        _tagView.contentMode = UIViewContentModeScaleToFill;
    }
    return _tagView;
}

- (void)setDataInfo:(CSChannelButtonDataInfo *)dataInfo {
    _dataInfo = dataInfo;
    if (![dataInfo.imgUrl hasPrefix:@"http"]) {
        [self setImage:[UIImage imageNamed:dataInfo.imgUrl] forState:UIControlStateNormal];
    } else {
        self.imageView.contentMode = UIViewContentModeCenter;
        [self sd_setImageWithURL:[NSURL URLWithString:dataInfo.imgUrl] forState:UIControlStateNormal placeholderImage:self.configInfo.placeholderImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if(!error) { self.imageView.contentMode = UIViewContentModeScaleToFill; }
        }];
    }
    
    [self setTitle:dataInfo.title forState:UIControlStateNormal];
    
    if (dataInfo.tagImgUrl.length > 0) {
        self.tagView.hidden = NO;
        if (![dataInfo.tagImgUrl hasPrefix:@"http"]) {
            self.tagView.image = [UIImage imageNamed:dataInfo.tagImgUrl];
        } else {
            [self.tagView sd_setImageWithURL:[NSURL URLWithString:dataInfo.tagImgUrl]];
        }
    } else {
        self.tagView.hidden = YES;
    }
}

@end


@implementation CSChannelButtonConfigInfo
@end

@implementation CSChannelButtonDataInfo
@end
