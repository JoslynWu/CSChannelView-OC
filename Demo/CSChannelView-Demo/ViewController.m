//
//  ViewController.m
//  CSChannelView
//
//  Created by Joslyn Wu on 2017/6/13.
//  Copyright © 2017年 joslyn. All rights reserved.
//

#import "ViewController.h"
#import "CSChannelView.h"
#import "YYModel.h"
#import "CSToast.h"

#define kFULL_WIDTH ([[UIScreen mainScreen] bounds].size.width)
@interface ViewController ()

@property (nonatomic, strong) NSMutableArray<NSDictionary *> *data;
@property (nonatomic, strong) NSMutableArray *imgs;
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *tagImgs;
@property (nonatomic, strong) CSChannelView *channelView;

@property (nonatomic, assign) BOOL showImage;
@property (nonatomic, assign) BOOL showTitle;
@property (nonatomic, assign) BOOL showTag;
@property (weak, nonatomic) IBOutlet UISegmentedControl *rowSegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *itemCountSegment;
@property (nonatomic, assign) CGFloat lastStepperValue;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    [self setupUI];
}


// -------------------- example --------------------

/**
 只有频道的图标
 */
- (void)setupImageOnlyChannelView {
    CSChannelView *imgOnlyChannelView = [[CSChannelView alloc] initWithFrame:CGRectMake(0, 20, kFULL_WIDTH, 100)];
    [self.view addSubview:imgOnlyChannelView];
    imgOnlyChannelView.prettySingleRow = true;
    imgOnlyChannelView.numberOfItemInRow = 5;
    [self addActionWithSender:imgOnlyChannelView];
    [imgOnlyChannelView loadDataInfoWithImages:self.imgs tittls:nil tagImages:nil];
}

/**
 只有频道标题
 */
- (void)setupTitleOnlyChannelView {
    CSChannelView *titleOnlyChannelView = [[CSChannelView alloc] initWithFrame:CGRectMake(0, 120 + 16, kFULL_WIDTH, 35 + 30)];
    [self.view addSubview:titleOnlyChannelView];
    titleOnlyChannelView.titleHeight = 35;
    titleOnlyChannelView.distanceOfCol = 8;
    titleOnlyChannelView.prettySingleRow = true;
    titleOnlyChannelView.hidesPageAlawys = true;
    titleOnlyChannelView.otherConfig = ^(UIButton *item) {
        item.backgroundColor = [UIColor whiteColor];
        item.layer.shadowOffset = CGSizeMake(0, 0);
        item.layer.shadowOpacity = 1;
        item.layer.cornerRadius = 6;
        item.layer.shadowColor = [UIColor colorWithWhite:0.87 alpha:1].CGColor;
    };
    [self addActionWithSender:titleOnlyChannelView];
    [titleOnlyChannelView loadDataInfoWithImages:nil tittls:self.titles tagImages:nil];
}

/**
 自定义频道样式
 */
- (void)customChannelView {
    CSChannelView *channelView = [[CSChannelView alloc] initWithFrame:CGRectMake(0, 201 + 16, kFULL_WIDTH, 165)];
    self.channelView = channelView;
//    channelView.verticalScrollActivated = YES;
    channelView.autoAdjustHeight = YES;
    [self.view addSubview:channelView];
    [self addActionWithSender:channelView];
    [channelView loadDataInfoWithImages:self.imgs tittls:self.titles tagImages:self.tagImgs];
}
// -------------------- example --------------------




- (void)loadData {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"config" ofType:@".plist"];
    NSArray *arr = [[[NSDictionary alloc] initWithContentsOfFile:plistPath] objectForKey:@"channel"];
    self.data = [NSMutableArray arrayWithArray:arr];
    [self refreshData];
}

- (void)setupUI {
    self.showImage = true; self.showTitle = true; self.showTag = true;
    self.rowSegment.selectedSegmentIndex = 1; self.itemCountSegment.selectedSegmentIndex = 1;
    self.lastStepperValue = 7;
    
    [self setupImageOnlyChannelView];
    [self setupTitleOnlyChannelView];
    [self customChannelView];
}

