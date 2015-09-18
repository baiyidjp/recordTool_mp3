//
//  ViewController.m
//  recordToolDemo
//
//  Created by I Smile going on 15/9/18.
//  Copyright (c) 2015年 dong. All rights reserved.
//

#import "ViewController.h"
#import "JPAVRecordTool.h"

//录音地址
#define kRecordAudioFilePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"myRecord.caf"]
//MP3地址
#define kRecordMP3FilePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"myRecord.mp3"]
@interface ViewController ()

@property(nonatomic,weak)JPAVRecordTool *recordTool;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    JPAVRecordTool *recordTool = [JPAVRecordTool sharedRecordTool];
    
    self.recordTool = recordTool;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//开始录音
- (IBAction)beginRecord:(id)sender {
    
    [self.recordTool startRecording];
    
    NSLog(@"开始录音");
}
//停止/结束录音/自动转MP3
- (IBAction)stopRecord:(id)sender {
    
    [self.recordTool stopRecording];
    
    NSLog(@"录音完成");
}
//播放本地
- (IBAction)playPath:(id)sender {
    
    [self.recordTool playRecordingFileWithRecordPath:kRecordAudioFilePath orRecordUrl:nil];
}
//播放网络
- (IBAction)playUrl:(id)sender {
    
    [self.recordTool playRecordingFileWithRecordPath:nil orRecordUrl:[NSURL URLWithString:@"网络音频地址"]];
}
//删除
- (IBAction)deleteRecord:(id)sender {
    
    [self.recordTool destructionRecordingFile];
}

@end
