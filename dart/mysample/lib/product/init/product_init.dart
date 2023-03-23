import 'package:mysample/cubit/add_location_cubit.dart';
import 'package:mysample/cubit/all_shot_record_cubit.dart';
import 'package:mysample/cubit/asked_question_cubit.dart';
import 'package:mysample/cubit/campaign_cubit.dart';
import 'package:mysample/cubit/canik_store_details_page_cubit.dart';
import 'package:mysample/cubit/compare_weapon_cubit.dart';
import 'package:mysample/cubit/dealer_cubit.dart';
import 'package:mysample/cubit/iys_add_cubit.dart';
import 'package:mysample/cubit/main_page_product_cubit.dart';
import 'package:mysample/cubit/product_cubit.dart';
import 'package:mysample/cubit/profile_image_cubit.dart';
import 'package:mysample/cubit/shot_timer_cubit.dart';
import 'package:mysample/cubit/special_page_cubit.dart';
import 'package:mysample/cubit/user_info_cubit.dart';
import 'package:mysample/cubit/weapon_add_cubit.dart';
import 'package:mysample/cubit/weapon_care_cubit.dart';
import 'package:mysample/cubit/weapon_list_cubit.dart';
import 'package:mysample/cubit/weapon_update_cubit.dart';

import 'package:flutter_bloc/src/bloc_provider.dart';

import '../../bloc/language_form_bloc.dart';
import '../../cubit/get_location_cubit.dart';
import '../../cubit/iys_questioning_list_cubit.dart';
import '../../cubit/product_categories_by_weapons_cubit.dart';
import '../../cubit/shot_record_cubit.dart';
import '../../cubit/weapon_to_user_get_cubit.dart';

class ProductInit {
  final List<BlocProviderSingleChildWidget> providers = [
    BlocProvider(create: (context) => LanguageFormBloc()),
    BlocProvider(create: (context) => CanikStoreDetailPageCubit()),
    BlocProvider(create: (context) => SpecialPageCubit()),
    BlocProvider(create: (context) => AskedQuestionCubit()),
    BlocProvider(create: (context) => ShotTimerCubit()),
    BlocProvider(create: (context) => UserInfoCubit()),
    BlocProvider(create: (context) => CampaignCubit()),
    BlocProvider(create: (context) => WeaponAddCubit()),
    BlocProvider(create: (context) => WeaponUpdateCubit()),
    BlocProvider(create: (context) => WeaponListCubit()),
    BlocProvider(create: (context) => WeaponToUserGetCubit()),
    BlocProvider(create: (context) => ShotRecordCubit()),
    BlocProvider(create: (context) => WeaponCareCubit()),
    BlocProvider(create: (context) => ProductCubit()),
    BlocProvider(create: (context) => AllShotRecordCubit()),
    BlocProvider(create: (context) => IysAddCubit()),
    BlocProvider(create: (context) => IysQuestioningListCubit()),
    BlocProvider(create: (context) => LocationAddCubit()),
    BlocProvider(create: (context) => GetLocationCubit()),
    BlocProvider(create: (context) => ProfileImageCubit()),
    BlocProvider(create: (context) => DealerCubit()),
    BlocProvider(create: (context) => CompareWeaponCubit()),
    BlocProvider(create: (context) => MainPageProductCubit()),
    BlocProvider(create: (context) => ProductCategoriesByWeaponsCubit())
  ];
}
