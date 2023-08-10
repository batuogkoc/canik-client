// 	Maximum resemblance-Minimum resemblance count-Resemblance-Shot Acc Lower Threshold-Shot Acc Upper Threshold
// Live	85			70				5		2				15
// Dry	75			70				10		1				3.8
// Paint	85			70				5		2.3				15
// Blank	85			70				5		2.3				15
// Cool	85			78				7		2.5				15

import 'package:canik_lib/canik_lib.dart';

ShotConditions liveFireConditions = ShotConditions(85, 70, 5, 2, 15);
ShotConditions dryFireConditions = ShotConditions(75, 70, 10, 1, 3.8);
ShotConditions paintFireConditions = ShotConditions(85, 70, 5, 2.3, 15);
ShotConditions blankFireConditions = ShotConditions(85, 70, 5, 2.3, 15);
ShotConditions coolFireConditions = ShotConditions(85, 78, 7, 2.5, 15);
