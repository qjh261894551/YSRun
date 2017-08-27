//
//  MCHeartRateRecordCommentView.m
//  MCRun
//
//  Created by moshuqi on 15/11/16.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "MCHeartRateRecordCommentView.h"
#import "MCCommentElement.h"

@interface MCHeartRateRecordCommentView ()

@property (nonatomic, weak) IBOutlet MCCommentElement *leftCommentElement;
@property (nonatomic, weak) IBOutlet MCCommentElement *centerCommentElement;
@property (nonatomic, weak) IBOutlet MCCommentElement *rightCommentElement;

@end

@implementation MCHeartRateRecordCommentView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        UIView *containerView = [[[UINib nibWithNibName:@"MCHeartRateRecordCommentView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        
        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        containerView.frame = newFrame;
        containerView.backgroundColor = [UIColor clearColor];
        
        [self addSubview:containerView];
    }
    
    return self;
}

- (void)setLeftCommentElementColor:(UIColor *)color text:(NSString *)text
{
    [self setCommentElement:self.leftCommentElement withColor:color text:text];
}

- (void)setCenterCommentElementColor:(UIColor *)color text:(NSString *)text
{
    [self setCommentElement:self.centerCommentElement withColor:color text:text];
}

- (void)setRightCommentElementColor:(UIColor *)color text:(NSString *)text
{
    [self setCommentElement:self.rightCommentElement withColor:color text:text];
}

- (void)setCommentElement:(MCCommentElement *)commentElement withColor:(UIColor *)color text:(NSString *)text
{
    [commentElement setCommentColor:color];
    [commentElement setCommentText:text];
}

- (void)setFontSize:(CGFloat)fontSize
{
    [self.leftCommentElement setCommentTextFontSize:fontSize];
    [self.centerCommentElement setCommentTextFontSize:fontSize];
    [self.rightCommentElement setCommentTextFontSize:fontSize];
}

@end
