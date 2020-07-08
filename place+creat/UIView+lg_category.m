
	//
//  UIView+lg_category.m
//  CreativeInteraction
//
//  Created by ios2 on 2020/7/8.
//  Copyright © 2020 cy. All rights reserved.
//

#import "UIView+lg_category.h"
#import <objc/runtime.h>

#define ExChange_Objc_methodAToB(originalSelector, swizzledSelector) { \
        Method originalMethod = class_getInstanceMethod(self, originalSelector); \
        Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector); \
        if (class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) { \
            class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod)); \
        } else { \
            method_exchangeImplementations(originalMethod, swizzledMethod); \
        } \
}

static const char lg_place_key = '\0';
static const char lg_placeLable_key = '\0';
static const char lg_placeInsets_key = '\0';
static const char lg_maxNumber_key = '\0';
static const char lg_textDidChange_key = '\0';
static const char lg_placeLable_font_key = '\0';

@interface UITextView ()
@property (nonatomic, strong) UILabel *lg_placeLable; //占位标签 放到外侧 可以进行处理
@property (nonatomic, copy) void (^ lg_textDidChange)(NSString *currentText); //变化


@end

@implementation UITextView (MaxText)
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self methodExchange];
    });
}
//设置属性
- (void)setLg_place:(NSString *)lg_place {
    [self willChangeValueForKey:@"lg_place"];
    objc_setAssociatedObject(self, &lg_place_key, lg_place, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"lg_place"];
    self.lg_placeLable.text = lg_place;
    [self setNeedsLayout];
}

- (NSString *)lg_place {
    return objc_getAssociatedObject(self, &lg_place_key);
}

- (UIColor *)place_textColor {
    return self.lg_placeLable.textColor;
}

- (void)setPlace_textColor:(UIColor *)place_textColor
{
    self.lg_placeLable.textColor = place_textColor;
}

- (void)setLg_placeLable:(UILabel *)lg_placeLable
{
    [self willChangeValueForKey:@"lg_placeLable"];
    objc_setAssociatedObject(self, &lg_placeLable_key, lg_placeLable, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"lg_placeLable"];
}

- (UILabel *)lg_placeLable {
    UILabel *l = objc_getAssociatedObject(self, &lg_placeLable_key);
    if (!l) {
        l = [UILabel new];
        l.textColor = [UIColor grayColor];
        l.font = self.font;        //默认字体大小
        l.numberOfLines = 0;
        self.lg_placeLable = l;
        [self addSubview:l];
        //在这个里添加监听
        [self lg_addNotification];
    }
    return l;
}

- (void)setPlace_font:(UIFont *)place_font
{
    [self willChangeValueForKey:@"place_font"];
    objc_setAssociatedObject(self, &lg_placeLable_font_key, place_font, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.lg_placeLable.font = place_font;
    [self didChangeValueForKey:@"place_font"];
}

- (UIFont *)place_font {
    UIFont *font = objc_getAssociatedObject(self, &lg_placeLable_font_key);
    return !font ? self.font : font;
}

- (void)lg_addNotification {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewDidChangeNotification:) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)textViewDidChangeNotification:(NSNotification *)noti {
    if (noti.object == self) {
        [self checkText];
    }
}

- (void)checkText {
    if (self.markedTextRange == nil) {
        if (self.text.length > self.maxNumber&&self.maxNumber >=0) {
            NSString *text = [self.text substringWithRange:(NSRange) { 0, self.maxNumber }];
            self.text = text;
        }
    }
    self.lg_placeLable.hidden = (self.text.length <= 0) ? NO : YES;
    !self.lg_textDidChange ? : self.lg_textDidChange(self.text);
}
- (void)setMaxNumber:(NSInteger)maxNumber {
    NSNumber *value =  @(maxNumber);
    [self willChangeValueForKey:@"maxNumber"];
    objc_setAssociatedObject(self, &lg_maxNumber_key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"maxNumber"];
}
- (NSInteger)maxNumber {
    NSNumber *number =  objc_getAssociatedObject(self,  &lg_maxNumber_key);
    if (!number) {
        return -1;
    }
    return number.integerValue;
}

