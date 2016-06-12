//
//  TCSettingViewController.h
//  TCSetting
//
//  Created by 陈 胜 on 16/5/24.
//  Copyright © 2016年 陈胜. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const kReuseIdentifier = @"Cell";

@interface TCSettingViewController : UITableViewController

@property (nonatomic, strong, readonly) NSArray *settingDatasource;

- (NSArray *)loadSettingDatasource;

@end
