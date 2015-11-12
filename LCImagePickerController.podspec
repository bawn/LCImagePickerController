Pod::Spec.new do |s|
  s.name             = "LCImagePickerController"
  s.version          = "0.1.2"
  s.summary          = "多选图片库"
  s.homepage         = "https://github.com/bawn/LCImagePickerController"
  s.license          = 'MIT'
  s.author           = { "bawn" => "lc5491137@gmail.com" }
  s.source           = { :git => "https://github.com/bawn/LCImagePickerController.git", :tag => s.version.to_s }
  s.platform         = :ios, '7.0'
  s.requires_arc     = true
  s.source_files     = "LCImagePickerController/**/*.{h,m}"
  s.resource_bundles = { "LCImagePickerController" => ["LCImagePickerController/*.storyboard"] }
  s.dependency       "Masonry", "~> 0.6.0"
  s.frameworks       = "AssetsLibrary"

end
