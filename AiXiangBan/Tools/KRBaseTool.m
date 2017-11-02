//
//  KRBaseTool.m
//  AlementHome
//
//  Created by 曾洪磊 on 2017/9/26.
//  Copyright © 2017年 曾洪磊. All rights reserved.
//

#import "KRBaseTool.h"
#import<CommonCrypto/CommonDigest.h> //苹果自带的MD5加密
//#import <UShareUI/UShareUI.h>
@implementation KRBaseTool
singleton_implementation(KRBaseTool)
#pragma mark————————————————给一个view加阴影
+ (void)viewAddYinYing:(UIView *)view{
    
    
    //阴影的颜色
    
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    //阴影的透明度
    
    view.layer.shadowOpacity = 0.8f;
    //阴影的圆角
    
    view.layer.shadowRadius = 4.f;
    //阴影偏移量
    
    view.layer.shadowOffset = CGSizeMake(1,1);
    
    
    
}
#pragma mark———————————————— 跳转 push
+ (void)pushNextViewController:(UIViewController *)nextViewController andRootController:(UIViewController *)rootVc
{
    
    
    
    rootVc.hidesBottomBarWhenPushed = YES;
    
    [nextViewController.navigationController pushViewController:rootVc
                                                       animated:YES];
    
}

#pragma mark———————————————— 计算文字高度
+ (CGSize)getNSStringSize:(NSString *)string andViewWight:(CGFloat)weight andFont:(NSInteger)font
{
    
    return  [string sizeOfTextWithMaxSize:CGSizeMake(weight, MAXFLOAT) font:[UIFont systemFontOfSize:font]];
    
}
#pragma mark——————————————转换时间锉 传入时间锉字符串  得到解析后的字符串
+ (NSString *)changeTimeCuo:(NSString *)time
{
    
    //如果带有网页标签 就先去掉
    if([time rangeOfString:@"/Date"].location !=NSNotFound)//_roaldSearchText
    {
        
        //去掉多余的字符
        NSString *timeString = [[time stringByReplacingOccurrencesOfString:@"/Date(" withString:@""] stringByReplacingOccurrencesOfString:@"000)/" withString:@""];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        
        
        double timeInt =[timeString doubleValue];
        
        
        
        NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:timeInt];
        
        
        
        
        
        NSString *myNewDateString = [formatter stringFromDate:date1];
        return myNewDateString;
    }
    else
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        
        //这里看后台返回的时间锉 长度是否为包含了毫秒级 如果返回了毫秒级 就／1000才能解析成正常的时间
        
        double timeInt =[time doubleValue];
        
        
        
        NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:timeInt];
        
        
        
        
        
        NSString *myNewDateString = [formatter stringFromDate:date1];
        return myNewDateString;
    }
    
    
}
#pragma mark——————————————————NSString转NSDate (年月日)
+ (NSDate *)NSStringToNSDate:(NSString *)dateStr
{
    //先获得开始时间
    
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *date=[dateFormatter dateFromString:dateStr];
    
    return date;
}
#pragma mark————————————根据sb来实例化vc并且跳转 (Sbname sb名字  ViewController要跳转的类的对象可以直接类名 new  selfVc 当前vc )注意： sb名字一定要和SB id 一样不然会崩
+ (void)pushSbVcSbname:(NSString *)Sbname andVc:(UIViewController *)ViewController andSelfVc:(UIViewController *)selfVc
{
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:Sbname bundle:nil];
    ViewController = [sb instantiateViewControllerWithIdentifier:Sbname];
    
    [KRBaseTool pushNextViewController:selfVc andRootController:ViewController];
    
}
#pragma mark————————————————清除sdwebImage里面的缓存
+ (void)clearSDWebImageChace{
    
    [[[SDWebImageManager sharedManager] imageCache] clearDiskOnCompletion:nil];
    [[[SDWebImageManager sharedManager] imageCache] clearMemory];
    
    
}
#pragma mark————————————————获取sdwebImage缓存大笑
+ (void)getSDWebImageChaceSize:(SDWebImageCalculateSizeBlock)completionBlock{
    
    
    
    
    [SDWebImageManager.sharedManager.imageCache
     calculateSizeWithCompletionBlock:completionBlock];
    
    //    NSLog(@"有%d张图片 缓存%.2fM",fileCount,totalSize / 1024.0 / 1024.0);
    
}
#pragma mark————————————uilable顶部对齐
+ (void)lableTopAlignment:(UILabel *)lable{
    
    CGSize size = [lable.text sizeWithAttributes:@{NSFontAttributeName:lable.font}];
    CGRect rect = [lable.text boundingRectWithSize:CGSizeMake(lable.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:lable.font} context:nil];
    lable.numberOfLines = 0;//为了添加\n必须为0
    NSInteger newLinesToPad = (lable.frame.size.height - rect.size.height)/size.height;
    
    for (NSInteger i = 0; i < newLinesToPad; i ++) {
        lable.text = [lable.text stringByAppendingString:@"\n "];
    }
    
    
}
//手机号码
+ (BOOL)isMobileNumber:(NSString *)mobileNum {
    //移动号段正则表达式
    NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
    //联通号段正则表达式
    NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
    //电信号段正则表达式
    NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
    
    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
    BOOL isMatch1 = [pred1 evaluateWithObject:mobileNum];
    NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
    BOOL isMatch2 = [pred2 evaluateWithObject:mobileNum];
    NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
    BOOL isMatch3 = [pred3 evaluateWithObject:mobileNum];
    
    if (isMatch1 || isMatch2 || isMatch3) {
        return YES;
    }else{
        return NO;
    }
}
// 根据图片url获取图片尺寸
+(CGSize)getImageSizeWithURL:(id)imageURL
{
    NSURL* URL = nil;
    if([imageURL isKindOfClass:[NSURL class]]){
        URL = imageURL;
    }
    if([imageURL isKindOfClass:[NSString class]]){
        URL = [NSURL URLWithString:imageURL];
    }
    if(URL == nil)
        return CGSizeZero;                  // url不正确返回CGSizeZero
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
    NSString* pathExtendsion = [URL.pathExtension lowercaseString];
    
    CGSize size = CGSizeZero;
    if([pathExtendsion isEqualToString:@"png"]){
        size =  [self getPNGImageSizeWithRequest:request];
    }
    else if([pathExtendsion isEqual:@"gif"])
    {
        size =  [self getGIFImageSizeWithRequest:request];
    }
    else{
        size = [self getJPGImageSizeWithRequest:request];
    }
    if(CGSizeEqualToSize(CGSizeZero, size))                    // 如果获取文件头信息失败,发送异步请求请求原图
    {
        NSData* data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:URL] returningResponse:nil error:nil];
        UIImage* image = [UIImage imageWithData:data];
        if(image)
        {
            size = image.size;
        }
    }
    return size;
}
//  获取PNG图片的大小
+(CGSize)getPNGImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=16-23" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(data.length == 8)
    {
        int w1 = 0, w2 = 0, w3 = 0, w4 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        [data getBytes:&w3 range:NSMakeRange(2, 1)];
        [data getBytes:&w4 range:NSMakeRange(3, 1)];
        int w = (w1 << 24) + (w2 << 16) + (w3 << 8) + w4;
        int h1 = 0, h2 = 0, h3 = 0, h4 = 0;
        [data getBytes:&h1 range:NSMakeRange(4, 1)];
        [data getBytes:&h2 range:NSMakeRange(5, 1)];
        [data getBytes:&h3 range:NSMakeRange(6, 1)];
        [data getBytes:&h4 range:NSMakeRange(7, 1)];
        int h = (h1 << 24) + (h2 << 16) + (h3 << 8) + h4;
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}
//  获取gif图片的大小
+(CGSize)getGIFImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=6-9" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(data.length == 4)
    {
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        short w = w1 + (w2 << 8);
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(2, 1)];
        [data getBytes:&h2 range:NSMakeRange(3, 1)];
        short h = h1 + (h2 << 8);
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}
//  获取jpg图片的大小
+(CGSize)getJPGImageSizeWithRequest:(NSMutableURLRequest*)request
{
    [request setValue:@"bytes=0-209" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    if ([data length] <= 0x58) {
        return CGSizeZero;
    }
    
    if ([data length] < 210) {// 肯定只有一个DQT字段
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
        [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
        short w = (w1 << 8) + w2;
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
        [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
        short h = (h1 << 8) + h2;
        return CGSizeMake(w, h);
    } else {
        short word = 0x0;
        [data getBytes:&word range:NSMakeRange(0x15, 0x1)];
        if (word == 0xdb) {
            [data getBytes:&word range:NSMakeRange(0x5a, 0x1)];
            if (word == 0xdb) {// 两个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0xa5, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0xa6, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0xa3, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0xa4, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            } else {// 一个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            }
        } else {
            return CGSizeZero;
        }
    }
}
#pragma mark——————————增加下啦刷新
+ (void)tableViewAddRefreshHeader:(UIScrollView *)scrollView withTarget:(id)target  refreshingAction:(SEL)action
{
    
    scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:target refreshingAction:action];
    
    
}
#pragma mark——————————增加上拉加载更多
+ (void)tableViewAddRefreshFooter:(UIScrollView *)scrollView withTarget:(id)target refreshingAction:(SEL)action
{
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:target refreshingAction:action];
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"" forState:MJRefreshStatePulling];
    [footer setTitle:@"" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"" forState:MJRefreshStateWillRefresh];
    [footer setTitle:@"" forState:MJRefreshStateNoMoreData];
    scrollView.mj_footer = footer;
}
#pragma mark————————————计算两个经纬度间的距离
//LocationOne LocationTwo 两个经纬度
+ (NSString *)getAddressNumberAddressOne:(CLLocationCoordinate2D )LocationOne  withAddressTwo:(CLLocationCoordinate2D )LocationTwo{
    
    CLLocation *orig=[[CLLocation alloc] initWithLatitude:LocationOne.latitude  longitude:LocationOne.longitude];
    
    CLLocation* dist=[[CLLocation alloc] initWithLatitude:LocationTwo.latitude  longitude:LocationTwo.longitude];
    
    CLLocationDistance kilometers=[orig distanceFromLocation:dist];
    
    NSLog(@"距离%f:",kilometers);
    
    if(kilometers<1000.0)
    {
        
        NSString *string =[NSString stringWithFormat:@"%.0f 米",kilometers];
        
        return string;
    }
    else
    {
        NSString *string = [NSString stringWithFormat:@"%.2f 公里",kilometers/1000.0];
        
        return string;
    }
    
    
    
}
#pragma mark——————————给lable某段文字颜色
+ (void)withLableAddColorWithLable:(UILabel *)lable with:(NSString *)colorString WithColor:(UIColor *)color
{
    if(colorString!=nil)
    {
        NSRange range1 = [lable.text rangeOfString:colorString];
        NSMutableAttributedString *richText =[[NSMutableAttributedString alloc]initWithAttributedString:lable.attributedText];
        [richText addAttribute:NSForegroundColorAttributeName value:color range:range1];
        lable.attributedText = richText;
    }
    
}
//#pragma mark————————————————————友盟分享
///**
// *  友盟分享
// *
// *  @param shareUrl 分享链接地址(点击)
// *  @param vc       当前vc
// *  @param title    标题
// *  @param image    分享图片
// *  @param Source   描述
// */
//+ (void)UMShareWithShareUrl:(NSString *)shareUrl  withViewController:(UIViewController *)vc  withTitle:(NSString *)title  withImage:(UIImage *)image withSource:(NSString *)Source{
//    
//    
//    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_Sina),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine)]];
//    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
//        [self shareWebPageToPlatformType:platformType andTitle:title andDes:Source andImage:image andUrl:shareUrl viewController:vc];
//    }];
//   
//}
//
//+ (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType andTitle:(NSString *)title andDes:(NSString *)description andImage:(id )thumImageUrl andUrl:(NSString *)url viewController:(UIViewController *)vc
//{
//    //创建分享消息对象
//    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
//    
//    //创建网页内容对象
//   
//    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:description thumImage:thumImageUrl];
//    //设置网页地址
//    shareObject.webpageUrl = url;
//    
//    //分享消息对象设置分享内容对象
//    messageObject.shareObject = shareObject;
//    
//    //调用分享接口
//    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:vc completion:^(id data, NSError *error) {
//        if (error) {
//            UMSocialLogInfo(@"************Share fail with error %@*********",error);
//        }else{
//            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
//                UMSocialShareResponse *resp = data;
//                //分享结果消息
//                UMSocialLogInfo(@"response message is %@",resp.message);
//                //第三方原始返回的数据
//                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
//                
//            }else{
//                UMSocialLogInfo(@"response data is %@",data);
//            }
//        }
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:error.description delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//    }];
//}
//
//
//
//
//
//
//
//
//
//#pragma mark————————————————————友盟分享(指定平台)
///**
// *  友盟分享
// *
// *  @param shareUrl 分享链接地址(点击)
// *  @param vc       当前vc
// *  @param title    标题
// *  @param image    分享图片
// *  @param Source   描述
// *  @param formType 分享平台
// *  @param completion 分享后的回调
// */
//+ (void)UMShareWithShareUrl:(NSString *)shareUrl  withViewController:(UIViewController *)vc  withTitle:(NSString *)title  withImage:(UIImage *)image withSource:(NSString *)Source withShareType:(UMSocialPlatformType)formType withCompletion:(UMSocialRequestCompletionHandler)completion{
//    
//    
//    //创建分享消息对象
//    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
//    //设置文本
//    messageObject.text = title;
//    
//    if(image==nil)
//    {
//        image = _zhanweiImageData;
//    }
//    
//    UMShareWebpageObject *umObj = [UMShareWebpageObject shareObjectWithTitle:title descr:Source thumImage:image];
//    umObj.webpageUrl  = shareUrl;
//    
//    messageObject.shareObject = umObj;
//    
//    
//    
//    [[UMSocialManager defaultManager] shareToPlatform:formType messageObject:messageObject currentViewController:vc completion:completion];
//    
//    
//}
#pragma mark————————————————————UIColor 转UIImage
+ (UIImage*)createImageWithColor: (UIColor*)color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}


