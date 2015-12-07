//
//  LCImgaeCollectionViewController.m
//  LCPickerControllerDemo
//
//  Created by bawn on 11/4/15.
//  Copyright © 2015 bawn. All rights reserved.
//

#import "LCImgaeCollectionViewController.h"
#import "LCImagePickerController.h"
#import "LCImageCollectionViewCell.h"
#import "LCImagePickerViewController+Internal.h"
#import "LCImageCollectionBackgroundView.h"
#import "LCCameraCollectionViewCell.h"
#import "ALAsset+url.h"
#import "ALAsset+date.h"
#import "Masonry.h"

static NSString *const kAssetsCellIdentifier = @"assetsCell";
static NSString *const kCameraCellIdentifier = @"cameraCell";

@interface LCImgaeCollectionViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) LCImagePickerController *imagePicker;
@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, assign) BOOL didLayoutSubviews;
@property (nonatomic, assign) BOOL didImagePickerShow;
@property (nonatomic, strong) NSMutableArray *assets;

@end

@implementation LCImgaeCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self setupAssets];
    [self addNotificationObserver];
}

// 滚动到底部
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if (!self.didLayoutSubviews && self.assets.count > 0){
        [self scrollToBottomIfNeeded];
        self.didLayoutSubviews = YES;
    }
}

- (void)setupButtons{
    if (self.imagePicker.delegate && [self.imagePicker.delegate respondsToSelector:@selector(doneButtonForImagePicker:)]) {
        UIButton *doneButton = [self.imagePicker.delegate doneButtonForImagePicker:self.imagePicker];
        [doneButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
        [doneButton addTarget:self.imagePicker action:@selector(finishPickingAssets:) forControlEvents:UIControlEventTouchUpInside];
    }
    else{
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self.imagePicker action:@selector(finishPickingAssets:)];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    if (self.imagePicker.delegate && [self.imagePicker.delegate respondsToSelector:@selector(backButtonForImagePicker:)]) {
        UIButton *backButton = [self.imagePicker.delegate backButtonForImagePicker:self.imagePicker];
        [backButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    }
}


- (void)backAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [self removeNotificationObserver];
}


- (void)initUI{
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.collectionView.allowsMultipleSelection = self.imagePicker.allowsMultipleSelection;
    self.flowLayout.minimumInteritemSpacing = 0;
    self.flowLayout.minimumLineSpacing = 1;
    CGFloat size = ([UIScreen mainScreen].bounds.size.width - 3.0f)/4;
    self.flowLayout.itemSize = CGSizeMake(size, size);
    self.flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    // 设置背景色
    self.collectionView.backgroundColor = [LCImageCollectionBackgroundView appearance].collectionBackgroundColor;
    [self setupButtons];
}


- (void)setupAssets{
    self.title = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    if (!_assets){
        self.assets = [[NSMutableArray alloc] init];
    }
    else{
        return;
    }
    
    [self.assetsGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            [self.assets addObject:result];
        }
    }];
    // 排序排列
    if (self.imagePicker.descendingOrder) {
        NSSortDescriptor *dateSort = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
        [self.assets sortUsingDescriptors:@[dateSort]];
    }
    if (self.imagePicker.showCameraCell) {
        ALAsset *asset = [[ALAsset alloc] init];
        [self.assets insertObject:asset atIndex:0];
    }
    if (self.imagePicker.defaultGroupType && !self.didImagePickerShow) {
        if (self.imagePicker.delegate && [self.imagePicker.delegate respondsToSelector:@selector(imagePickerDidShow:)]) {
            [self.imagePicker.delegate imagePickerDidShow:self.imagePicker];
        }
        self.didImagePickerShow = YES;
    }
}


#pragma mark - Scroll to bottom

- (void)scrollToBottomIfNeeded{
    BOOL shouldScrollToBottom;
    
    if ([self.imagePicker.delegate respondsToSelector:@selector(imagePickerControllerShouldScrollToBottom:)]){
        shouldScrollToBottom = [self.imagePicker.delegate imagePickerControllerShouldScrollToBottom:self.imagePicker];
    }
    else{
        shouldScrollToBottom = YES;
    }
    
    if (shouldScrollToBottom){
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.assets.count - 1 inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
    }
}


#pragma mark - Notifications

- (void)addNotificationObserver{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center addObserver:self
               selector:@selector(assetsLibraryChanged:)
                   name:ALAssetsLibraryChangedNotification
                 object:nil];
    
    [center addObserver:self
               selector:@selector(selectedAssetsChanged:)
                   name:LCImagePickerSelectedAssetsDidChangeNotification
                 object:nil];
    
    [center addObserver:self
               selector:@selector(assetsPickerDidSelectAsset:)
                   name:LCImagePickerDidSelectAssetNotification
                 object:nil];
    
    [center addObserver:self
               selector:@selector(assetsPickerDidDeselectAsset:)
                   name:LCImagePickerDidDeselectAssetNotification
                 object:nil];
    
}

- (void)removeNotificationObserver{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:ALAssetsLibraryChangedNotification object:nil];
    [center removeObserver:self name:LCImagePickerSelectedAssetsDidChangeNotification object:nil];
    [center removeObserver:self name:LCImagePickerDidSelectAssetNotification object:nil];
    [center removeObserver:self name:LCImagePickerDidDeselectAssetNotification object:nil];
}


#pragma mark - Assets Library Changed

