Pod::Spec.new do |s|

s.author = {'licy' => 'licunyao1@gmail.com'}
s.license = 'Apache License 2.0'
s.requires_arc = true
s.version = '0.0.1'
s.homepage = "https://github.com/yaocunli/FMDB"
s.name = "fmdb_pickviewController"

s.source_files = 'fmdb_pickviewController/Entity/*/.{h,m}'
s.source = { :git => 'https://github.com/yaocunli/FMDB.git', :tag => s.version }
s.summary = '简述'
s.description = '描述'

end

