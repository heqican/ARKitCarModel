//
//  HCMessagePanelView.m
//  HCARKitDetectionimage
//
//  Created by 何其灿 on 2019/5/22.
//  Copyright © 2019 松小宝. All rights reserved.
//

#import "HCMessagePanelView.h"
#import <Masonry.h>

static const CGFloat Page_Control_Distance_X = 10.f;//页面控件横向间隔
static const CGFloat Page_Control_Distance_Y = 10.f;
static const CGFloat Car_Image_Size_Width = 200;//汽车图片宽度
static const CGFloat textField_size_height = 30.f;

@interface HCMessagePanelView ()
@property (nonatomic, strong) UIButton *dismissButton;
@property (nonatomic, strong) UIImageView *carImageView;

@property (nonatomic, strong) UILabel *nameLabel;//名字
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UILabel *xingLabel;//姓氏
@property (nonatomic, strong) UITextField *xingTextField;
@property (nonatomic, strong) UILabel *mailLabel;//电子邮箱
@property (nonatomic, strong) UITextField *mailTextField;
@property (nonatomic, strong) UILabel *telLabel;//电话
@property (nonatomic, strong) UITextField *telTextField;
@property (nonatomic, strong) UILabel *typeLabel;//证件类型
@property (nonatomic, strong) UITextField *typeTextField;
@property (nonatomic, strong) UILabel *idCardLabel;//身份证号
@property (nonatomic, strong) UITextField *idCardTextField;

@property (nonatomic, strong) UIView *line1;
@property (nonatomic, strong) UIView *line2;
@property (nonatomic, strong) UILabel *zaiyaoLabel;//摘要
@property (nonatomic, strong) UILabel *youtTypeLabel;//您的车型
@property (nonatomic, strong) UILabel *dateLabel;//交付日期
@property (nonatomic, strong) UILabel *contentLabel;//概要内容
@property (nonatomic, strong) UIButton *submitButton;//提交订单

@property (nonatomic, strong) UILabel *addressLabel;//提车地点
@property (nonatomic, strong) UILabel *addressAlertLabel;
@property (nonatomic, strong) UITextField *selectAddressTextField;

@end

@implementation HCMessagePanelView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = UIColorFromRGB(0xf7f7f7);
        [self createSubviews];
        [self createAutoLayout];
        
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClicked:)];
        [self addGestureRecognizer:ges];
    }
    return self;
}



- (void)createSubviews{
    [self addSubview:self.dismissButton];
    [self addSubview:self.carImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.nameTextField];
    [self addSubview:self.xingLabel];
    [self addSubview:self.xingTextField];
    [self addSubview:self.mailLabel];
    [self addSubview:self.mailTextField];
    [self addSubview:self.telLabel];
    [self addSubview:self.telTextField];
    [self addSubview:self.typeLabel];
    [self addSubview:self.typeTextField];
    [self addSubview:self.idCardLabel];
    [self addSubview:self.idCardTextField];
    
    [self addSubview:self.line1];
    [self addSubview:self.line2];
    [self addSubview:self.zaiyaoLabel];
    [self addSubview:self.youtTypeLabel];
    [self addSubview:self.dateLabel];
    
    [self addSubview:self.contentLabel];
    [self addSubview:self.submitButton];
    
    [self addSubview:self.addressLabel];
    [self addSubview:self.addressAlertLabel];
    [self addSubview:self.selectAddressTextField];
}

