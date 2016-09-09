# CYGAnalyseTool
Url请求结果展示工具

##使用方法：
```objc

    [NSURLProtocol registerClass:[CYUrlAnalyseProtocol class]];
    [[CYUrlAnalyseManager defaultManager] registAnalyse];
```
应用启动后，通过『摇一摇』的方式，便可以唤出网络请求的展示界面
