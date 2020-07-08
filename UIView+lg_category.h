//
//  UIView+lg_category.h
//  CreativeInteraction
//
//  Created by ios2 on 2020/7/8.
//  Copyright © 2020 cy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (MaxText)

@property (nonatomic,strong)UIColor *place_textColor;

@property(nonatomic,assign)NSInteger maxNumber; //最大数量

@property(nonatomic,assign)UIEdgeInsets lg_placeInsets; //使用上左下右进行处理

@property (nonatomic,strong)UIFont *place_font; //占位字体

@property (nonatomic,readonly)NSString *placeholder;

@property (nonatomic, copy) NSString *lg_place; //占位文字

/*
   如果 max 设置 成 小于0 的数字就不进行输入检查
*/

//设置占位文字并监听变化
-(void)lgPlace:(NSString *)place
	   maxWord:(NSInteger)max
 textDidChange:(nullable void(^)(NSString *text) )textDidchagne;

@end


#pragma mark - 处理文字监听问题
@interface UITextField (MaxText)
/*
 如果 max 设置 成 小于0 的数字就不进行输入检查
 */
//对文字进行监听
-(void)lgMaxWord:(NSInteger)max
   textDidChange:(nullable void(^)(NSString *text))textDidchagne;

@end



@interface UITextView (creat)

+(UITextView *)make:(void(^)(UITextView *make))make;         //创建方法

-(UITextView *(^)(UIColor * textColor))lg_text_color;       //文字颜色

-(UITextView *(^)(NSString *text))lg_txt;                   //文字内容

-(UITextView *(^)(UIFont *font))lg_font;                    //字体大小

-(UITextView *(^)(NSTextAlignment alignment))lg_align;      //对齐方式

-(UITextView *(^)(UIColor * color))lg_bg_color;             //背景颜色

-(UITextView *(^)(CGFloat r))lg_r_d;                        //圆角半径

-(UITextView *(^)(UIEdgeInsets textEdgeInsets))lg_insets;   //设置内边距

-(UITextView *(^)(UIView *superV))addTo;


@end


//创建
@interface UITextField (creat)

+(UITextField *)make:(void(^)(UITextField *make))make;
-(UITextField *(^)(UIColor * textColor))lg_text_color;
-(UITextField *(^)(NSString *text))lg_txt;
-(UITextField *(^)(UIFont *font))lg_font;
-(UITextField *(^)(NSTextAlignment alignment))lg_align;
-(UITextField *(^)(UIColor * color))lg_bg_color;
-(UITextField *(^)(CGFloat r))lg_r_d;
-(UITextField *(^)(UIView *superV))addTo;
@end



@interface UILabel (creat)
+(UILabel *)make:(void(^)(UILabel *make))make;
-(UILabel *(^)(UIColor * textColor))lg_text_color;
-(UILabel *(^)(NSString *text))lg_txt;
-(UILabel *(^)(UIFont *font))lg_font;
-(UILabel *(^)(NSTextAlignment alignment))lg_align;
-(UILabel *(^)(UIColor * color))lg_bg_color;
-(UILabel *(^)(CGFloat r))lg_r_d;
-(UILabel *(^)(UIView *superV))addTo;
@end


@interface UIButton(creat)

+(UIButton *)make:(void(^)(UIButton * make))make;
/** 设置标题(NSString *text,UIControlState state) */
-(UIButton *(^)(NSString *text,UIControlState state))lg_title;          //设置文字
/** 设置标题颜色 （UIColor *c,UIControlState state） */
-(UIButton *(^)(UIColor *c,UIControlState state))lg_title_color;        //设置字体颜色
/** 设置图片 (UIImage *img,UIControlState state) */
-(UIButton *(^)(UIImage *img,UIControlState state))lg_image;            //设置图片
/** 设置背景图片 (UIImage *img,UIControlState state) */
-(UIButton *(^)(UIImage *img,UIControlState state))lg_bg_image;         //设置背景图片
/** 设置字体 (UIFont *f) */
-(UIButton *(^)(UIFont *f))lg_font;
/** 添加点击方法 (id taget,SEL sel,UIControlEvents event) */
-(UIButton *(^)(id taget,SEL sel,UIControlEvents event))lg_sel;
/** (UIEdgeInsets e) */
-(UIButton *(^)(UIEdgeInsets e))lg_imgInsets;                           //图片 偏移
/** 设置标题的 偏移 (UIEdgeInsets e) */
-(UIButton *(^)(UIEdgeInsets e))lg_titleInsets;                         //标题的 偏移
/** 设置H 对齐方式 (UIControlContentHorizontalAlignment align) */
-(UIButton *(^)(UIControlContentHorizontalAlignment align))lg_h_align;   //横向对齐方式
/** 设置V 对齐方式   (UIControlContentVerticalAlignment align) */
-(UIButton *(^)(UIControlContentVerticalAlignment align))lg_v_align;     //纵向对齐方式
/**  设置圆角 (CGFloat r) */
-(UIButton *(^)(CGFloat r))lg_r_d;
-(UIButton *(^)(UIView *superV))addTo;
-(UIButton *(^)(UIColor *color))lg_bgColor;
@end

@interface UIImageView (creat)
+(UIImageView *)make:(void(UIImageView *make))make;
-(UIImageView *(^)(UIImage *image))lg_imge;
-(UIImageView *(^)(UIViewContentMode fillModel))lg_fillModel;
-(UIImageView *(^)(CGFloat r))lg_r_d;
-(UIImageView *(^)(UIColor *color))lg_bgColor;
-(UIImageView *(^)(UIView *superV))addTo;
@end



NS_ASSUME_NONNULL_END


