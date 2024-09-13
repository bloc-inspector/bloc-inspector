install:
		(flutter pub get; flutter pub run build_runner build --delete-conflicting-outputs; npm install -g appdmg)

dmg:
		(flutter build macos; rm ./installer/macos_dmg/flutter-bloc-inspector.dmg; appdmg ./installer/macos_dmg/config.json ./installer/macos_dmg/flutter-bloc-inspector.dmg)