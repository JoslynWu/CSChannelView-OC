//
//  CSChannelButton.h
//  CSChannelView
//
//  Created by Joslyn Wu on 2017/6/14.
//  Copyright © 2017年 joslyn. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CSChannelButtonConfigInfo;
@class CSChannelButtonDataInfo;

typedef NS_ENUM(NSInteger, CSChannelType) {
    CSChannelTypeNormal,
    CSChannelTypeImageOnly,
    CSChannelTypeTitleOnly
};

@interface CSChannelButton : UIButton

- (instancetype)initWithFrame:(CGRect)frame configInfo:(CSChannelButtonConfigInfo *)configInfo;

@property (nonatomic, strong) CSChannelButtonDataInfo *dataInfo;

@end


@interface CSChannelButtonConfigInfo : NSObject

@property (nonatomic, assign) CSChannelType channelType;
@property (nonatomic, assign) CGSize imageSize;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, assign) CGFloat titleHeight;
@property (nonatomic, assign) CGFloat distanceInItem;
@property (nonatomic, strong) UIImage *placeholderImage;
@property (nonatomic, assign) CGSize tagImageSize;
@property (nonatomic, assign) CGPoint tagImagePoint;
@property (nonatomic, copy) void(^otherConfig)(UIButton *item);
@property (nonatomic, assign) CGSize titleMinSize;

@end


@interface CSChannelButtonDataInfo : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *imgUrl;
@property (nonatomic, copy) NSString *tagImgUrl;

@end