#pragma mark————————————————————UIImage转UIColor
+ (void)imageToColor:(UIImage *)image
{
    [UIColor colorWithPatternImage:image];
    
}
//#pragma mark——————————————SDWebImage加载图片
//+ (void)sd_setImageWithimageView:(UIImageView *)imageView withImageUrl:(NSString *)imageUrl  withPlaceholderImage:(UIImage *)placeholderImage withCompleted:(SDWebImageCompletionBlock)completedBlock{
//        
//        if([imageUrl isKindOfClass:[NSNull class]])
//        {
//            imageUrl = @"";
//        }
//        
//        [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:placeholderImage completed:completedBlock];
//        
//}
#pragma mark————————————NSDict 转 json
+ (NSString*)DataTOjsonString:(id)object
{
    if(object==nil)
    {
        return @"";
    }
    
    if([object isKindOfClass:[NSDictionary class]])
    {
        
        
        //去掉一些转换不了的属性
        NSMutableDictionary *muDict = [NSMutableDictionary dictionaryWithDictionary:object];
        
        for (id sonObj in muDict.allKeys) {
            
            if([muDict[sonObj] isKindOfClass:[NSData class]])
            {
                
                [muDict removeObjectForKey:sonObj];
                
            }
            
        }
        
        
        NSString *jsonString = nil;
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:muDict
                                                           options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                             error:&error];
        if (! jsonData) {
            NSLog(@"Got an error: %@", error);
            
            return @"";
        } else {
            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
        
        
        return jsonString;
    }
    else if ([object isKindOfClass:[NSArray class]])
    {
        
        
        if([object count] >0)
        {
            NSString *jsonString = nil;
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                               options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                                 error:&error];
            if (! jsonData) {
                NSLog(@"Got an error: %@", error);
                
                return @"";
            } else {
                jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            }
            
            
            return jsonString;
        }
        
        
        
    }
    
    return @"";
    
}

