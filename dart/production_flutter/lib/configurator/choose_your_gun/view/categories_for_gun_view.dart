import 'package:draggable_bottom_sheet_nullsafety/draggable_bottom_sheet_nullsafety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mysample/constants/color_constants.dart';
import 'package:mysample/views/add_gun_home.dart';
import 'package:sizer/sizer.dart';
import '../../../views/tabs_bar.dart';
import '../../../widgets/app_bar_icon_widget.dart';
import '../../../widgets/background_image_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

import 'confignavbar.dart';
class CategoriesForGun extends StatefulWidget {
  GeneralMockData accessories;
  
  CategoriesForGun({required this.accessories,Key? key}) : super(key: key);

  @override
  State<CategoriesForGun> createState() => _CategoriesForGunState();
}

class _CategoriesForGunState extends State<CategoriesForGun> {
  final GlobalKey _key = GlobalKey();
  double minExtent = 120;
  double expansionExtent = 10;
  double _x = 0.0, _y = 0.0;
  late Object mac10;
  late Object jet;
  List<Accessories> accessoryList = [];
  bool getAccList = false;
  List<bool> isClick = [];
  List<String> images = [
    "assets/images/configurator/AnaKategoriler/1-0renk.png",
    "assets/images/configurator/AnaKategoriler/2-0namlu.png", 
    "assets/images/configurator/AnaKategoriler/3-0nisangah.png",
    "assets/images/configurator/AnaKategoriler/4-0taktik-fener.png",
    "assets/images/configurator/AnaKategoriler/5-0tetik.png",
    "assets/images/configurator/AnaKategoriler/6-0sarjor.png",
    "assets/images/configurator/AnaKategoriler/7-0dipcik.png",
    "assets/images/configurator/AnaKategoriler/8-0tutamak.png", 
    "assets/images/configurator/AnaKategoriler/9-0susturucu.png", 
    "assets/images/configurator/AnaKategoriler/10-0arka-kabza.png",
    "assets/images/configurator/AnaKategoriler/11-0magwell.png",
    "assets/images/configurator/AnaKategoriler/12-0kilif.png",
    "assets/images/configurator/AnaKategoriler/13-0sarjor-kilidi.png",
  ];
  
  
Future<GeneralMockData> addAccessory(String item,int ind,String _path) async{
  
                setState(() {
                  widget.accessories.checkedList[ind] = true;
                  numberOfCheckList = ind;
                });
                Accessories accmodel = Accessories(
                parentIndex: ind,  
                image: ind+1 != 1 ? "assets/images/configurator/AltKategoriler/${item}.png"
                : "assets/images/configurator/AltKategoriler/${item}.jpg", 
                name: "SFx RIVAL", 
                description: "Geliştirilmiş kunduz kuyruğu, daha agresif ön kabza tırtıkları, yardımcı elin daha etkin kavramasına izin veren derinleştirilmiş tetik korkuluğu açısı, özel kılıflar için tasarlanan ‘tak&kilitle’ delikleri ve kendinden şarjör hunili yeni gövde tasarımı ile tüm rakiplerini geride bırakacak üstünlüğe sahiptir. Ayarlanabilir gez ve fiber optik arpacık ile donatılmış agresif yeni kapak tasarımı sayesinde tabancanız ile daha hızlı nişan almanız ve her türlü manipülasyonunu yapmanız daha kolay hale getirilmiştir. SFx RIVAL®️, CANiK®️’in yeni nesil kolay sökülebilir gövde tasarımına sahiptir. Bu tasarım sayesinden, atıcının kutu içinden çıkan CANiK®️ Zımba yardımıyla tabancasının en küçük parçasına kadar söküp takabilmesi sağlanmıştır. CANiK®️ tetik tasarımında dünyanın en ileri teknolojisini kullanmaya devam etmektedir. SFx RIVAL®️’ın 90 ° açılı elmas kesim hafifletilmiş alüminyum tetiği kısaltılmış ön seyir ve kurulma mesafesi ile daha hızlı ve isabetli mükerrer atışları mümkün kılmaktadır. Tüm bu teknik geliştirmelerin yanında RIVAL’ın dizaynında estetik kaygılar da dikkate alınmıştır: Gövde ve kapakta Cerakote tarafından CANiK®️ için özel üretilen ‘Canik Rival Grey’ renk kaplama kullanılırken silahın özenle seçilen parçalarına bu rengi estetik olarak tamamlayacak şekilde Cerakote H122 altın rengi ile kaplama uygulanmıştır.", 
                technicaldescription: [
                  "Kolay sökülebilir elyaf katkılı tam boy polimer gövde",
                  "Fiber Arpacık",
                  "Ayarlanabilir Gez",
                  "İğne Kurulu Göstergesi",
                  "Düşük Profilli Kolay Sökülebilir Sürgü mandalı",
                  "Tabanca Kılıfı 'Tak ve Kitle ' yuvası",
                  "Kendinden Şarjör Hunili Gövde",
                  "+0 Şarjör Alt Kapağı",
                  "Yönü Değiştirilebilir Uzatmalı Şarjör Kilidi (S-M-L)",
                  "Çift Yönlü Sürgü Tutucu",
                  "MIL-STD-1913 Picatini Ray",
                  "Şarjör Hunisi Uyumlu Arka Kabza (3 Boy)",
                  "Hafifletilmiş 90° Elmas Kesim Alüminyum Düz Tetik",
                  "Sportif Şarjör Hunisi"
                ],
                );
                if(widget.accessories.accessories != null){
                  
                  accessoryList.add(accmodel);
                  for (var element in widget.accessories.accessories!) {
                    accessoryList.add(element);
                    setState(() {
                      
                    });
                  }
                
                }
                else{
                  
                  accessoryList.add(accmodel);
                  setState(() {
                      
                  });
                }
                

                GeneralMockData mockData = GeneralMockData(accessories:accessoryList,checkedList: widget.accessories.checkedList,imagePath: _path);
                return mockData;
  } 
  List<bool> get checkList {
    return isClick;
  }
  StaticImages staticImages = StaticImages(mainImage: [], parentImages: []);
  List<String> parentImages = [
    "1-1renk_siyah",
    "1-2renk",
    "1-2renk_safari",
    "1-3renk",
    "2-1namlu1",
    "2-2namlu2",
    "2-3uc",
    "3-1arpacik1",
    "3-1gez1",
    "3-2arpacik2",
    "3-2gez2",
    "3-3arpacik3",
    "3-3gez3",
    "4-1taktik-fener1",
    "4-2taktik-fener2",
    "4-3taktik-fener3",
    "5-1tetik1",
    "5-2tetik2",
    "6-1sarjor1",
    "6-2sarjor2",
    "7-1dipcik1",
    "7-2dipcik_kisa",
    "8-1tutamak1",
    "9-1susturucu1",
    "10-1arka-kabza1",
    "10-2arka-kabza2",
    "10-3arka-kabza3",
    "10-4arka-kabza4",
    "11-1magwell1",
    "12-1kilif1",
    "12-2kilif2",
    "13-1sarjor-kilidi1",
    "13-2sarjor-kilidi2"
  ];
   void _getOffset(GlobalKey key) {
    RenderBox? box = key.currentContext?.findRenderObject() as RenderBox?;
    Offset? position = box?.localToGlobal(Offset.zero);

    if (position != null) {
      setState(() {
        _x = position.dx;
        _y = position.dy;
      });
    }
  }
  int numberOfCheckList = 0;
  checkedlistupdate(int index,bool value,bool fromkey){
     setState(() {
        widget.accessories.checkedList[index] = value;
     });
    if(fromkey == true){
      Accessories indexitem = widget.accessories.accessories!.where((element) => element.parentIndex == index).first;
      widget.accessories.accessories!.remove(indexitem);
    }
    
  }
  @override
  void initState() {
    
      // jet = Object(fileName: "assets/images/3d/Jet.obj");
      // jet.rotation.setValues(-30, 90, 30);
      // jet.updateTransform();
    
    
      // mac10 = Object(fileName: "assets/images/3d/mac10.obj");
      // mac10.rotation.setValues(-30, 90, 30);
      // mac10.updateTransform();

    isClick = List<bool>.filled(images.length, false);

    staticImages.mainImage = images;
    staticImages.parentImages = parentImages;

    
    super.initState();
    
  }
  var popUpTitleTextStyle =
        const TextStyle(fontSize: 22, fontFamily: 'Built', fontWeight: FontWeight.w600, color: Colors.white,letterSpacing: 2);
  var textStyle3 = TextStyle(color: projectColors.black3, fontSize: 15, fontWeight: FontWeight.w500);      
  Widget build(BuildContext context) {
    double? screenHeight = MediaQuery.of(context).size.height;
    double maxExtent = MediaQuery.of(context).size.height*0.8 ;
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.red;
      }
      return Colors.blue;
      
    }
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async=> false,
      child: Scaffold(
       body: DraggableBottomSheet(
       // Arka Taraftaki ekran 
       backgroundWidget: Background3d(
        checklistupdate: checkedlistupdate,
        accessoryList: widget.accessories.accessories,
        height: height,
        path: widget.accessories.imagePath  ),
       // Açıldıktan önceki alttaki ekran 
       previewChild: Container(
            padding: const EdgeInsets.all(16),
            decoration:  BoxDecoration(
              color: projectColors.black,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              border: Border.all(color: projectColors.white1)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:[
                Container(
                  width: 40,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 16),
                 Text(
                  AppLocalizations.of(context)!.config_categories,
                  style:const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
       // Açıldıktan sonraki ekran
       expandedChild:Container(
            padding: const EdgeInsets.only(left:30,right: 30),
            decoration:  BoxDecoration(
              color: projectColors.black,
              borderRadius:const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:[
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  const Icon(
                  Icons.keyboard_arrow_down,
                  size: 30,
                  color: Colors.white,
                ),
                 Text(
                  AppLocalizations.of(context)!.config_gun,
                  style:const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                  ],
                ),
                const SizedBox(height: 30,),
                Expanded(
                child:!getAccList ? GridView.builder(
                  physics:const BouncingScrollPhysics(),
                  itemCount: staticImages.mainImage.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          
                          getAccList = true;
                          numberOfCheckList = index;
                        });
                      },
                      child: Container(
                      decoration: BoxDecoration(
                        image:const DecorationImage(image: AssetImage('assets/images/gun_background.png'), fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child:Stack(
                        children:[
                        Center(child: Image.asset(staticImages.mainImage[index],fit: BoxFit.cover,)),
                        widget.accessories.checkedList[index] ? Positioned(
                          top: 0,
                          right: 0,
                          child: Checkbox(
                            checkColor: Colors.white,
                            fillColor: MaterialStateProperty.resolveWith(getColor),
                            value:widget.accessories.checkedList[index], 
                            onChanged: (value) {
                            // setState(() {
                            //   widget.accessories.checkedList[index] = value!;
                            // });
                            checkedlistupdate(index,value!,true);
                          },),
                        ): const SizedBox(height: 0,),
                        ] )
                        ),
                    );
                  },
                ) : AccessoryList(height,width,context,numberOfCheckList+1),
                  ),
               getAccList ? ElevatedButton(onPressed: () {
                  setState(() {
                    getAccList = false;
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => deneme(path: "assets/images/3d/Jet.obj"),));
                  });
                }, 
                style: ElevatedButton.styleFrom(
                fixedSize: const Size(400, 24),
                primary:  projectColors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                  side:  BorderSide(color: projectColors.black, width: 1.5),
                )),
                child: Text(AppLocalizations.of(context)!.back))
               :const SizedBox(height: 0,)
               ],
            ),
          ),
       expansionExtent: expansionExtent,   
       minExtent: minExtent,
       maxExtent: maxExtent,
       )
       
      ),
    );
  }
  
  Widget AccessoryList(double height,double width,BuildContext context,int num){
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.red;
      }
      return Colors.blue;
      
    }
    return StatefulBuilder(
      builder: (context, setState) {
        return SizedBox(
        height: height,
        width: width,
        child: GridView.builder(
          physics:const NeverScrollableScrollPhysics(),
          itemCount: staticImages.parentImages.where((element) => element.startsWith("${num}-")).length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, int index) {
            var items = staticImages.parentImages.where((element) => element.startsWith("${num}-")).toList();
            return Container(
            decoration: BoxDecoration(
              image:const DecorationImage(image: AssetImage('assets/images/gun_background.png'), fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(5),
            ),
            child:
            GestureDetector(
              onTap: () async{
                // Navigator.push(context, MaterialPageRoute(builder: (context) => deneme(path: "assets/images/3d/mac10.obj",),));
               
             await addAccessory(items[index],num-1,"assets/images/3d/sub_elite_cas.glb").then((value) => Navigator.push(context, MaterialPageRoute(builder: (context) => CategoriesForGun(accessories: value),)));
                // setState(() => {
                //   isClick[num-1] = true,
                //   getAccList = false,
                //  });
              },
              child: Center(child: 
              num != 1 ?
              Image.asset("assets/images/configurator/AltKategoriler/${items[index]}.png",fit: BoxFit.cover,)
              : Image.asset("assets/images/configurator/AltKategoriler/${items[index]}.jpg",fit: BoxFit.cover,)
              ),
            )
              );
          },
        ),
      );
      },
       );
             
  }
  
}

