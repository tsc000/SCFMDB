//
//  ListViewCell.m
//  FMDB_Package
//
//  Created by Mac on 16/6/10.
//  Copyright © 2016年 tsc. All rights reserved.
//

#import "ListViewCell.h"
#import "DataModel.h"

@interface ListViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *idx;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *conten_id;
@property (weak, nonatomic) IBOutlet UILabel *content_type;
@property (weak, nonatomic) IBOutlet UILabel *IDs;
@property (weak, nonatomic) IBOutlet UILabel *note_type;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *user_id;

@end

@implementation ListViewCell

+ (instancetype)cellWithTableView:(UITableView*)tableView {
    ListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    return cell;
}

- (void)setData:(DataModel *)data {
    _data = data;
    self.idx.text = data.idx;
    self.content.text = data.content;
    self.conten_id.text = data.content_id;
    self.content_type.text = data.content_type;
    self.IDs.text = data.ID;
    self.note_type.text = data.notes_type;
    self.time.text = data.time;
    self.user_id.text = data.user_id;
}
@end
