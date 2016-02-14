//
//  ViewController.m
//  datapicker
//
//  Created by 大麦 on 15/8/26.
//  Copyright (c) 2015年 lsp. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, retain) NSMutableArray *yearArr;
@property (nonatomic, retain) NSMutableArray *monthArr;
@property (nonatomic, retain) NSMutableArray *dayArr;
@property (nonatomic, retain) NSMutableArray *hourArr;
@property (nonatomic, retain) NSMutableArray *minArr;

@property (nonatomic, retain) NSString *yearString;
@property (nonatomic, retain) NSString *monthString;
@property (nonatomic, retain) NSString *dayString;
@property (nonatomic, retain) NSString *hourString;
@property (nonatomic, retain) NSString *minString;



@property (nonatomic, retain) UIPickerView *pickV;

@end


@implementation ViewController

@synthesize yearString,monthString,dayString,hourString,minString;
@synthesize pickV;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createPicker];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createPicker
{
    //获取当前时间
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd-HH-mm"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
//    NSLog(@"%@",destDateString);
    //
    yearString = [[destDateString componentsSeparatedByString:@"-"] objectAtIndex:0];
    monthString = [[destDateString componentsSeparatedByString:@"-"] objectAtIndex:1];
    dayString = [[destDateString componentsSeparatedByString:@"-"] objectAtIndex:2];
    hourString = [[destDateString componentsSeparatedByString:@"-"] objectAtIndex:3];
    minString = [[destDateString componentsSeparatedByString:@"-"] objectAtIndex:4];
    //
    pickV = [[UIPickerView alloc]init];
//    pickV.backgroundColor = [UIColor blackColor];
    [pickV setFrame:CGRectMake(0, 130, 320, 162)];
    pickV.delegate = self;
    pickV.dataSource = self;
//    pickV.showsSelectionIndicator = YES;
    //
     self.yearArr = [NSMutableArray array];
    self.monthArr = [NSMutableArray array];
    self.hourArr = [NSMutableArray array];
    self.dayArr = [NSMutableArray array];
    self.hourArr = [NSMutableArray array];
    self.minArr = [NSMutableArray array];
   
    int yearINT = [yearString intValue];
    for(int i=0;i<=10;i++)
    {
        [self.yearArr addObject:[NSString stringWithFormat:@"%d",yearINT+i]];
    }
    for(int i=1;i<=12;i++)
    {
        [self.monthArr addObject:[NSString stringWithFormat:@"%.2d",i]];
    }
    NSInteger maxDay = [self DaysfromYear:[yearString integerValue] andMonth:[monthString integerValue]];
    for(int i=1;i<=maxDay;i++)
    {
        [self.dayArr addObject:[NSString stringWithFormat:@"%.2d",i]];
    }
    for(int i=0;i<24;i++)
    {
        [self.hourArr addObject:[NSString stringWithFormat:@"%.2d",i]];
    }
    for(int i=0;i<60;i++)
    {
        [self.minArr addObject:[NSString stringWithFormat:@"%.2d",i]];
    }
    [self.view addSubview:pickV];
//    调整为想要的时间
    NSArray *indexArray = [self getNowDate:date];
    for (int i=0; i<indexArray.count; i++) {
        [pickV selectRow:[indexArray[i] integerValue] inComponent:i animated:NO];
    }
    //计算年月日时分的位置.
    //    70,50,20
    NSString *yearPointx = [NSString stringWithFormat:@"%f",pickV.frame.size.width*80/320];
    NSString *monthPointx = [NSString stringWithFormat:@"%f",pickV.frame.size.width*135/320];
    NSString *dayPointx = [NSString stringWithFormat:@"%f",pickV.frame.size.width*190/320];
    NSString *hourPointx = [NSString stringWithFormat:@"%f",pickV.frame.size.width*245/320];
    NSString *minPointx = [NSString stringWithFormat:@"%f",pickV.frame.size.width*300/320];
//    [self creatValuePointXs:@[@"80",@"135",@"190",@"245",@"300"]
//                  withNames:@[@"年",@"月",@"日",@"时",@"分"]];
    [self creatValuePointXs:@[yearPointx,monthPointx,dayPointx,hourPointx,minPointx]
                  withNames:@[@"年",@"月",@"日",@"时",@"分"]];
}
- (void)creatValuePointXs:(NSArray *)xArr withNames:(NSArray *)names
{
    for (int i=0; i<xArr.count; i++) {
        [self addLabelWithNames:names[i] withPointX:[xArr[i] intValue]];
    }
}
- (void)addLabelWithNames:(NSString *)name withPointX:(NSInteger)point_x
{
//    NSLog(@"Y=%f  %f  %f  %f",pickV.frame.origin.x,pickV.frame.origin.y,pickV.frame.size.width,pickV.frame.size.height);
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(point_x, pickV.frame.size.height/2.0-8, 20, 16)];
    label.text = name;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor blackColor];
    label.layer.shadowColor = [[UIColor whiteColor] CGColor];
    label.layer.shadowOpacity = 0.5;
    label.layer.shadowRadius = 5;
    label.backgroundColor = [UIColor clearColor];
    [pickV addSubview:label];
}
// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 5;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return [self.yearArr count];
    }
    else if(component == 1){
        return [self.monthArr count];
    }else if(component == 2){
        return [self.dayArr count];
    }else if(component == 3){
        return [self.hourArr count];
    }else if(component == 4){
        return [self.minArr count];
    }else{
        return 0;
    }

}
// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if(component == 0){
        return 70*pickV.frame.size.width/320;
    }else{
        return 50*pickV.frame.size.width/320;
    }
}
// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(component == 0){
        yearString = [self.yearArr objectAtIndex:row];
        //改变天数
        [self.dayArr removeAllObjects];
        NSInteger maxDay = [self DaysfromYear:[yearString integerValue] andMonth:[monthString integerValue]];
        for(int i=1;i<=maxDay;i++)
        {
            [self.dayArr addObject:[NSString stringWithFormat:@"%.2d",i]];
        }
        [pickV reloadComponent:2];
    }else if(component == 1){
        monthString = [self.monthArr objectAtIndex:row];
        //改变天数
        [self.dayArr removeAllObjects];
        NSInteger maxDay = [self DaysfromYear:[yearString integerValue] andMonth:[monthString integerValue]];
        for(int i=1;i<=maxDay;i++)
        {
            [self.dayArr addObject:[NSString stringWithFormat:@"%.2d",i]];
        }
        [pickV reloadComponent:2];
        
    }else if(component == 2){
        dayString = [self.dayArr objectAtIndex:row];
    }else if(component == 3){
        hourString = [self.hourArr objectAtIndex:row];
    }else if(component == 4){
        minString = [self.minArr objectAtIndex:row];
    }
    NSLog(@"选择的时间:%@年%@月%@日%@时%@分",yearString,monthString,dayString,hourString,minString);
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    
    UILabel *customLabel = (UILabel *)view;
    if (!customLabel) {
        customLabel = [[UILabel alloc] init];
        customLabel.textAlignment = NSTextAlignmentCenter;
        [customLabel setFont:[UIFont systemFontOfSize:18]];
    }
    UIColor *textColor = [UIColor blackColor];
    NSString *title;

    textColor = [UIColor orangeColor];
    
    if (component==0) {
        title = self.yearArr[row];
    }
    if (component==1) {
        title = self.monthArr[row];
    }
    if (component==2) {
        title = self.dayArr[row];
    }
    if (component==3) {
        title = self.hourArr[row];
    }
    if (component==4) {
        title = self.minArr[row];
    }
    customLabel.text = title;
    customLabel.textColor = textColor;
    return customLabel;
}
//获取当前时间解析及位置
- (NSArray *)getNowDate:(NSDate *)date
{
    NSDate *dateShow;
    if (date) {
        dateShow = date;
    }else{
        dateShow = [NSDate date];
    }
    
    //获取当前时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd-HH-mm"];
    NSString *destDateString = [dateFormatter stringFromDate:dateShow];
    //
    yearString = [[destDateString componentsSeparatedByString:@"-"] objectAtIndex:0];
    monthString = [[destDateString componentsSeparatedByString:@"-"] objectAtIndex:1];
    dayString = [[destDateString componentsSeparatedByString:@"-"] objectAtIndex:2];
    hourString = [[destDateString componentsSeparatedByString:@"-"] objectAtIndex:3];
    minString = [[destDateString componentsSeparatedByString:@"-"] objectAtIndex:4];
    //
    yearIndex =  [yearString integerValue];
    monthIndex = [monthString integerValue]- 1;
    dayIndex = [dayString integerValue]- 1;
    hourIndex = [hourString integerValue]- 0;
    minuteIndex = [minString integerValue]- 0;
    //
    NSNumber *year   = [NSNumber numberWithInteger:yearIndex];
    NSNumber *month  = [NSNumber numberWithInteger:monthIndex];
    NSNumber *day    = [NSNumber numberWithInteger:dayIndex];
    NSNumber *hour   = [NSNumber numberWithInteger:hourIndex];
    NSNumber *minute = [NSNumber numberWithInteger:minuteIndex];
    
    return @[year,month,day,hour,minute];

}
//通过年月求每月天数
- (NSInteger)DaysfromYear:(NSInteger)year andMonth:(NSInteger)month
{
    NSInteger num_year  = year;
    NSInteger num_month = month;
    
    BOOL isrunNian = num_year%4==0 ? (num_year%100==0? (num_year%400==0?YES:NO):YES):NO;
    switch (num_month) {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:{
            return 31;
        }
            break;
        case 4:
        case 6:
        case 9:
        case 11:{
            return 30;
        }
            break;
        case 2:{
            if (isrunNian) {
                return 29;
            }else{
                return 28;
            }
        }
            break;
        default:
            break;
    }
    return 0;
}

@end
