//
//  LCImagePickerViewController.m
//  LCPickerControllerDemo
//
//  Created by bawn on 11/4/15.
//  Copyright © 2015 bawn. All rights reserved.
//

#import "LCImagePickerController.h"
#import "LCImageGroupViewController.h"
#import "LCImagePickerDefines.h"
#import "NSBundle+LCImagePickerController.h"

NSString * const LCImagePickerSelectedAssetsDidChangeNotification = @"LCImagePickerSelectedAssetsDidChangeNotification";
NSString * const LCImagePickerDidSelectAssetNotification = @"LCImagePickerDidSelectAssetNotification";
NSString * const LCImagePickerDidDeselectAssetNotification = @"LCImagePickerDidDeselectAssetNotification";

@interface LCImagePickerController ()<UINavigationControllerDelegate>

@property (nonatomic, strong) NSMutableArray *selectedAssets;
@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;


@end

@implementation LCImagePickerController


- (instancetype)init{
    self = [super init];
    if (self) {
        _selectedAssets = [NSMutableArray array];
        _showsCancelButton = YES;
        [self setupNavigationController];
    }
    return self;
}

- (void)setSelectedAssets:(NSMutableArray *)selectedAssets{
    if ([selectedAssets isKindOfClass:[NSMutableArray class]]) {
        _selectedAssets = selectedAssets;
    }
    else{
        _selectedAssets = [NSMutableArray arrayWithArray:selectedAssets];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (UIViewController *)childViewControllerForStatusBarStyle
{
    return self.childViewControllers.firstObject;
}

#pragma mark - Check authorization status

//- (void)checkAuthorizationStatus
//{
//    ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
//    switch (status)
//    {
//        case ALAuthorizationStatusNotDetermined:
////            [self requestAuthorizationStatus];
//            break;
//        case ALAuthorizationStatusRestricted:// 未被授权访问相册，比如家长控制选项
//        case ALAuthorizationStatusDenied:// 用户禁用访问相册
//        {
////            [self showAccessDenied];
//            if (self.delegate && [self.delegate respondsToSelector:@selector(imagePickerDidShow:)]) {
//                [self.delegate imagePickerDidShow:self];
//            }
//            break;
//        }
//        case ALAuthorizationStatusAuthorized:// 已授权访问相册
//        default:
//        {
//            
//            break;
//        }
//    }
//}

#pragma mark - Check assets count



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Setup Navigation Controller

- (void)setupNavigationController{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LCImagePicker" bundle:[NSBundle lcAssetsPickerControllerBundle]];
    LCImageGroupViewController *vc = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([LCImageGroupViewController class])];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    nav.interactivePopGestureRecognizer.enabled  = YES;
    nav.interactivePopGestureRecognizer.delegate = nil;
    
    nav.delegate = self;
    [nav willMoveToParentViewController:self];
    
    [nav.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:nav.view];
    [self addChildViewController:nav];
    [nav didMoveToParentViewController:self];
}



#pragma mark - ALAssetsLibrary

+ (ALAssetsLibrary *)defaultAssetsLibrary{

    static dispatch_once_t onceToken;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&onceToken, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}


- (ALAssetsLibrary *)assetsLibrary{
    if (nil == _assetsLibrary){
        _assetsLibrary = [self.class defaultAssetsLibrary];
    }
    
    return _assetsLibrary;
}


#pragma mark - Indexed Accessors

- (NSUInteger)countOfSelectedAssets{
    return self.selectedAssets.count;
}

- (id)objectInSelectedAssetsAtIndex:(NSUInteger)index{
    return [self.selectedAssets objectAtIndex:index];
}


- (void)insertObject:(id)object inSelectedAssetsAtIndex:(NSUInteger)index{
    if (self.allowsMultipleSelection) {
        [self.selectedAssets insertObject:object atIndex:index];
    }
    else{
        [self.selectedAssets removeAllObjects];
        [self.selectedAssets insertObject:object atIndex:0];
    }
}

- (void)removeObjectFromSelectedAssetsAtIndex:(NSUInteger)index{
    [self.selectedAssets removeObjectAtIndex:index];
}

- (void)replaceObjectInSelectedAssetsAtIndex:(NSUInteger)index withObject:(ALAsset *)object{
    [self.selectedAssets replaceObjectAtIndex:index withObject:object];
}

#pragma mark - Post Notifications

- (void)postAssetsDidChangedNotification:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:LCImagePickerSelectedAssetsDidChangeNotification object:sender];
}

- (void)postDidSelectAssetNotification:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:LCImagePickerDidSelectAssetNotification object:sender];
}


- (void)postDidDeselectAssetNotification:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:LCImagePickerDidDeselectAssetNotification object:sender];
}



#pragma mark - Select / Deselect Asset

- (void)selectAsset:(ALAsset *)asset{
    [self insertObject:asset inSelectedAssetsAtIndex:self.countOfSelectedAssets];
    [self postDidSelectAssetNotification:asset];
    
}

- (void)deselectAsset:(ALAsset *)asset{
    [self removeObjectFromSelectedAssetsAtIndex:[self.selectedAssets indexOfObject:asset]];
    [self postDidDeselectAssetNotification:asset];
}


#pragma mark - Actions

- (void)dismiss:(id)sender{
    if ([self.delegate respondsToSelector:@selector(imagePickerControllerDidCancel:)]) {
        [self.delegate imagePickerControllerDidCancel:self];
    } else {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}


- (void)finishPickingAssets:(id)sender{
    if ([self.delegate respondsToSelector:@selector(imagePickerController:didFinishPickingAssets:)]){
        [self.delegate imagePickerController:self didFinishPickingAssets:self.selectedAssets];
    }
}

@end
