//
//  UILabel+HYBAttributedCategory.m
//  Demo
//
//  Created by huangyibiao on 15/9/16.
//  Copyright © 2015年 huangyibiao. All rights reserved.
//

#import "UILabel+HYBAttributedCategory.h"

typedef NS_ENUM(NSInteger, HYBStyleType) {
  HYBStyleTypeNone = 0,
  HYBStyleTypeFont = 1,
  HYBStyleTypeColor = 2,
  HYBStyleTypeBoldFont = 3,
  HYBStyleTypeUnderline = 4,
  HYBStyleTypeBackgroundColor = 5
};

@implementation UILabel (HYBAttributedCategory)

/*
 underline=[0,9](与枚举类型对应)
 欢迎使用<style font=18 color=red underline=1 backgroundcolor=#eeeeee>这是很多种样式了</style>
 ,<style color=#ffffff underline=1 boldfont=18></style>
 */
- (BOOL)hyb_setAttributedText:(NSString *)text {
  if (text == nil || text.length == 0) {
    return NO;
  }
  
  NSMutableString *originString = [[NSMutableString alloc] init];
  NSArray *styles = [text componentsSeparatedByString:@"</style>"];
  if (styles.count == 0) {
    return NO;
  }
  
  NSMutableArray *resultArray = [[NSMutableArray alloc] init];
  for (NSString *line in styles) {
    if (line == nil || line.length == 0) {
      continue;
    }
    
    NSRange range = [line rangeOfString:@"<style" options:NSCaseInsensitiveSearch];
    BOOL hasProperty = [line rangeOfString:@"<style>" options:NSCaseInsensitiveSearch].location == NSNotFound;
    if (range.location != NSNotFound && hasProperty) {
      NSString *tmpString = [line substringToIndex:range.location];
      [originString appendString:tmpString];
      
      // 不需要添加样式
      [resultArray addObject:@[tmpString]];
      NSLog(@"%@", tmpString);
      
      NSString *restLine = [line substringFromIndex:range.location + range.length];
      NSLog(@"restLine: %@", restLine);
      // 获取<style的结束标签>，寻找到第一个与之匹配的就是正确的
      range = [restLine rangeOfString:@">"];
      if (range.location != NSNotFound && range.length + range.length < restLine.length) {
        tmpString = [restLine substringFromIndex:range.location + 1];
        NSLog(@"tmpString: %@", tmpString);
        
        // 解析样式
        restLine = [restLine substringWithRange:NSMakeRange(0, restLine.length - 1 - tmpString.length)];
        NSLog(@"restLine = %@", restLine);
        // 过滤多余的空格
        NSMutableString *styleString = [[NSMutableString alloc] init];
        BOOL isSpace = NO;
        for (NSUInteger i = 0; i < restLine.length; ++i) {
          if ([restLine characterAtIndex:i] != ' ') {
            if (isSpace && [restLine characterAtIndex:i] != '=' && styleString.length != 0) { // 前一个是空格，则需要先添加一个空格
              if (i >= 1) {
                // 如果前面有=号，则不添加空格
                if ([styleString characterAtIndex:styleString.length - 1] == '=') {
                  [styleString appendString:[NSString stringWithFormat:@"%c", [restLine characterAtIndex:i]]];
                  isSpace = NO;
                  continue;
                }
              }
              
              [styleString appendString:[NSString stringWithFormat:@" %c", [restLine characterAtIndex:i]]];
            } else {
              [styleString appendString:[NSString stringWithFormat:@"%c", [restLine characterAtIndex:i]]];
            }
            
            isSpace = NO;
          } else {
            isSpace = YES;
            continue;
          }
        }
        
        NSArray *tmpArray = [styleString componentsSeparatedByString:@" "];
        NSMutableDictionary *styleDict = [[NSMutableDictionary alloc] init];
        for (NSString *property in tmpArray) {
          NSArray *propertyArray = [property componentsSeparatedByString:@"="];
          if (propertyArray.count >= 2) {
            NSString *propertyName = propertyArray[0];
            NSString *propertyValue = propertyArray[1];
            if (propertyName == nil || propertyName.length == 0 || propertyValue == nil || propertyValue.length == 0) {
              NSLog(@"property is empty");
              continue;
            }
            switch ([self private_hyb_judgePropertyTypeWithName:propertyName]) {
              case HYBStyleTypeFont:
                if ([propertyValue respondsToSelector:@selector(floatValue)]) {
                  [styleDict setObject:[UIFont systemFontOfSize:propertyValue.floatValue]
                                forKey:NSFontAttributeName];
                }
                break;
              case HYBStyleTypeBoldFont:
                if ([propertyValue respondsToSelector:@selector(floatValue)]) {
                  [styleDict setObject:[UIFont boldSystemFontOfSize:propertyValue.floatValue]
                                forKey:NSFontAttributeName];
                }
                break;
              case HYBStyleTypeColor: {
                UIColor *color = [self private_hyb_parseColorWithString:propertyValue];
                if (color != nil) {
                  [styleDict setObject:color forKey:NSForegroundColorAttributeName];
                }
              }
                break;
              case HYBStyleTypeBackgroundColor: {
                UIColor *color = [self private_hyb_parseColorWithString:propertyValue];
                if (color != nil) {
                  [styleDict setObject:color forKey:NSBackgroundColorAttributeName];
                }
                break;
              }
              case HYBStyleTypeUnderline: {
                if ([propertyValue respondsToSelector:@selector(intValue)]) {
                  // 与系统的枚举对应，超过的值过滤掉
                  if (propertyValue.intValue >= 0 && propertyValue.intValue <= 9) {
                    [styleDict setObject:@(propertyValue.intValue) forKey:NSUnderlineStyleAttributeName];
                  }
                }
              }
              default:
                break;
            }
          } else {
            NSLog(@"属性写法不正确：%@，将会被过滤掉", property);
          }
        }
        
        if (styleDict.count >= 1) {
          [resultArray addObject:@[tmpString, styleDict]];
        } else {
          [resultArray addObject:@[tmpString]];
        }
        [originString appendString:tmpString];
      } else {
        NSLog(@"style开始标签没有对应的>符号");
        // 不合规则的不处理样式
        [resultArray addObject:@[restLine]];
        [originString appendString:tmpString];
      }
    } else {
      NSString *originLine = [NSString stringWithFormat:@"%@</style>", line];
      [originString appendString:originLine];
      // 不需要添加样式
      [resultArray addObject:@[originLine]];
    }
  }
  
  
  // 拼接成完整的字符串
  NSLog(@"originString: %@", originString);
  NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:originString];
  NSUInteger location = 0;
  for (NSArray *item in resultArray) {
    NSString *itemString = item[0];
    if (item.count == 2) { // 有样式
      [attr setAttributes:item[1] range:NSMakeRange(location, itemString.length)];
    }
    location += itemString.length;
  }
  self.attributedText = attr;
  
  return YES;
}