- (void)setLg_placeInsets:(UIEdgeInsets)lg_placeInsets {
    NSValue *value =  [NSValue valueWithUIEdgeInsets:lg_placeInsets];
    [self willChangeValueForKey:@"lg_placeInsets"];
    objc_setAssociatedObject(self, &lg_placeInsets_key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"lg_placeInsets"];
    [self setNeedsLayout];
}

- (UIEdgeInsets)lg_placeInsets {
	NSValue *value =  objc_getAssociatedObject(self, &lg_placeInsets_key);
    return !value ? self.textContainerInset: [value UIEdgeInsetsValue];
}

- (void)setLg_textDidChange:(void (^)(NSString *))lg_textDidChange {
    [self willChangeValueForKey:@"lg_textDidChange"];
    objc_setAssociatedObject(self, &lg_textDidChange_key, lg_textDidChange, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"lg_textDidChange"];
}

- (void (^)(NSString *text))lg_textDidChange {
    return objc_getAssociatedObject(self, &lg_textDidChange_key);
}

#pragma mark - 交换方法
+ (void)methodExchange {
    ExChange_Objc_methodAToB(NSSelectorFromString(@"dealloc"),
                             @selector(textView_dealloc));
    ExChange_Objc_methodAToB(@selector(layoutSubviews), @selector(textView_layoutSubViews));
	ExChange_Objc_methodAToB(@selector(setText:),@selector(textView_setText:));
}
-(void)textView_setText:(NSString *)text
{
	[self textView_setText:text];
	[self checkText];
}
- (void)textView_layoutSubViews {
    [self textView_layoutSubViews];
    self.lg_placeLable.font = self.place_font;
    CGFloat w =  CGRectGetWidth(self.bounds);
    UIEdgeInsets insets = self.lg_placeInsets;
    CGFloat text_w = w - (insets.left + insets.right + self.layer.borderWidth*2);
    CGSize size =  [self.lg_placeLable sizeThatFits:CGSizeMake(text_w, CGFLOAT_MAX)];
    CGRect f = CGRectMake(insets.left + self.layer.borderWidth, insets.top + self.layer.borderWidth, text_w, MAX(size.height, self.place_font.lineHeight));
    self.lg_placeLable.frame = f;
}
- (void)textView_dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
    [self textView_dealloc];
}
#pragma mark - publick method
- (void)lgPlace:(NSString *)place maxWord:(NSInteger)max textDidChange:(void (^)(NSString *text))textDidchagne {
    self.lg_place = place;
    self.maxNumber = max;
    self.lg_textDidChange = textDidchagne;
}
- (NSString *)placeholder {
    return self.lg_place;
}

@end

static const char lg_tfmaxNumber_key = '\0';
static const char lg_tftextDidChange_key = '\0';

@interface UITextField ()
@property (nonatomic, copy) void (^ lg_textDidChange)(NSString *currentText); //变化
@property (nonatomic, assign) NSInteger maxNumber; //最大数量
@end

@implementation UITextField (MaxText)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self methodExchange];
    });
}

- (void)lgMaxWord:(NSInteger)max textDidChange:(nullable void (^)(NSString *text))textDidchagne {
    self.maxNumber = max;
    self.lg_textDidChange = textDidchagne;
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:nil];
}
- (void)textDidChangeNotification:(NSNotification *)noti {
    if (noti.object == self) {
        [self checkText];
    }
}
- (void)checkText {
    if (self.markedTextRange == nil) {
		if (self.text.length > self.maxNumber&&self.maxNumber>=0) {
            NSString *text = [self.text substringWithRange:(NSRange) { 0, self.maxNumber }];
            self.text = text;
        }
        !self.lg_textDidChange ? : self.lg_textDidChange(self.text);
    }
}

#pragma mark - 交换方法
+ (void)methodExchange {
    ExChange_Objc_methodAToB(NSSelectorFromString(@"dealloc"),
                             @selector(tf_dealloc));
	ExChange_Objc_methodAToB(@selector(setText:),
							 @selector(tf_setText:));
}
-(void)tf_setText:(NSString *)text
{
	[self tf_setText:text];
	[self checkText];
}
- (void)tf_dealloc {
    [self tf_dealloc];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)setLg_textDidChange:(void (^)(NSString *))lg_textDidChange {
    [self willChangeValueForKey:@"lg_textDidChange"];
    objc_setAssociatedObject(self, &lg_tftextDidChange_key, lg_textDidChange, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"lg_textDidChange"];
}

