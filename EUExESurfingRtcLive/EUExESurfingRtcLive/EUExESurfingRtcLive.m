//
//  EUExESurfingRtcLive.m
//  AppCanPlugin
//
//  Created by cc on 15/5/13.
//  Copyright (c) 2015年 zywx. All rights reserved.
//

#import "EUExESurfingRtcLive.h"
#import "JSON.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <AVFoundation/AVCaptureSession.h>

@implementation EUExESurfingRtcLive

@synthesize mgr;

//每次open一个新窗口触发插件接口时，会进入一次此函数
- (id)initWithBrwView:(EBrowserView *)eInBrwView
{
    self = [super initWithBrwView:eInBrwView];
    if (self) {
        self.mgr=[MySingletonRTCLive sharedInstance];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AcceptNotification:) name:@"DOACCEPT_EVENT" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ShowPlayviewNotification:) name:@"SHOWPLAYVIEW_EVENT" object:nil];
        
        [self createNotificationCentre];
    }
    return self;
}

-(void)cbLogStatus:(NSString*)senser{
    NSString* jsString = [NSString stringWithFormat:@"uexESurfingRtcLive.cbLogStatus(\"0\",\"0\",\'%@\');",senser];
    dispatch_async(self.mgr.callBackDispatchQueue, ^(void){
        [EUtility evaluatingJavaScriptInRootWnd:jsString];
    });
}

-(void)cbGetChannel:(NSString*)senser
{
    NSString* jsString = [NSString stringWithFormat:@"uexESurfingRtcLive.cbGetChannel(\"0\",\"0\",\'%@\');",senser];
    dispatch_async(self.mgr.callBackDispatchQueue, ^(void){
        [EUtility evaluatingJavaScriptInRootWnd:jsString];
    });
}

-(void)onGlobalStatus:(NSString*)senser{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"HH:mm:ss"];
    NSString* datestr = [dateFormat stringFromDate:[NSDate date]];
    [dateFormat release];
    NSString* strs = [NSString stringWithFormat:@"%@: %@",datestr,senser];
    NSString* jsString = [NSString stringWithFormat:@"uexESurfingRtcLive.onGlobalStatus(\"0\",\"0\",\'%@\');",strs];
    dispatch_async(self.mgr.callBackDispatchQueue, ^(void){
        [EUtility evaluatingJavaScriptInRootWnd:jsString];
    });
}

-(void)cbCastStatus:(NSString*)senser{
    NSString* jsString = [NSString stringWithFormat:@"uexESurfingRtcLive.cbCastStatus(\"0\",\"0\",\'%@\');",senser];
    dispatch_async(self.mgr.callBackDispatchQueue, ^(void){
        [EUtility evaluatingJavaScriptInRootWnd:jsString];
    });
}

-(void)cbPlayStatus:(NSString*)senser{
    NSString* jsString = [NSString stringWithFormat:@"uexESurfingRtcLive.cbPlayStatus(\"0\",\"0\",\'%@\');",senser];
    dispatch_async(self.mgr.callBackDispatchQueue, ^(void){
        [EUtility evaluatingJavaScriptInRootWnd:jsString];
    });
}

-(void)AcceptNotification:(NSNotification *)notification
{
    if(self.mgr.userView)
    {
        NSDictionary* dic3 = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:self.mgr.x3],@"x",
                              [NSNumber numberWithInt:self.mgr.y3],@"y",
                              [NSNumber numberWithInt:self.mgr.width3],@"w",
                              [NSNumber numberWithInt:self.mgr.height3],@"h",
                              nil];
        [self showJoinCastView:dic3];
    }
}

-(void)ShowPlayviewNotification:(NSNotification *)notification
{
    UIView* videoView = [notification object];
    if(self.mgr.onlyAudio == 0 && videoView)
    {
        NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithInt:self.mgr.x1],@"x",
                             [NSNumber numberWithInt:self.mgr.y1],@"y",
                             [NSNumber numberWithInt:self.mgr.width1],@"w",
                             [NSNumber numberWithInt:self.mgr.height1],@"h",
                             nil];
        [self showPlayView:dic view:videoView];
    }
}