//#pragma mark————————————json字符串转NSDict
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    
    if([jsonString isKindOfClass:[NSDictionary class]])
    {
        
        return (NSDictionary *)jsonString;
        
    }
    
    
    
    
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
#pragma mark————————————————————苹果自带的md5加密
+ (NSString *) md5:(NSString *) input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}
#pragma mark————————————按钮倒计时
+ (void)daojishi:(NSInteger)miao  withButton:(UIButton *)button
{
    __block NSInteger second= miao;
    
    
    button.userInteractionEnabled = NO;
    
    
    
    NSString *buttonString = button.titleLabel.text;
    
    UIColor *btnColor = button.titleLabel.textColor;
    
    [button setTitle:@"哈哈" forState:UIControlStateNormal];
    
    
    
    [button setTitle:[NSString stringWithFormat:@"重新获取(%d)",60] forState:UIControlStateNormal];
    
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    
    //全局队列    默认优先级
    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //定时器模式  事件源
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, quene);
    //NSEC_PER_SEC是秒，＊1是每秒
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), NSEC_PER_SEC * 1, 0);
    //设置响应dispatch源事件的block，在dispatch源指定的队列上运行
    dispatch_source_set_event_handler(timer, ^{
        //回调主线程，在主线程中操作UI
        dispatch_async(dispatch_get_main_queue(), ^{
            if (second > 0) {
                
                [button setTitle:[NSString stringWithFormat:@"重新获取(%ld)",(long)second] forState:UIControlStateNormal];
                
                
                
                second--;
                
                
            }
            else
            {
                //这句话必须写否则会出问题
                dispatch_source_cancel(timer);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    button.userInteractionEnabled = YES;
                    
                    
                    
                    [button setTitle:buttonString forState:UIControlStateNormal];
                    
                    [button setTitleColor:btnColor forState:UIControlStateNormal];
                    
                });
                
                
            }
        });
    });
    //启动源
    dispatch_resume(timer);
    
    
}
+ (void)setIOSX:(UIScrollView *)vc {
//    if (@available(iOS 11.0, *)) {
//        vc.contentInsetAdjustmentBehavior =UIScrollViewContentInsetAdjustmentNever;
//        vc.contentInset =UIEdgeInsetsMake(navHight,0,64,0);//64和49自己看效果，是否应该改成0
//        vc.scrollIndicatorInsets = vc.contentInset;
//    }
}
+ (NSString *)timeStringFromFormat:(NSString *)dateFormate withDate:(NSDate *)date{
    NSDateFormatter *formater = [[NSDateFormatter alloc]init];
    formater.dateFormat = dateFormate;
    return [formater stringFromDate:date];
    
}
+ (NSArray *)getDeviceDataWithElderId:(NSString *)elderId andHomeId:(NSString *)homeId {
    NSString *path=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).lastObject;
    NSMutableArray *deviceArray = [[NSArray arrayWithContentsOfFile:[path stringByAppendingPathComponent:@"device.plist"]] mutableCopy];
    for (NSDictionary *member in deviceArray) {
        if ([member[@"id"] isEqualToString:[KRUserInfo sharedKRUserInfo].memberId]) {
            for (NSDictionary *dic in member[@"homes"]) {
                if ([dic[@"id"] isEqualToString:homeId]) {
                    for (NSDictionary *elder in dic[@"elders"]) {
                        return elder[@"devices"];
                    }
                }
            }
        }
    }
    return nil;
    
}
+ (void)saveDeviceDataWith:(NSArray *)deviceArray andElderId:(NSString *)elderId andHomeId:(NSString *)homeId{
    NSString *path=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).lastObject;
    NSMutableArray *array = [[NSArray arrayWithContentsOfFile:[path stringByAppendingPathComponent:@"device.plist"]] mutableCopy];
    
    NSMutableArray *tempArray = [NSMutableArray array];
    BOOL hasMember = false;
    for (NSDictionary *dic in array) {
        
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
        if ([dic[@"id"] isEqualToString:[KRUserInfo sharedKRUserInfo].memberId]) {
            hasMember = YES;
            NSMutableArray *homes = [dic[@"homes"] mutableCopy];
            tempDic[@"id"] = dic[@"id"];
            NSMutableArray *tempHome = [NSMutableArray array];
            BOOL haseHome = false;
            
            for (NSDictionary *home in homes) {
                
                
                if ([home[@"id"] isEqualToString:homeId]) {
                    haseHome = YES;
                    NSMutableArray *elderIds = [NSMutableArray array];
                    NSMutableDictionary *tempElder = [NSMutableDictionary dictionary];
                    BOOL haseElder = false;
                    
                    for (NSDictionary *elder in home[@"elders"]) {
                        if ([elder[@"id"] isEqualToString:elderId]) {
                            haseElder = YES;
                            tempElder[@"devices"] = deviceArray;
                            tempElder[@"id"] = elder[@"id"];
                            [elderIds addObject:tempElder];
                        } else {
                            [elderIds addObject:elder];
                        }
                    }
                    if (!haseElder) {
                        [elderIds addObject:@{@"id":elderId,@"devices":deviceArray}];
                    }
                    
                    [tempHome addObject:@{@"id":homeId,@"elders":elderIds}];
                    
                    
                } else {
                    [tempHome addObject:home];
                }
                
            }
            if (!haseHome) {
                [tempHome addObject:@{@"id":homeId,@"elders":@[@{@"id":elderId,@"devices":deviceArray}]}];
                
            }
            tempDic[@"homes"] = tempHome;
            [tempArray addObject:tempDic];
        } else {
            [tempArray addObject:dic];
        }
        
    }
    if (!hasMember) {
        NSDictionary *device = @{@"id":[KRUserInfo sharedKRUserInfo].memberId,@"homes":@[@{@"id":homeId,@"elders":@[@{@"id":elderId,@"devices":deviceArray}]}]};
        [tempArray addObject:device];
    }
    [tempArray writeToFile:[path stringByAppendingPathComponent:@"device.plist"] atomically:YES];
}
+ (void)setDevice {
    NSString *path=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).lastObject;
    if (![[NSFileManager defaultManager] fileExistsAtPath:[path stringByAppendingPathComponent:@"device.plist"]]) {
        [[NSFileManager defaultManager] createFileAtPath:@"device.plist" contents:nil attributes:nil];
    }
}
+ (NSString *)timeWithTimeIntervalString:(NSString *)timeString {
    return [self timeWithTimeIntervalString:timeString andFormate:@"HH:mm:ss"];
}
+ (NSString *)timeWithTimeIntervalString:(NSString *)timeString andFormate:(NSString *)format {
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]/1000];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}
+ (void)showAlert:(NSString *)alterTitle  with_Controller:(UIViewController *)controller with_titleArr:(NSArray *)titieArray withShowType:(UIAlertControllerStyle)preferredStyle  with_Block:(touchIndex)touchBlock{
    // 1.弹框提醒
    // 初始化对话框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:alterTitle preferredStyle:preferredStyle];
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:cancelAction];
    
    //遍历添加提示框文字
    for (int x=0; x<titieArray.count; x++) {
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:titieArray[x] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            //记录tag 点击调用的时候 返回给block
            
            
            if(touchBlock!=nil)
            {
                touchBlock(x);
            }
            
            
        }];
        
        [alert addAction:action];
        
        
        
    }
    
    // 弹出对话框
    [controller presentViewController:alert animated:true completion:nil];
    
}
@end
