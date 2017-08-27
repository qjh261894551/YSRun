//
//  MCWaveProgressView.m
//  MCRun
//
//  Created by moshuqi on 16/1/11.
//  Copyright © 2016年 msq. All rights reserved.
//

#import "MCWaveProgressView.h"
#import "MCAchievementView.h"
#import "MCWaterWaveView.h"

@interface MCWaveProgressView ()

@property (nonatomic, weak) IBOutlet MCAchievementView *achievementView;
@property (nonatomic, weak) IBOutlet MCWaterWaveView *waterWaveView;

//@property (nonatomic, weak) IBOutlet UIImageView *innerImageView;

@end

@implementation MCWaveProgressView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        UIView *containerView = [[[UINib nibWithNibName:@"MCWaveProgressView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        
        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        containerView.frame = newFrame;
        containerView.backgroundColor = [UIColor clearColor];
        
        [self addSubview:containerView];
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [self bringSubviewToFront:self.achievementView];
}

- (void)setupWithLevel:(NSInteger)level title:(NSString *)title grogressPercent:(CGFloat)percent
{
    [self.achievementView setupWithLevel:level title:title];
    [self.waterWaveView startWaveToPercent:percent];
}

- (void)resetWaterWaveView
{
    CGFloat diameter = CGRectGetWidth(self.waterWaveView.frame);
    
    self.waterWaveView.layer.cornerRadius = diameter / 2;
    self.waterWaveView.clipsToBounds = YES;
    
    self.waterWaveView.layer.borderWidth = 2;
    self.waterWaveView.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (void)resetProgress:(CGFloat)progress
{
    [self.waterWaveView startWaveToPercent:progress];
}


@end
