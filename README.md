# Survey-Device


### Survey-Device SDK 说明


#### 手动集成framework
###### 1.1 引入LiteRTK.framework
  将ExampleDemo内的framework文件夹下的`LiteRTK.framework`添加到自己的项目工程里面，<br>然后需要选中项目`target->General->Frameworks,Libraries,and Embedded Content`,<br>修改引入的
  LiteRTK.framework的Embed到`Embed&Sign`选项<br>
  
  ![](https://github.com/WoncanWct/ImageCache/blob/main/frameworkEmbed.jpg)
###### 1.2 引用头文件`#import <LiteRTK/LiteRTK.h>`
LiteRTK.framework目前是基于`Objective-C`开发，如果接入的项目也是OC环境可以直接引入`#import <LiteRTK/LiteRTK.h>`开始使用，<br>如果是`Swift`环境需要在桥接文件`bridging-header`里面引入`#import <LiteRTK/LiteRTK.h>`
###### 1.3 MFi设备支持（如不需要可忽略以下配置）
如需增加项目对MFi设备的连接支持需要如下配置：
项目Info.plist添加<br>
```
<key>UISupportedExternalAccessoryProtocols</key>
	<array>
		<string>com.woncan.data</string>
	</array>
```
Background Models 支持<br>
![](https://github.com/WoncanWct/ImageCache/blob/main/BackgroundModes.jpg)
<br>
<br>
<br>
#### 使用
#### 蓝牙管理类初始化
```Swift
    var util: HCUtil?
    util = HCUtil(delegate: self)
```
#### 搜索设备
使用以下方式搜索设备
```Swift
  util?.toSearchDevice(with: .BleRTK)//蓝牙rtk
  util?.toSearchDevice(with: .EaRTK)//Mfi rtk
```
搜索设备结果返回
```Swift
func hcSearchResult(_ deviceNameList: [String]!, isDone: Bool) {
        print("搜索到的设备：\(deviceNameList ?? [])")
    }
```
连接设备
```Swift
  util?.toConnectDevice(index)
```
断开连接
```Swift
  util?.toDisconnect()
```
#### HCUtilDelegate
连接设备成功
```Swift
func hcDeviceConnected(_ index: Int) {
    }
```
收到数据
```Swift
func hcReceive(_ deviceInfoBaseModel: HCDeviceInfoBaseModel!) {
        //持续返回收到的卫星数据和差分数据
    }
```
设备连接断开
```Swift
func hcDeviceDisconnected() {  
    }
```
连接设备报错
```Swift
    func hcDeviceDidFailWithError(_ error: HCStatusError) {
        switch error {
        case .BleUnauthorized:
            print("蓝牙未授权")
            break
        case .UnsupportedDeviceType:
            print("不支持该设备连接")
            break
        case .BlePoweredOff:
            self.list.removeAll()
            print("手机蓝牙未开启，请先开启后再连接设备")
            break
        case .Unknown:
            break
        default:
            break
        }
    }
```
#### 自带差分配置
  当前设备如果支持自带差分功能会在连接上蓝牙后去主动发起差分连接，无需其他配置就可以实现固定解。
###### 自带差分的状态
  ```Swift
    var util: HCUtil?
    self.util?.hasDeviceDiff //是否支持自带差分功能
    self.util?.isConnectDeviceDiff //自带差分是否连接
```
###### 自带差分的连接与断开
  ```Swift
   self.util?.toConnectDeviceDiff() // 发起自带差分连接(需要判断设备是否支持该功能)
    self.util?.toDisconnectDeviceDiff() // 断开自带差分连接
```

#### Ntrip账号差分配置
#### 差分管理类初始化
```Swift
    var socketUtil: HCSocketUtil?
    self.socketUtil = HCSocketUtil()
    self.socketUtil?.delegate = self
```
获取挂载点
```Swift
    let model = HCDiffModel()
    model.ip = self.addressTextField.text ?? ""
    model.port = Int(self.portTextField.text ?? "") ?? 0
    model.account = self.accountTextField.text ?? ""
    model.password = self.passwordTextField.text ?? ""
    self.socketUtil?.replaceDiffModel(model)
    self.socketUtil?.getMountPoints()
```
发起差分连接
```Swift
    let model = HCDiffModel()
    model.ip = self.addressTextField.text ?? ""
    model.port = Int(self.portTextField.text ?? "") ?? 0
    model.account = self.accountTextField.text ?? ""
    model.password = self.passwordTextField.text ?? ""
    model.mountPointList = self.mountPointList
    model.currentMountPoint = self.mountPointTextField.text ?? ""
    self.socketUtil?.replaceDiffModel(model)
    self.socketUtil?.toLogin()
```
断开差分连接
```Swift
    self.socketUtil?.disconnect()
```
写入NMEA原始数据
```Swift
     self.socketUtil?.sendData("\(nmeaSourceText)\r\n\r\n")
```
#### HCSocketUtilDelegate
差分登录成功
```Swift
func loginSuccess(_ tcpUtil: HCSocketUtil) {
        if timer == nil {//差分登录成功后需要把获取到的差分数据发送到硬件设备
            timer = Timer(timeInterval: 0.5, target: self, selector: #selector(getDiffData), userInfo: nil, repeats: true)
            RunLoop.current.add(timer!, forMode: .common)
        }
        timer?.fireDate = .distantPast
    }
@objc func getDiffData() {
        if let nmeaSourceText = nmeaSourceText, nmeaSourceText.count > 0 {
            self.socketUtil?.sendData("\(nmeaSourceText)\r\n\r\n")
        }
    }
```
差分登录失败
```Swift
    func loginFailure(_ tcpUtil: HCSocketUtil, error: Error?) {
        self.socketUtil?.disconnect()
    }
```
获取挂载点成功
```Swift
func didGetMountPointsSuccess(_ socketUtil: HCSocketUtil) {
        self.socketUtil?.disconnect()
    }
```
处理差分数据
```Swift
func didReadOriginDiffDataSuccess(_ data: Data, socketUtil: HCSocketUtil) {
        //var util: HCUtil?
        //差分数据发送给硬件设备处理
        self.util?.toSend(data)
    }
```