//登录接口
-(void)login:(NSMutableArray*)inArgument
{    
    if ([inArgument isKindOfClass:[NSMutableArray class]] && [inArgument count] == 5)
    {
        [self.mgr.appID release];
        self.mgr.appID = [inArgument objectAtIndex:0];
        [self.mgr.appID retain];
        
        [self.mgr.appKey release];
        self.mgr.appKey = [inArgument objectAtIndex:1];
        [self.mgr.appKey retain];
        
        [self.mgr.accID release];
        self.mgr.accID = [inArgument objectAtIndex:2];
        [self.mgr.accID retain];
        
        [self.mgr.accKey release];
        self.mgr.accKey = [inArgument objectAtIndex:3];
        [self.mgr.accKey retain];
        
        [self.mgr.userID release];
        self.mgr.userID = [inArgument objectAtIndex:4];
        [self.mgr.userID retain];
        
        if(!self.mgr.userID || !self.mgr.accID || !self.mgr.accKey || [self.mgr.userID isEqualToString:@""] || [self.mgr.accID isEqualToString:@""] || [self.mgr.accKey isEqualToString:@""])
        {
            [self performSelectorOnMainThread:@selector(cbLogStatus:) withObject:@"ERROR:PARM_ERROR" waitUntilDone:NO];
            return;
        }
        
        [self.mgr.userKey release];
        self.mgr.userKey = self.mgr.userID;//[inArgument objectAtIndex:3];
        [self.mgr.userKey retain];

//        NSString * infoStr = [inArgument objectAtIndex:0];
//        NSDictionary * dic = [infoStr JSONValue];
//        NSDictionary * dict = [dic objectForKey:@"localView"];
//        NSDictionary * dictt = [dic objectForKey:@"remoteView"];
//        
//        self.mgr.x = [[dict objectForKey:@"x"] intValue];
//        self.mgr.y = [[dict objectForKey:@"y"] intValue];
//        self.mgr.width = [[dict objectForKey:@"w"]intValue];
//        self.mgr.height = [[dict objectForKey:@"h"]intValue];
//        self.mgr.x1 = [[dictt objectForKey:@"x"]intValue];
//        self.mgr.y1 = [[dictt objectForKey:@"y"]intValue];
//        self.mgr.width1 = [[dictt objectForKey:@"w"]intValue];
//        self.mgr.height1 = [[dictt objectForKey:@"h"]intValue];
        
        [self.mgr onSDKInit];
    }
    else{
        [self performSelectorOnMainThread:@selector(cbLogStatus:) withObject:@"ERROR:PARM_ERROR" waitUntilDone:NO];
    }
}

-(void)logout: (NSMutableArray *)inArgument
{
    if (self.mgr.mRTCLiveObj)
    {
        [self.mgr.mRTCLiveObj release];
        self.mgr.mRTCLiveObj = nil;
    }
    [self performSelectorOnMainThread:@selector(cbLogStatus:) withObject:@"OK:LOGOUT" waitUntilDone:NO];
    if(self.mgr.castVideoView)
    {
        [self.mgr.castVideoView removeFromSuperview];
        [self.mgr.castVideoView release];
        self.mgr.castVideoView = nil;
    }
    if(self.mgr.playVideoView)
    {
        [self.mgr.playVideoView removeFromSuperview];
        [self.mgr.playVideoView release];
        self.mgr.playVideoView = nil;
    }
    if(self.mgr.joinCastView)
    {
        [self.mgr.joinCastView removeFromSuperview];
        [self.mgr.joinCastView release];
        self.mgr.joinCastView = nil;
    }
    if(self.mgr.dapiview)
    {
        [self.mgr.dapiview removeFromSuperview];
        //        [self.mgr.dapiview release];
        //        self.mgr.dapiview = nil;
    }
}

- (void)getLiveChannel:(NSMutableArray*)inArgument
{
    if(!self.mgr.mRTCLiveObj)
    {
        [self performSelectorOnMainThread:@selector(cbGetChannel:) withObject:@"ERROR:UNREGISTER" waitUntilDone:NO];
        return;
    }
    NSString* record = @"off";
    if([inArgument count] == 1)
        record = [inArgument objectAtIndex:0];
    if(!record || [record isEqualToString:@""] || (![record isEqualToString:@"on"] && ![record isEqualToString:@"off"]))
        record = @"off";
    [self.mgr.mRTCLiveObj getLiveChannel:self.mgr.accID andAccKey:self.mgr.accKey record:record];
    
    return;
}

