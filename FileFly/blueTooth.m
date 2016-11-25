//
//  blueTooth.m
//  FileFly
//
//  Created by jx on 16/5/10.
//  Copyright © 2016年 jx. All rights reserved.
//

#import "blueTooth.h"
#import "BabyBluetooth.h"
#import "SVProgressHUD.h"
@interface blueTooth ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *peripherals;
    BabyBluetooth *baby;
}
@property(strong,nonatomic)NSArray *cellTitle;
@property(strong,nonatomic)NSArray *cellDetail;
@property(strong,nonatomic)NSMutableArray *cellindex;
@property (strong, nonatomic) IBOutlet UILabel *labelDetail;
@property (nonatomic)NSInteger *state;

@end

@implementation blueTooth

- (void)viewDidLoad {
    [super viewDidLoad];
    //cell标题
    self.cellTitle = [NSArray arrayWithObjects:@"扫描到的设备", nil];
    //cell状态描述
    
    //初始化BabyBluetooth蓝牙库
    baby = [BabyBluetooth shareBabyBluetooth];
    [self babyDelegate];
    //设置委托后可以直接使用无需等待CBCentralManagerStatePoweredOn状态
    baby.scanForPeripherals().begin();
    
}
//-(void)viewDidAppear:(BOOL)animated
//{
//    if (self.state ==CBCentralManagerStatePoweredOn) {
//        self.labelDetail.text = @"已连接";
//    }
//    else
//    {
//        self.labelDetail.text = @"未连接(前往设置开启蓝牙)";
//    }
//    
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 蓝牙代理方法
//蓝牙网关的初始化和委托方法设置
-(void)babyDelegate{
    [baby setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {

//            self.state = CBCentralManagerStatePoweredOn;
                if (central.state ==CBCentralManagerStatePoweredOn) {
                    [SVProgressHUD showInfoWithStatus:@"设备打开成功，开始扫描设备"];
                    self.labelDetail.text = @"已连接";
                }
                else
                {
                    self.labelDetail.text = @"未连接(前往设置开启蓝牙)";
                    [self.table reloadData];
                }
        
        
    }];
    //扫描到设备的委托
    [baby setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        NSLog(@"搜索到设备：%@",peripheral.name);
        if (peripheral.name !=nil) {
            if ([_cellindex containsObject:peripheral.name]==NO) {
                 [_cellindex addObject:peripheral.name];
            }
            }
        [self.table reloadData];
    }];
    //过滤器
    //设置查找设备的过滤器
    [baby setFilterOnDiscoverPeripherals:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
        if (peripheralName.length >1) {
            return YES;
        }
        return NO;
    }];    //连接到设备的委托
//    [baby setBlockOnConnected:^(CBCentralManager *central, CBPeripheral *peripheral) {
//        NSLog(@"设备：%@--连接成功",peripheral.name);
//    }];
    //发现设备服务的委托
    [baby setBlockOnDiscoverServices:^(CBPeripheral *peripheral, NSError *error) {
        for (CBService *service in peripheral.services) {
            NSLog(@"搜索到服务:%@",service.UUID.UUIDString);
        }
    }];
 
    //发现设备服务的特征
    [baby setBlockOnReadValueForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
        NSLog(@"服务的名称:%@ value is:%@",characteristics.UUID,characteristics.value);
    }];
    //设置读取characteristics的委托
    [baby setBlockOnReadValueForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
        NSLog(@"特征名称:%@ value is:%@",characteristics.UUID,characteristics.value);
    }];
    //示例:
    //扫描选项->CBCentralManagerScanOptionAllowDuplicatesKey:忽略同一个Peripheral端的多个发现事件被聚合成一个发现事件
    NSDictionary *scanForPeripheralsWithOptions = @{CBCentralManagerScanOptionAllowDuplicatesKey:@YES};
    //连接设备->
    [baby setBabyOptionsWithScanForPeripheralsWithOptions:scanForPeripheralsWithOptions connectPeripheralWithOptions:nil scanForPeripheralsWithServices:nil discoverWithServices:nil discoverWithCharacteristics:nil];

}

#pragma mark -tableviewdele
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.cellTitle objectAtIndex:section];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//几行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cellindex.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellString = @"cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellString];
    if (cell ==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellString];
    }
    UILabel *phoneName = (UILabel *)[cell viewWithTag:1000];
    phoneName.text = [self.cellindex objectAtIndex:indexPath.row];
    UILabel *phoneDetail = (UILabel *)[cell viewWithTag:2000];
    phoneDetail.text = @"未连接";
    UIImageView *img = (UIImageView *)[cell viewWithTag:3000];
    img.image = [UIImage imageNamed:@"forward"];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//        [baby setBlockOnConnected:^(CBCentralManager *central, CBPeripheral *peripheral) {
//            NSLog(@"设备：%@--连接成功",peripheral.name);
//        }];
    //停止扫描
    [baby cancelScan];
    

    
}
#pragma mark - 懒加载
-(NSMutableArray *)cellindex
{
    if (_cellindex ==nil) {
        _cellindex = [[NSMutableArray alloc]init];
    }
    return _cellindex;
}

@end
