/// 系统类型
enum UASystem {
  windows,
  android,
  ios,
  macos,
  linux,
  fuchsia,
  blackberry,
  chromeos,
}

/// 设备类型
enum UADevice {
  pc,
  mobile,
  pad,
}

/// 浏览器类型
enum UABrowser {
  chrome,
  edge,
  safari,
  ie,
  firefox,
  opera,
  uc,
}

/// 引擎类型
enum UAEngine {
  webKit,
  trident,
  gecko,
  presto,
}

/// 动态创建userAgent
class UserAgent {
  final StringBuffer _build = StringBuffer();

  String _mozillaVersion = '5.0';
  UASystem? _system;
  String? _systemName;
  String? _systemVersion;

  UADevice? _device;
  String? _deviceName;
  String? _deviceVersion;

  UABrowser? _browser;
  String? _browserVersion;
  String? _chromeVersion;
  String? _webkitVersion;

  UAEngine? _engine;
  String _engineVersion = '537.36';

  bool _isX64 = false;

  UserAgent([String mozillaVersion = '5.0']) {
    _mozillaVersion = mozillaVersion;
  }

  /// 设置系统及版本
  void system(UASystem system, {String? version, String? systemName}) {
    _system = system;
    _systemName = systemName;
    _systemVersion = version;
  }

  /// 设置设备及版本
  void device(UADevice device, {String? version, String? deviceName}) {
    _device = device;
    _deviceVersion = version;
    _deviceName = deviceName;
  }

  /// 设置浏览器及版本，包括混合版本
  void browser(
    UABrowser browser, {
    String? version,
    String? webkitVersion,
    String? chromeVersion,
  }) {
    _browser = browser;
    _browserVersion = version;
    _webkitVersion = webkitVersion;
    _chromeVersion = chromeVersion;
  }

  /// 设置引擎及版本
  void engine(UAEngine engine, {String version = '537.36'}) {
    _engine = engine;
    _engineVersion = version;
  }

  /// 设置前缀的Mozilla版本 默认为5.0
  void mozillaVersion(String version) {
    _mozillaVersion = version;
  }

  /// 是否64位应用，针对Windows系统
  void x64(bool isX64) {
    _isX64 = isX64;
  }

  /// 根据设置好的参数创建userAgent
  String build() {
    _build.clear();
    _build.write('Mozilla/$_mozillaVersion ');
    final isIE11 =
        _browser == UABrowser.ie && _browserVersion?.substring(0, 2) == '11';
    switch (_system) {
      case UASystem.windows:
        if (_browser == UABrowser.ie) {
          bool isLower7 = false;
          if (_engine != UAEngine.trident) {
            // IE 强制trident
            _engine = UAEngine.trident;
            _browserVersion ??= '10.0';
            switch (_browserVersion![0]) {
              case '4':
              case '5':
              case '6':
              case '7':
                isLower7 = true;
                break;
              case '8':
                _engineVersion = '4.0';
                break;
              case '9':
                _engineVersion = '5.0';
                break;
              default:
                _engineVersion = isIE11 ? '7.0' : '6.0';
                break;
            }
          }
          if (isIE11) {
            _build.write('(Windows NT ${_systemVersion ?? '10.0'}; '
                '${_isX64 ? 'Win64; x64' : 'WOW64'}; '
                'Trident/$_engineVersion; rv:11.0)');
          } else if (isLower7) {
            _build.write('(compatible; MSIE $_browserVersion; '
                'Windows NT ${_systemVersion ?? '10.0'}; ');
          } else {
            _build.write('(compatible; MSIE $_browserVersion; '
                'Windows NT ${_systemVersion ?? '10.0'}; '
                'Trident/$_engineVersion) ');
          }
        } else {
          _build.write('(Windows NT ${_systemVersion ?? '10.0'}; '
              '${_isX64 ? 'Win64; x64' : 'WOW64'}) ');
        }
        break;
      case UASystem.ios:
        if (_device != UADevice.mobile && _device != UADevice.pad) {
          device(UADevice.mobile);
        }
        switch (_device) {
          case UADevice.mobile:
            _build.write(
                '(iPhone; CPU iPhone OS $_systemVersion like Mac OS X) ');
            break;
          case UADevice.pad:
            _build.write('(iPad; CPU OS $_systemVersion like Mac OS X) ');
            break;
          case UADevice.pc:
          default:
            break;
        }
        break;
      case UASystem.macos:
        if (_device != UADevice.pc) {
          device(UADevice.pc);
        }
        _build.write(
            '(Macintosh; Intel Mac OS X ${_systemVersion ?? '10_14_6'}) ');
        break;
      case UASystem.android:
        if (_device != UADevice.mobile && _device != UADevice.pad) {
          device(UADevice.mobile);
        }
        _build.write('(Linux; Android ${_systemVersion ?? '10'}; '
            '${_deviceName ?? 'Nexus 7'} Build/${_deviceVersion ?? 'MOB30X'}) ');
        break;
      case UASystem.linux:
        // TODO: fix
        _build.write('(Linux; $_systemName ${_systemVersion ?? '10'};) ');
        break;
      case UASystem.fuchsia:
        // TODO:
        _build.write('');
        break;
      case UASystem.blackberry:
        _build.write('(BlackBerry; U; BlackBerry $_systemVersion; en-US) ');
        break;
      case UASystem.chromeos:
        _build.write('(X11; CrOS x86_64 $_systemVersion) ');
        break;
      default:
        _build.write('(Windows NT 10.0; Win64; x64) ');
    }
    switch (_engine) {
      case UAEngine.trident:
        if (isIE11) {
          _build.write('like Gecko');
        }
        break;
      case UAEngine.gecko:
        _build.write('Gecko/$_engineVersion ');
        break;
      case UAEngine.webKit:
      default:
        _build.write('AppleWebKit/$_engineVersion (KHTML, like Gecko) ');
        break;
    }

    switch (_browser) {
      case UABrowser.chrome:
        _build.write(
            'Chrome/${_browserVersion ?? _chromeVersion} Safari/$_engineVersion');
        break;
      case UABrowser.edge:
        _build.write('Chrome/${_chromeVersion ?? _browserVersion} '
            'Safari/$_engineVersion '
            'Edg/$_browserVersion');
        break;
      case UABrowser.firefox:
        if (_device != UADevice.pc && _system == UASystem.ios) {
          _build.write('FxiOS/1.0 Mobile/12F69 Safari/$_engineVersion');
        } else {
          _build.write('Firefox/$_browserVersion');
        }
        break;
      case UABrowser.ie:
        break;
      case UABrowser.safari:
        _build.write(
            'Version/13.0.3${_device != UADevice.pc ? ' Mobile/${_deviceVersion ?? '15E148'}' : ''} Safari/${_browserVersion ?? '605.1.15'}');
        break;
      case UABrowser.opera:
        if (_engine == UAEngine.presto) {
          _build.write('Presto/2.9.201 Version/12.02');
        } else {
          _build.write(
              'Chrome/${_chromeVersion ?? '78.0.3904.97'} Safari/$_engineVersion OPR/${_browserVersion ?? '65.0.3467.48'}');
        }
        break;
      case UABrowser.uc:
        _build.write(
            'Version/4.0 Chrome/${_chromeVersion ?? '57.0.2987.108'} UCBrowser/${_browserVersion ?? '12.11.1.1197'} Mobile Safari/$_engineVersion');
        break;
      default:
        _build.write("Chrome/98.0.4758.102 Safari/537.36 Edg/98.0.1108.56");
    }
    return _build.toString();
  }
}
