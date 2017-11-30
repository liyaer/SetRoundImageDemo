//
//  ViewController.m
//  SetRoundImageDemo
//
//  Created by 杜文亮 on 2017/11/30.
//  Copyright © 2017年 杜文亮. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //设置背景色，便于观察结果
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 200, 200)];
    imageView.backgroundColor = [UIColor brownColor];//设置背景色，对三种方式做对比的依据
    imageView.image = [UIImage imageNamed:@"1"];
    [self.view addSubview:imageView];

    /*
     *  方式一：通过设置layer的属性。直接对展示图片的ImageView的layer进行操作（无法看到背景色brownColor）
     */
//    [self one:imageView];
    
    /*
     *  方式二：使用UIGraphics配合UIBezierPath或者Core Graphics生成新图片。对图片的操作（正因如此，可以看到背景色brownColor）将方形图片进行处理，生成了一张圆形图片；也可能还是方形图片，只不过圆形区域外是透明的，类似于美工直接切好的那种图的效果。具体是哪一种情况无从考证，不过后者可能性比较大
     */
    [self two:imageView];
    
    /*
     *   方式三：UIBezierPath+CAShapeLayer配合CALayer的mask属性实现，本质也是对图层的操作。（无法看到背景色brownColor）
     */
//    [self three:imageView];
}

-(void)one:(UIImageView *)imageView
{
    imageView.layer.cornerRadius = imageView.frame.size.width / 2;
    imageView.layer.masksToBounds = YES;
}

-(void)two:(UIImageView *)imageView
{
    //1，创建一张和imageView大小一致的画布（一块方形画布）
    UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, NO, [UIScreen mainScreen].scale);
    
    //2，在画布上切出圆形（切成圆形画布）
    //                        UIBezierPath方式
//    [[UIBezierPath bezierPathWithRoundedRect:imageView.bounds cornerRadius:imageView.frame.size.width/2] addClip];
    //                      CGContextRef方式实现
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddArc(context, imageView.bounds.size.width/2, imageView.bounds.size.height/2, imageView.bounds.size.width/2, 0, M_PI *2, YES);
    CGContextClip(context);

    //3，将内容绘制到画布区域（方形imageView绘制到圆形画布中，最终显示圆形区域的内容）
    [imageView drawRect:imageView.bounds];
    
    //4，将3中的圆形区域内容生成图片
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    
    //5，结束画图
    UIGraphicsEndImageContext();
}

-(void)three:(UIImageView *)imageView
{
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:imageView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:imageView.bounds.size];
    maskLayer.path = maskPath.CGPath;
    imageView.layer.mask = maskLayer;
}


@end