//开始预览
-(void)startPreview:(NSMutableArray*)inArgument
{
    if ([inArgument isKindOfClass:[NSMutableArray class]] /*&& [inArgument count] == 5 */&& !self.mgr.iscastVideoView)
    {
        if(!self.mgr.mRTCLiveObj)
        {
            NSLog(@"请先初始化");
            [self performSelectorOnMainThread:@selector(cbCastStatus:) withObject:@"ERROR:UNREGISTER" waitUntilDone:NO];
            return;
        }
    
        NSString * infoStr = [inArgument objectAtIndex:0];
        NSDictionary * dic = [infoStr JSONValue];
        self.mgr.x = [[dic objectForKey:@"x"] intValue];
        self.mgr.y = [[dic objectForKey:@"y"] intValue];
        self.mgr.width = [[dic objectForKey:@"w"]intValue];
        self.mgr.height = [[dic objectForKey:@"h"]intValue];
        NSString * infoStr2 = [inArgument objectAtIndex:1];
        NSDictionary * dic2 = [infoStr2 JSONValue];
        int w = [[dic2 objectForKey:@"w"]intValue];
        int h = [[dic2 objectForKey:@"h"]intValue];
        int frameRate = [[inArgument objectAtIndex:2] intValue];
        int cameraID = [[inArgument objectAtIndex:3] intValue];
        int codec = [[inArgument objectAtIndex:4] intValue];
        int onlyAudio = [[inArgument objectAtIndex:5] intValue];
        
        if (onlyAudio == 0)
        {
            NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithInt:self.mgr.x],@"x",
                                 [NSNumber numberWithInt:self.mgr.y],@"y",
                                 [NSNumber numberWithInt:self.mgr.width],@"w",
                                 [NSNumber numberWithInt:self.mgr.height],@"h",
                                 nil];
            [self showCastView:dic];
        }
        self.mgr.iscastVideoView = YES;
        [self.mgr.mRTCLiveObj startPreview:w height:h videoFramerate:frameRate cameraId:cameraID videoCodec:codec onlyAudio:onlyAudio localVideoWindow:self.mgr.castVideoView];
        [self performSelectorOnMainThread:@selector(cbCastStatus:) withObject:@"OK:PREVIEW" waitUntilDone:NO];
    }
    else
    {
        [self performSelectorOnMainThread:@selector(cbCastStatus:) withObject:@"ERROR:CAST_FAIL" waitUntilDone:NO];
    }
    
    return;
}

//开始直播
-(void)startCast:(NSMutableArray *)inArgument
{
    if ([inArgument isKindOfClass:[NSMutableArray class]] && [inArgument count] == 1 && self.mgr.iscastVideoView)
    {
        if(!self.mgr.mRTCLiveObj)
        {
            NSLog(@"请先初始化");
            [self performSelectorOnMainThread:@selector(cbCastStatus:) withObject:@"ERROR:UNREGISTER" waitUntilDone:NO];
            return;
        }
    
        NSString* channelID = @"EUExESurfingRtcLive";//[inArgument objectAtIndex:0];
        NSString* url = [inArgument objectAtIndex:0];
        
        int ret = [self.mgr.mRTCLiveObj startCast:channelID pushURL:[url UTF8String]];
        if (EC_OK != ret)
        {
            if(self.mgr.castVideoView)
            {
                [self.mgr.castVideoView removeFromSuperview];
                [self.mgr.castVideoView release];
                self.mgr.castVideoView = nil;
                self.mgr.iscastVideoView = NO;
            }
            
            NSLog(@"创建直播失败:%@",[RTCLive ECodeToStr:ret]);
            [self performSelectorOnMainThread:@selector(cbCastStatus:) withObject:@"ERROR:CAST_FAIL" waitUntilDone:NO];
            return;
        }
        else
            [self performSelectorOnMainThread:@selector(cbCastStatus:) withObject:@"OK:CASTING" waitUntilDone:NO];
    }
    else
    {
        [self performSelectorOnMainThread:@selector(cbCastStatus:) withObject:@"ERROR:CAST_FAIL" waitUntilDone:NO];
    }
    
    return;
}

