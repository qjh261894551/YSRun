//
//  MCVoiceSettingsViewController.m
//  MCRun
//
//  Created by moshuqi on 15/12/8.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "MCVoiceSettingsViewController.h"
#import "MCNavigationBarView.h"
#import "MCConfigManager.h"
#import "MCAppMacro.h"

#define VoiceSettingsTableViewReuseIdentifier @"VoiceSettingsTableViewReuseIdentifier"

@interface MCVoiceSettingsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet MCNavigationBarView *navigationBarView;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *voiceTypeArray;

@end

@implementation MCVoiceSettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupVoiceTypeArray];
    [self setupTableView];
    
    [self.navigationBarView setupWithTitle:@"语音提示" target:self action:@selector(voiceSettingsViewBack)];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)setupVoiceTypeArray
{
    // 男声、女声、关
    self.voiceTypeArray = @[[NSNumber numberWithInteger:MCVoicePromptTypeMan],
                            [NSNumber numberWithInteger:MCVoicePromptTypeGirl],
                            [NSNumber numberWithInteger:MCVoicePromptClose]];
}

- (void)setupTableView
{
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:VoiceSettingsTableViewReuseIdentifier];
    
    self.tableView.backgroundColor = LightgrayBackgroundColor;
    self.tableView.scrollEnabled = NO;
}

- (void)voiceSettingsViewBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)resetCheck
{
    // 选中之后改变标记
    NSArray *indexPaths = self.tableView.indexPathsForVisibleRows;
    NSInteger count = [indexPaths count];
    for (NSInteger i = 0; i < count; i++)
    {
        NSIndexPath *indexPath = indexPaths[i];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        MCVoicePromptType type = [self.voiceTypeArray[indexPath.row] integerValue];
        
        BOOL bCheck = ([MCConfigManager voicePromptType] == type);
        if (bCheck)
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [UIView new];
    return footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MCVoicePromptType type = [self.voiceTypeArray[indexPath.row] integerValue];
    [MCConfigManager setVoicePromptType:type];
    
    [self resetCheck];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.voiceTypeArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:VoiceSettingsTableViewReuseIdentifier forIndexPath:indexPath];
    
    if (cell == nil)
    {
        cell = [UITableViewCell new];
    }
    
    MCVoicePromptType type = (MCVoicePromptType)[self.voiceTypeArray[indexPath.row] integerValue];
    cell.textLabel.text = [MCConfigManager getVoiceTypeNameStringWithType:type];
    
    cell.textLabel.textColor = RGB(56, 56, 56);
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    // 选中标记
    BOOL bCheck = ([MCConfigManager voicePromptType] == type);
    if (bCheck)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

@end