- (void)createAutoLayout{
    [self.dismissButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    
    CGFloat height = Car_Image_Size_Width * 627 / 1022;
    [self.carImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.dismissButton.mas_top);
        make.right.mas_equalTo(self.mas_right).offset(-Page_Control_Distance_X);
        make.width.mas_equalTo(Car_Image_Size_Width);
        make.height.mas_equalTo(height);
    }];
    
    CGFloat controlWidth = (self.frame.size.width - Page_Control_Distance_X*4 - Car_Image_Size_Width)/2;
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.dismissButton.mas_left);
        make.top.mas_equalTo(self.dismissButton.mas_bottom).offset(Page_Control_Distance_Y);
        make.width.mas_equalTo(controlWidth);
        make.height.mas_equalTo(15);
    }];
    
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.top.mas_equalTo(self.nameLabel.mas_bottom);
        make.width.mas_equalTo(controlWidth);
        make.height.mas_equalTo(textField_size_height);
    }];
    
    [self.xingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_right).offset(Page_Control_Distance_X);
        make.top.mas_equalTo(self.nameLabel.mas_top);
        make.width.mas_equalTo(controlWidth);
        make.height.mas_equalTo(15);
    }];
    
    [self.xingTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.xingLabel.mas_left);
        make.top.mas_equalTo(self.xingLabel.mas_bottom);
        make.width.mas_equalTo(controlWidth);
        make.height.mas_equalTo(textField_size_height);
    }];
    
    [self.mailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.top.mas_equalTo(self.nameTextField.mas_bottom).offset(Page_Control_Distance_Y);
        make.width.mas_equalTo(controlWidth);
        make.height.mas_equalTo(15);
    }];
    
    [self.mailTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mailLabel.mas_left);
        make.top.mas_equalTo(self.mailLabel.mas_bottom);
        make.width.mas_equalTo(controlWidth);
        make.height.mas_equalTo(textField_size_height);
    }];
    
    [self.telLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.xingLabel.mas_left);
        make.top.mas_equalTo(self.mailLabel.mas_top);
        make.width.mas_equalTo(controlWidth);
        make.height.mas_equalTo(15);
    }];
    
    [self.telTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.telLabel.mas_left);
        make.top.mas_equalTo(self.telLabel.mas_bottom);
        make.width.mas_equalTo(controlWidth);
        make.height.mas_equalTo(textField_size_height);
    }];
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.top.mas_equalTo(self.mailTextField.mas_bottom).offset(Page_Control_Distance_Y);
        make.width.mas_equalTo(controlWidth);
        make.height.mas_equalTo(15);
    }];
    
    [self.typeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.typeLabel.mas_left);
        make.top.mas_equalTo(self.typeLabel.mas_bottom);
        make.width.mas_equalTo(controlWidth);
        make.height.mas_equalTo(textField_size_height);
    }];
    
    [self.idCardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.xingLabel.mas_left);
        make.top.mas_equalTo(self.typeLabel.mas_top);
        make.width.mas_equalTo(controlWidth);
        make.height.mas_equalTo(15);
    }];
    
    [self.idCardTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.idCardLabel.mas_left);
        make.top.mas_equalTo(self.idCardLabel.mas_bottom);
        make.width.mas_equalTo(controlWidth);
        make.height.mas_equalTo(textField_size_height);
    }];
    
    //line
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.typeTextField.mas_left);
        make.top.mas_equalTo(self.typeTextField.mas_bottom).offset(Page_Control_Distance_Y*3);
        make.right.mas_equalTo(self.idCardTextField.mas_right);
        make.height.mas_equalTo(2);
    }];
    
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.carImageView.mas_left);
        make.top.mas_equalTo(self.line1.mas_top);
        make.right.mas_equalTo(self.carImageView.mas_right);
        make.height.mas_equalTo(1);
    }];
    
    [self.zaiyaoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.line2.mas_left);
        make.bottom.mas_equalTo(self.line2.mas_bottom).offset(-5);
    }];
    
    [self.youtTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.carImageView.mas_left);
        make.bottom.mas_equalTo(self.idCardLabel.mas_top);
        make.right.mas_equalTo(self.carImageView.mas_right);
        make.height.mas_equalTo(30);
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.youtTypeLabel.mas_left);
        make.top.mas_equalTo(self.youtTypeLabel.mas_bottom);
        make.right.mas_equalTo(self.youtTypeLabel.mas_right);
        make.height.mas_equalTo(30);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.line2.mas_bottom).offset(5);
        make.left.mas_equalTo(self.line2.mas_left).offset(20);
        make.width.mas_equalTo(self.line2.mas_width);
        make.height.mas_equalTo(80);
    }];
    
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentLabel.mas_bottom);
        make.left.mas_equalTo(self.contentLabel.mas_left);
        make.right.mas_equalTo(self.contentLabel.mas_right).offset(-40);
        make.height.mas_equalTo(30);
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.line1.mas_bottom).offset(Page_Control_Distance_Y);
        make.left.mas_equalTo(self.line1.mas_left);
        make.right.mas_equalTo(self.line1.mas_right);
        make.height.mas_equalTo(20);
    }];
    
    [self.addressAlertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.addressLabel.mas_bottom).offset(Page_Control_Distance_Y);
        make.left.mas_equalTo(self.line1.mas_left).offset(20);
        make.right.mas_equalTo(self.line1.mas_right);
        make.height.mas_equalTo(15);
    }];
    
    [self.selectAddressTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.addressAlertLabel.mas_bottom).offset(Page_Control_Distance_Y);
        make.left.mas_equalTo(self.addressAlertLabel.mas_left);
        make.right.mas_equalTo(self.line1.mas_right);
        make.height.mas_equalTo(textField_size_height);
    }];
}


