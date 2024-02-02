# bundleSuffix

- **LAST UPDATED 18-JAN-2024**

A complete, self-contained, Flutter app that is the starting point for an **App** for iOS, MacOS, Android, Windows, and Chrome

- The outline has light, dark, and system theme mode switching using *hooks_riverpod* for state management.
- Theme mode is persisted using *hive_flutter* database.
- Dependency management and navigation is done using *flutter_modular*.

## Getting Started

### These are the steps when using VSCode

- Find/Replace `app_template` to name of the flutter name of the app (ex: `my_spiffy_app`)
- Find/Replace `MyAppName` to a label used to name the app on mobile Platforms (ex:`My Spiffy Mobile App`)
- Find/Replace `macOSName` to the name of your macOS app (ex: `My Spiffy macOS App`)
- Find/Replace `my.domain` to the project down for the product/customer (ex: `apple.com`)
- Find/Replace `reverse.domain` with the projects **reverse domain** that the start of the apps' identifier (ex: `com.apple`)
- Find/Replace `bundleSuffix` with bundle id (ex: `my_spiffy_app`) **[using the folder name is ideal]**
- Find/Replace `AppleSuffix` for Apple bundles as iOS/MacOS do like '_'. **[ideal is folder name to lower-camel case (ex: `mySpiffyApp`)]**
- The image `/assets/images/ltmm1024x1024.png` is a placeholder image to generate application icons. In the `pubspec.yaml` file is section marked *flutter_icons*:

  ```dart
  flutter_icons:
  android: 'launcher_icon'
  ios: true
  remove_alpha_ios: true
  image_path: 'assets/images/ltmm1024x1024.png'
  macos:
    generate: true
    image_path: 'assets/images/ltmm1024x1024.png'
  web:
    generate: true
    image_path: 'assets/images/ltmm1024x1024.png'
  windows:
    generate: true
    image_path: 'assets/images/ltmm1024x1024.png'

  ```

  This generates icons for the platforms by running from the terminal in the ide:

  ```dart
  % dart run flutter_launcher_icons
  ```

  generating icons for iOS/Mac/Android/Web and even Windows *(Widows sucks but I guess someone has to do it.)*

  NOTE: The sample app already has the [ltmm1024x1024](assets/images/ltmm1024x1024.png). The best images are 1024x1024. Replace the image and make sure the `image_path` in `pubspec.yaml` is updated and then run the
  `% dart run flutter_launcher_icons` again.

- From the terminal in the IDE:

  ```dart
  % flutter clean
  % flutter pub get
  % dart run build_runner build -d
  ```

The `build_runner` will generate `lib/gen/assets.gen.dart`, this is part of [flutter_gen_runner](https://pub.dev/packages/flutter_gen_runner), the flutter code generator for assets/fonts/colors to get rid of String-based APIs. Search `flutter_gen_runner` for an example of it's use.

All done, this is ideal first-commit for the new app.

## The template app is ready

### For ***macOS*** warnings

*IF* running ***macOS***, and there is a warning:

`The macOS deployment target 'MACOSX_DEPLOYMENT_TARGET' is set to 10.11, but the range of supported deployment target versions is 10.13 to 13.1.99. (in target 'FlutterMacOS' from project 'Pods')`

This is because *Launching/Running* an app the first time after *flutter pub get* generates serveral files that are **macOS** platform version 10.11

*WORKAROUND* Find/Replace `10.11` with `10.13` ![Only for macos path-ed files](/README/mac_os_deployment_target_workaround.png)

*NOTE* Make sure only ***macOS/*** pathed files are shown and replaced!!

### Summary of included files in /lib

- **main.dart** the entry point into the app
- **screens/app_module.dart** where routes and injects are defined {see **[flutter_modular]([https:www.cnn.com](https://pub.dev/packages/flutter_modular))**}
- **screens/home_scaffold** the start page for the app (its path of "/" is defined in *app_module.dart*), probably the first thing to replace