- (void)refreshData {
    self.imgs = [NSMutableArray new];
    self.titles = [NSMutableArray new];
    self.tagImgs = [NSMutableArray new];
    for (NSDictionary *dict in self.data) {
        [self.imgs addObject:([dict objectForKey:@"imgUrl"] == nil ? @"" : [dict objectForKey:@"imgUrl"])];
        [self.titles addObject:([dict objectForKey:@"title"] == nil ? @"" : [dict objectForKey:@"title"])];
        [self.tagImgs addObject:([dict objectForKey:@"iconImgUrl"] == nil ? @"" : [dict objectForKey:@"iconImgUrl"])];
    }
}

- (void)addActionWithSender:(CSChannelView *)sender {
    sender.itemDidClickBlock = ^(NSInteger index) {
        CSToast.text([self.titles objectAtIndex:index]).bottom(210).show();
    };
}

- (void)refreshChannelView {
    NSArray *imgs = self.showImage ? self.imgs : nil;
    NSArray *titles = self.showTitle ? self.titles : nil;
    NSArray *tags = self.showTag ? self.tagImgs : nil;
    
    [self.channelView loadDataInfoWithImages:imgs tittls:titles tagImages:tags];
}

- (IBAction)changeRowNumber:(UISegmentedControl *)sender {
    self.channelView.numberOfRowInPage = sender.selectedSegmentIndex + 1;
    [self refreshChannelView];
}
- (IBAction)changeItemCountInfRow:(UISegmentedControl *)sender {
    self.channelView.numberOfItemInRow = sender.selectedSegmentIndex + 3;
    [self refreshChannelView];
}
- (IBAction)showImage:(UISwitch *)sender {
    self.channelView.tagImagePoint = sender.on ? CGPointMake(-15, 0) : CGPointMake(0, 0);
    self.channelView.tagImageSize = sender.on ? CGSizeMake(40, 20) : CGSizeMake(20, 10);
    self.channelView.titleFont = sender.on ? [UIFont systemFontOfSize:13] : [UIFont systemFontOfSize:16];
    self.channelView.titleHeight = sender.on ? 0.0 : 35.0;
    self.channelView.distanceOfCol = sender.on ? 0.0 : 8;
    self.channelView.distanceOfTop = sender.on ? 8 : 15;
    self.channelView.titleColor = sender.on ? [UIColor colorWithRed:70/255.0 green:70/255.0 blue:70/255.0 alpha:1] : [UIColor whiteColor];
    self.channelView.otherConfig = sender.on ? nil : ^(UIButton *item) {
        item.backgroundColor = [UIColor darkGrayColor];
        item.layer.shadowOffset = CGSizeMake(0, 0);
        item.layer.shadowOpacity = 1;
        item.layer.cornerRadius =  6;
        item.layer.shadowColor = [UIColor colorWithWhite:0.87 alpha:1].CGColor;
    };
    self.showImage = sender.on;
    [self refreshChannelView];
}
- (IBAction)showTitle:(UISwitch *)sender {
    self.showTitle = sender.on;
    [self refreshChannelView];
}
- (IBAction)showTagImage:(UISwitch *)sender {
    self.showTag = sender.on;
    [self refreshChannelView];
}

- (IBAction)changeChannelViewHeight:(UISlider *)sender {
    CGRect tempRect = self.channelView.frame;
    tempRect.size.height = sender.value;
    self.channelView.frame = tempRect;
    [self refreshChannelView];
}

- (IBAction)changeChannelViewWidth:(UISlider *)sender {
    CGRect tempRect = self.channelView.frame;
    tempRect.size.width = sender.value;
    tempRect.origin.x = ([UIScreen mainScreen].bounds.size.width - sender.value) * 0.5;
    self.channelView.frame = tempRect;
    [self refreshChannelView];
}

- (IBAction)changeItemCount:(UIStepper *)sender {
    NSDictionary *randomDict = [self.data objectAtIndex:(NSUInteger)arc4random_uniform((uint32_t)(self.data.count - 1))];
    if (sender.value > self.lastStepperValue) {
        [self.data addObject:randomDict];
        [self refreshData];
    } else {
        [self.data removeLastObject];
        [self refreshData];
    }
    [self refreshChannelView];
    self.lastStepperValue = sender.value;
}


@end
