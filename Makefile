.DEFAULT_GOAL := build
APP="unpin"
CONSTRUCT=xcodebuild -workspace $(APP).xcworkspace -scheme $(APP) clean
PROJECTPATH=$(CURDIR)

install_deps:
	pod install
create_config:
	swift package resolve
	swift package generate-xcodeproj
update_config:
	perl -pi.back -e 's/MACOSX_DEPLOYMENT_TARGET = 10.10/MACOSX_DEPLOYMENT_TARGET = 10.14/g;' $(APP).xcodeproj/project.pbxproj
clean:
	rm -rf bin .build $(APP).xcodeproj $(APP).xcworkspace Package.pins Pods Podfile.lock
build: clean create_config install_deps update_config
	$(CONSTRUCT) archive -archivePath bin/$(APP)
	cp bin/$(APP).xcarchive/Products/usr/local/bin/$(APP) bin/
	rm -rf bin/unpin.xcarchive
