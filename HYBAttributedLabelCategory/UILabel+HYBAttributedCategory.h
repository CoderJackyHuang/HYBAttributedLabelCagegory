//
//  UILabel+HYBAttributedCategory.h
//  Demo
//
//  Created by huangyibiao on 15/9/16.
//  Copyright © 2015年 huangyibiao. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 快速设置UILabel的attributedText属性的API，参数中只能使用指定的规则，才可以生效。
 * 使用规则：必须是<style font=18 color=red backgroundcolor=#eee underline=1>中间是描述</style>
 * 目前支持的属性有：font（普通字体）、boldfont（粗体）、color（前景色）、backgroundcolor（背景色）、
 *                underline（下划线，使用【0，9】数字，分别对应NSUnderlineStyle枚举类型的成员的值）
 * 1、对于字体font和boldfont的值只能是数值；
 * 2、color和backgroundcolor的值可以是任何十六进制值，支持0x|0X|#开头，
 *    也支持系统自带的生成颜色的类方法API函数名，如color=red或者color=redcolor
 * 3、underline的值只能是NSUnderlineStyle枚举成员的值，取0到9。
 *
 * @author huangyibiao
 * @email  huangyibiao520@163.com
 * @blog   http://www.hybblog.com
 * @github https://github.com/632840804
 *
 * @see NSUnderlineStyle
 * @note <style></style>只能是全小写，对于属性名和属性值不区分大小写
 */
@interface UILabel (HYBAttributedCategory)

/**
 * 快速设置UILabel的attributedText属性的API，参数中只能使用指定的规则，才可以生效。
 * 使用规则：必须是<style font=18 color=red backgroundcolor=#eee underline=1>中间是描述</style>
 * 目前支持的属性有：font（普通字体）、boldfont（粗体）、color（前景色）、backgroundcolor（背景色）、
 *                underline（下划线，使用【0，9】数字，分别对应NSUnderlineStyle枚举类型的成员的值）
 * 1、对于字体font和boldfont的值只能是数值；
 * 2、color和backgroundcolor的值可以是任何十六进制值，支持0x|0X|#开头，
 *    也支持系统自带的生成颜色的类方法API函数名，如color=red或者color=redcolor
 * 3、underline的值只能是NSUnderlineStyle枚举成员的值，取0到9。
 *
 * @param text 待设置样式的文本内容
 *
 * @author huangyibiao
 * @see NSUnderlineStyle
 * @note <style></style>只能是全小写，对于属性名和属性值不区分大小写
 *
 * @return YES表示成功设置，NO表示写法有误，且无法过滤，因此无效果。
 */
- (BOOL)hyb_setAttributedText:(NSString *)text;

@end
