//
//  MCCommentElement.m
//  MCRun
//
//  Created by moshuqi on 15/11/16.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "MCCommentElement.h"

@interface MCCommentElement ()

@property (nonatomic, strong) IBOutlet UIView *colorView;
@property (nonatomic, strong) IBOutlet UILabel *commentLabel;

@end

@implementation MCCommentElement

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        UIView *containerView = [[[UINib nibWithNibName:@"MCCommentElement" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        
        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        containerView.frame = newFrame;
        containerView.backgroundColor = [UIColor clearColor];
        
        [self addSubview:containerView];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.commentLabel.adjustsFontSizeToFitWidth = YES;
//    self.commentLabel.textAlignment = NSTextAlignmentCenter;
    
    self.commentLabel.textColor = [UIColor colorWithRed:81 / 255.0 green:81 / 255.0 blue:81 / 255.0 alpha:1.0];
}

- (void)setCommentColor:(UIColor *)color
{
    self.colorView.backgroundColor = color;
}

- (void)setCommentText:(NSString *)text
{
    self.commentLabel.text = text;
}

- (void)setCommentTextFontSize:(CGFloat)fontSize
{
    self.commentLabel.font = [UIFont systemFontOfSize:fontSize];
}

@end
