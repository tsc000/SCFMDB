//
//  ViewController.m
//  FMDB_Package
//
//  Created by tsc on 16/6/7.
//  Copyright © 2016年 tsc. All rights reserved.
//

#import "ViewController.h"
#import "SCFMDB.h"
#import "ListViewCell.h"
#import "DataModel.h"

#define cell @"cell"

@interface ViewController ()
<
    UITableViewDelegate,
    UITableViewDataSource
>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) SCFMDB *db;
@property (weak, nonatomic) IBOutlet UILabel *header;

@property (nonatomic, strong) NSMutableArray *data;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initial];
}

- (void)initial {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"ListViewCell" bundle:nil] forCellReuseIdentifier:cell];
}

- (IBAction)createDataBase:(UIButton *)sender {
    
    SCFMDB *db = [SCFMDB sharedInstance];
    self.db = db;
    BOOL rec = [db initFMDB:@"tsc.sqlite"];
    if (rec) {
        self.header.text = @"数据库创建成功";
    }
    else
        self.header.text = @"数据库创建失败";
}

- (IBAction)createTable:(UIButton *)sender {
    //创建表1
    
    NSArray *key = @[@"id",@"content",@"content_id",@"content_type",@"IDs",@"notes_type",@"time",@"user_id",@"isRead"];
    NSArray *type = @[@"integer PRIMARY KEY AUTOINCREMENT",@"text",@"text",@"text",@"text",@"text",@"text",@"text",@"integer"];
    NSDictionary *dict = @{key:type};
    
    BOOL rec = [self.db createTable:@"t123" Fields:dict];
    if (rec) {
        self.header.text = @"数据表创建成功";
    }
    else
        self.header.text = @"数据表创建失败";
}

- (IBAction)insertRecord:(UIButton *)sender {
    
    for (NSInteger i = 0 ; i < 10; i ++) {
        
        NSString *temp = [NSString stringWithFormat:@"content%ld",i];
        NSArray *values = @[temp,@"2",@"3",@"4",@"5",@"6",@"7",@"0"];
        BOOL rec = [self.db insertRecord:values toTable:@"t123"];
        if (rec) {
            self.header.text = @"10条记录插入成功";
        }
        else
            self.header.text = @"插入失败";
    }
    [self getData];
}

- (IBAction)updateRecord:(UIButton *)sender {

    NSDictionary *dict3 = @{@"content_id":@"38"};
    
    BOOL rec = [self.db updateFields:dict3 toTable:@"t123" condition:@"content = 'content4'"];
    if (rec) {
        self.header.text = @"更新成功";
    }
    else
        self.header.text = @"更新失败";
    [self getData];
}

- (IBAction)queryRecord:(UIButton *)sender {
    FMResultSet * set = [self.db queryRecord:@"content_id = 38" inTable:@"t123"];
    if ([set next]) {
        [self.data removeAllObjects];
        
        DataModel *data = [[DataModel alloc] init];
        data.idx = [set stringForColumn:@"id"];
        data.content = [set stringForColumn:@"content"];
        data.content_id = [set stringForColumn:@"content_id"];
        data.content_type = [set stringForColumn:@"content_type"];
        data.ID = [set stringForColumn:@"IDs"];
        data.notes_type = [set stringForColumn:@"notes_type"];
        data.time = [set stringForColumn:@"time"];
        data.user_id = [set stringForColumn:@"user_id"];
        [self.data addObject:data];

        
        while ([set next]) {
            DataModel *data = [[DataModel alloc] init];
            data.idx = [set stringForColumn:@"id"];
            data.content = [set stringForColumn:@"content"];
            data.content_id = [set stringForColumn:@"content_id"];
            data.content_type = [set stringForColumn:@"content_type"];
            data.ID = [set stringForColumn:@"IDs"];
            data.notes_type = [set stringForColumn:@"notes_type"];
            data.time = [set stringForColumn:@"time"];
            data.user_id = [set stringForColumn:@"user_id"];
            [self.data addObject:data];
        }
        [self.tableView reloadData];

        self.header.text = @"查询成功";
    }
    else
        self.header.text = @"查询失败";
}

- (IBAction)deleteRecord:(id)sender {
    BOOL rec = [self.db deleteRecord:@"content_id = 38" fromTable:@"t123"];
    if (rec) {
        self.header.text = @"删除成功";
    }
    else
        self.header.text = @"删除失败";
    [self getData];
}

#pragma mark --UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ListViewCell *c = [ListViewCell cellWithTableView:tableView];
    c.data = self.data[indexPath.row];
    return c;
}


- (void)getData {

    //从数据库中获取数据
    [self.data removeAllObjects];
    FMResultSet * set = [self.db queryRecord:@"1 = 1" inTable:@"t123"];
    while ([set next]) {
        DataModel *data = [[DataModel alloc] init];
        data.idx = [set stringForColumn:@"id"];
        data.content = [set stringForColumn:@"content"];
        data.content_id = [set stringForColumn:@"content_id"];
        data.content_type = [set stringForColumn:@"content_type"];
        data.ID = [set stringForColumn:@"IDs"];
        data.notes_type = [set stringForColumn:@"notes_type"];
        data.time = [set stringForColumn:@"time"];
        data.user_id = [set stringForColumn:@"user_id"];
        [self.data addObject:data];
    }
    [self.tableView reloadData];
}
#pragma mark -- lazy load

- (NSMutableArray *)data {
    if (!_data) {
        _data = [NSMutableArray array];
    }
    return _data;
}
@end