- (void)assetsLibraryChanged:(NSNotification *)notification{
    // 重置所有的专辑
    if (notification.userInfo == nil){
        [self performSelectorOnMainThread:@selector(reloadAssets) withObject:nil waitUntilDone:NO];
    }
    
    // 重置受影响的专辑
    if (notification.userInfo.count > 0){
        [self reloadAssetsGroupForUserInfo:notification.userInfo];
    }
}


#pragma mark - Reload Assets Group

- (void)reloadAssetsGroupForUserInfo:(NSDictionary *)userInfo{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSSet *updateAsstes = [userInfo objectForKey:ALAssetLibraryUpdatedAssetsKey];
        if (updateAsstes.allObjects.count) {
            
            NSSet *URLs = [userInfo objectForKey:ALAssetLibraryUpdatedAssetGroupsKey];
            NSURL *URL  = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyURL];
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF == %@", URL];
            NSArray *matchedGroups = [URLs.allObjects filteredArrayUsingPredicate:predicate];
            if (matchedGroups.count > 0){
                // 默认相机拍照图片储存后 updateAsstes 数量为 3 而且是最后三个 Asstes，删除照片的情况，updateAsstes 数量就是 3 + n
                // 代码添加保存照片时，会接受到三次通知，其中两次的同时分别是 最后三个 Asstes 和 添加的照片的 Asstes
                if (updateAsstes.allObjects.count != 3) {
                    NSPredicate *pred = [NSPredicate predicateWithFormat:@"NOT (url IN %@ )", updateAsstes.allObjects];
                    [self.imagePicker.selectedAssets filterUsingPredicate:pred];
                }
                [self reloadAssets];
            }
        }
    });
}

#pragma mark - Selected Assets Changed

- (void)selectedAssetsChanged:(NSNotification *)notification{
    //    NSArray *selectedAssets = (NSArray *)notification.object;
    
    //    [[self.toolbarItems objectAtIndex:1] setTitle:[self.picker toolbarTitle]];
    //
    //    [self.navigationController setToolbarHidden:(selectedAssets.count == 0) animated:YES];
    
    // Reload assets for calling de/selectAsset method programmatically
    //    [self.collectionView reloadData];
}

- (void)assetsPickerDidSelectAsset:(NSNotification *)notification{
    ALAsset *asset = (ALAsset *)notification.object;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[self.assets indexOfObject:asset] inSection:0];
    if (self.imagePicker.allowsMultipleSelection) {
        [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        [self updateSelectionOrderLabels];
    }
    else{
        [self.imagePicker finishPickingAssets:nil];
    }
}

- (void)assetsPickerDidDeselectAsset:(NSNotification *)notification{
    ALAsset *asset = (ALAsset *)notification.object;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[self.assets indexOfObject:asset] inSection:0];
    [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
    [self updateSelectionOrderLabels];
}


#pragma mark - Reload Assets

- (void)reloadAssets{
    [self.assets removeAllObjects];
    self.assets = nil;
    [self setupAssets];
    [self.collectionView reloadData];
}

#pragma mark - Update Selection Order Labels

- (void)updateSelectionOrderLabels{
    for (NSIndexPath *indexPath in [self.collectionView indexPathsForSelectedItems]){
        ALAsset *asset = [self assetAtIndexPath:indexPath];
        LCImageCollectionViewCell *cell = (LCImageCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        cell.selectionIndex = [self.imagePicker.selectedAssets indexOfObject:asset];
    }
}


#pragma mark - Accessors

- (LCImagePickerController *)imagePicker{
    return (LCImagePickerController *)self.navigationController.parentViewController;
}

- (ALAsset *)assetAtIndexPath:(NSIndexPath *)indexPath{
    return (self.assets.count > 0) ? self.assets[indexPath.item] : nil;
}


#pragma mark - UICollectionView Method

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  _assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if ((self.imagePicker.showCameraCell && indexPath.row) || !self.imagePicker.showCameraCell) {
        LCImageCollectionViewCell *cell = (LCImageCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kAssetsCellIdentifier forIndexPath:indexPath];
        ALAsset *asset = [self.assets objectAtIndex:indexPath.row];
        if ([self.imagePicker.selectedAssets containsObject:asset]){
            cell.selected = YES;
            cell.selectionIndex = [self.imagePicker.selectedAssets indexOfObject:asset];
            [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        }
        [cell configWithItem:_assets[indexPath.row]];
        return cell;
    }
    else {
        LCCameraCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCameraCellIdentifier forIndexPath:indexPath];
        return cell;
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ALAsset *asset = [self.assets objectAtIndex:indexPath.row];
    if ([self.imagePicker.delegate respondsToSelector:@selector(imagePickerController:shouldSelectAsset:)]){
        return [self.imagePicker.delegate imagePickerController:self.imagePicker shouldSelectAsset:asset];
    }
    else{
        return YES;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ALAsset *asset = [self.assets objectAtIndex:indexPath.row];
    if (self.imagePicker.delegate && [self.imagePicker.delegate respondsToSelector:@selector(collectionPickerController:didSelectItemAtIndexPath:asset:)]){
        BOOL showOther = [self.imagePicker.delegate collectionPickerController:self didSelectItemAtIndexPath:indexPath asset:asset];
        if (showOther) {
            [collectionView deselectItemAtIndexPath:indexPath animated:YES];
        }
        else{
            [self.imagePicker selectAsset:asset];
        }
    }
    else{
        [self.imagePicker selectAsset:asset];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    ALAsset *asset = [self.assets objectAtIndex:indexPath.row];
    [self.imagePicker deselectAsset:asset];
}

@end
