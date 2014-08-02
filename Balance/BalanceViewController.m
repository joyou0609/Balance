//
//  BalanceViewController.m
//  Balance
//
//  Created by 14cm0122 on 2014/05/20.
//  Copyright (c) 2014年 jec.ac.jp. All rights reserved.
//

#import "BalanceViewController.h"

@interface BalanceViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *ball;
@property (weak, nonatomic) IBOutlet UIImageView *flash;

@end

@implementation BalanceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // 加速度センサーの利用
    
    // 加速度センサーのインスタンスを取得
    
    // UIAccelerometer *accelerometer = [UIAccelerometer sharedAccelerometer]; //20140527コメントアウト
    
    self.motionManager = [[CMMotionManager alloc] init]; //20140527追加
    
    // 加速度センサーの値を得る時間間隔を指定
    //accelerometer.updateInterval = 0.02; //20140527コメントアウト
    self.motionManager.accelerometerUpdateInterval = 0.02; //20140527追加
    
    // 加速度センサーの値を受け取るデリゲートを自分自身に設定
    //accelerometer.delegate = self; //20140527コメントアウト
    NSOperationQueue *currentQueue = [NSOperationQueue currentQueue]; //20140527追加
    
    [self.motionManager startAccelerometerUpdatesToQueue:currentQueue //20140527追加
                                             withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
                                                 CMAcceleration acceleration = accelerometerData.acceleration;
                                                 accelX = acceleration.x;
                                                 accelY = acceleration.y;
                                                 accelZ = acceleration.z;
                                                 [self move];
                                             }];

    
    // 位置の初期値を設定
    positionX = self.view.bounds.size.width / 2;
    positionY = self.view.bounds.size.height / 2;
    
    // 速度の初期値を設定
    speedX = 0.0;
    speedY = 0.0;
    
    // 加速度の初期値を設定
    accelX = 0.0;
    accelY = 0.0;
    
#if (TARGET_IPHONE_SIMULATOR)
    //
    [NSTimer scheduledTimerWithTimeInterval:0.02
                                     target:self
                                   selector:@selector(fakeAccelerometer)
                                   userInfo:nil
                                    repeats:YES];
#endif
}

#if (TARGET_IPHONE_SIMULATOR)
//シミュレータ動作の疑似的な加速度センサーの処理

-(void)fakeAccelerometer
{
    //
    accelX = 0.1;
    accelY = 0.2;
    accelZ = 0.0;
    
    //ボールを移動させる
    
    [self move];
}
#endif

//
//-(void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
//{
//    //加速度センサーの処理
//    //インスタンス変数に加速度の値を代入
//    
//    accelX = acceleration.x;
//    accelY = acceleration.y;
//    accelZ = acceleration.z;
//    
//    //ボールを移動させる
//    [self move];
//}
//

-(void)move
{
    //加速度かた速度を計算
    speedX = speedX + accelX;
    speedY = speedY - accelY;

    
    // 速度から位置を計算
    positionX = positionX + speedX;
    positionY = positionY + speedY;
    
    //計算した位置にボールを移動
    self.ball.center = CGPointMake(positionX, positionY);
    
    // ホールと左側のフレームとの衝突判定
    if (positionX <= 80) {
        //ボールが
        speedX *= -1;
        positionX = 80 + (80 - positionX);
        
        // フレームを光らせる
        [self bump];
    }
    
    //ホールと右側のフレームとの衝突判定
    
    if (positionX >= 240) {
        speedX *= -1;
        positionX = 240 - (positionX - 240);
        
        // フレームを光らせる
        [self bump];
    }
    
    //ホールと上側のフレームとの衝突判定
    if (positionY <= 80) {
        speedY *= -1;
        positionY = 80 + (80 - positionY);
        
        // フレームを光らせる
        [self bump];
    }
    
    int farmeY = self.view.bounds.size.height;
    int farmeTopY = farmeY - 80;
    
    //ホールと下側のフレームとの衝突判定
    if (positionY >= farmeTopY){
        
        // ボールが跳ね返るよう位置と速度を設定
        speedY *= -1;
        positionY = farmeTopY - (positionY - farmeTopY);
        
        // フレームを光らせる
        [self bump];

    }
}

- (void)bump
{
    //フルファ値を1.0にして光るフレームを表示
    self.flash.alpha = 1.0;
    
    //一秒かけてフルファ値を0.0に変化させる
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    
    self.flash.alpha = 0.0;
    
    [UIView commitAnimations];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