class StaticImages{
List<String> mainImage;
List<String> parentImages;
StaticImages({
required this.mainImage,
required this.parentImages
});
}
class GeneralMockData{
  List<Accessories>? accessories;
  List<bool> checkedList;
  String imagePath;
  GeneralMockData({
    this.accessories,
    required this.checkedList,
    required this.imagePath
  });
   @override
  String toString() => 'Accessories(ImagePath: $imagePath,CheckedList: $checkedList';
}
class Accessories{
  int parentIndex;
  String image;
  String name;
  String description;
  List<String> technicaldescription;
  
  Accessories({
    required this.parentIndex,
    required this.image,
    required this.name,
    required this.description,
    required this.technicaldescription,
   
  });
  
 
}

class Background3d extends StatefulWidget {
  String path;
  double height;
  Function checklistupdate;
  List<Accessories>? accessoryList;
  Background3d({required this.checklistupdate,this.accessoryList,required this.height,required this.path,Key? key}) : super(key: key);

  @override
  State<Background3d> createState() => _Background3dState();
}

class _Background3dState extends State<Background3d> {
  late Object general3d;
  showdialog(){
      showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                                      return AlertDialog(
                                        backgroundColor: projectColors.black,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                        title: Text(
                                          AppLocalizations.of(context)!.product_shop,
                                          textAlign: TextAlign.center,
                                          style: popUpTitleTextStyle,
                                        ),
                                        content: SizedBox(
                                          height: 400,
                                          width: 300,
                                          child: widget.accessoryList != null ? ListView.builder(
                                            physics:const BouncingScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: widget.accessoryList!.length,
                                            itemBuilder: (context, index) {
                                              return 
                                               Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                              Expanded(
                                                flex: 1,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(5.0),
                                                  child: Image.asset(widget.accessoryList![index].image,fit: BoxFit.cover),
                                                )),
                                              Expanded(
                                                flex: 2,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    showDialog(
                                                    context: context,
                                                    builder: (BuildContext context){
                                                      return accDetailsCard(widget.accessoryList![index]);
                                                    });
                                                  },
                                                  child: Text(
                                                    widget.accessoryList![index].name,
                                                    style: TextStyle(color: projectColors.white,fontSize: 17,fontWeight: FontWeight.bold),
                                                    textAlign: TextAlign.center,
                                                    ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    
                                                   showDialog(context: context,
                                                    builder: (context) {
                                                       return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                                                        return AlertDialog(
                                                          backgroundColor: ProjectColors().black,
                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                                          title: Text(
                                                                AppLocalizations.of(context)!.are_you_sure,
                                                                style: TextStyle(color: projectColors.white,fontSize: 24,fontWeight: FontWeight.w500),
                                                                textAlign: TextAlign.center,
                                                          ),
                                                          actions: <Widget>[
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                        children: [
                                                                          ElevatedButton(
                                                                            style: ElevatedButton.styleFrom(
                                                                              fixedSize: Size(100, 30),
                                                                                primary: const Color(0xff4F545A),
                                                                                shape: RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.circular(40),
                                                                                  side: const BorderSide(color: Colors.white, width: 1.5),
                                                                                )),
                                                                            onPressed: () => Navigator.pop(context, 'Cancel'),
                                                                            child:  Text(AppLocalizations.of(context)!.close,style:const TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                                                                          ),
                                                                          const SizedBox(
                                                                            width: 11,
                                                                          ),
                                                                          ElevatedButton(
                                                                            style: ElevatedButton.styleFrom(
                                                                                fixedSize: Size(100, 30),
                                                                                primary: projectColors.red,
                                                                                shape: RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.circular(40),
                                                                                )),
                                                                            onPressed: ()  {

                                                                             removeacitem(index);
                                                                            },
                                                                            child:  Text(AppLocalizations.of(context)!.delete,style:const TextStyle(fontSize: 16,fontWeight: FontWeight.w500)),
                                                                          ),
                                                                          
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                        );
                                                       });
                                                    });
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(25),
                                                    child: Image.asset("assets/images/close_icon.png",fit: BoxFit.contain,),
                                                  ),
                                                )),
                                              ],),
                                              SizedBox(width: 300,
                                                child: Divider(
                                                  height: 10,
                                                  thickness: 1,
                                                  color: projectColors.white,
                                                ),)
                                                ],
                                              );
                                              
                                            }
                                             ,
                                            
                                            ) :const SizedBox(height: 0,),
                                        ),
                                        actions: <Widget>[
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                          fixedSize:const Size(300, 24),
                                                          primary: projectColors.blue,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(40),
                                                            side: BorderSide(color: projectColors.blue, width: 1),
                                                          )),
                                                      onPressed: () => Navigator.pop(context, 'Cancel'),
                                                      child:  Text(AppLocalizations.of(context)!.save),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    });
                                  }).then((value) => setState(() {}));
                            
  }
  removeacitem (int index) {
    EasyLoading.show();
    
    widget.checklistupdate(widget.accessoryList![index].parentIndex,false,false);  
    widget.accessoryList!.remove(widget.accessoryList![index]);
    EasyLoading.dismiss();
    Navigator.pop(context);
    Navigator.pop(context);
    showdialog();
    
  }
  var popUpTitleTextStyle = const TextStyle(fontSize: 26, fontFamily: 'Built', fontWeight: FontWeight.w600, color: Colors.white,letterSpacing: 2);
  var textStyle3 = TextStyle(color: projectColors.black3, fontSize: 15, fontWeight: FontWeight.w500);     
  @override
  
  Widget build(BuildContext context) {
    return Stack(children: [
      Image.asset(
          'assets/images/configurator/Background.jpg',
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
      Scaffold(
        backgroundColor: Colors.transparent,
        appBar:const ConfiguratorNavbar(),
        body:  Stack(
          children:[
            SizedBox(
            height:widget.height/1.3,
            child:  
            ModelViewer(
            backgroundColor: Colors.transparent,
            cameraOrbit: "125deg 65deg",
            // https://modelviewer.dev/shared-assets/models/Astronaut.glb
            // src: 'assets/images/3d/sub_elite_cas.glb', // a bundled asset file
            src: "https://cors-anywhere.herokuapp.com/http://167.99.214.62/Glb/merged.glb",
            ar: false,
            autoRotate: false,
            cameraControls: true,
            // iosSrc: 'https://modelviewer.dev/shared-assets/models/Astronaut.usdz',
            )
          ),
          Positioned(
            top: 40,
            right: 40,
            child: 
            Container(
              decoration: BoxDecoration(
                color: projectColors.blue,
                borderRadius: BorderRadius.circular(10)
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Center(child: 
                GestureDetector(
                  onTap: () {
                    showdialog();
                  },
                  child: Icon(Icons.add_shopping_cart_rounded,size: 35,color: projectColors.white,))),
              )))
          ] 
        ),
      )
     ]);
     }
    StatefulBuilder accDetailsCard(Accessories accessories){
      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
                  backgroundColor: projectColors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  title: Text(
                    AppLocalizations.of(context)!.product_shop,
                    textAlign: TextAlign.center,
                    style: popUpTitleTextStyle,
                  ),
                  content:  SizedBox(
                    height: 500,
                    width: 300,
                    child: SingleChildScrollView(
                      physics:const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                        SizedBox(
                          height: 150,
                          width: 300,
                          child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                          Image.asset(accessories.image,fit: BoxFit.cover,),
                          const SizedBox(height: 10,),
                          Text(accessories.name,style: TextStyle(color: projectColors.white,fontSize: 20),textAlign: TextAlign.center,),
                          ],),
                        ),
                        const SizedBox(height: 10,),
                        SizedBox(
                          height: 350,
                          width: 300,
                          child: DefaultTabController(
                            length: 2,
                            child: Scaffold(
                              backgroundColor:projectColors.black,
                              appBar: PreferredSize(
                                preferredSize:const Size.fromHeight(50),
                                child: AppBar(
                                    shape:const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                     topLeft: Radius.circular(10),
                                     topRight: Radius.circular(10),
                                    ),
                                  ),
                                  titleSpacing: 0,
                                  backgroundColor: projectColors.black2,
                                  automaticallyImplyLeading: false ,
                                  bottom:  TabBar(
                                    unselectedLabelColor: projectColors.white,
                                    labelColor: projectColors.blue,
                                    tabs:[
                                    Tab(text: AppLocalizations.of(context)!.product_explanation,),
                                    Tab(text: AppLocalizations.of(context)!.technical_features,),
                                  ]),
                                ),
                              ) ,
                              body:  TabBarView(
                              children: [
                                SingleChildScrollView(
                                  physics:const BouncingScrollPhysics(),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(accessories.description,textAlign: TextAlign.justify,style: TextStyle(color: projectColors.white),),
                                  )),
                                ListView.builder(
                                  physics:const BouncingScrollPhysics(),
                                  itemCount: accessories.technicaldescription.length,
                                  itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(accessories.technicaldescription[index],style: TextStyle(color: projectColors.white),textAlign: TextAlign.justify,),
                                  );
                                },),
                              ],
                            ),
                            )
                            
                            ),
                        ),
                    
                      ],),
                    )
                  ),
                  actions: <Widget>[
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    fixedSize:const Size(300, 24),
                                    primary: projectColors.red,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40),
                                      side: BorderSide(color: projectColors.black, width: 1),
                                    )),
                                onPressed: () => Navigator.pop(context, 'Cancel'),
                                child:  Text(AppLocalizations.of(context)!.close),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                );
                                    
      },);
     }
}