//暂停直播
-(void)pauseCast:(NSMutableArray*)inArgument
{
    if ([inArgument isKindOfClass:[NSMutableArray class]] && [inArgument count] == 1)
    {
        if(!self.mgr.mRTCLiveObj)
        {
            NSLog(@"请先初始化");
            [self performSelectorOnMainThread:@selector(cbCastStatus:) withObject:@"ERROR:UNREGISTER" waitUntilDone:NO];
            return;
        }
        
        NSString* flag = [inArgument objectAtIndex:0];
        int arg = 0;
        if ([flag isEqualToString:@"true"])
        {
            arg = 1;
            [self performSelectorOnMainThread:@selector(cbCastStatus:) withObject:@"OK:PAUSE" waitUntilDone:NO];
        }
        else
        {
            arg = 0;
            [self performSelectorOnMainThread:@selector(cbCastStatus:) withObject:@"OK:CASTING" waitUntilDone:NO];
        }
        
        [self.mgr.mRTCLiveObj pauseCast:arg pauseJPG:NULL];
    }
}

//停止直播
-(void)stopCast:(NSMutableArray*)inArgument
{
    [self performSelectorOnMainThread:@selector(cbCastStatus:) withObject:@"OK:NORMAL" waitUntilDone:NO];
    if(!self.mgr.mRTCLiveObj)
    {
        NSLog(@"请先初始化");
        [self performSelectorOnMainThread:@selector(cbCastStatus:) withObject:@"ERROR:UNREGISTER" waitUntilDone:NO];
        return;
    }
    else
    {
        [self.mgr.mRTCLiveObj stopCast];
    }
    
    if(self.mgr.castVideoView)
    {
        [self.mgr.castVideoView removeFromSuperview];
        [self.mgr.castVideoView release];
        self.mgr.castVideoView = nil;
        self.mgr.iscastVideoView = NO;
    }
}

//静音
-(void)mute:(NSMutableArray*)inArgument
{
    if([inArgument isKindOfClass:[NSMutableArray class]] && [inArgument count] == 1)
    {
        if(!self.mgr.mRTCLiveObj)
        {
            NSLog(@"请先初始化");
            return;
        }
        
        NSString* flag = [inArgument objectAtIndex:0];
        int arg = 0;
        if ([flag isEqualToString:@"true"])
            arg = 1;
        else
            arg = 0;
        
        [self.mgr.mRTCLiveObj muteMic:arg];
    }
}

//切换摄像头
-(void)switchCamera:(NSMutableArray*)inArgument
{
//    if ([inArgument isKindOfClass:[NSMutableArray class]] && [inArgument count] == 1)
//    {
        if(!self.mgr.mRTCLiveObj)
        {
            NSLog(@"请先初始化");
            return;
        }
    
//        NSString* flag = [inArgument objectAtIndex:0];
//        int camera = 1;
//        if ([flag isEqualToString:@"front"])
//            camera = 1;
//        else
//            camera = 0;
    
        [self.mgr.mRTCLiveObj switchCamera];
    //}
}

//旋转摄像头
-(void)rotateCamera:(NSMutableArray*)inArgument
{
    if ([inArgument isKindOfClass:[NSMutableArray class]] && [inArgument count] == 1)
    {
        if(!self.mgr.mRTCLiveObj)
        {
            NSLog(@"请先初始化");
            return;
        }

        int mRotate = [[inArgument objectAtIndex:0] intValue];
        if (mRotate == 1)
            mRotate = 90;
        else if(mRotate == 2)
            mRotate = 180;
        else if(mRotate == 3)
            mRotate = 270;
        else
            mRotate = 0;
        
        [self.mgr.mRTCLiveObj rotateCamera:mRotate];
    }
}

