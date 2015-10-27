//
//  ViewController.m
//  ccc
//
//  Created by apple on 15/8/20.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    //信息保存的文件路径
    NSString *_fileSavePath;
    //所有联系人可变数组,里面存Contact类的对象
    NSMutableArray *_contactsArray;
    NSUInteger _currentIndex;
}

@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *gender;
@property (weak, nonatomic) IBOutlet UITextField *company;
@property (weak, nonatomic) IBOutlet UITextField *occupation;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *wechat;
@property (weak, nonatomic) IBOutlet UITextField *search;
@property (weak, nonatomic) IBOutlet UITextView *Textview;

@end

@interface Contact : NSObject
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *gender;
@property (nonatomic,strong) NSString *company;
@property (nonatomic,strong) NSString *occupation;
@property (nonatomic,strong) NSString *phone;
@property (nonatomic,strong) NSString *email;
@property (nonatomic,strong) NSString *wechat;

@end
@implementation Contact

@end

@implementation ViewController

-(void)getPrepared
{
    //初始化保存文件路径
    _fileSavePath=[NSHomeDirectory()stringByAppendingString:@"/Documents/contacts.plist"];
    _contactsArray=[NSMutableArray array];
}
-(void)loadContacts
{
    //从保存的文件恢复联系人字典对象(字典里还有字典)
    NSMutableDictionary *allContact=[NSMutableDictionary dictionaryWithContentsOfFile:_fileSavePath];
    //遍历字典，把内层字典转换为Contact对象
    for (NSString *key in [allContact allKeys]) {
        NSMutableDictionary *tmpDic;
        tmpDic=[allContact objectForKey:key];
        Contact *contact=[Contact new];
        contact.name=[tmpDic objectForKey:@"name"];
        contact.gender=[tmpDic objectForKey:@"gender"];
        contact.company=[tmpDic objectForKey:@"company"];
        contact.occupation=[tmpDic objectForKey:@"occupation"];
        contact.phone=[tmpDic objectForKey:@"phone"];
        contact.email=[tmpDic objectForKey:@"email"];
        contact.wechat=[tmpDic objectForKey:@"wechat"];
        //下面添加到实例变量的联系人数组中
        [_contactsArray addObject:contact];
       
    }
}
-(void)displayContact:(Contact *)nerr
{
    _name.text=nerr.name ;
    _gender.text=nerr.gender ;
    _company.text=nerr.company ;
    _occupation.text=nerr.occupation ;
    _phone.text=nerr.phone ;
    _email.text=nerr.email ;
    _wechat.text=nerr.wechat ;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self getPrepared];
    [self loadContacts];//页面出来之前加载所有联系人
    //默认显示第一个联系人：自定义的方法
    [self displayContact:[_contactsArray firstObject]];
    if ([_contactsArray firstObject]) {
        _currentIndex = 0;
    }else{
        _currentIndex = NSNotFound;
    }
}

-(void)saveContacts
{
    NSMutableDictionary *allContact;
    allContact=[NSMutableDictionary dictionary];
    for (Contact *tmp in _contactsArray) {
        NSMutableDictionary  *single;
        single=[NSMutableDictionary dictionary];
        [single setObject:tmp.name forKey:@"name"];
        [single setObject:tmp.gender forKey:@"gender"];
        [single setObject:tmp.company forKey:@"company"];
        [single setObject:tmp.occupation forKey:@"occupation"];
        [single setObject:tmp.phone forKey:@"phone"];
        [single setObject:tmp.email forKey:@"email"];
        [single setObject:tmp.wechat forKey:@"wechat"];
        [allContact setObject:single forKey:tmp.name];
    }
    [allContact writeToFile:_fileSavePath atomically:YES];
}

//添加
- (IBAction)addButton:(id)sender
{
    Contact *new1=[Contact new];
    new1.name=_name.text;
    new1.gender=_gender.text;
    new1.company=_company.text;
    new1.occupation=_occupation.text;
    new1.phone=_phone.text;
    new1.email=_email.text;
    new1.wechat=_wechat.text;
    //新增联系人对象到联系人数组中
    [_contactsArray addObject:new1];
    
    [self saveContacts];
    _currentIndex = [_contactsArray count] - 1;

}

//上一个
- (IBAction)preButton:(id)sender
{
    if (_currentIndex==0|| _currentIndex==NSNotFound) {
        return ;
    }
    Contact *contact=[_contactsArray objectAtIndex:_currentIndex-1];
    [self displayContact:contact];
    _currentIndex--;

}

//下一个
- (IBAction)nextButton:(id)sender
{
    if ([_contactsArray count]==0) {
        return ;
    }
    NSUInteger lastIndex=[_contactsArray count]-1;
    if (_currentIndex==lastIndex) {
        return ;
    }
    Contact *contact=[_contactsArray objectAtIndex:_currentIndex+1];
    [self displayContact:contact];
    _currentIndex++;
}

//删除
- (IBAction)deleteButton:(id)sender
{
    if (_currentIndex==NSNotFound) {
        return ;
    }
    [_contactsArray removeObjectAtIndex:_currentIndex];
    NSUInteger count=[_contactsArray count];
    
    if (count>0) {
        if (_currentIndex== count) {
            _currentIndex--;
            Contact *lastContact = _contactsArray[_currentIndex];
            [self displayContact:lastContact];
            return;
        }
        _currentIndex++;
        [self displayContact:_contactsArray[_currentIndex]];
    }
    else
    {
        _currentIndex=NSNotFound;
        _name.text=@"name";
        _gender.text=@"gender" ;
        _company.text=@"company ";
        _occupation.text=@"occupation" ;
        _phone.text=@"phone ";
        _email.text=@"email" ;
        _wechat.text=@"wechat";

    }
}

//搜索
- (IBAction)search:(id)sender {
    
    NSString *input=_search.text;
    if (input && input.length>0) {
        [self searchWitch:input];
    }
}

-(void)searchWitch:(NSString *)input
{
    NSPredicate *pred=[NSPredicate predicateWithFormat:input];
    NSArray *array=[_contactsArray filteredArrayUsingPredicate:pred];
    NSMutableString *text3=[NSMutableString string];
    for (Contact *C in array) {
        NSString *contact;
        contact=[NSString stringWithFormat:@"%@|%@|%@|%@|%@|%@|%@\n",C.name,C.gender,C.company,C.occupation,C.phone,C.email,C.wechat];
        [text3 appendString:contact];
    }
    
    _Textview.text=text3;
}

//点击空白地方收起键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //关闭键盘
      [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
