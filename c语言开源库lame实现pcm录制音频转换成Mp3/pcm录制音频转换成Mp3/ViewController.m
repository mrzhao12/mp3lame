//
//  ViewController.m
//  pcm录制音频转换成Mp3
//
//  Created by sjhz on 2017/9/1.
//  Copyright © 2017年 sjhz. All rights reserved.
//

#import "ViewController.h"

#import <lame/lame.h>
@interface ViewController ()
@property (nonatomic, strong) NSString *audioTemporarySavePath;
@end

@implementation ViewController
{


}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self audio_PCMtoMP3];
}

- (void)audio_PCMtoMP3
{
    NSLog(@"开始转换");
//     FILE *in_file,*out_file = NULL;

// NSString* pcmFilePath = @"/Users/zhaotong/Desktop/picture/媒体资源/audio/pcm & wav/月光の云海 - 久石譲.pcm";
//   NSString* mp3FilePath = @"/Users/zhaotong/Desktop/picture/媒体资源/audio/9111.mp3";
//    NSString *mp3FileName = [self.audioFileSavePath lastPathComponent];
//    mp3FileName = [mp3FileName stringByAppendingString:@".mp3"];
//    NSString *mp3FilePath = [self.audioTemporarySavePath stringByAppendingPathComponent:mp3FileName];
    
    @try {
        int read, write;
//                 in_file = fopen("/Users/zhaotong/Desktop/cuc_view_480x272.yuv", "rb");

//        FILE *pcm = fopen([pcmFilePath cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
        FILE *pcm = fopen("/Users/zhaotong/Desktop/picture/媒体资源/audio/pcm & wav/月光の云海 - 久石譲.pcm","rb");
        
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
//        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
        FILE *mp3 = fopen("/Users/zhaotong/Desktop/picture/媒体资源/audio/9111.mp3","wb");
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 11025.0);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
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

              NSLog(@"MP3生成成功:");
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