- (void (^)(NSString *text))lg_textDidChange {
    return objc_getAssociatedObject(self, &lg_tftextDidChange_key);
}

- (void)setMaxNumber:(NSInteger)maxNumber {
    NSNumber *value =  @(maxNumber);
    [self willChangeValueForKey:@"maxNumber"];
    objc_setAssociatedObject(self, &lg_tfmaxNumber_key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"maxNumber"];
}

- (NSInteger)maxNumber {
    NSNumber *number =  objc_getAssociatedObject(self,  &lg_tfmaxNumber_key);
    if (!number) {
        return -1;
    }
    return number.integerValue;
}

@end


@implementation UITextView (creat)

+ (UITextView *)make:(void (^)(UITextView *tv))make {
    UITextView *tf = [[UITextView alloc]init];
    make(tf);
    return tf;
}

- (UITextView *(^)(UIColor *textColor))lg_text_color {
    return ^(UIColor *color) {
               self.textColor = color;
               return self;
    };
}
-(UITextView *(^)(UIEdgeInsets textEdgeInsets))lg_insets
{
	return ^(UIEdgeInsets e) {
				  self.textContainerInset = e;
				  return self;
	   };
}
- (UITextView *(^)(NSString *text))lg_txt
{
    return ^(NSString *t) {
               self.text = t;
               return self;
    };
}

- (UITextView *(^)(UIFont *font))lg_font {
    return ^(UIFont *f) {
               self.font = f;
               return self;
    };
}

- (UITextView *(^)(NSTextAlignment alignment))lg_align
{
    return ^(NSTextAlignment a) {
               self.textAlignment = a;
               return self;
    };
}

- (UITextView *(^)(UIColor *color))lg_bg_color
{
    return ^(UIColor *c) {
               self.backgroundColor = c;
               return self;
    };
}

- (UITextView *(^)(CGFloat r))lg_r_d
{
    return ^(CGFloat rd) {
               self.layer.cornerRadius = rd;
               return self;
    };
}
-(UITextView *(^)(UIView *superV))addTo
{
	return ^(UIView *v){
		[v addSubview:self];
		return self;
	};
}

@end

@implementation UITextField (creat)

+ (UITextField *)make:(void (^)(UITextField *make))make
{
    UITextField *tf = [[UITextField alloc]init];
    make(tf);
    return tf;
}

- (UITextField *(^)(UIColor *textColor))lg_text_color
{
    return ^(UIColor *color) {
               self.textColor = color;
               return self;
    };
}

- (UITextField *(^)(NSString *text))lg_txt
{
    return ^(NSString *t) {
               self.text = t;
               return self;
    };
}

- (UITextField *(^)(UIFont *font))lg_font {
    return ^(UIFont *f) {
               self.font = f;
               return self;
    };
}

- (UITextField *(^)(NSTextAlignment alignment))lg_align
{
    return ^(NSTextAlignment a) {
               self.textAlignment = a;
               return self;
    };
}

- (UITextField *(^)(UIColor *color))lg_bg_color
{
    return ^(UIColor *c) {
               self.backgroundColor = c;
               return self;
    };
}

- (UITextField *(^)(CGFloat r))lg_r_d
{
    return ^(CGFloat rd) {
               self.layer.cornerRadius = rd;
               return self;
    };
}
-(UITextField *(^)(UIView *superV))addTo
{
	return ^(UIView *v){
		[v addSubview:self];
		return self;
	};
}

@end

@implementation UILabel (creat)
+ (UILabel *)make:(void (^)(UILabel *make))make {
    UILabel *tf = [[UILabel alloc]init];
    make(tf);
    return tf;
}

- (UILabel *(^)(UIColor *textColor))lg_text_color
{
    return ^(UIColor *color) {
               self.textColor = color;
               return self;
    };
}

- (UILabel *(^)(NSString *text))lg_txt
{
    return ^(NSString *t) {
               self.text = t;
               return self;
    };
}

- (UILabel *(^)(UIFont *font))lg_font
{
    return ^(UIFont *f) {
               self.font = f;
               return self;
    };
}

- (UILabel *(^)(NSTextAlignment alignment))lg_align
{
    return ^(NSTextAlignment a) {
               self.textAlignment = a;
               return self;
    };
}