- (void)show{
    [UIView animateWithDuration:0.5 animations:^{
        self.center = CGPointMake(iphone_width/2, Message_Panel_Size_Height/2);
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)hidden{
    [self.nameTextField resignFirstResponder];
    [self.xingTextField resignFirstResponder];
    [self.mailTextField resignFirstResponder];
    [self.telTextField resignFirstResponder];
    [self.idCardTextField resignFirstResponder];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.center = CGPointMake(iphone_width/2, -Message_Panel_Size_Height/2);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)tapClicked:(UITapGestureRecognizer *)ges{
    [self.nameTextField resignFirstResponder];
    [self.xingTextField resignFirstResponder];
    [self.mailTextField resignFirstResponder];
    [self.telTextField resignFirstResponder];
    [self.idCardTextField resignFirstResponder];
}

#pragma mark - 点击
- (void)doDismissView{
    [self hidden];
}

//提交订单
- (void)submitOrder:(id)sender{
    [self hidden];
    
}

#pragma mark - lazy load
- (UIButton *)dismissButton{
    if (!_dismissButton) {
        _dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dismissButton setImage:[UIImage imageNamed:@"message_panel_dismiss_image"] forState:UIControlStateNormal];
        [_dismissButton addTarget:self action:@selector(doDismissView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dismissButton;
}

- (UIImageView *)carImageView{
    if (!_carImageView) {
        _carImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"message_car_image"]];
        _carImageView.layer.cornerRadius = 10;
        _carImageView.layer.masksToBounds = YES;
    }
    return _carImageView;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = UIColorFromRGB(0x666666);
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.text = @"   名字";
    }
    return _nameLabel;
}

- (UITextField *)nameTextField{
    if (!_nameTextField) {
        _nameTextField = [[UITextField alloc] init];
        _nameTextField.backgroundColor = [UIColor whiteColor];
        _nameTextField.layer.masksToBounds = YES;
        _nameTextField.layer.cornerRadius = textField_size_height/2;
    }
    return _nameTextField;
}

- (UILabel *)xingLabel{
    if (!_xingLabel) {
        _xingLabel = [[UILabel alloc] init];
        _xingLabel.textColor = UIColorFromRGB(0x666666);
        _xingLabel.font = [UIFont systemFontOfSize:14];
        _xingLabel.text = @"   姓氏";
    }
    return _xingLabel;
}

- (UITextField *)xingTextField{
    if (!_xingTextField) {
        _xingTextField = [[UITextField alloc] init];
        _xingTextField.backgroundColor = [UIColor whiteColor];
        _xingTextField.layer.masksToBounds = YES;
        _xingTextField.layer.cornerRadius = textField_size_height/2;
    }
    return _xingTextField;
}

- (UILabel *)mailLabel{
    if (!_mailLabel) {
        _mailLabel = [[UILabel alloc] init];
        _mailLabel.textColor = UIColorFromRGB(0x666666);
        _mailLabel.font = [UIFont systemFontOfSize:14];
        _mailLabel.text = @"   电子邮箱";
    }
    return _mailLabel;
}

- (UITextField *)mailTextField{
    if (!_mailTextField) {
        _mailTextField = [[UITextField alloc] init];
        _mailTextField.backgroundColor = [UIColor whiteColor];
        _mailTextField.layer.masksToBounds = YES;
        _mailTextField.layer.cornerRadius = textField_size_height/2;
    }
    return _mailTextField;
}

- (UILabel *)telLabel{
    if (!_telLabel) {
        _telLabel = [[UILabel alloc] init];
        _telLabel.textColor = UIColorFromRGB(0x666666);
        _telLabel.font = [UIFont systemFontOfSize:14];
        _telLabel.text = @"   电话";
    }
    return _telLabel;
}

- (UITextField *)telTextField{
    if (!_telTextField) {
        _telTextField = [[UITextField alloc] init];
        _telTextField.backgroundColor = [UIColor whiteColor];
        _telTextField.layer.masksToBounds = YES;
        _telTextField.layer.cornerRadius = textField_size_height/2;
    }
    return _telTextField;
}

- (UILabel *)typeLabel{
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.textColor = UIColorFromRGB(0x666666);
        _typeLabel.font = [UIFont systemFontOfSize:14];
        _typeLabel.text = @"   证件类型";
    }
    return _typeLabel;
}

