/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart' as _svg;
import 'package:vector_graphics/vector_graphics.dart' as _vg;

class $AssetsBackgroundGen {
  const $AssetsBackgroundGen();

  /// File path: assets/background/elipse.png
  AssetGenImage get elipse =>
      const AssetGenImage('assets/background/elipse.png');

  /// File path: assets/background/onboarding_background_elipse.svg
  SvgGenImage get onboardingBackgroundElipse =>
      const SvgGenImage('assets/background/onboarding_background_elipse.svg');

  /// List of all assets
  List<dynamic> get values => [elipse, onboardingBackgroundElipse];
}

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/Call.svg
  SvgGenImage get call => const SvgGenImage('assets/icons/Call.svg');

  /// File path: assets/icons/Keys.svg
  SvgGenImage get keys => const SvgGenImage('assets/icons/Keys.svg');

  /// File path: assets/icons/Message.svg
  SvgGenImage get message => const SvgGenImage('assets/icons/Message.svg');

  /// File path: assets/icons/Notification.svg
  SvgGenImage get notification =>
      const SvgGenImage('assets/icons/Notification.svg');

  /// File path: assets/icons/Send.svg
  SvgGenImage get send => const SvgGenImage('assets/icons/Send.svg');

  /// File path: assets/icons/Video.svg
  SvgGenImage get video => const SvgGenImage('assets/icons/Video.svg');

  /// File path: assets/icons/apple.svg
  SvgGenImage get apple => const SvgGenImage('assets/icons/apple.svg');

  /// File path: assets/icons/back_button.svg
  SvgGenImage get backButton =>
      const SvgGenImage('assets/icons/back_button.svg');

  /// File path: assets/icons/camera.svg
  SvgGenImage get camera => const SvgGenImage('assets/icons/camera.svg');

  /// File path: assets/icons/clip.svg
  SvgGenImage get clip => const SvgGenImage('assets/icons/clip.svg');

  /// File path: assets/icons/facebook.svg
  SvgGenImage get facebook => const SvgGenImage('assets/icons/facebook.svg');

  /// File path: assets/icons/github_icon.svg
  SvgGenImage get githubIcon =>
      const SvgGenImage('assets/icons/github_icon.svg');

  /// File path: assets/icons/google.svg
  SvgGenImage get google => const SvgGenImage('assets/icons/google.svg');

  /// File path: assets/icons/logo_for_black_back.svg
  SvgGenImage get logoForBlackBack =>
      const SvgGenImage('assets/icons/logo_for_black_back.svg');

  /// File path: assets/icons/logo_for_white_back.svg
  SvgGenImage get logoForWhiteBack =>
      const SvgGenImage('assets/icons/logo_for_white_back.svg');

  /// File path: assets/icons/microphone.svg
  SvgGenImage get microphone =>
      const SvgGenImage('assets/icons/microphone.svg');

  /// File path: assets/icons/more.svg
  SvgGenImage get more => const SvgGenImage('assets/icons/more.svg');

  /// File path: assets/icons/search.svg
  SvgGenImage get search => const SvgGenImage('assets/icons/search.svg');

  /// File path: assets/icons/settings.svg
  SvgGenImage get settings => const SvgGenImage('assets/icons/settings.svg');

  /// File path: assets/icons/trash.svg
  SvgGenImage get trash => const SvgGenImage('assets/icons/trash.svg');

  /// File path: assets/icons/user-add.svg
  SvgGenImage get userAdd => const SvgGenImage('assets/icons/user-add.svg');

  /// File path: assets/icons/user.svg
  SvgGenImage get user => const SvgGenImage('assets/icons/user.svg');

  /// List of all assets
  List<SvgGenImage> get values => [
        call,
        keys,
        message,
        notification,
        send,
        video,
        apple,
        backButton,
        camera,
        clip,
        facebook,
        githubIcon,
        google,
        logoForBlackBack,
        logoForWhiteBack,
        microphone,
        more,
        search,
        settings,
        trash,
        userAdd,
        user
      ];
}

class $AssetsLangGen {
  const $AssetsLangGen();

  /// File path: assets/lang/en.json
  String get en => 'assets/lang/en.json';

  /// File path: assets/lang/pt_br.json
  String get ptBr => 'assets/lang/pt_br.json';

  /// List of all assets
  List<String> get values => [en, ptBr];
}

class Assets {
  Assets._();

  static const $AssetsBackgroundGen background = $AssetsBackgroundGen();
  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsLangGen lang = $AssetsLangGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class SvgGenImage {
  const SvgGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  }) : _isVecFormat = false;

  const SvgGenImage.vec(
    this._assetName, {
    this.size,
    this.flavors = const {},
  }) : _isVecFormat = true;

  final String _assetName;
  final Size? size;
  final Set<String> flavors;
  final bool _isVecFormat;

  _svg.SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    _svg.SvgTheme? theme,
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    final _svg.BytesLoader loader;
    if (_isVecFormat) {
      loader = _vg.AssetBytesLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
      );
    } else {
      loader = _svg.SvgAssetLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
        theme: theme,
      );
    }
    return _svg.SvgPicture(
      loader,
      key: key,
      matchTextDirection: matchTextDirection,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      colorFilter: colorFilter ??
          (color == null ? null : ColorFilter.mode(color, colorBlendMode)),
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
