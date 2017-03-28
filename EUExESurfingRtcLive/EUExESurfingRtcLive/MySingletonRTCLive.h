//
//  MySingletonRTCLive.h
//  DEMO
//
//  Created by cc on 15/11/4.
//  Copyright © 2015年 hexc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>
#import "EUtility.h"
#import "RTCLive.h"
#import "JSONKitRTC.h"
#import "DAPIPViewLive.h"

@interface MySingletonRTCLive : NSObject<RTCLiveCallBackProtocol>

@property (strong, nonatomic) RTCLive* mRTCLiveObj;
@property(nonatomic,retain)NSString * appID;
@property(nonatomic,retain)NSString * appKey;
@property(nonatomic,retain)NSString * accID;
@property(nonatomic,retain)NSString * accKey;
@property(nonatomic,retain)NSString * userID;
@property(nonatomic,retain)NSString * userKey;
@property (strong, nonatomic) UIView *castVideoView;
@property (strong, nonatomic) UIView *playVideoView;
@property(nonatomic,assign)BOOL iscastVideoView;
@property(nonatomic,assign)BOOL isplayVideoView;
@property(nonatomic,assign)BOOL isjoinVideoView;
@property (nonatomic,retain) DAPIPViewLive * dapiview;
@property (nonatomic,retain) IOSDisplay *joinCastView;
@property(nonatomic,assign)int x;
@property(nonatomic,assign)int y;
@property(nonatomic,assign)int width;
@property(nonatomic,assign)int height;
@property(nonatomic,assign)int x1;
@property(nonatomic,assign)int y1;
@property(nonatomic,assign)int width1;
@property(nonatomic,assign)int height1;
@property(nonatomic,assign)int x2;
@property(nonatomic,assign)int y2;
@property(nonatomic,assign)int width2;
@property(nonatomic,assign)int height2;
@property(nonatomic,assign)int x3;
@property(nonatomic,assign)int y3;
@property(nonatomic,assign)int width3;
@property(nonatomic,assign)int height3;
@property(nonatomic,assign)int isAnchorman;
@property(nonatomic,assign)int userView;
@property(nonatomic,assign)int onlyAudio;
@property (nonatomic,strong) dispatch_queue_t callBackDispatchQueue;

+ (instancetype)sharedInstance;
- (void)setLog:(NSString*)log;
- (void)onSDKInit;

@end
