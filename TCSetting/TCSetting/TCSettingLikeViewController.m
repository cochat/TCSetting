//
//  TCSettingLikeViewController.m
//  TCSetting
//
//  Created by 陈 胜 on 16/7/13.
//  Copyright © 2016年 陈胜. All rights reserved.
//

#import "TCSettingLikeViewController.h"

/**
 *  tableview分隔线颜色
 */
#ifndef ktcTableViewSeparatorColor
#define ktcTableViewSeparatorColor [UIColor colorWithRed:225.0f / 255 green:225.0f / 255 blue:225.0f / 255 alpha:1]
#endif

static const CGFloat ktcTableViewFooterHeight = 15.0f;    // tableview footer高度

@interface TCSettingLikeViewController ()

@end

@implementation TCSettingLikeViewController

- (instancetype)init {
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = NO;
    self.tableView.separatorColor = ktcTableViewSeparatorColor;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = ktcFirstSectionHeaderHeight;
    [self tc_setup];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    return NO;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return ktcFirstSectionHeaderHeight;
    }
    return ktcOtherSectionHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return ktcSectionFooterHeight;
}

#pragma mark - Private Methods

- (void)tc_setup {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    CGRect frame = CGRectMake(0, 0, ktcScreenWidth, ktcTableViewFooterHeight);
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:frame];
}

@end
