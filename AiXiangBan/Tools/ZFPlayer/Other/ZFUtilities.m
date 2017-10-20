//
//  ZFUtilities.m
//  ZFPlayer
//
// Copyright (c) 2016年 任子丰 ( http://github.com/renzifeng )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "ZFUtilities.h"

@implementation ZFUtilities

+ (NSString *)convertTimeSecond:(NSInteger)timeSecond {
    NSString *theLastTime = nil;
    long second = timeSecond;
    if (timeSecond < 60) {
        theLastTime = [NSString stringWithFormat:@"00:%02zd", second];
    } else if(timeSecond >= 60 && timeSecond < 3600){
        theLastTime = [NSString stringWithFormat:@"%02zd:%02zd", second/60, second%60];
    } else if(timeSecond >= 3600){
        theLastTime = [NSString stringWithFormat:@"%02zd:%02zd:%02zd", second/3600, second%3600/60, second%60];
    }
    return theLastTime;
}

+ (ZFMediaFormat)mediaFormatForContentURL:(NSURL *)contentURL {
    if (!contentURL) return ZFMediaFormatError;
    
    NSString * path;
    if (contentURL.isFileURL) {
        path = contentURL.path;
    } else {
        path = contentURL.absoluteString;
    }
    path = [path lowercaseString];
    
    if ([path hasPrefix:@"rtmp:"]) {
        return ZFMediaFormatRTMP;
    } else if ([path hasPrefix:@"rtsp:"]) {
        return ZFMediaFormatRTSP;
    } else if ([path containsString:@".flv"]) {
        return ZFMediaFormatFLV;
    } else if ([path containsString:@".mp4"]) {
        return ZFMediaFormatMPEG4;
    } else if ([path containsString:@".mp3"]) {
        return ZFMediaFormatMP3;
    } else if ([path containsString:@".m3u8"]) {
        return ZFMediaFormatM3U8;
    } else if ([path containsString:@".mov"]) {
        return ZFMediaFormatMOV;
    }
    return ZFMediaFormatUnknown;
}

+ (ZFPlayerType)decoderTypeForContentURL:(NSURL *)contentURL {
    ZFMediaFormat mediaFormat = [self mediaFormatForContentURL:contentURL];
    switch (mediaFormat) {
        case ZFMediaFormatError:
            return ZFPlayerTypeError;
        case ZFMediaFormatUnknown:
            return ZFPlayerTypeError;
        case ZFMediaFormatMP3:
            return ZFPlayerTypeAV;
        case ZFMediaFormatMPEG4:
            return ZFPlayerTypeAV;
        case ZFMediaFormatMOV:
            return ZFPlayerTypeAV;
        case ZFMediaFormatFLV:
            return ZFPlayerTypeIJK;
        case ZFMediaFormatM3U8:
            return ZFPlayerTypeAV;
        case ZFMediaFormatRTMP:
            return ZFPlayerTypeIJK;
        case ZFMediaFormatRTSP:
            return ZFPlayerTypeIJK;
    }
}


@end
