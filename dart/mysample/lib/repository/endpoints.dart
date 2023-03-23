class EndPoints {
  static const String domain = "http://164.90.212.149/api/";

  static const String getMainCategories = "Product/GetMainCategories";
  static const String getProductCategories = "Product/GetProductCategories";
  static const String getProductCategoryAssigments = "Product/GetProductCategoryAssignments";
  static const String getAllProducts = "Product/GetAllProducts";
  static const String getAllWeapons = "Product/GetAllWeapons";

  static const String getActivities = "PowerApps/GetActivities";
  static const String getNews = "PowerApps/GetNews";
  static const String getFraquentlyAskedQuestions = "PowerApps/GetFrequentlyAskedQuestions";
  static const String getCampaigns = "PowerApps/GetCampaigns";

  static const String getWeaponName = "Definition/WeaponName";
  static const String addWeaponToUser = "Definition/AddWeaponToUser";
  static const String updateWeaponToUser = "Definition/UpdateWeaponToUser";
  static const String listWeaponToUser = "Definition/WeaponToUserList";
  static const String getWeaponToUser = "Definition/GetWeaponToUser";

  static const String addShotRecord = "Definition/AddShotRecord";
  static const String listShotRecord = "Definition/ShotRecordList";
  static const String updateShotRecord = "Definition/UpdateShotRecord";
  static const String listShotRecordWithcanikId = "Definition/ShotRecordListWithCanikId";

  static const String addWeaponCare = "Definition/AddWeaponCare";
  static const String listWeaponCare = "Definition/WeaponCareList";
  static const String updateWeaponCare = "Definition/UpdateWeaponCare";

  static const String addAccessory = "Definition/AddAccessory";
  static const String listAccessory = "Definition/AccessoryList";
  static const String deleteAccessory = "Definition/DeleteAccessory";

  static const String dealerList = "Definition/DealerList";

  static const String addShotTimer = "ShotTimer/AddShotTimer";
  static const String listShotTimer = "ShotTimer/ShotTimerList";
  static const String updateShotTimer = "ShotTimer/ShotTimerUpdate";
  static const String deleteShotTimer = "ShotTimer/ShotTimerDelete";
  static const String shotTimerRecordList = "ShotTimer/ShotTimerRecordList";

  static const String userInfo =
      "https://canikb2c.b2clogin.com/canikb2c.onmicrosoft.com/oauth2/v2.0/authorize?p=B2C_1_signupsignin&client_id=98c22eff-99a3-43cb-86b5-7d5b906e0cbe&nonce=defaultNonce&redirect_uri=https%3A%2F%2Foauth.pstmn.io%2Fv1%2Fcallback&scope=openid&response_type=id_token&prompt=login";

  static const String addIys = "Iys/AddIys";
  static const String permissionQuestionin = "Iys/PermissionQuestioning";
  static const String getLocationPermission = "Iys/GetLocationPermission";
  static const String addLocationPermission = "Iys/AddLocationPermission";

  static const String getProfileImage = "Profile/GetProfileImage";
  static const String addProfileImage = "Profile/AddProfileImage";
  static const String deleteProfileImage = "Profile/DeleteProfileImage";

  static const String getMainPageProduct = "Definition/MainPageProduct";

  static const String getProductCategoriesByWeapons = "Product/GetProductCategoriesByWeapons";
}
