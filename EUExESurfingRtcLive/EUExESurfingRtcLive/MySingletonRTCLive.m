//
//  MySingletonRTCLive.m
//  DEMO
//
//  Created by cc on 15/11/4.
//  Copyright © 2015年 hexc. All rights reserved.
//

#import "MySingletonRTCLive.h"

@implementation MySingletonRTCLive

+ (instancetype)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static MySingletonRTCLive *sharedObject = nil;
    dispatch_once(&pred, ^{
        sharedObject = [[self alloc] init];
    });
    
    return sharedObject;
}

-(instancetype)init{
    self=[super init];
    if(self){
        //初始化变量
        self.iscastVideoView = NO;
        self.isplayVideoView = NO;
        self.isjoinVideoView = NO;
        self.userID = @"";
        [self.userID retain];
        self.userKey = @"";
        [self.userKey retain];
        self.appKey = @"";
        [self.appKey retain];
        self.appID = @"";
        [self.appID retain];
        self.accID = @"";
        [self.accID retain];
        self.accKey = @"";
        [self.accKey retain];
        self.x = 0;
        self.y = 0;
        self.width = 0;
        self.height = 0;
        self.x1 = 0;
        self.y1 = 0;
        self.width1 = 0;
        self.height1 = 0;
        self.x2 = 0;
        self.y2 = 0;
        self.width2 = 0;
        self.height2 = 0;
        self.x3 = 0;
        self.y3 = 0;
        self.width3 = 0;
        self.height3 = 0;
        self.isAnchorman = 0;
        self.mRTCLiveObj = nil;
        self.userView = 0;
        self.callBackDispatchQueue=dispatch_queue_create("gcd.uexESurfingRtcCallBackDispatchQueue",NULL);
        
//        NSString* islog = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"enablelog"];
//        if([islog isEqualToString:@"1"])
//            initCWDebugLog();
        
        //注册本地推送
//        if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]&&[[[UIDevice currentDevice]systemVersion]floatValue]>=8.0)
//        {
//            [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
//            NSLog(@"registerUserNotificationSettings");
//        }
        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBackgroundNotification:) name:UIApplicationDidEnterBackgroundNotification object:nil];
//        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterForegroundNotification:) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    
    return self;
}

-(void)cbLogStatus:(NSString*)senser
{
    NSString* jsString = [NSString stringWithFormat:@"uexESurfingRtcLive.cbLogStatus(\"0\",\"0\",\'%@\');",senser];
    dispatch_async(self.callBackDispatchQueue, ^(void){
        [EUtility evaluatingJavaScriptInRootWnd:jsString];
    });
}

-(void)cbGetChannel:(NSString*)senser
{
    NSString* jsString = [NSString stringWithFormat:@"uexESurfingRtcLive.cbGetChannel(\"0\",\"0\",\'%@\');",senser];
    dispatch_async(self.callBackDispatchQueue, ^(void){
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
    dispatch_async(self.callBackDispatchQueue, ^(void){
        [EUtility evaluatingJavaScriptInRootWnd:jsString];
    });
}

-(void)onDoAccept:(NSString*)senser
{
    [[NSNotificationCenter defaultCenter]  postNotificationName:@"DOACCEPT_EVENT" object:nil];
}

-(void)onShowPlayview:(UIView*)senser
{
    [[NSNotificationCenter defaultCenter]  postNotificationName:@"SHOWPLAYVIEW_EVENT" object:senser];
}

- (void)onSDKInit
{
    if (self.mRTCLiveObj)
    {
        [self.mRTCLiveObj release];
        self.mRTCLiveObj = nil;
    }
    
    signal(SIGPIPE, SIG_IGN);
    self.mRTCLiveObj = [[RTCLive alloc]init];
    [self.mRTCLiveObj setDelegate:self];//必须设置回调代理，否则无法执行回调
    [self.mRTCLiveObj loginRtcCloud:self.appID appKey:self.appKey usrId:self.userID usrKey:self.userKey];
}

-(void)setLog:(NSString*)log
{
    //回调信息；
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"mm:ss"];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateFormat setLocale:usLocale];
    [usLocale release];
    NSString* datestr = [dateFormat stringFromDate:[NSDate date]];
    [dateFormat release];
    
    NSLog(@"SDKTEST:%@:%@",datestr,log);
    NSString* strs = [NSString stringWithFormat:@"%@:%@",datestr,log];
    NSLog(@"++++==>>>%@",strs);
}