//开始播放
-(void)startPlay:(NSMutableArray*)inArgument
{
    if ([inArgument isKindOfClass:[NSMutableArray class]] && [inArgument count] == 3 && !self.mgr.isplayVideoView)
    {
        if(!self.mgr.mRTCLiveObj)
        {
            NSLog(@"请先初始化");
            [self performSelectorOnMainThread:@selector(cbPlayStatus:) withObject:@"ERROR:UNREGISTER" waitUntilDone:NO];
            return;
        }
        
        NSString * infoStr = [inArgument objectAtIndex:0];
        NSDictionary * dic = [infoStr JSONValue];
        self.mgr.x1 = [[dic objectForKey:@"x"] intValue];
        self.mgr.y1 = [[dic objectForKey:@"y"] intValue];
        self.mgr.width1 = [[dic objectForKey:@"w"]intValue];
        self.mgr.height1 = [[dic objectForKey:@"h"]intValue];
        NSString* url = [inArgument objectAtIndex:1];
        self.mgr.onlyAudio = [[inArgument objectAtIndex:2] intValue];
        int ret = [self.mgr.mRTCLiveObj playMedia:url bounds:CGRectMake(0, 0, self.mgr.width1, self.mgr.height1)];
        if (ret == EC_OK)
        {
            [self performSelectorOnMainThread:@selector(cbPlayStatus:) withObject:@"OK:PLAYING" waitUntilDone:NO];
            self.mgr.isplayVideoView = YES;
        }
        else
        {
            if(self.mgr.playVideoView)
            {
                [self.mgr.playVideoView removeFromSuperview];
                [self.mgr.playVideoView release];
                self.mgr.playVideoView = nil;
            }
            self.mgr.isplayVideoView = NO;
            
            NSLog(@"播放失败");
            [self performSelectorOnMainThread:@selector(cbPlayStatus:) withObject:@"ERROR:PLAY_FAIL" waitUntilDone:NO];
            
            return;
        }
    }
    else
    {
        [self performSelectorOnMainThread:@selector(cbPlayStatus:) withObject:@"ERROR:PLAY_FAIL" waitUntilDone:NO];
    }
    
    return;
}

//暂停播放
-(void)pausePlay:(NSMutableArray*)inArgument
{
    if ([inArgument isKindOfClass:[NSMutableArray class]] && [inArgument count] == 1)
    {
        if(!self.mgr.mRTCLiveObj)
        {
            NSLog(@"请先初始化");
            [self performSelectorOnMainThread:@selector(cbPlayStatus:) withObject:@"ERROR:UNREGISTER" waitUntilDone:NO];
            return;
        }
        
        NSString* flag = [inArgument objectAtIndex:0];
        int arg = 0;
        if ([flag isEqualToString:@"true"])
        {
            arg = 1;
            [self.mgr.mRTCLiveObj pausePlayMedia];
            [self performSelectorOnMainThread:@selector(cbPlayStatus:) withObject:@"OK:PAUSE" waitUntilDone:NO];
        }
        else
        {
            arg = 0;
            [self.mgr.mRTCLiveObj resumePlayMedia];
            [self performSelectorOnMainThread:@selector(cbPlayStatus:) withObject:@"OK:PLAYING" waitUntilDone:NO];
        }
        
        [self.mgr.mRTCLiveObj pauseCast:arg  pauseJPG:NULL];
    }
}

//停止播放
-(void)stopPlay:(NSMutableArray*)inArgument
{
    [self performSelectorOnMainThread:@selector(cbPlayStatus:) withObject:@"OK:NORMAL" waitUntilDone:NO];
    if(!self.mgr.mRTCLiveObj)
    {
        NSLog(@"请先初始化");
        [self performSelectorOnMainThread:@selector(cbPlayStatus:) withObject:@"ERROR:UNREGISTER" waitUntilDone:NO];
        return;
    }
    else
    {
        [self.mgr.mRTCLiveObj stopPlayMedia];
    }
    
    if(self.mgr.playVideoView)
    {
        [self.mgr.playVideoView removeFromSuperview];
        [self.mgr.playVideoView release];
        self.mgr.playVideoView = nil;
    }
    self.mgr.isplayVideoView = NO;
}

-(void)createNotificationCentre {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playErr:) name:RTCLivePlayerPlaybackErrorNotification object:nil];//播放器发生错误
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playOver:) name:RTCLivePlayerPlaybackDidFinishNotification object:nil];//播放结束
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(castErr:) name:RTCLiveRtmpPushErrorNotification object:nil];//推流错误
}

//播放器发生错误
-(void)playErr:(NSNotification * )notification {
    NSArray* error = [notification.userInfo objectForKey:@"params"];
    if (error) {
        NSString * result = [error description];
        if (result) {
            [self performSelectorOnMainThread:@selector(cbPlayStatus:) withObject:[NSString stringWithFormat:@"ERROR:PLAYER_ERR,%@",result] waitUntilDone:NO];
        }
    }
}

//播放结束
-(void)playOver:(NSNotification * )notification {
    [self performSelectorOnMainThread:@selector(cbPlayStatus:) withObject:@"OK:FINISH" waitUntilDone:NO];
}

