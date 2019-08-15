
Pod::Spec.new do |spec| 
  spec.name         = 'fmdb_pickviewController' #库名字
  spec.version      = '3.1.0' #版本号
  spec.license      = { :type => 'BSD' } #许可协议
  spec.homepage     = 'https://github.com/yaocunli/FMDB' #主页
  spec.authors      = { 'licy' => 'licunyao1@gmail.com' } #作者
  spec.summary      = 'tsestsfaf' #简介
  spec.source       = { :git => 'https://github.com/yaocunli/FMDB.git', :tag => 'v3.1.0' } #仓库地址
  spec.source_files = 'ResidenceModel.{h,m}' #参与编译的文件
  spec.ios.deployment_target = '8.0'

end