- (UILabel *(^)(UIColor *color))lg_bg_color
{
    return ^(UIColor *c) {
               self.backgroundColor = c;
               return self;
    };
}

- (UILabel *(^)(CGFloat r))lg_r_d {
    return ^(CGFloat rd) {
               self.layer.cornerRadius = rd;
               return self;
    };
}
-(UILabel *(^)(UIView *superV))addTo
{
	return ^(UIView *v){
		[v addSubview:self];
		return self;
	};
}
@end


@implementation UIButton (creat)

//创建按钮
+(UIButton *)make:(void(^)(UIButton * make))make {
	UIButton *b = [UIButton new];
	make(b);
	return b;
}
-(UIButton *(^)(UIImage *img,UIControlState state))lg_image {
	return ^(UIImage *i,UIControlState s){
		[self setImage:i forState:s];
		return self;
	};
}

-(UIButton *(^)(UIImage *img,UIControlState state))lg_bg_image {
	return ^(UIImage *i,UIControlState s){
		[self setBackgroundImage:i forState:s];
		return self;
	};
}

-(UIButton *(^)(NSString *text,UIControlState state))lg_title {
	return ^(NSString *t ,UIControlState s){
		[self setTitle:t forState:s];
		return self;
	};
}
-(UIButton *(^)(UIColor *c,UIControlState state))lg_title_color  {
	return ^(UIColor *cl,UIControlState s){
		[self setTitleColor:cl forState:s];
		return self;
	};
}

-(UIButton *(^)(UIFont *f))lg_font {
	return ^(UIFont *ft){
		self.titleLabel.font = ft;
		return self;
	};
}
-(UIButton *(^)(id taget,SEL sel,UIControlEvents event))lg_sel {
	return ^(id t,SEL s,UIControlEvents e){
		[self addTarget:t action:s forControlEvents:e];
		return self;
	};
}
-(UIButton *(^)(UIEdgeInsets e))lg_imgInsets
{
	return ^(UIEdgeInsets ae){
		[self setImageEdgeInsets:ae];
		return self;
	};
}
-(UIButton *(^)(UIEdgeInsets e))lg_titleInsets
{
	return ^(UIEdgeInsets ae){
		[self setTitleEdgeInsets:ae];
		return self;
	};
}
-(UIButton *(^)(UIControlContentHorizontalAlignment align))lg_h_align
{
	return ^(UIControlContentHorizontalAlignment a){
		[self setContentHorizontalAlignment:a];
		return self;
	};
}
-(UIButton *(^)(UIControlContentVerticalAlignment align))lg_v_align{
	return ^(UIControlContentVerticalAlignment a){
		[self setContentVerticalAlignment:a];
		return self;
	};
}

-(UIButton *(^)(CGFloat r))lg_r_d
{
	return ^(CGFloat ar){
		self.layer.cornerRadius = ar;
		return self;
	};
}
-(UIButton *(^)(UIView *superV))addTo
{
	return ^(UIView *v){
		[v addSubview:self];
		return self;
	};
}
-(UIButton *(^)(UIColor *color))lg_bgColor
{
	return ^(UIColor *c){
		self.backgroundColor = c;
		return self;
	};
}
@end


@implementation UIImageView (creat)

+(UIImageView *)make:(void(UIImageView *make))make
{
	UIImageView *imgV = [UIImageView new];
	make(imgV);
	return imgV;
}
-(UIImageView *(^)(UIImage *image))lg_imge
{
	return ^(UIImage *i){
		self.image = i;
		return self;
	};
}
-(UIImageView *(^)(UIViewContentMode fillModel))lg_fillModel
{
	return ^(UIViewContentMode m){
		self.contentMode = m;
		return self;
	};
}
-(UIImageView *(^)(CGFloat r))lg_r_d
{
	return ^(CGFloat ar){
		self.layer.cornerRadius = ar;
		return self;
	};
}
-(UIImageView *(^)(UIColor *color))lg_bgColor
{
	return ^(UIColor *ac){
		self.backgroundColor = ac;
		return self;
	};
}
-(UIImageView *(^)(UIView *superV))addTo
{
	return ^(UIView *v){
		[v addSubview:self];
		return self;
	};
}
@end