//推流错误
-(void)castErr:(NSNotification * )notification {
    [self performSelectorOnMainThread:@selector(cbCastStatus:) withObject:@"ERROR:CAST_CLOSE" waitUntilDone:NO];
}

- (void)showCastView:(NSDictionary *)paramDict
{
    if(self.mgr.castVideoView)
        return;
    
    float orgX = [[paramDict objectForKey:@"x"] floatValue];
    float orgY = [[paramDict objectForKey:@"y"] floatValue];
    float viewW = [[paramDict objectForKey:@"w"] floatValue];
    float viewH = [[paramDict objectForKey:@"h"] floatValue];
    
    self.mgr.castVideoView = [[UIView alloc]initWithFrame:CGRectMake(orgX, orgY, viewW, viewH)];
    self.mgr.castVideoView.backgroundColor = [UIColor blackColor];
    self.mgr.iscastVideoView = YES;
    //self.mgr.castVideoView.center = CGPointMake(viewW/2, viewH/2);
    [EUtility brwView: meBrwView  addSubview:self.mgr.castVideoView];
}

- (void)showPlayView:(NSDictionary *)paramDict view:(UIView*)view
{
    if(self.mgr.playVideoView)
        return;
    
    float orgX = [[paramDict objectForKey:@"x"] floatValue];
    float orgY = [[paramDict objectForKey:@"y"] floatValue];
    float viewW = [[paramDict objectForKey:@"w"] floatValue];
    float viewH = [[paramDict objectForKey:@"h"] floatValue];
    
    self.mgr.playVideoView = [[UIView alloc]initWithFrame:CGRectMake(orgX, orgY, viewW, viewH)];
    self.mgr.playVideoView.backgroundColor = [UIColor blackColor];
    self.mgr.isplayVideoView = YES;
    //self.mgr.playVideoView.center = CGPointMake(viewW/2, viewH/2);
    
    [self.mgr.playVideoView addSubview:view];
    [EUtility brwView: meBrwView  addSubview:self.mgr.playVideoView];
}

- (void)showJoinCastView:(NSDictionary *)paramDict {
    if(self.mgr.joinCastView)
    {
        [self.mgr.joinCastView removeFromSuperview];
        [self.mgr.joinCastView release];
        self.mgr.joinCastView = nil;
    }
    if(self.mgr.dapiview)
    {
        [self.mgr.dapiview removeFromSuperview];
        [self.mgr.dapiview release];
        self.mgr.dapiview = nil;
    }
    
    //    NSString *fixedOn = [paramDict stringValueForKey:@"fixedOn" defaultValue:nil];//frame名称
    //    BOOL fixed = [paramDict boolValueForKey:@"fixed" defaultValue:YES];//是否移动
    float orgX = [[paramDict objectForKey:@"x"] floatValue];
    float orgY = [[paramDict objectForKey:@"y"] floatValue];
    float viewW = [[paramDict objectForKey:@"w"] floatValue];
    float viewH = [[paramDict objectForKey:@"h"] floatValue];
    
    self.mgr.dapiview = [[DAPIPViewLive alloc] init:CGRectMake(orgX, orgY, viewW, viewH)];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        self.mgr.dapiview.borderInsets = UIEdgeInsetsMake(1.0f,       // top
                                                          1.0f,       // left
                                                          45.0f,      // bottom
                                                          1.0f);      // right
    }
    else
    {
        self.mgr.dapiview.borderInsets = UIEdgeInsetsMake(1.0f,       // top
                                                          1.0f,       // left
                                                          1.0f,       // bottom
                                                          1.0f);      // right
    }
    
    self.mgr.joinCastView = [RTCLive newJoinCastVideoWindow:self.mgr.dapiview.bounds];
    self.mgr.joinCastView.backgroundColor = [UIColor blackColor];
    self.mgr.joinCastView.center = CGPointMake(self.mgr.dapiview.bounds.size.width/2, self.mgr.dapiview.bounds.size.height/2);
    [self.mgr.dapiview addSubview:self.mgr.joinCastView];
    self.mgr.isjoinVideoView = YES;
    
    [EUtility brwView: meBrwView  addSubview:self.mgr.dapiview];
}

//得到直播已发送字节，单位KB
-(void)getKBSent:(NSMutableArray *)inArgument
{
    if(!self.mgr.mRTCLiveObj)
    {
        NSLog(@"请先初始化");
        return;
    }
    long ret =  [self.mgr.mRTCLiveObj getKBSent];
    [self performSelectorOnMainThread:@selector(onGlobalStatus:) withObject:[NSString stringWithFormat:@"getKBSent:%ld",ret] waitUntilDone:NO];
}

