Pod::Spec.new do |s|
 s.name = 'Restofire-Gloss'
 s.version = '1.0.0'
 s.license = { :type => "MIT", :file => "LICENSE" }
 s.summary = 'Restofire-Gloss is a component library for Restofire to serialize responses into Gloss'
 s.homepage = 'https://github.com/Restofire/Restofire-Gloss'
 s.social_media_url = 'https://twitter.com/rahulkatariya91'
 s.authors = { "Rahul Katariya" => "rahulkatariya@me.com" }
 s.source = { :git => "https://github.com/Restofire/Restofire-Gloss.git", :tag => "v"+s.version.to_s }
 s.platforms     = { :ios => "8.0", :osx => "10.10", :tvos => "9.0", :watchos => "2.0" }
 s.requires_arc = true

 s.default_subspec = "Core"
 s.subspec "Core" do |ss|
     ss.source_files  = "Sources/*.swift"
     ss.dependency "Restofire", "~> 1.0"
     ss.dependency "Gloss", "~> 0.7"
     ss.framework  = "Foundation"
 end

end
