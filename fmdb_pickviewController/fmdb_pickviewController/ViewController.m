//
//  ViewController.m
//  fmdb_pickviewController
//
//  Created by lcy on 16/4/6.
//  Copyright © 2016年 ZG. All rights reserved.
//

#import "ViewController.h"
#import "DataManager.h"
#import "ResidenceModel.h"

@interface ViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIPickerView *pickView;

@property (nonatomic,strong) NSMutableArray * addressArray;

@property (nonatomic,copy)NSString * addressString;

@property (nonatomic,strong)DataManager * manager;
@end

@implementation ViewController

/*
 懒加载
 1.不必将创建的代码全部写在- (void)viewDidLoad方法中,增加了代码的可读性;
 2.每个属性的getter方法中分别负责各自的实例化处理,代码彼此之间的独立性强,耦合性低;
 3.只有到真正需要资源的时候才回去加载,节省了内存空间;
 4.当收到内存警告是,需要didReceviewMemoryWarning方法中清理缓存,如果是懒加载的话,如果以后有的地方用到了该属性,还会再次顺利的加载出来;
 */


- (void)viewDidLoad {
    [super viewDidLoad];
    _manager = [[DataManager alloc] init];
    _pickView.dataSource= self;
    _pickView.delegate = self;
    
    NSString* file = [[NSBundle mainBundle] pathForResource:@"ResidenceLabel" ofType:@"plist"];
    _addressArray = [[NSDictionary dictionaryWithContentsOfFile:file] objectForKey:@"ResidenceInJapan"];
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _addressArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    _addressString = _addressArray[row];
    return _addressArray[row];
}


- (IBAction)add:(id)sender {
    ResidenceModel * r = [[ResidenceModel alloc] init];
    r.residence = _addressString;
    [_manager addResidence:r];
}

- (IBAction)delete:(id)sender {
    ResidenceModel * r = [[ResidenceModel alloc] init];
    r.residence = _addressString;
    [_manager deleteResidence:r];
}

- (IBAction)update:(id)sender {
    ResidenceModel * r = [[ResidenceModel alloc] init];
    r.residence = _addressString;
    [_manager updateResidence:r :@"新的"];
}

- (IBAction)read:(id)sender {
    NSArray * array = [_manager residenceArray];
    NSLog(@"%@", array);
}

@end
