//
//  TCSettingViewController.m
//  TCSetting
//
//  Created by 陈 胜 on 16/5/24.
//  Copyright © 2016年 陈胜. All rights reserved.
//

#import "TCSettingViewController.h"
#import "TCSettingTableViewCell.h"

static const CGFloat ktcHeaderMarginBottom = 8.0f;
static const CGFloat ktcFooterMarginTop = 8.0f;
static const CGFloat ktcHeaderAndFooterFontSize = 14.0f;

@interface TCSettingViewController () <TCSettingTableViewCellDelegate>

@property (nonatomic, strong, readwrite) NSArray *settingDatasource;

@end

@implementation TCSettingViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.settingDatasource = [self loadSettingDatasource];
}

- (void)viewDidAppear:(BOOL)animated {
    self.tableView.showsVerticalScrollIndicator = NO;
    [super viewDidAppear:animated];
    self.tableView.showsVerticalScrollIndicator = YES;
}

#pragma mark - UITableViewsettingDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.settingDatasource) {
        return self.settingDatasource.count;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.settingDatasource) {
        NSArray *sectionsettingDatasource = self.settingDatasource[section];
        return sectionsettingDatasource.count;
    }
    return 0;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ktcReuseIdentifier];
    if (!cell) {
        cell = [[TCSettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                             reuseIdentifier:ktcReuseIdentifier];
        cell.delegate = self;
        cell.tableView = tableView;
    }
    cell.cellModel = self.settingDatasource[indexPath.section][indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCSettingCellModel *cellModel = self.settingDatasource[indexPath.section][indexPath.row];
    if (cellModel) {
        return cellModel.height;
    }
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TCSettingCellModel *cellModel = self.settingDatasource[indexPath.section][indexPath.row];
    if (cellModel.operation) {
        cellModel.operation();
    } else if (cellModel.clazz) {
        Class clazz = NSClassFromString(cellModel.clazz);
        UIViewController *controller = [[clazz alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    } else if (cellModel.accessoryType == TCCellAccessoryCheckmark) {
        TCSettingTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        BOOL checked = cell.accessoryType == UITableViewCellAccessoryNone; // 原来没有选中，现在要选中
        cell.accessoryType = checked ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        cellModel.checked = checked;
        if (cell.delegate && [cell.delegate respondsToSelector:@selector(tableViewCell:withCellModel:atIndexPath:)]) {
            [cell.delegate tableViewCell:cell withCellModel:cellModel atIndexPath:indexPath];
        }
        
        /**
         *  把同组其它cell都置为没选中
         */
        for (TCSettingTableViewCell *theCell in [tableView visibleCells]) {
            if ([tableView indexPathForCell:theCell].section == indexPath.section) { // 同组cell
                if (theCell != cell && theCell.accessoryType == UITableViewCellAccessoryCheckmark) {
                    theCell.accessoryType = UITableViewCellAccessoryNone;
                }
            }
        }
        
        /**
         *  把其它同组的cellModel checked都置为NO
         */
        for (TCSettingCellModel *tmpCellModel in self.settingDatasource[indexPath.section]) {
            if (tmpCellModel != cellModel) {
                tmpCellModel.checked = NO;
            }
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TCSettingCellModel *cellModel = [self.settingDatasource[section] firstObject];
    NSString *headerText = cellModel.headerText;
    if (headerText) {
        UILabel *headerLabel = [[UILabel alloc] init];
        headerLabel.textAlignment = cellModel.headerAlignment;
        headerLabel.text = headerText;
        headerLabel.numberOfLines = 0;
        headerLabel.font = [UIFont systemFontOfSize:ktcHeaderAndFooterFontSize];
        headerLabel.textColor = [UIColor grayColor];
        CGSize constraintSize = CGSizeMake(ktcScreenWidth - ktcSectionHeaderAndFooterMarginLeft  * 2, CGFLOAT_MAX);
        CGSize size = [self boundingSizeWithFont:[UIFont systemFontOfSize:ktcHeaderAndFooterFontSize]
                                       forString:headerText
                                  constraintSize:constraintSize];
        if (section == 0) {
            if (cellModel.footerAlignment == NSTextAlignmentCenter) {
                CGFloat x = (ktcScreenWidth - size.width) / 2;
                headerLabel.frame = CGRectMake(x, ktcFirstSectionHeaderHeight, size.width, size.height);
            } else {
                headerLabel.frame =
                CGRectMake(ktcSectionHeaderAndFooterMarginLeft, ktcFirstSectionHeaderHeight, size.width, size.height);
            }
        } else {
            if (cellModel.footerAlignment == NSTextAlignmentCenter) {
                CGFloat x = (ktcScreenWidth - size.width) / 2;
                headerLabel.frame = CGRectMake(x, ktcOtherSectionHeaderHeight, size.width, size.height);
            } else {
                headerLabel.frame =
                CGRectMake(ktcSectionHeaderAndFooterMarginLeft, ktcOtherSectionHeaderHeight, size.width, size.height);
            }
        }
        UIView *headerView = [[UIView alloc] init];
        [headerView addSubview:headerLabel];
        CGFloat headerViewHeight;
        if (section == 0) {
            headerViewHeight = size.height + ktcHeaderMarginBottom + ktcFirstSectionHeaderHeight;
        } else {
            headerViewHeight = size.height + ktcHeaderMarginBottom + ktcOtherSectionHeaderHeight;
        }
        headerView.frame = CGRectMake(0, 0, ktcScreenWidth, headerViewHeight);
        return headerView;
    }
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    TCSettingCellModel *cellModel = [self.settingDatasource[section] lastObject];
    NSString *footerText = cellModel.footerText;
    if (footerText) {
        UILabel *footerLabel = [[UILabel alloc] init];
        footerLabel.textAlignment = cellModel.footerAlignment;
        footerLabel.text = footerText;
        footerLabel.numberOfLines = 0;
        footerLabel.font = [UIFont systemFontOfSize:ktcHeaderAndFooterFontSize];
        footerLabel.textColor = [UIColor grayColor];
        CGSize constraintSize = CGSizeMake(ktcScreenWidth - ktcSectionHeaderAndFooterMarginLeft * 2, CGFLOAT_MAX);
        CGSize size = [self boundingSizeWithFont:[UIFont systemFontOfSize:ktcHeaderAndFooterFontSize]
                                       forString:footerText
                                  constraintSize:constraintSize];
        if (cellModel.footerAlignment == NSTextAlignmentCenter) {
            CGFloat x = (ktcScreenWidth - size.width) / 2;
            footerLabel.frame = CGRectMake(x, ktcFooterMarginTop, size.width, size.height);
        } else {
            footerLabel.frame = CGRectMake(ktcSectionHeaderAndFooterMarginLeft, ktcFooterMarginTop, size.width, size.height);
        }
        UIView *footerView = [[UIView alloc] init];
        [footerView addSubview:footerLabel];
        CGFloat footerViewHeight;
        if (section == 0) {
            footerViewHeight = size.height + ktcFooterMarginTop + ktcSectionFooterHeight;
        } else {
            footerViewHeight = size.height + ktcFooterMarginTop + ktcSectionFooterHeight;
        }
        footerView.frame = CGRectMake(0, 0, ktcScreenWidth, footerViewHeight);
        return footerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    TCSettingCellModel *cellModel = [self.settingDatasource[section] firstObject];
    if (cellModel &&  cellModel.headerText) {
        CGSize constraintSize = CGSizeMake(ktcScreenWidth - ktcSectionHeaderAndFooterMarginLeft * 2, CGFLOAT_MAX);
        CGSize size = [self boundingSizeWithFont:[UIFont systemFontOfSize:ktcHeaderAndFooterFontSize]
                                       forString: cellModel.headerText
                                  constraintSize:constraintSize];
        if (section == 0) {
            return size.height + ktcHeaderMarginBottom + ktcFirstSectionHeaderHeight;
        } else {
            return size.height + ktcHeaderMarginBottom + ktcOtherSectionHeaderHeight;
        }
    } else {
        return [super tableView:tableView heightForHeaderInSection:section];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    TCSettingCellModel *cellModel = [self.settingDatasource[section] lastObject];
    if (cellModel && cellModel.footerText) {
        CGSize constraintSize = CGSizeMake(ktcScreenWidth - ktcSectionHeaderAndFooterMarginLeft * 2, CGFLOAT_MAX);
        CGSize size = [self boundingSizeWithFont:[UIFont systemFontOfSize:ktcHeaderAndFooterFontSize]
                                       forString:cellModel.footerText
                                  constraintSize:constraintSize];
        return size.height + ktcFooterMarginTop + ktcSectionFooterHeight;
    }
    return [super tableView:tableView heightForFooterInSection:section];
}

/**
 *  子类继承该方法提供数据源
 *
 *  @return 数据源
 */
- (NSArray *)loadSettingDatasource {
    return nil;
}

/**
 *  刷新数据源
 */
- (void)reloadSettingDatasource {
    self.settingDatasource = [self loadSettingDatasource];
    if ([[NSThread currentThread] isMainThread]) {
        [self.tableView reloadData];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
           [self.tableView reloadData]; 
        });
    }
}

#pragma mark - Private Methods

- (CGSize)boundingSizeWithFont:(UIFont *)font
                     forString:(NSString *)string
                constraintSize:(CGSize)size {
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
    return [string boundingRectWithSize:size
                                options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                             attributes:attributes
                                context:nil].size;
}

@end
