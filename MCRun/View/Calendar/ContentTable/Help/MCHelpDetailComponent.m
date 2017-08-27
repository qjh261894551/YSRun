//
//  MCHelpDetailComponent.m
//  MCRun
//
//  Created by moshuqi on 15/11/24.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "MCHelpDetailComponent.h"
#import "MCAppMacro.h"

@interface MCHelpDetailComponent ()

@property (nonatomic, weak) IBOutlet UIView *colorView;
@property (nonatomic, weak) IBOutlet UILabel *detailLabel;

@end

@implementation MCHelpDetailComponent

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        UIView *containerView = [[[UINib nibWithNibName:@"MCHelpDetailComponent" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        
        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        containerView.frame = newFrame;
        
        [self addSubview:containerView];
        
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.detailLabel.textColor = RGB(136, 136, 136);
    self.detailLabel.font = [UIFont systemFontOfSize:13];
    self.detailLabel.numberOfLines = 0;
    
    self.colorView.layer.cornerRadius = 3;
}

- (void)setDetailWithText:(NSString *)text color:(UIColor *)color
{
    self.detailLabel.text = text;
    self.colorView.backgroundColor = color;
}

@end
