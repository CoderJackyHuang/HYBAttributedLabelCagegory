# HYBAttributedLabelCagegory
An very useful category of UILabel, for we can easily set style strings with HTML-like.

##Introduce
We usually need to specify a special style in seperate part when using a UILabel to show some tips,
and will use NSMutableAttributedString to add special style with a range, but it's not so easy to finish
our goal. So, I try to write an useful-use API to do that.

This API is a category api of UILabel, with it, you can use HTML-LIKE label to specify some style defined.
Now, we only support `<style></style>` to specify different style for a UILable object.We just need to know
what properties of style.

######Properties

* `font=value` : Specify a normal font with a value, e.g. font=18.
* `boldfont=value`: Specify a bold font with a value, e.g. boldfont=18.
* `color=value`: Specify a foreground color with a value. The value can be red/blue/yellow... or #eee/#eeee/#eeeeee or 0x/0Xffffff, e.g. color=red, color=#fff, color=0xffffff.
* `backgroundcolor=value`: Specify a background color with a value. The value can be red/blue/yellow... or #eee/#eeee/#eeeeee or 0x/0Xffffff, e.g. backgroundcolor=red, backgroundcolor=#fff, backgroundcolor=0xffffff.
* `underline=value`: Specify underline style with a number between 0 and 9. For more information, please refer NSUnderlineStyle. The value should be in [0, 9]. e.g. underline=0, underline=1.

##How to use
```
pod "HYBAttributedLabelCagegory", '~> 0.0.1'
```

##screenshot
![image](https://github.com/632840804/HYBAttributedLabelCagegory/blob/master/screenshot.jpg)


##Enjoys
Hope every one enjoy it. If any bugs, please give me a feedback and send to my email: huangyibiao520@163.com. Thanks in advance!

##Author
Hello, my name is huangyibiao（黄仪标), and I have an English name JackyHuang, just call me Jacky.
Now I have my own blog http://www.hybblog.com/, If you use Weibo, make friends with me: JackyHuang（标哥）.

##More
For more information, please move to my blog and watch assosiated article. URL:http://www.hybblog.com/hybattributedlabelcategory/

##Follow Me
![image](https://github.com/CoderJackyHuang/IOSCallJsOrJsCallIOS/blob/master/wx.jpg)

##LICENSE
This software confirms MIT LICENSE, you can use it anywhere.
