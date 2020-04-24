Pod::Spec.new do |s|

  s.name                = "FloatingSideMenu"
  s.version             = "1.0.3"
  s.summary             = "Side menu with floating design."
  s.description         = "Customizable side menu with floating design."
  s.homepage            = "https://github.com/LesGrob/FloatingSideMenu"
  s.license             = "MIT"
  s.author              = { "Nikita Kurochkin" => "kurochkin.nikita.a@gmail.com" }
  s.platform            = :ios, "11.0"
  s.source              = { :git => "https://github.com/LesGrob/FloatingSideMenu.git", :tag => "#{s.version}" }
  s.source_files        = "FloatingSideMenu"
  s.swift_version       = "4.2"

end