//得到直播缓存中字节，单位KB
-(void)getKBQueue:(NSMutableArray *)inArgument
{
    if(!self.mgr.mRTCLiveObj)
    {
        NSLog(@"请先初始化");
        return;
    }
    long ret = [self.mgr.mRTCLiveObj getKBQueue];
    [self performSelectorOnMainThread:@selector(onGlobalStatus:) withObject:[NSString stringWithFormat:@"getKBQueue:%ld",ret] waitUntilDone:NO];
}

//得到直播上传速率，单位KB/S
-(void)getKBitrate:(NSMutableArray *)inArgument
{
    if(!self.mgr.mRTCLiveObj)
    {
        NSLog(@"请先初始化");
        return;
    }
    long ret = [self.mgr.mRTCLiveObj getKBitrate];
    [self performSelectorOnMainThread:@selector(onGlobalStatus:) withObject:[NSString stringWithFormat:@"getKBitrate:%ld",ret] waitUntilDone:NO];
}

//得到直播时间，单位S
-(void)getTimeCast:(NSMutableArray *)inArgument
{
    if(!self.mgr.mRTCLiveObj)
    {
        NSLog(@"请先初始化");
        return;
    }
    long ret = [self.mgr.mRTCLiveObj getTimeCast];
    [self performSelectorOnMainThread:@selector(onGlobalStatus:) withObject:[NSString stringWithFormat:@"getTimeCast:%ld",ret] waitUntilDone:NO];
}

//直播状态
-(void)isConnected:(NSMutableArray *)inArgument
{
    if(!self.mgr.mRTCLiveObj)
    {
        NSLog(@"请先初始化");
        return;
    }
    long ret = [self.mgr.mRTCLiveObj isConnected];
    [self performSelectorOnMainThread:@selector(onGlobalStatus:) withObject:[NSString stringWithFormat:@"IsConnected:%d",(int)ret] waitUntilDone:NO];
}

/**
 *  得到当前点播播放时间
 *  @return position
 */
-(void)getPlayMediaPosition:(NSMutableArray *)inArgument
{
    if(!self.mgr.mRTCLiveObj)
    {
        NSLog(@"请先初始化");
        return;
    }
    float ret = [self.mgr.mRTCLiveObj getPlayMediaPosition];
    [self performSelectorOnMainThread:@selector(onGlobalStatus:) withObject:[NSString stringWithFormat:@"getPlayMediaPosition:%f",ret] waitUntilDone:NO];
}

/**
 *  设置当前点播时间，用于设置视频观看进度
 *  @return EC_OK或者错误码
 */
-(void)setPlayMediaPosition:(NSMutableArray *)inArgument
{
    if ([inArgument isKindOfClass:[NSMutableArray class]] && [inArgument count] == 1)
    {
        if(!self.mgr.mRTCLiveObj)
        {
            NSLog(@"请先初始化");
            return;
        }
        float pos = [[inArgument objectAtIndex:0] floatValue];
        [self.mgr.mRTCLiveObj setPlayMediaPosition:pos];
    }
}

/**
 *  连麦者发送连麦请求
 *
 *  @param remoteUri   主播ID
 *
 *  @return 错误码
 */
- (void)sendJoinCastRequest:(NSMutableArray *)inArgument
{
    if ([inArgument isKindOfClass:[NSMutableArray class]] && [inArgument count] == 2)
    {
        if(!self.mgr.mRTCLiveObj)
        {
            NSLog(@"请先初始化");
            return;
        }
        NSString* userID = [inArgument objectAtIndex:0];
        
        NSString * infoStr = [inArgument objectAtIndex:1];
        NSDictionary * dic = [infoStr JSONValue];
        self.mgr.x3 = [[dic objectForKey:@"x"] intValue];
        self.mgr.y3 = [[dic objectForKey:@"y"] intValue];
        self.mgr.width3 = [[dic objectForKey:@"w"]intValue];
        self.mgr.height3 = [[dic objectForKey:@"h"]intValue];
        
        if(self.mgr.width3 * self.mgr.height3 == 0)
            self.mgr.userView = 0;
        else
            self.mgr.userView = 1;
        
        int ret = [self.mgr.mRTCLiveObj sendJoinCastRequest:userID remoteTerminalType:TERMINAL_TYPE_ANY remoteAccType:ACCTYPE_APP];
        [self performSelectorOnMainThread:@selector(onGlobalStatus:) withObject:[NSString stringWithFormat:@"JoinCast:sendRequest,code=%d",ret] waitUntilDone:NO];
    }
}

