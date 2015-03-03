//
//  ViewController.h
//  STTwitter
//
//  Created by 田中友貴 on 2015/02/24.
//  Copyright (c) 2015年 TomokiTanaka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking.h>
#import <Accounts/Accounts.h>

@interface ViewController : UIViewController{
    
    NSArray *jsonArray;
}
-(IBAction)tweetButton;
-(void)timeline;




@end

