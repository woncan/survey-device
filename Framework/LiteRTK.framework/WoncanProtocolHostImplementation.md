# 桓参App端跨平台资源库

## 桓参协议库

### 主接口文件

见 @ref woncan_host_interface.h

### 简介

桓参协议是一个二进制协议。协议内容涵盖了桓参的产品的各个方面：GNSS、IMU、激光、NFC、固件更新、设备信息等等。任何人用肉眼看原始的二进制信息，完全不知道里面是什么内容，而如果让每个平台的App开发者去写一套读、写桓参协议的代码，不好维护且容易出错。因此，向App开发者提供用C语言编写的桓参协议库，以便App的开发。

如果把桓参协议理解为一门语言，桓参协议库可以理解成一名翻译。App从桓参设备收到了桓参协议的原始信息，应把原始信息交给协议库去翻译，然后协议库再把翻译结果通知App，见第一章。同时，App如果想向桓参设备下指令或者发送数据，应调用协议库的相关接口，协议库会把App的指令翻译成桓参协议；翻译完成之后，协议库会把桓参协议的信息交给App，由App发给桓参设备，见第二章。

桓参协议是一个加密的协议，因此在每次App与桓参设备能够建立会话之前，会有一个握手交换密钥的过程，见第三章。

### 1. App处理从设备收到的二进制信息

1）App收到设备发来的二进制数据流后，调用下列库函数接口，将二进制数据传入库中，其中需要输入：`pbuf`是App从设备收到的数据流指针，指向第一个字节；`len`是数据流的长度。

```c
void AddWoncanDeviceData(uint8_t* pbuf, uint16_t len);
```

2）库函数获取数据流`pbuf`和长度`len`后，内部会检查传输协议，确定数据包的完整性，如完整，则解析数据。

3）库解析完数据后，通过回调函数，将数据类型`classID`，和未知类型的结构体指针`ouput`传给App。

```c
void WoncanHostParseResultCallback(uint16_t classID, void* output);
```

4）App需负责完成回调函数中的代码，供库函数解析完后调用。具体操作：首先查表，根据`classID`确定解析后的数据结构体类型，然后将`output`强制转换为对应结构体，最后按需要使用结构体中的数据。

例：`classID`为0x0101时，对应结构体为`LocationReport`，应将output强制转换为`LocationReport`类型，即可从中取出App所需的位置相关信息。结构体类型定义详见.h文件。

### 2.App生成向设备发送的二进制信息

1）App向设备发送信息或指令时，需要根据信息内容选择合适的生成信息的库函数，并调用函数接口。

例如：App向设备发送设置设备ID的指令，需要调用库函数如下，其中，App须向库函数输入`deviceSN`和`deviceID`信息。不同指令对应不同的库函数，参考.h文件。

```C
void WriteCF01_SetDeviceID(const char* deviceSN, const char* deviceID);
```

2）库函数会利用App输入的信息，生成对应发送给设备的二进制数据包，并调用下列回调函数向设备发送数据。

```C
void WoncanHostSendToDeviceCallback(uint8_t* pbuf, uint16_t len);
```

3）App需负责完成回调函数代码，供库函数打包好数据后调用。具体操作：根据回调函数中库输入的数据包指针头`pbuf`和数据长度`len`，完成将数据发送给设备的代码，不同的平台采用不同的数据传输方式。

### 3. App与设备每次建立连接时握手

1）设备开机，尚未与App建立数据连接时，设备会持续以1秒1次的频率向App发送信息0xAA01，直到App向设备发送回应信息

2）如果App在回调函数`WoncanHostParseResultCallback`解析出的 `classID`为0xAA01，需要向设备发送回应信息0xAA02，调用下列库函数，无需输入参数

```C
void WriteAA02_AuthenticationResponse(void);
```

3）设备收到App发送的0xAA02数据包后，会向App发送0xAA03数据包

4）如果App在回调函数`WoncanHostParseResultCallback`解析出的 `classID`为0xAA03，需要向设备发送回应信息0xAA04数据包，调用下列库函数，无需输入参数。App发送0xAA04数据包后即握手成功。

```C
void WriteAA04_SessionKeyAcknowledgment(void);
```

## 测绘资源库

### 经纬度（BLH）、地心地固（ECEF）、投影平面（NEU）坐标之间转换

见 @ref CoordinateProjection.h

### 已知坐标转换参数，经纬度（BLH）平面（NEU）坐标之间转换

见 @ref CoordinateTransform.h

### 已知控制点平面（NEU）坐标、测量点经纬度（BLH）坐标，求坐标转换参数

见 @ref CoordinateTransformParams.h

### 道路元素（交点法、线元法）

见 @ref RoadCenterline.h
