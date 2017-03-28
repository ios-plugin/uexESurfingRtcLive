/*

Sort: 26
Toc: 1
Tips: 天翼RTC云直播
keywords: appcan开发文档,插件API,uexESurfingRtcLive 
description: uexESurfingRtcLive插件封装了天翼RTC云直播产品的SDK，使用此模块可轻松实现直播功能。
天翼RTC平台官方网站：http://www.chinartc.com/dev/ 
天翼RTC开发者支持QQ群：172898609
天翼RTC公有云咨费标准：http://www.chinartc.com/dev/rtcweb/price.html
更多appcan开发文档，请见http://newdocx.appcan.cnShow: /newdocx/docx?type=1468_975

*/
- [1、简介](#-1-http-appcan-download-oss-cn-beijing-aliyuncs-com-e5-85-ac-e6-b5-8b-2fgf-png-ignore- "1、简介")
- [2、API概览](#-2-api-ignore- "2、API概览")
- [3、更新历史](#-4-ignore- "更新历史")

**附录：**- [错误码](#-3-errorcode- "错误码")
#### **1、简介 ** <ignore> 
天翼RTC直播插件
###### **1.1、说明**<ignore>
 天翼RTC云直播，是中国电信基于优势的网络与云资源打造的云直播产品，为企业客户提供各种场景下端到端的互联网直播产品。
 uexESurfingRtcLive插件封装了天翼RTC云直播产品的SDK，使用此模块可轻松实现直播功能。

天翼RTC平台官方网站：[http://www.chinartc.com/dev/](http://www.chinartc.com/dev/)

天翼RTC开发者支持QQ群：172898609（含示例代码下载）

天翼RTC云直播资费标准：请进入开发者支持群咨询

请开发者进入门户提交资料并接受平台审核，审核通过后将获得appId及appKey。
若开发者同时接入tyRTC以及tyRTCLive模块，同时使用音视频通信以及直播功能，请申请两套appId及appKey，分别用于音视频通信和直播，不能混用。

请使用iOS8+定制引擎打包，否则会导致打包失败。  

###### ** 1.2、开源源码**<ignore>
插件测试用例与源码下载：[点击](http://plugin.appcan.cn/details.html#720_index)插件中心至插件详情页  

#### **2、API概览**<ignore>

###### **2.1、方法**<ignore>
>###### **login //设置应用程序的appKey和appId，并登录直播云平台**

`uexESurfingRtcLive.login(appID, appKey, accID, accKey, userID)`

**说明:**

登录直播云平台，回调方法[cbLogStatus](#-cblogstatus-) 

**参数:**

|  参数名称 | 参数类型  | 是否必选  |  说明 |
| ------------ | ------------ | ------------ | ------------ |
| appID | String | 是 | 从RTC平台申请的appId |
| appKey | String | 是 | 从RTC平台申请的appKey |
| accID | String | 是 | RTC分配的直播应用ID，每个直播应用分配不同的应用ID（此参数暂不支持从门户获取，请进入开发者群咨询） |
| accKey | String | 是 | RTC分配的直播应用Key，与accID成对获取 |
| userID | String | 是 | 用户自定义登录账号，不能为空，账号不可包含“~”、“-”、空格、中文字符。|

**平台支持:**

iOS8.0+

**版本支持:**

3.0.0+

**示例:**

```js
var appKey = "123";
var appID = "123456";
var accID = "myacc";
var accKey = "mykey";
var userID = "001";
uexESurfingRtcLive.login(appID,appKey,accID,accKey,userID);
```
>###### **logout //退出RTC平台**

`uexESurfingRtc.logout()`

**说明:**

从RTC平台注销，回调方法[cbLogStatus](#-cblogstatus-) 

**参数:**

无

**平台支持:**

iOS8.0+

**版本支持:**

3.0.0+

**示例:**

```
uexESurfingRtcLive.logout(); 
```
>###### **getLiveChannel //获取推流和播放地址**

`uexESurfingRtcLive.getLiveChannel()`

**说明:**

获取推流和播放地址，回调方法[cbGetChannel](#-cbgetchannel-) 
登录成功之后才能调用此接口，得到推流和播放地址后请应用层做好缓存

**参数:**

无

**平台支持:**

iOS8.0+

**版本支持:**

3.0.0+

**示例:**

```js
uexESurfingRtcLive.getLiveChannel();
```
>###### **startPreview //直播预览**

`uexESurfingRtcLive.startPreview(castView, resolution, frameRate, cameraID, codec, onlyAudio)`

**说明:**

直播预览，回调方法[cbCastStatus](#-cbcaststatus-)

**参数:**

|  参数名称 | 参数类型  | 是否必选  |  说明 |
| ------------ | ------------ | ------------ | ------------ |
| castView | String | 是 | 直播视频窗口位置和大小数据 |
| resolution | String | 是 | 视频分辨率 |
| frameRate | Number | 是 | 帧率 |
| cameraID | Number | 是 | 摄像头ID，0为后置摄像头，1为前置摄像头 |
| codec | Number | 是 | 编码器选择，0为硬件编码，1为软件编码 |
| onlyAudio | Number | 是 | 是否纯音频，0为音+视频，1为纯音频 |
castView为一json字符串，格式为：
````
  {"x":"100", "y":"100", "w":"144", "h":"176"}
````
|  参数名称 |  说明 |
| ------------ | ------------ |
| x | 窗口起始x坐标 |
| y | 窗口起始y坐标 |
| w | 窗口宽度 |
| h | 窗口高度 |

resolution为一json字符串，格式为：
````
  {"w":"144", "h":"192"}
````
|  参数名称 |  说明 |
| ------------ | ------------ |
| w | 分辨率宽 |
| h | 分辨率高 |
w*h或h*w的取值范围如下:192x144/352x288/480x360/640x360/640x480/704x576/960x540/1280x720/1280x960/1920x1080

**平台支持:**

iOS8.0+

**版本支持:**

3.0.0+

**示例:**

```js
var jsonObj1 = {};
jsonObj1.x = 50;
jsonObj1.y = 100;
jsonObj1.w = 144;
jsonObj1.h = 176;
var jsonObj2 = {};
jsonObj2.w = 144;
jsonObj2.h = 192;
var frameRate = 24;
var cameraID = 0;
var codec = 0;
var onlyAudio = 0;
uexESurfingRtcLive.startPreview(JSON.stringify(jsonObj1), JSON.stringify(jsonObj2), frameRate, cameraID, codec, onlyAudio);
```
>###### **startCast //开始直播**

`uexESurfingRtcLive.startCast(url)`

**说明:**

开始直播，开始直播前需要先调用直播预览，回调方法[cbCastStatus](#-cbcaststatus-)

**参数:**

|  参数名称 | 参数类型  | 是否必选  |  说明 |
| ------------ | ------------ | ------------ | ------------ |
| url | String | 是 | getLiveChannel获取的直播推流地址 |

**平台支持:**

iOS8.0+

**版本支持:**

3.0.0+

**示例:**

```
uexESurfingRtcLive.startCast(url);
```
>###### **stopCast //结束直播**

`uexESurfingRtcLive.stopCast()`

**说明:**

结束直播，回调方法[cbCastStatus](#-cbcaststatus-)

**参数:**

无

**平台支持:**

iOS8.0+

**版本支持:**

3.0.0+

**示例:**

```
uexESurfingRtcLive.stopCast();
```
>###### **pauseCast //暂停直播**

`uexESurfingRtcLive.pauseCast(value)`

**说明:**

暂停直播，回调方法[cbCastStatus](#-cbcaststatus-)

**参数:**

|  参数名称 | 参数类型  | 是否必选  |  说明 |
| ------------ | ------------ | ------------ | ------------ |
| value | String | 是 | "true"：暂停；"false"：继续|

**平台支持:**

iOS8.0+

**版本支持:**

3.0.0+

**示例:**

```
uexESurfingRtcLive.pauseCast("true");
```
>###### **startPlay //开始播放**
 
`uexESurfingRtcLive.startPlay(playView, url, onlyAudio)`

**说明:**

开始播放，此过程为同步过程，回调方法[cbPlayStatus](#-cbplaystatus-)

**参数:**

|  参数名称 | 参数类型  | 是否必选  |  说明 |
| ------------ | ------------ | ------------ | ------------ |
| playView | String | 是 | 播放直播视频窗口位置和大小数据 |
| url | String | 是 | getLiveChannel获取的观看地址，不能为空 |
| onlyAudio | Number | 是 | 是否播放纯音频，0为音+视频，1为纯音频 |
playView为一json字符串，格式为：
````
  {"x":"100", "y":"100", "w":"144", "h":"176"}
````
|  参数名称 |  说明 |
| ------------ | ------------ |
| x | 窗口起始x坐标 |
| y | 窗口起始y坐标 |
| w | 窗口宽度 |
| h | 窗口高度 |

**平台支持:**

iOS8.0+

**版本支持:**

3.0.0+

**示例:**

```
var jsonObj2 = {};
jsonObj2.x = 150;
jsonObj2.y = 100;
jsonObj2.w = 144;
jsonObj2.h = 176;
var jsonStr = JSON.stringify(jsonObj2);
var onlyAudio = 0;
uexESurfingRtcLive.startPlay(jsonStr, url, onlyAudio);
```
>###### **stopPlay //结束播放**

`uexESurfingRtcLive.stopPlay()`

**说明:**

结束播放，回调方法[cbPlayStatus](#-cbplaystatus-)

**参数:**

无

**平台支持:**

iOS8.0+

**版本支持:**

3.0.0+

**示例:**

```
uexESurfingRtcLive.stopPlay();
```
>###### **mute //设置静音/取消静音接口**
 
`uexESurfingRtcLive.mute(value)`

**说明:**

设置静音/取消静音接口

**参数:**

|  参数名称 | 参数类型  | 是否必选  |  说明 |
| ------------ | ------------ | ------------ | ------------ |
| value | String | 是 | "true"：静音；"false"：取消静音|

**平台支持:**

iOS8.0+

**版本支持:**

3.0.0+

**示例:**

```
uexESurfingRtcLive.mute("true");
```
>###### **switchCamera //切换摄像头接口**
 
`uexESurfingRtcLive.switchCamera()`

**说明:**

切换前后置摄像头

**参数:**

无

**平台支持:**

iOS8.0+

**版本支持:**

3.0.0+

**示例:**

```
uexESurfingRtcLive.switchCamera();
```
>###### **rotateCamera //旋转摄像头接口**
 
`uexESurfingRtcLive.rotateCamera(value)`

**说明:**

旋转摄像头

**参数:**

|  参数名称 | 参数类型  | 是否必选  |  说明 |
| ------------ | ------------ | ------------ | ------------ |
| value | Number | 是 | 画面逆时针旋转。0：旋转0度；1：旋转90度；2：旋转180度，3：旋转270度|

**平台支持:**

iOS8.0+

**版本支持:**

3.0.0+

**示例:**

```
uexESurfingRtcLive.rotateCamera(1);
```
>###### **GetKBSent //获取已发送的数据大小**
 
`uexESurfingRtcLive.getKBSent()`

**说明:**

获取已发送的数据大小，单位KB，回调方法[onGlobalStatus](#-onGlobalStatus-)
 
**参数:**

无

**平台支持:**

iOS8.0+

**版本支持:**

3.0.0+

**示例:**

```
uexESurfingRtcLive.getKBSent();
```
>###### **GetKBQueue //获取缓存中数据大小**
 
`uexESurfingRtcLive.getKBQueue()`

**说明:**

获取缓存中数据大小，单位KB，回调方法[onGlobalStatus](#-onGlobalStatus-) 

**参数:**

无

**平台支持:**

iOS8.0+

**版本支持:**

3.0.0+

**示例:**

```
uexESurfingRtcLive.getKBQueue();
```
>###### **GetKBitrate //获取发送速率**
 
`uexESurfingRtcLive.getKBitrate()`

**说明:**

获取发送速率，单位KB/S，回调方法[onGlobalStatus](#-onGlobalStatus-) 

**参数:**

无

**平台支持:**

iOS8.0+

**版本支持:**

3.0.0+

**示例:**

```
uexESurfingRtcLive.getKBitrate();
```
>###### **GetTimeCast //获取直播时间**
 
`uexESurfingRtcLive.getTimeCast()`

**说明:**

获取直播时间，单位秒，回调方法[onGlobalStatus](#-onGlobalStatus-) 

**参数:**

无

**平台支持:**

iOS8.0+

**版本支持:**

3.0.0+

**示例:**

```
uexESurfingRtcLive.getTimeCast();
```
>###### **IsConnected //获取直播连接或断开状态**
 
`uexESurfingRtcLive.isConnected()`

**说明:**

获取直播连接或断开状态，回调方法[onGlobalStatus](#-onGlobalStatus-) 

**参数:**

无

**平台支持:**

iOS8.0+

**版本支持:**

3.0.0+

**示例:**

```
uexESurfingRtcLive.isConnected();
```
>###### **getPlayMediaPosition //得到当前点播播放时间**
 
`uexESurfingRtcLive.getPlayMediaPosition()`

**说明:**

得到当前点播播放时间，单位秒，回调方法[onGlobalStatus](#-onGlobalStatus-) 

**参数:**

无

**平台支持:**

iOS8.0+

**版本支持:**

3.0.0+

**示例:**

```
uexESurfingRtcLive.getPlayMediaPosition();
```
>###### **setPlayMediaPosition //设置当前点播时间**
 
`uexESurfingRtcLive.setPlayMediaPosition(position)`

**说明:**

设置当前点播时间，用于设置视频观看进度

**参数:**

|  参数名称 | 参数类型  | 是否必选  |  说明 |
| ------------ | ------------ | ------------ | ------------ |
| position | Number | 是 | 浮点型，点播时间|

**平台支持:**

iOS8.0+

**版本支持:**

3.0.0+

**示例:**

```
uexESurfingRtcLive.setPlayMediaPosition(0.0);
```
###### **2.2、监听方法**<ignore>
>###### **onGlobalStatus //监听客户端全局状态的回调函数**

`uexESurfingRtcLive.onGlobalStatus(opId, dataType, data)`

**参数:**

|  参数名称 | 参数类型  | 是否必选  |  说明 |
| ------------ | ------------ | ------------ | ------------ |
| opId | Number | 是 |  操作ID，在此函数中不起作用，可忽略 |
| dataType| Number | 是 | 数据类型String标识，可忽略 |
| data | String | 是 | 返回客户端实时状态，详情如下：<br>"getKBSent:":得到直播已发送字节<br>"getKBQueue":得到直播缓存中字节<br>"getKBitrate":得到直播上传速率<br>"getTimeCast":得到直播时间<br>"isConnected":得到直播状态<br>"getPlayMediaPosition:xx":得到当前播放时间<br>"getPlayMediaDuration:xx":得到视频总长度|

**版本支持:**

3.0.0+

**示例：**

```
uexESurfingRtcLive.onGlobalStatus = updateGlobalStatus;

function updateGlobalStatus(opCode, dataType, data){
        document.getElementById('globalStatus').innerHTML = data;
    } 
```
###### **2.2、回调方法**<ignore>
>###### **cbLogStatus //客户端注册至RTC平台的回调函数**
 
`uexESurfingRtcLive.cbLogStatus(opId, dataType, data)`

**参数:**

|  参数名称 | 参数类型  | 是否必选  |  说明 |
| ------------ | ------------ | ------------ | ------------ |
| opId | Number | 是 |  操作ID，在此函数中不起作用，可忽略 |
| dataType| Number | 是 | 数据类型String标识，可忽略 |
| data | String | 是 | 返回客户端注册至RTC平台的结果，详情如下：<br>"OK:LOGIN":登录成功<br>“OK:LOGOUT”:注销成功<br>"ERROR:PARM_ERROR":登录参数有误 <br>"ERROR:error_msg":error_msg为其他错误信息|

**版本支持:**

3.0.0+

**示例：**

```
uexESurfingRtcLive.cbLogStatus = updateLogStatus;

function updateLogStatus(opCode, dataType, data){
        document.getElementById('globalStatus').innerHTML = data;
    } 
```
>###### **cbGetChannel //获取推流和播放地址的回调函数**
 
`uexESurfingRtcLive.cbGetChannel(opId, dataType, data)`

**参数:**

|  参数名称 | 参数类型  | 是否必选  |  说明 |
| ------------ | ------------ | ------------ | ------------ |
| opId | Number | 是 |  操作ID，在此函数中不起作用，可忽略 |
| dataType| Number | 是 | 数据类型String标识，可忽略 |
| data | String | 是 | 返回获取推流和播放地址的结果，详情如下：<br>“OK:url={"pushurl":"xx","playurl":"xx"}”:获取推流和播放地址，通过json返回<br>“ERROR:UNREGISTER”：未注册至RTC平台<br>"ERROR:error_msg":error_msg为其他错误信息|

**版本支持:**

3.0.0+

**示例：**

```
uexESurfingRtcLive.cbGetChannel = updateGetChannel;

function updateGetChannel(opCode, dataType, data){
        document.getElementById('globalStatus').innerHTML = data;
    } 
```
>###### **cbCastStatus //直播状态的回调函数**

`uexESurfingRtcLive.cbCastStatus(opId, dataType, data)`

**参数:**

|  参数名称 | 参数类型  | 是否必选  |  说明 |
| ------------ | ------------ | ------------ | ------------ |
| opId | Number | 是 |  操作ID，在此函数中不起作用，可忽略 |
| dataType| Number | 是 | 数据类型String标识，可忽略|
| data | String | 是 | 返回直播的结果，详情如下：<br>"OK:NORMAL"：正常状态（未在直播）<br>“OK:PREVIEW”：预览状态，未开始直播<br>“OK:CASTING”：直播中<br>“OK:PAUSE”：暂停直播<br>"ERROR:CAST_FAIL"：发起预览或发起推流失败<br>"ERROR:CAST_CLOSE"：推流异常断开<br>"ERROR:UNREGISTER"：未注册至RTC平台|

**版本支持:**

3.0.0+

**示例：**

```
uexESurfingRtcLive.cbCastStatus = updateCastStatus;

function updateCastStatus(opCode, dataType, data){
        document.getElementById('globalStatus').innerHTML = data;
    } 
```
>###### **cbPlayStatus //播放状态的回调函数**
 
`uexESurfingRtcLive.cbPlayStatus(opId, dataType, data)`

**参数:**

|  参数名称 | 参数类型  | 是否必选  |  说明 |
| ------------ | ------------ | ------------ | ------------ |
| opId | Number | 是 |  操作ID，在此函数中不起作用，可忽略 |
| dataType| Number | 是 | 数据类型String标识，可忽略 |
| data | String | 是 | 返回播放的结果，详情如下：<br>"OK:NORMAL"：正常状态（未在播放）<br>“OK:PLAYING”：正在打开视频或播放中<br>“OK:PAUSE”：暂停播放<br>“OK:FINISH”：播放结束<br>"ERROR:PLAY_FAIL"：发起播放失败<br>"ERROR:PLAYER_ERR,errcode"：播放器发生错误<br>"ERROR:UNREGISTER"：未注册至RTC平台 |

**版本支持:**

3.0.0+

**示例：**

```
uexESurfingRtcLive.cbPlayStatus = updatePlayStatus;

function updatePlayStatus(opCode, dataType, data){
        document.getElementById('globalStatus').innerHTML = data;
    } 
```

#### **3、常见错误码errorcode**

- 400   //请求类错误4xx的下界
- 403   //被踢或token失效，请重新获取token，重新注册
- 404   //呼叫的号码不存在，被叫号码从未获取token登录过
- 408   //超时，请求服务器超时或被呼叫方网络异常
- 480   //对方不在线，对方未登陆，或网络异常断开一段时间
- 486   //正忙
- 487   //取消呼叫
- 488   //媒体协商失败
- 500   //服务器类错误5xx的下界
- 503   //网络不可用或服务器错误
- 600   //全局错误6xx的下界
- 603   //被叫拒接，或服务器拒绝请求
- 891   //已经在其他地方接听
- 1001  //内存错误；或网络断开，可选择是否挂断正在进行的通话
- 1002  //参数错误；或连接上了网络，可以继续呼叫
- 1003  //缺少参数；或网络闪断，可以忽略，不影响呼叫
- 1004  //重置参数失败；或重连失败应用可以选择重新登录，应限制呼叫
- 1005  //呼叫失败
- 1006  //呼叫结束
- 1007  //动作失败
- 1008  //sdk已初始化
- 1009  //sdk初始化不完整
- 1010  //容量溢出
- 1011  //无效函数

#### **4、更新历史**<ignore>

**iOS**<ignore>

API 版本：`uexESurfingRtcLive-3.0.0` 

iOS最近更新时间：2016-8-24

|  历史发布版本 | iOS更新    |
| ------------ | ------------  |
| 3.0.0  | 初始版本  |
 
