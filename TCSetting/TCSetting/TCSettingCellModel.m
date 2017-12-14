//
//  TCSettingCellModel.m
//  TCSetting
//
//  Created by 陈 胜 on 16/5/24.
//  Copyright © 2016年 陈胜. All rights reserved.
//

#import "TCSettingCellModel.h"
#import "TCSizeManager.h"

@implementation TCSettingCellModel

- (CGFloat)height {
    if (_height == 0.0f) {
        _height = CELL_HEIGHT(TCCellHeightStyle44);
    }
    return _height;
}

@end
