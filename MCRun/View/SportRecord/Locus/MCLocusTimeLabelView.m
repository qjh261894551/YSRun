//
//  MCLocusTimeLabelView.m
//  MCRun
//
//  Created by moshuqi on 16/1/25.
//  Copyright © 2016年 msq. All rights reserved.
//

#import "MCLocusTimeLabelView.h"
#import "MCAppMacro.h"
#import "MCTimeFunc.h"

@interface MCLocusTimeLabelView ()

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *spaceConstraint;

@end

@implementation MCLocusTimeLabelView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        UIView *containerView = [[[UINib nibWithNibName:@"MCLocusTimeLabelView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        
        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        containerView.frame = newFrame;
        
        [self addSubview:containerView];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    // 设置颜色、圆角
    
    // 自身视图的圆角
    CGFloat height = CGRectGetHeight(self.frame);
    self.layer.cornerRadius = height / 2;
    self.clipsToBounds = YES;

    // 此时self.nameLabel的frame还没调整到正确的值，所以通过这种方式这只圆角
    CGFloat cornerRadius = (height - 2 * self.spaceConstraint.constant) / 2;
    
    self.nameLabel.layer.cornerRadius = cornerRadius;
    self.nameLabel.clipsToBounds = YES;
    self.nameLabel.backgroundColor = GreenBackgroundColor;
    
    self.timeLabel.textColor = GreenBackgroundColor;
    
    self.nameLabel.adjustsFontSizeToFitWidth = YES;
    self.timeLabel.adjustsFontSizeToFitWidth = YES;
}


- (void)setupWithTimestamp:(NSInteger)timestamp
{
    self.timeLabel.text = [MCTimeFunc dateStrFromTimestamp:timestamp];
}

@end