#pragma mark - UIActionSheetDelegate
//导航结果回调
-(void)onNavigationResp:(int)code error:(NSString*)error
{
    //[self performSelectorOnMainThread:@selector(onGlobalStatus:) withObject:[NSString stringWithFormat:@"ClientListener:onInit,result=%d",code] waitUntilDone:NO];
    
    if([error hasPrefix:@"getLiveChannel"])
    {
        if(0 == code)
        {
            NSArray* arr = [error componentsSeparatedByString:@"getLiveChannel pushurl:"];
            arr = [arr[1] componentsSeparatedByString:@",playurl:"];
            NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 arr[0],@"pushurl",
                                 arr[1],@"playurl",
                                 nil];
            NSError *parseError = nil;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
            NSString* jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
            NSRange range = {0,jsonString.length};
            [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
            NSRange range2 = {0,mutStr.length};
            [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
            NSRange range3 = {0,mutStr.length};
            [mutStr replaceOccurrencesOfString:@"\\" withString:@"" options:NSLiteralSearch range:range3];
            [self performSelectorOnMainThread:@selector(cbGetChannel:) withObject:[NSString stringWithFormat:@"OK:url=%@",mutStr] waitUntilDone:NO];
        }
        else
        [self performSelectorOnMainThread:@selector(cbGetChannel:) withObject:[NSString stringWithFormat:@"ERROR:%d",code] waitUntilDone:NO];
    }
    else
    {
        if (0 == code)
        {
            if(error)
            {
                [self performSelectorOnMainThread:@selector(cbLogStatus:) withObject:@"OK:LOGIN" waitUntilDone:NO];
            }
        }
        else
        {
            [self performSelectorOnMainThread:@selector(cbLogStatus:) withObject:[NSString stringWithFormat:@"ERROR:%d",code] waitUntilDone:NO];
            if (self.mRTCLiveObj)
            {
                [self.mRTCLiveObj release];
                self.mRTCLiveObj = nil;
            }
        }
//        if(code == -1001)//没有网络
//            [self performSelectorOnMainThread:@selector(onGlobalStatus:) withObject:@"StateChanged,result=-1001" waitUntilDone:NO];
//        else if(code == -1002)//切换网络
//            [self performSelectorOnMainThread:@selector(onGlobalStatus:) withObject:@"StateChanged,result=-1002" waitUntilDone:NO];
//        else if(code == -1003)//网络差
//            [self performSelectorOnMainThread:@selector(onGlobalStatus:) withObject:@"StateChanged,result=-1003" waitUntilDone:NO];
//        else if(code == -1004)//重连失败需要重登录
//            [self performSelectorOnMainThread:@selector(onGlobalStatus:) withObject:@"StateChanged,result=-1004" waitUntilDone:NO];
    }
}

//申请连麦到达回调
//param形如:
//{
//    "call.er" = "10-1446013949~70038~Browser";
//    "call.type" = "text/plain";
//}
-(int)onReceiveJoinCastRequest:(NSDictionary*)param
{
    //NSString* mime = [param objectForKey:KEY_CALL_TYPE];
    NSString* uri = [param objectForKey:KEY_CALLER];
    
    const char* cacc = [uri UTF8String];
    int strindex1=0,strindex2=0;
    int l = (int)strlen(cacc);
    for(int i = 0;i<l;i++)
    {
        if(cacc[i]=='-')
        {
            strindex1=i;
            break;
        }
    }
    for(int i = 0;i<l;i++)
    {
        if(cacc[i]=='~')
        {
            strindex2=i;
            break;
        }
    }
    NSString* accNum = [[NSString stringWithUTF8String:cacc] substringWithRange:NSMakeRange(strindex1+1, strindex2-strindex1-1)];//解析出的来电号码
    [self performSelectorOnMainThread:@selector(onGlobalStatus:) withObject:[NSString stringWithFormat:@"JoinCast:receiveRequest=%@",accNum] waitUntilDone:NO];
    
    return 0;
}

//连麦状态回调
-(int)onJoinCastStatus:(SDK_CALLBACK_TYPE)type code:(int)code
{
    //常见连麦code码含义：
    //404：被连麦端的账号不存在
    //408：本地或对端网络异常
    //480：被连麦端未登录，或网络断开了
    //487：发起连麦后被连麦端网络断开，或是连麦过程中对端挂断，或是收到连麦后连麦端挂断。
    //603：发起连麦后被连麦端挂断，或是收到连麦后连麦端网络断开
    
    //不同事件类型见SDK_CALLBACK_TYPE
    if(type == SDK_CALLBACK_RING)
    {
        [self performSelectorOnMainThread:@selector(onGlobalStatus:) withObject:@"JoinCast:onConnecting" waitUntilDone:NO];
    }
    else if (type == SDK_CALLBACK_ACCEPTED)
    {
        if(code == 1)
        {
            [self performSelectorOnMainThread:@selector(onDoAccept:) withObject:nil waitUntilDone:NO];
        }
        else if(code == 200)
        {
            [self.dapiview setHidden:NO];
            [self.joinCastView setHidden:NO];
        }
        [self performSelectorOnMainThread:@selector(onGlobalStatus:) withObject:@"JoinCast:onConnected" waitUntilDone:NO];
    }
    else
    {
        if(self.joinCastView)
        {
            [self.joinCastView removeFromSuperview];
            [self.joinCastView release];
            self.joinCastView = nil;
        }
        self.isjoinVideoView = NO;
        if(self.dapiview)
        {
            [self.dapiview removeFromSuperview];
            //            [self.dapiview release];
            //            self.dapiview = nil;
        }
        [self performSelectorOnMainThread:@selector(onGlobalStatus:) withObject:[NSString stringWithFormat:@"JoinCast:onDisconnect,code=%d",code] waitUntilDone:NO];
        
        
    }
    return 0;
}

/**
 *  设置连麦窗口回调，主播和连麦者都会收到此回调，用来设置各自所需窗口：
 *  连麦者：设置本地视频预览窗口（视频连麦需要设置，音频连麦不需要设置）
 *  主播：设置显示远端连麦者视频的窗口（视频连麦需要设置，音频连麦不需要设置）,可设置为NULL，则不显示连麦者画面
 *  @return 错误码
 */
-(int)onJoinCastNeedVideoWindow
{
    if(!self.userView)
    {
        [self.mRTCLiveObj doSetJoinCastVideoWindow:NULL];
        return 0;
    }
    
//    if (self.isAnchorman == 0) {
//        [self.mRTCLiveObj doSetJoinCastVideoWindow:(__bridge void*)self.playVideoView];
//    } else {
        [self.mRTCLiveObj doSetJoinCastVideoWindow:(__bridge void*)self.joinCastView];
    //}
    
    return 0;
}

/**
 *  调用playMedia:(NSString *)mediaPath bounds:(CGRect)bounds函数之后的回调函数，设置当前视频的duration，单位秒
 *  @return 错误码
 */
-(int)onPlayMediaDurationAvailable:(NSTimeInterval)duration
{
    [self performSelectorOnMainThread:@selector(onGlobalStatus:) withObject:[NSString stringWithFormat:@"getPlayMediaDuration:%f",duration] waitUntilDone:NO];
    
    return 0;
}

-(int)onPlayMediaViewAvailable:(UIView*)view
{
    NSLog(@"onPlayMediaViewAvailable");
    [self performSelectorOnMainThread:@selector(onShowPlayview:) withObject:view waitUntilDone:NO];
    
    return 0;
}

@end
