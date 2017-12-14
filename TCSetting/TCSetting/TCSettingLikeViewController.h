//
//  TCSettingLikeViewController.h
//  TCSetting
//
//  Created by 陈 胜 on 16/7/13.
//  Copyright © 2016年 陈胜. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  屏幕宽高
 */
#ifndef ktcScreenWidth
    #define ktcScreenWidth [UIScreen mainScreen].bounds.size.width
#endif
#ifndef ktcScreenHeight
    #define ktcScreenHeight [UIScreen mainScreen].bounds.size.height
#endif

static const CGFloat ktcFirstSectionHeaderHeight = 15.0f; // 第一个section header高度
static const CGFloat ktcOtherSectionHeaderHeight = 20.0f; // 其它section header高度
static const CGFloat ktcSectionFooterHeight = 0.01f;      // section footer高度

@interface TCSettingLikeViewController : UITableViewController

@end
