APP="unpin"
CONSTRUCT=xcodebuild -workspace $(APP).xcworkspace -scheme $(APP) clean

install_deps:
	pod install
create_config:
	swift package resolve
	swift package generate-xcodeproj
wipe:
	rm -rf .build $(APP).xcodeproj $(APP).xcworkspace Package.pins Pods Podfile.lock
build: wipe create_config install_deps
	$(CONSTRUCT) build 
