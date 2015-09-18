//
//  AVRecordTool.h
//  录音demo
//
//  Created by I Smile going on 15/9/11.
//  Copyright (c) 2015年 dong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
@interface JPAVRecordTool : NSObject

/*
 在工程中调用JPAVRecordTool工具类
 在工程中调用方法获取单例
 使用单例操作
 */

/** 录音工具的单例 */
+ (instancetype)sharedRecordTool;

/** 开始录音 */
- (void)startRecording;

/** 停止录音 */
- (void)stopRecording;

/** 播放本地/在线录音文件 */
- (void)playRecordingFileWithRecordPath:(NSString *)recordPath orRecordUrl:(NSURL *)recordUrl;

/** 停止播放录音文件 */
- (void)stopPlaying;

/** 销毁录音文件 */
- (void)destructionRecordingFile;

/** 录音对象 */
@property (nonatomic, strong) AVAudioRecorder *recorder;

/** 本地播放器对象 */
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

/** 在线播放器对象 */
@property (nonatomic, strong) MPMoviePlayerController *audioUrlPlayer;

@end
