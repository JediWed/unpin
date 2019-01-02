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
	$(CONSTRUCT) build -configuration Release -derivedDataPath bin
	cp -R bin/Build/Products/Release/*.framework bin/
	cp bin/Build/Products/Release/unpin bin/
	rm -rf bin/Build bin/Logs bin/ModuleCache.noindex bin/info.plist