//
//  BalanceViewController.h
//  Balance
//
//  Created by 14cm0122 on 2014/05/20.
//  Copyright (c) 2014年 jec.ac.jp. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreMotion/CoreMotion.h> //20140527追加

@interface BalanceViewController : UIViewController <UIAccelerometerDelegate>
{
    double accelX, accelY, accelZ;  //加速度
    double speedX, speedY;          //速度
    double positionX, positionY;    //位置
}

@property (nonatomic, strong) CMMotionManager *motionManager; // モーションマネージャー 20140527追加

-(void)move;    //　ボールを移動させるメソッド
-(void)bump;
@end
