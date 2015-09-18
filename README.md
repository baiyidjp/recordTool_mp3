# recordTool-mp3

*** 直接将lib文件夹拖到工程中

*** 在工程中调用JPAVRecordTool工具类

#import "JPAVRecordTool.h"

*** 在工程中调用方法获取单例

- (void)viewDidLoad {
[super viewDidLoad];

AVRecordTool *recordTool = [AVRecordTool  sharedRecordTool];

self.recordTool = recordTool;

}


*** 使用单例操作

//开始录音

[self startRecording];

//停止录音(自动保存,可以查看沙盒目录)

[self stopRecording];

//播放本地/在线录音文件(播放本地 url传nil 播放网络资源 path传nil)

[self playRecordingFileWithRecordPath:(NSString *)recordPath orRecordUrl:(NSURL *)recordUrl]

//停止播放

[self stopPlaying];

//销毁录音文件

[self destructionRecordingFile];

//转MP3格式(录音完成自动执行)

[self transformCAFToMP3];
