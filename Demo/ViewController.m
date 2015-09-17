//
//  ViewController.m
//  Demo
//
//  Created by huangyibiao on 15/9/16.
//  Copyright © 2015年 huangyibiao. All rights reserved.
//

#import "ViewController.h"
#import "UILabel+HYBAttributedCategory.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  
  CGFloat w = [UIScreen mainScreen].bounds.size.width;
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, w - 20, 300)];
  [label hyb_setAttributedText:@"欢迎收藏作者博客：<style color=blue underline=1>www.hybblog.com</style>使用规则：underline=[0,9](与系统枚举类型NSUnderlineStyle成员对应)<style font=18 color=red underline=1 backgroundcolor=0xeeeeee>属性名称和属性值不区分大小写且颜色的十六进制可以用0x或者0X或者#开头</style>,<style color=#333 underline=0 boldfont=18 bacKGroundColor=ClearColor>可以设置背景颜色，支持系统UIColor提供的方便的颜色，可以省略color这几个，如设置为红色，设置为color=red或者color=Red或者color=redcolor是一样的</style>"
   ];
  [self.view addSubview:label];
  label.numberOfLines = 0;
  
  
  UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 290, w - 20, 280)];
  label1.numberOfLines = 0;
  [self.view addSubview:label1];
  [label1 hyb_setAttributedText:@"作者：<style color=blue boldfont=19 underline=4>JackyHuang\n</style>必须严格使用<style>开头</style>结尾表示样式的开始与结束。设置样式只能通过style的属性的形式设置。\n<style boldfont=18 color=#ffffff backgroundcolor=red>属性之间必须至少有一个空格来隔开。</style>。\n<style color=blue underline=1>设置属性值时，如果设置颜色color=red，那么=两边不能有空格。</style>。\n</style>。\n<style color = red underline    =      1>设置属性值时，如果设置颜色color  =  red，一样是可以识别的。。</style>"];

}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