/**
 *  主播实施连麦
 *
 *  @param remoteUri   连麦者ID
 *  @param joinType 连麦类型：0 audio; 1 audio+video
 *  @return 错误码
 */
- (void)joinCast:(NSMutableArray *)inArgument
{
    if ([inArgument isKindOfClass:[NSMutableArray class]] /*&& [inArgument count] == 2*/)
    {
        if(!self.mgr.mRTCLiveObj)
        {
            NSLog(@"请先初始化");
            return;
        }
        if(self.mgr.isjoinVideoView)
            return;
        NSString* userID = [inArgument objectAtIndex:0];
        if(!userID || [userID isEqualToString:@""])
        {
            [self performSelectorOnMainThread:@selector(onGlobalStatus:) withObject:[NSString stringWithFormat:@"JoinCast:onDisconnect,code=%d",EC_PARAM_WRONG] waitUntilDone:NO];
            return;
        }
        int joinType = [[inArgument objectAtIndex:1] intValue];
        self.mgr.userView = [[inArgument objectAtIndex:2] intValue];
        
        if(joinType == 1 && self.mgr.userView)
        {
            NSString * infoStr = [inArgument objectAtIndex:3];
            NSDictionary * dic = [infoStr JSONValue];
            self.mgr.x2 = [[dic objectForKey:@"x"] intValue];
            self.mgr.y2 = [[dic objectForKey:@"y"] intValue];
            self.mgr.width2 = [[dic objectForKey:@"w"]intValue];
            self.mgr.height2 = [[dic objectForKey:@"h"]intValue];
            NSDictionary* dic2 = [NSDictionary dictionaryWithObjectsAndKeys:
                         [NSNumber numberWithInt:self.mgr.x2],@"x",
                         [NSNumber numberWithInt:self.mgr.y2],@"y",
                         [NSNumber numberWithInt:self.mgr.width2],@"w",
                         [NSNumber numberWithInt:self.mgr.height2],@"h",
                         nil];
            [self showJoinCastView:dic2];
            [self.mgr.dapiview setHidden:YES];
            [self.mgr.joinCastView setHidden:YES];
        }
        
        self.mgr.isjoinVideoView = YES;
        self.mgr.isAnchorman = 1;
        int ret = [self.mgr.mRTCLiveObj doJoinCast:userID joinType:joinType remoteTerminalType:TERMINAL_TYPE_ANY remoteAccType:ACCTYPE_APP];
        
        if (EC_OK > ret)
        {
            if(self.mgr.joinCastView)
            {
                [self.mgr.joinCastView removeFromSuperview];
                [self.mgr.joinCastView release];
                self.mgr.joinCastView = nil;
            }
            self.mgr.isjoinVideoView = NO;
            if(self.mgr.dapiview)
            {
                [self.mgr.dapiview removeFromSuperview];
                [self.mgr.dapiview release];
                self.mgr.dapiview = nil;
            }
            
            [self performSelectorOnMainThread:@selector(onGlobalStatus:) withObject:[NSString stringWithFormat:@"JoinCast:onDisconnect,code=%d",EC_PARAM_WRONG] waitUntilDone:NO];
        }
    }
}

/**
 *  停止连麦（主播或连麦者都可调用）
 *  @return 错误码
 */
-(void)stopJoinCast:(NSMutableArray*)inArgument
{
    if(!self.mgr.mRTCLiveObj)
    {
        NSLog(@"请先初始化");
        return;
    }
    [self.mgr.mRTCLiveObj doStopJoinCast];
    
    if(self.mgr.joinCastView)
    {
        [self.mgr.joinCastView removeFromSuperview];
        [self.mgr.joinCastView release];
        self.mgr.joinCastView = nil;
    }
    self.mgr.isjoinVideoView = NO;
    if(self.mgr.dapiview)
    {
        [self.mgr.dapiview removeFromSuperview];
        //[self.mgr.dapiview release];
        //self.mgr.dapiview = nil;
    }
}

@end
