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

@end

@implementation LCImagePickerController


- (instancetype)init{
    self = [super init];
    if (self) {
        self.selectedAssets = [NSMutableArray array];
        self.showsCancelButton = YES;
        [self setupNavigationController];
        [self addKeyValueObserver];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [self removeKeyValueObserver];
}

#pragma mark - Setup Navigation Controller

- (void)setupNavigationController
{
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



#pragma mark - Key-Value Observers

- (void)addKeyValueObserver{
    [self addObserver:self forKeyPath:@"selectedAssets" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
}

- (void)removeKeyValueObserver{
    [self removeObserver:self forKeyPath:@"selectedAssets"];
}

#pragma mark - Key-Value Changed

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqual:@"selectedAssets"]){
        
        [self postAssetsDidChangedNotification:[object valueForKey:keyPath]];
    }
}


#pragma mark - ALAssetsLibrary

+ (ALAssetsLibrary *)defaultAssetsLibrary
{

    static dispatch_once_t onceToken;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&onceToken, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}


- (ALAssetsLibrary *)assetsLibrary
{
    if (nil == _assetsLibrary){
        _assetsLibrary = [self.class defaultAssetsLibrary];
    }
    
    return _assetsLibrary;
}

#pragma mark - Indexed Accessors

- (NSUInteger)countOfSelectedAssets
{
    return self.selectedAssets.count;
}

- (id)objectInSelectedAssetsAtIndex:(NSUInteger)index
{
    return [self.selectedAssets objectAtIndex:index];
}


- (void)insertObject:(id)object inSelectedAssetsAtIndex:(NSUInteger)index
{
    [self.selectedAssets insertObject:object atIndex:index];
}

- (void)removeObjectFromSelectedAssetsAtIndex:(NSUInteger)index
{
    [self.selectedAssets removeObjectAtIndex:index];
}

- (void)replaceObjectInSelectedAssetsAtIndex:(NSUInteger)index withObject:(ALAsset *)object
{
    [self.selectedAssets replaceObjectAtIndex:index withObject:object];
}

#pragma mark - Post Notifications

- (void)postAssetsDidChangedNotification:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:LCImagePickerSelectedAssetsDidChangeNotification
                                                        object:sender];
}

- (void)postDidSelectAssetNotification:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:LCImagePickerDidSelectAssetNotification
                                                        object:sender];
}


- (void)postDidDeselectAssetNotification:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:LCImagePickerDidDeselectAssetNotification
                                                        object:sender];
}



#pragma mark - Select / Deselect Asset

- (void)selectAsset:(ALAsset *)asset
{
    [self insertObject:asset inSelectedAssetsAtIndex:self.countOfSelectedAssets];
    [self postDidSelectAssetNotification:asset];
    
}

- (void)deselectAsset:(ALAsset *)asset
{
    [self removeObjectFromSelectedAssetsAtIndex:[self.selectedAssets indexOfObject:asset]];
    [self postDidDeselectAssetNotification:asset];
}


#pragma mark - Actions

- (void)dismiss:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(imagePickerControllerDidCancel:)]) {
        [self.delegate imagePickerControllerDidCancel:self];
    } else {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}


- (void)finishPickingAssets:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(imagePickerController:didFinishPickingAssets:)]){
        [self.delegate imagePickerController:self didFinishPickingAssets:self.selectedAssets];
    }
}




@end
