//
//  MCPaceDataTableView.h
//  MCRun
//
//  Created by moshuqi on 16/1/27.
//  Copyright © 2016年 msq. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MCPaceDataTableViewLabelHeight  44
#define MCPaceDataTableViewItemHeight   56

@interface MCPaceDataTableView : UIView

- (id)initWithFrame:(CGRect)frame sectionDataModelArray:(NSArray *)sectionDataModelArray;

@end
