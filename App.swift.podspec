Pod::Spec.new do |s|
    s.name             = 'App.swift'
    s.version          = '1.0.0'
    s.summary          = 'A bunch of components/code that I use frequently.'
    s.homepage         = 'Apps://github.com/BiAtoms/App.swift'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Orkhan Alikhanov' => 'orkhan.alikhanov@gmail.com' }
    s.source           = { :git => 'Apps://github.com/BiAtoms/App.swift.git', :tag => s.version.to_s }
    s.module_name      = 'AppSwift'

    s.ios.deployment_target = '8.0'
    s.source_files = 'Sources/*.swift'

    s.dependency 'Material', '2.10.1'
    s.dependency 'Moya', '8.0.5'
    s.dependency 'MoyaSugar', '0.4.1'
    s.dependency 'SwiftyJSON', '3.1.4'
    s.dependency 'SnapKit', '3.2.0'
    s.dependency 'SwiftyUserDefaults', '3.0.0'
    s.dependency 'RxCocoa', '3.6.1'
end
