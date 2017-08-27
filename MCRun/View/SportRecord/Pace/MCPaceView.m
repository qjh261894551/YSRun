//
//  MCPaceView.m
//  MCRun
//
//  Created by moshuqi on 16/1/25.
//  Copyright © 2016年 msq. All rights reserved.
//

#import "MCPaceView.h"
#import "MCPaceSectionDataModel.h"
#import "MCPaceDataTableView.h"
#import "MCDataRecordModel.h"
#import "MCPaceCalculateFunc.h"
#import "MCTimeLocationArray.h"
#import "MCAppMacro.h"
#import "MCDevice.h"

@interface MCPaceView ()

@property (nonatomic, strong) NSArray *paceSectionDataArray;
@property (nonatomic, strong) MCPaceDataTableView *paceDataTableView;
@property (nonatomic, strong) MCDataRecordModel *dataRecordModel;
@property (nonatomic, strong) MCPaceCalculateFunc *paceCalculateFunc;

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *paceLabel;

@end

@implementation MCPaceView

static const CGFloat kEdgeDistance = 15;    // 边缘间距

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = LightgrayBackgroundColor;
    
    UIColor *textColor = RGB(81, 81, 81);
    self.titleLabel.textColor = textColor;
    self.paceLabel.textColor = textColor;
    
    CGFloat fontSize = 12;
    if ([MCDevice isPhone6Plus])
    {
        fontSize = 16;
    }
    self.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    self.paceLabel.font = [UIFont systemFontOfSize:fontSize];
}

- (void)addTable
{
    self.paceDataTableView = [[MCPaceDataTableView alloc] initWithFrame:self.bounds sectionDataModelArray:self.paceSectionDataArray];
    [self addSubview:self.paceDataTableView];
    
    self.paceDataTableView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSString *viewKey = @"paceDataTableView";
    NSDictionary *viewsDictionary = @{viewKey : self.paceDataTableView};
    
    // 高度约束
    NSString *heightConstraintsVFL = [NSString stringWithFormat:@"V:[%@(%@)]", viewKey, @([self tableHeight])];
    NSArray *heightConstraints = [NSLayoutConstraint constraintsWithVisualFormat:heightConstraintsVFL
                                                                         options:0
                                                                         metrics:nil
                                                                           views:viewsDictionary];
    [self addConstraints:heightConstraints];
    
    // 水平约束
    NSString *constrainsVFL_H = [NSString stringWithFormat:@"H:|-%@-[%@]-%@-|", @(kEdgeDistance), viewKey, @(kEdgeDistance)];
    NSArray *constrains_H = [NSLayoutConstraint constraintsWithVisualFormat:constrainsVFL_H
                                                                         options:0
                                                                         metrics:nil
                                                                           views:viewsDictionary];
    [self addConstraints:constrains_H];
    
    // 垂直约束
    NSString *constrainsVFL_V = [NSString stringWithFormat:@"V:|-60-[%@]", viewKey];
    NSArray *constrains_V = [NSLayoutConstraint constraintsWithVisualFormat:constrainsVFL_V
                                                                    options:0
                                                                    metrics:nil
                                                                      views:viewsDictionary];
    [self addConstraints:constrains_V];
}

- (CGFloat)tableHeight
{
    CGFloat height = MCPaceDataTableViewLabelHeight + MCPaceDataTableViewItemHeight * [self.paceSectionDataArray count];
    return height;
}

- (void)setupWithDataRecordModel:(MCDataRecordModel *)dataRecordModel
{
    self.dataRecordModel = dataRecordModel;
    
    [self setupTable];
    [self setupLabels];
}

- (void)setupTable
{
    // 设置每段数据
    
    // test code
    MCTimeLocationArray *timeLocationArray = [[MCTimeLocationArray alloc] initWithLocationArray:self.dataRecordModel.locationArray timestampArray:nil];
    
    // 每段距离配速的数据
    self.paceCalculateFunc = [[MCPaceCalculateFunc alloc] initWithTimeLocationArray:timeLocationArray useTime:self.dataRecordModel.endTime - self.dataRecordModel.startTime];
    self.paceSectionDataArray = [self.paceCalculateFunc getPaceSectionDataArray];
    
    if ([self.paceSectionDataArray count] > 0)
    {
        // 有数据时才加上table
        [self addTable];
    }
}

- (void)setupLabels
{
    // 设置最上面两个标签
    self.titleLabel.text = @"平均配速（分钟/公里）";
    
    self.paceLabel.text = [NSString stringWithFormat:@"%.2f", [self.dataRecordModel getPace]];
}

@end
