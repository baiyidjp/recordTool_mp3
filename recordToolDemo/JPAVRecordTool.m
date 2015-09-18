//
//  AVRecordTool.m
//  录音demo
//
//  Created by I Smile going on 15/9/11.
//  Copyright (c) 2015年 dong. All rights reserved.
//

#import "JPAVRecordTool.h"
#import "lame.h"
#import <MediaPlayer/MediaPlayer.h>
//录音地址
#define kRecordAudioFilePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"myRecord.caf"]
//MP3地址
#define kRecordMP3FilePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"myRecord.mp3"]

static JPAVRecordTool *_instance;

@interface JPAVRecordTool ()<AVAudioRecorderDelegate>

/** 录音文件地址 */
@property (nonatomic, strong) NSURL *recordFileUrl;

@property (nonatomic, strong) AVAudioSession *session;

@end

@implementation JPAVRecordTool


#pragma mark - 单例
+ (instancetype)sharedRecordTool {
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        if (_instance == nil) {
            _instance = [[JPAVRecordTool alloc] init];
        }
    });
    return _instance;
}

//懒加载录音对象

- (AVAudioRecorder *)recorder
{
    if (!_recorder) {
        
        // 1.获取沙盒地址

        self.recordFileUrl = [NSURL fileURLWithPath:kRecordAudioFilePath];
        
        // 2. 设置录音的一些参数
        NSMutableDictionary *setting = [NSMutableDictionary dictionary];
        // 音频格式
        setting[AVFormatIDKey] = [NSNumber numberWithInt:kAudioFormatLinearPCM];
        // 录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）
        setting[AVSampleRateKey] = [NSNumber numberWithFloat:11025.0];
        // 音频通道数 1 或 2
        setting[AVNumberOfChannelsKey] = [NSNumber numberWithInt:2];
        // 线性音频的位深度  8、16、24、32
        setting[AVLinearPCMBitDepthKey] = [NSNumber numberWithInt:16];
        //录音的质量
        setting[AVEncoderAudioQualityKey] = [NSNumber numberWithInt:AVAudioQualityHigh];

        
        //3.创建录音对象
        
        _recorder = [[AVAudioRecorder alloc]initWithURL:self.recordFileUrl settings:setting error:NULL];
        
        _recorder.delegate = self;
        
        [_recorder prepareToRecord];
        
    }
    
    return _recorder;
}



//录音

- (void)startRecording
{
    //设置音频会话
    
    self.session=[AVAudioSession sharedInstance];
    
    //设置为播放和录音状态，以便可以在录制完之后播放录音
    
    [self.session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    [self.session setActive:YES error:nil];
    
    if (![self.recorder isRecording]) {
        
        [self.recorder record];
    }
}

//停止录音(自动保存文件)

- (void)stopRecording
{
    if ([self.recorder isRecording]) {
        
        [self.recorder stop];
        
        [self transformCAFToMP3];
    }
}

//录音完成

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    if (flag) {
        
        [self.session setActive:NO error:nil];
        
    }
}

//播放录音

- (void)playRecordingFileWithRecordPath:(NSString *)recordPath orRecordUrl:(NSURL *)recordUrl{
    // 播放时停止录音
    [self.recorder stop];
    
    // 正在播放就返回
    if ([self.audioPlayer isPlaying]) return;
    
    //创建播放器
    
    if (recordPath) {
        
        self.audioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL URLWithString:recordPath] error:NULL];
        
        [self.session setCategory:AVAudioSessionCategoryPlayback error:nil];
        
        [self.audioPlayer play];
        
    }else if(recordUrl)
    {
        self.audioUrlPlayer=[[MPMoviePlayerController alloc]initWithContentURL:recordUrl];
        
        [self.session setCategory:AVAudioSessionCategoryPlayback error:nil];
        
        [self.audioUrlPlayer play];
    }
    
    
    
   
    
}

//停止播放

- (void)stopPlaying {
    
    [self.audioPlayer stop];
    
    [self.audioUrlPlayer stop];
}



- (void)transformCAFToMP3 {
    
    
    @try {
        int write,read;
        
        FILE *pcm = fopen([kRecordAudioFilePath cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
        fseek(pcm, 4*1024, SEEK_CUR);
        FILE *mp3 = fopen([kRecordMP3FilePath cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 11025.0);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = (int)fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
        
        NSLog(@"MP3生成成功");
        
    }
    
}

//删除录音

- (void)destructionRecordingFile {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (self.recordFileUrl) {
        
        [fileManager removeItemAtURL:self.recordFileUrl error:NULL];
    }
    
    if (kRecordMP3FilePath) {
        
        [fileManager removeItemAtPath:kRecordMP3FilePath error:NULL];
    }
}

@end
