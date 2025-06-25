import '../size_config.dart';

// extension SizeExtension on num {
//   num get height => SizeConfig.height(this.toDouble());
//
//   num get width => SizeConfig.width(this.toDouble());
//
//   num get text => SizeConfig.textSize(this.toDouble());
// }
extension SizeExtension on num {
  double get height => (SizeConfig.blockSizeVertical * this).toDouble();
  double get width => (SizeConfig.blockSizeHorizontal * this).toDouble();
  double get text => (SizeConfig.textMultiplier * this).toDouble();
}
