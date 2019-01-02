.DEFAULT_GOAL := build
APP="unpin"
CONSTRUCT=xcodebuild -project $(APP).xcodeproj -scheme $(APP) clean
PROJECTPATH=$(CURDIR)

create_config:
	swift package resolve
	swift package generate-xcodeproj
update_config:
	perl -pi.back -e 's/MACOSX_DEPLOYMENT_TARGET = 10.10/MACOSX_DEPLOYMENT_TARGET = 10.14/g;' $(APP).xcodeproj/project.pbxproj
clean:
	rm -rf bin .build $(APP).xcodeproj Package.pins
build: clean create_config update_config
	$(CONSTRUCT) archive -archivePath bin/$(APP)
	cp bin/$(APP).xcarchive/Products/usr/local/bin/$(APP) bin/
	rm -rf bin/unpin.xcarchive