- (UITextField *)typeTextField{
    if (!_typeTextField) {
        _typeTextField = [[UITextField alloc] init];
        _typeTextField.backgroundColor = [UIColor whiteColor];
        _typeTextField.layer.masksToBounds = YES;
        _typeTextField.layer.cornerRadius = textField_size_height/2;
        _typeTextField.userInteractionEnabled = NO;
        _typeTextField.text = @"  身份证";
    }
    return _typeTextField;
}

-(UILabel *)idCardLabel{
    if (!_idCardLabel) {
        _idCardLabel = [[UILabel alloc] init];
        _idCardLabel.textColor = UIColorFromRGB(0x666666);
        _idCardLabel.font = [UIFont systemFontOfSize:14];
        _idCardLabel.text = @"   身份证号";
    }
    return _idCardLabel;
}

- (UITextField *)idCardTextField{
    if (!_idCardTextField) {
        _idCardTextField = [[UITextField alloc] init];
        _idCardTextField.backgroundColor = [UIColor whiteColor];
        _idCardTextField.layer.masksToBounds = YES;
        _idCardTextField.layer.cornerRadius = textField_size_height/2;
    }
    return _idCardTextField;
}

- (UIView *)line1{
    if (!_line1) {
        _line1 = [[UIView alloc] init];
        _line1.backgroundColor = [UIColor grayColor];
    }
    return _line1;
}

- (UIView *)line2{
    if (!_line2) {
        _line2 = [[UIView alloc] init];
        _line2.backgroundColor = [UIColor grayColor];
    }
    return _line2;
}

- (UILabel *)zaiyaoLabel{
    if (!_zaiyaoLabel) {
        _zaiyaoLabel = [[UILabel alloc] init];
        _zaiyaoLabel.font = [UIFont systemFontOfSize:18];
        _zaiyaoLabel.text = @"概要";
    }
    return _zaiyaoLabel;
}

- (UILabel *)youtTypeLabel{
    if (!_youtTypeLabel) {
        _youtTypeLabel = [[UILabel alloc] init];
        _youtTypeLabel.font = [UIFont systemFontOfSize:25];
        _youtTypeLabel.textAlignment = NSTextAlignmentCenter;
        _youtTypeLabel.text = @"您的车型";
    }
    return _youtTypeLabel;
}

- (UILabel *)dateLabel{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.font = [UIFont systemFontOfSize:20];
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        _dateLabel.text = @"预计交互日期：6月";
    }
    return _dateLabel;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = [UIColor grayColor];
        _contentLabel.text = @"纯黑色车漆\n19英寸银色轮毂\n纯黑色高级内饰(黑色座椅)\nAutopilot自动辅助驾驶";
    }
    return _contentLabel;
}

- (UIButton *)submitButton{
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _submitButton.backgroundColor = [UIColor purpleColor];
        _submitButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _submitButton.titleLabel.textColor = [UIColor whiteColor];
        _submitButton.layer.cornerRadius = 15;
        [_submitButton setTitle:@"提交订单" forState:UIControlStateNormal];
        [_submitButton addTarget:self action:@selector(submitOrder:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}

- (UILabel *)addressLabel{
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.font = [UIFont systemFontOfSize:20];
        _addressLabel.textAlignment = NSTextAlignmentLeft;
        _addressLabel.numberOfLines = 0;
        _addressLabel.textColor = [UIColor grayColor];
        _addressLabel.text = @"提车地点";
    }
    return _addressLabel;
}

- (UILabel *)addressAlertLabel{
    if (!_addressAlertLabel) {
        _addressAlertLabel = [[UILabel alloc] init];
        _addressAlertLabel.font = [UIFont systemFontOfSize:16];
        _addressAlertLabel.textAlignment = NSTextAlignmentLeft;
        _addressAlertLabel.numberOfLines = 0;
        _addressAlertLabel.textColor = [UIColor grayColor];
        _addressAlertLabel.text = @"请选择离您最近的提车地点";
    }
    return _addressAlertLabel;
}

- (UITextField *)selectAddressTextField{
    if (!_selectAddressTextField) {
        _selectAddressTextField = [[UITextField alloc] init];
        _selectAddressTextField.backgroundColor = [UIColor whiteColor];
        _selectAddressTextField.layer.masksToBounds = YES;
        _selectAddressTextField.layer.cornerRadius = textField_size_height/2;
        _selectAddressTextField.userInteractionEnabled = NO;
        _selectAddressTextField.text = @"  选择地点";
    }
    return _selectAddressTextField;
}

@end
