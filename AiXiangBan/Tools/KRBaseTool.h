//
//  KRBaseTool.h
//  AlementHome
//
//  Created by 曾洪磊 on 2017/9/26.
//  Copyright © 2017年 曾洪磊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import <CoreLocation/CoreLocation.h>

//#import <UMSocialCore/UMSocialCore.h>
@interface KRBaseTool : NSObject
singleton_interface(KRBaseTool)
//一个公用的block  返回一个数据
typedef void (^responseObjectBlock)(id responseObject);
//一个KRTools公用的属性 返回值
@property (nonatomic,strong)responseObjectBlock dataBlock;
#pragma mark————————————————给一个view加阴影
+ (void)viewAddYinYing:(UIView *)view;
#pragma mark————————————————跳转 push
+ (void)pushNextViewController:(UIViewController *)nextViewController andRootController:(UIViewController *)rootVc;

#pragma mark————————————————计算文字高度
+ (CGSize)getNSStringSize:(NSString *)string andViewWight:(CGFloat)weight andFont:(NSInteger)font;
#pragma mark——————————————转换时间锉 传入时间锉字符串  得到解析后的字符串
+ (NSString *)changeTimeCuo:(NSString *)time;
#pragma mark——————————————————NSString转NSDate
+ (NSDate *)NSStringToNSDate:(NSString *)dateStr;
#pragma mark————————————根据sb来实例化vc并且跳转 (Sbname sb名字  ViewController要跳转的类的对象可以直接类名 new  selfVc 当前vc )注意： sb名字一定要和SB id 一样不然会崩
+ (void)pushSbVcSbname:(NSString *)Sbname andVc:(UIViewController *)ViewController andSelfVc:(UIViewController *)selfVc;
#pragma mark————————————————清除sdwebImage里面的缓存
+ (void)clearSDWebImageChace;
#pragma mark————————————————获取sdwebImage缓存大小
+ (void)getSDWebImageChaceSize:(SDWebImageCalculateSizeBlock)completionBlock;
#pragma mark————————————uilable顶部对齐
+ (void)lableTopAlignment:(UILabel *)lable;
//手机号码是否正确
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
// 根据图片url获取图片尺寸
+(CGSize)getImageSizeWithURL:(id)imageURL;
#pragma mark——————————增加下啦刷新
+ (void)tableViewAddRefreshHeader:(UIScrollView *)scrollView withTarget:(id)target  refreshingAction:(SEL)action;

#pragma mark——————————增加上拉加载更多
+ (void)tableViewAddRefreshFooter:(UIScrollView *)scrollView withTarget:(id)target refreshingAction:(SEL)action;
#pragma mark————————————计算两个经纬度间的距离得到米或千米
//LocationOne LocationTwo 两个经纬度
+ (NSString *)getAddressNumberAddressOne:(CLLocationCoordinate2D )LocationOne  withAddressTwo:(CLLocationCoordinate2D )LocationTwo;
#pragma mark——————————————给lable某段文字颜色
+ (void)withLableAddColorWithLable:(UILabel *)lable with:(NSString *)colorString WithColor:(UIColor *)color;
//#pragma mark————————————————————友盟分享
///**
// *  友盟分享
// *
// *  @param shareUrl 分享链接地址(点击)
// *  @param vc       当前vc
// *  @param title    标题
// *  @param image    分享图片
// *  @param Source   分享来源(活动. 商品...) 字符串
// */
//+ (void)UMShareWithShareUrl:(NSString *)shareUrl  withViewController:(UIViewController *)vc  withTitle:(NSString *)title  withImage:(UIImage *)image withSource:(NSString *)Source;


#pragma mark————————————————————友盟分享(指定平台)
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
//+ (void)UMShareWithShareUrl:(NSString *)shareUrl  withViewController:(UIViewController *)vc  withTitle:(NSString *)title  withImage:(UIImage *)image withSource:(NSString *)Source withShareType:(UMSocialPlatformType)formType withCompletion:(UMSocialRequestCompletionHandler)completion;
#pragma mark————————————————————UIColor 转UIImage
+ (UIImage*)createImageWithColor:(UIColor*) color;

#pragma mark————————————————————UIImage转UIColor
+ (void)imageToColor:(UIImage *)image;
#pragma mark——————————————SDWebImage加载图片
//+ (void)sd_setImageWithimageView:(UIImageView *)imageView withImageUrl:(NSString *)imageUrl  withPlaceholderImage:(UIImage *)placeholderImage withCompleted:(SDWebImageCompletionBlock)completedBlock;
#pragma mark————————————NSDict 转 json
+ (NSString*)DataTOjsonString:(id)object;

#pragma mark————————————json字符串转NSDict
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
//BASE 64 MD5加密 GTMBase64
+ (NSString *) md5:(NSString *) input;
#pragma mark————————————按钮倒计时
+ (void)daojishi:(NSInteger)miao  withButton:(UIButton *)button;
#pragma mark-------------适配ios11
+ (void)setIOSX:(UIScrollView *)vc;
+ (NSString *)timeStringFromFormat:(NSString *)dateFormate withDate:(NSDate *)date;
+ (NSArray *)getDeviceDataWithElderId:(NSString *)elderId andHomeId:(NSString *)homeId;
+ (void)saveDeviceDataWith:(NSArray *)deviceArray andElderId:(NSString *)elderId andHomeId:(NSString *)homeId;
+ (void)setDevice;
+ (NSString *)timeWithTimeIntervalString:(NSString *)timeString;
+ (NSString *)timeWithTimeIntervalString:(NSString *)timeString andFormate:(NSString *)format;
//返回索引的block
typedef void (^touchIndex)(int index);
#pragma mark——————————————弹出提示框
+ (void)showAlert:(NSString *)alterTitle  with_Controller:(UIViewController *)controller with_titleArr:(NSArray *)titieArray withShowType:(UIAlertControllerStyle)preferredStyle  with_Block:(touchIndex)touchBlock;
@end