- (HYBStyleType)private_hyb_judgePropertyTypeWithName:(NSString *)name {
  if (name == nil || ![name isKindOfClass:[NSString class]] || name.length == 0) {
    return HYBStyleTypeNone;
  }

  // 不区分大小写
  if ([name compare:@"font" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
    return HYBStyleTypeFont;
  } else if ([name compare:@"color" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
    return HYBStyleTypeColor;
  } else if ([name compare:@"backgroundcolor" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
    return HYBStyleTypeBackgroundColor;
  } else if ([name compare:@"boldfont" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
    return HYBStyleTypeBoldFont;
  } else if ([name compare:@"underline" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
    return HYBStyleTypeUnderline;
  }
  
  return HYBStyleTypeNone;
}

- (UIColor *)private_hyb_parseColorWithString:(NSString *)colorString {
  if (colorString == nil || ![colorString isKindOfClass:[NSString class]] || colorString.length == 0) {
    return nil;
  }
  
  if ([colorString hasPrefix:@"0x"] || [colorString hasPrefix:@"0X"]) {
    if (colorString.length > 2) {
      colorString = [colorString substringFromIndex:2];
      
      return [self private_hyb_parseHexColor:colorString];
    }
  } else if ([colorString hasPrefix:@"#"]) {
      return [self private_hyb_parseHexColor:colorString];
  }
  
  if ([colorString compare:@"blackColor" options:NSCaseInsensitiveSearch] == NSOrderedSame
      || [colorString compare:@"black" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
    return [UIColor blackColor];
  } else if ([colorString compare:@"darkGrayColor" options:NSCaseInsensitiveSearch] == NSOrderedSame
             || [colorString compare:@"darkGray" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
    return [UIColor darkGrayColor];
  } else if ([colorString compare:@"lightGrayColor" options:NSCaseInsensitiveSearch] == NSOrderedSame
             || [colorString compare:@"lightGray" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
    return [UIColor lightGrayColor];
  } else if ([colorString compare:@"whiteColor" options:NSCaseInsensitiveSearch] == NSOrderedSame
             || [colorString compare:@"white" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
    return [UIColor whiteColor];
  } else if ([colorString compare:@"grayColor" options:NSCaseInsensitiveSearch] == NSOrderedSame
             || [colorString compare:@"gray" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
    return [UIColor grayColor];
  } else if ([colorString compare:@"redColor" options:NSCaseInsensitiveSearch] == NSOrderedSame
             || [colorString compare:@"red" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
    return [UIColor redColor];
  } else if ([colorString compare:@"greenColor" options:NSCaseInsensitiveSearch] == NSOrderedSame
             || [colorString compare:@"green" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
    return [UIColor greenColor];
  } else if ([colorString compare:@"blueColor" options:NSCaseInsensitiveSearch] == NSOrderedSame
             || [colorString compare:@"blue" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
    return [UIColor blueColor];
  } else if ([colorString compare:@"cyanColor" options:NSCaseInsensitiveSearch] == NSOrderedSame
             || [colorString compare:@"cyan" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
    return [UIColor cyanColor];
  } else if ([colorString compare:@"yellowColor" options:NSCaseInsensitiveSearch] == NSOrderedSame
             || [colorString compare:@"yellow" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
    return [UIColor yellowColor];
  } else if ([colorString compare:@"magentaColor" options:NSCaseInsensitiveSearch] == NSOrderedSame
             || [colorString compare:@"magenta" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
    return [UIColor magentaColor];
  } else if ([colorString compare:@"orangeColor" options:NSCaseInsensitiveSearch] == NSOrderedSame
             || [colorString compare:@"orange" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
    return [UIColor orangeColor];
  } else if ([colorString compare:@"purpleColor" options:NSCaseInsensitiveSearch] == NSOrderedSame
             || [colorString compare:@"purple" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
    return [UIColor purpleColor];
  } else if ([colorString compare:@"brownColor" options:NSCaseInsensitiveSearch] == NSOrderedSame
             || [colorString compare:@"brown" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
    return [UIColor brownColor];
  } else if ([colorString compare:@"clearColor" options:NSCaseInsensitiveSearch] == NSOrderedSame
             || [colorString compare:@"clear" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
    return [UIColor clearColor];
  }

  return nil;
}

- (UIColor *)private_hyb_parseHexColor:(NSString *)hexColorString {
  if ([hexColorString hasPrefix:@"#"]) {
    return [self private_hyb_colorWithHexString:hexColorString];
  }
  
  return [self private_hyb_colorWithHexString:[NSString stringWithFormat:@"#%@", hexColorString]];
}

- (UIColor *)private_hyb_colorWithHexString:(NSString *)hexString {
  NSString *colorString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
  CGFloat alpha, red, blue, green;
  switch([colorString length]) {
    case 3: // #RGB
      alpha = 1.0f;
      red = [self private_hyb_colorComponentFrom:colorString start:0 length:1];
      green = [self private_hyb_colorComponentFrom:colorString start:1 length:1];
      blue = [self private_hyb_colorComponentFrom:colorString start:2 length:1];
      break;
    case 4: // #ARGB
      alpha = [self private_hyb_colorComponentFrom:colorString start:0 length:1];
      red = [self private_hyb_colorComponentFrom:colorString start:1 length:1];
      green = [self private_hyb_colorComponentFrom:colorString start:2 length:1];
      blue = [self private_hyb_colorComponentFrom:colorString start:3 length:1];
      break;
    case 6: // #RRGGBB
      alpha = 1.0f;
      red = [self private_hyb_colorComponentFrom:colorString start:0 length:2];
      green = [self private_hyb_colorComponentFrom:colorString start:2 length:2];
      blue = [self private_hyb_colorComponentFrom:colorString start:4 length:2];
      break;
    case 8: // #AARRGGBB
      alpha = [self private_hyb_colorComponentFrom:colorString start:0 length:2];
      red = [self private_hyb_colorComponentFrom:colorString start:2 length:2];
      green = [self private_hyb_colorComponentFrom:colorString start:4 length:2];
      blue = [self private_hyb_colorComponentFrom:colorString start:6 length:2];
      break;
    default:
      [NSException raise:@"Invalid color value" format:@"Color value %@ is invalid.  It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", hexString];
      break;
  }
  
  return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (CGFloat)private_hyb_colorComponentFrom:(NSString *)string
                         start:(NSUInteger)start
                        length:(NSUInteger)length {
  NSString *substring = [string substringWithRange:NSMakeRange(start, length)];
  NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat:@"%@%@",
                                                 substring, substring];
  unsigned hexComponent;
  [[NSScanner scannerWithString:fullHex] scanHexInt:&hexComponent];
  
  return hexComponent / 255.0;
}


@end
