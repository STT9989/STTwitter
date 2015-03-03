//
//  ViewController.m
//  STTwitter
//
//  Created by 田中友貴 on 2015/02/24.
//  Copyright (c) 2015年 TomokiTanaka. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking.h>
#import <SimpleAuth.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // Somewhere in your app boot process
    SimpleAuth.configuration[@"twitter"] = @{
                                             @"consumer_key" : @"PSziV78c5TJKjtIwbWWUPx6Fc",
                                             @"consumer_secret" : @"rnwANl3Gwcxmrzz6wWgov4xDz0OlnxSqOzRibtmsvpOV4qkxet"
                                             };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)loginWithTwitter {
    [SimpleAuth authorize:@"twitter" completion:^(id responseObject, NSError *error) {
        NSLog(@"%@", responseObject);
         //TODO:シークレットとトークンを取得
        NSString *secret = [responseObject valueForKey:@""];
        NSString *token = [responseObject valueForKey:@""];
        [self timeline:secret withToken:token];
    }];
}



-(void)timeline:(NSString *)secret withToken:(NSString *)token{
    //iOSに保存されているアカウントを取得
    ACAccountStore *account =[[ACAccountStore alloc]init];
    ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    //ユーザーにアカウントを使うことの許可を取る
    [account requestAccessToAccountsWithType:accountType
                                     options:nil
                                  completion:^(BOOL granted, NSError *error)
     
     {
         //ユーザーが許可したら
         if(granted ==YES){
             //デバイスに保存されているアカウントを全て取得
             NSArray * arrayOfAccounts =[account accountsWithAccountType:accountType];
             
             //アカウントが１つ以上あれば
             if([arrayOfAccounts count]>0){
                 //0番目（最後）のアカウントを使用
                 ACAccount *twitterAccount =[arrayOfAccounts lastObject];
                 NSDictionary *dic = @{@"twitter_account": twitterAccount};
                 NSLog(@"%@",dic);
                 
                 
                 // AFHTTPRequestOperationManagerを利用して、twitterからJSONデータを取得する
                 AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                 
                 [manager GET:@"https://api.twitter.com/1.1/statuses/home_timeline.json"
                  //TODO:パラメーターを入れる
                   parameters:@{@"":token, @"":secret}
                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                          // 通信に成功した場合の処理
                          NSLog(@"%@",jsonArray);
                          
                      }
                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                          // エラーの場合はエラーの内容をコンソールに出力する
                          NSLog(@"Error: %@", error);
                      }
                  
                  ];
             }else{
                 NSLog(@"アカウントがありません");
             }
         }
     }];
}
 



@end
