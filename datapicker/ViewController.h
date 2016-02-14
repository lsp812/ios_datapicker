//
//  ViewController.h
//  datapicker
//
//  Created by 大麦 on 15/8/26.
//  Copyright (c) 2015年 lsp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate>
{
    //记录位置
    NSInteger yearIndex;
    NSInteger monthIndex;
    NSInteger dayIndex;
    NSInteger hourIndex;
    NSInteger minuteIndex;
}


@end

