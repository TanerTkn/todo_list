class SvgConstant {
  static SvgConstant instance = SvgConstant._init();

  SvgConstant._init();

  static const String basePath = 'assets';

  static final String appBarIcon = '$basePath/appBarIcon'.toSvg;
  static final String orangeCircularIcon = '$basePath/orangeCircularIcon'.toSvg;
  static final String pinkblueCircularIcon =
      '$basePath/pinkblueCircularIcon'.toSvg;
  static final String deepBlueCircularIcon =
      '$basePath/deepBlueCircularIcon'.toSvg;
  static final String lightBlueCircularIcon =
      '$basePath/lightBlueCircularIcon'.toSvg;
  static final String listBottomIcon = '$basePath/listBottomIcon'.toSvg;
  static final String multiCheckIcon = '$basePath/multiCheck'.toSvg;
  static final String multiplayCircularIcon =
      '$basePath/multiplayCircularIcon'.toSvg;

  static final String calendar = '$basePath/calendar'.toSvg;
  static final String check = '$basePath/check'.toSvg;
  static final String plus = '$basePath/plus'.toSvg;
  static final String shopping = '$basePath/shopping'.toSvg;

  static final String blueCircularButton = '$basePath/blueCircularButton'.toSvg;
  static final String pinkCircularButton = '$basePath/pinkCircularButton'.toSvg;
  static final String whiteCircularButton =
      '$basePath/whiteCircularButton'.toSvg;
  static final String addRectangleButton = '$basePath/addButton'.toSvg;
  static final String blackCircularButton =
      '$basePath/blackCircularButton'.toSvg;

  static final String weight = '$basePath/weight'.toSvg;
  static final String coding = '$basePath/coding'.toSvg;
  static final String console = '$basePath/console'.toSvg;
}

extension SvgsConstantExtension on String {
  String get toSvg => '$this.svg';
  String get toPng => '$this.png';
}
