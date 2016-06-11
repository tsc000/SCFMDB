//
//  ListViewCell.h
//  FMDB_Package
//
//  Created by Mac on 16/6/10.
//  Copyright © 2016年 tsc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataModel;
@interface ListViewCell : UITableViewCell

@property (nonatomic, strong) DataModel *data;

+ (instancetype)cellWithTableView:(UITableView*)tableView;

@end
