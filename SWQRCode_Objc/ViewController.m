//
//  ViewController.m
//  SWQRCode_Objc
//
//  Created by zhuku on 2018/4/4.
//  Copyright © 2018年 selwyn. All rights reserved.
//

#import "ViewController.h"
#import "SWQRCode.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSArray *_titles;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _titles = @[@"扫一扫"];
    
    UITableView *tbv = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tbv.delegate = self;
    tbv.dataSource = self;
    [self.view addSubview:tbv];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cell_id = @"cell_id";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
    }
    cell.textLabel.text = _titles[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            SWQRCodeConfig *config = [[SWQRCodeConfig alloc]init];
            config.scannerType = SWScannerTypeBoth;
            
            SWQRCodeViewController *qrcodeVC = [[SWQRCodeViewController alloc]init];
            qrcodeVC.codeConfig = config;
            [self.navigationController pushViewController:qrcodeVC animated:YES];
        }
            break;
        default:
            break;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
