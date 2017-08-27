//
//  MCUserLevelView.h
//  MCRun
//
//  Created by moshuqi on 15/10/16.
//  Copyright © 2015年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MCUserLevelViewDelegate <NSObject>

@required
- (void)headPhotoChange;
- (void)toLogin;
- (BOOL)loginState;

@end

@interface MCUserLevelView : UIView

@property (nonatomic, weak) id<MCUserLevelViewDelegate> delegate;

- (void)setUserName:(NSString *)userName
          headPhoto:(UIImage *)headPhoto
              grade:(NSInteger)grade
       achieveTitle:(NSString *)achieveTitle
           progress:(CGFloat)progress
upgradeRequireTimes:(NSInteger)upgradeRequireTimes;

- (void)setHeadPhoto:(UIImage *)photo;

@end
