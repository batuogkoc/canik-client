import 'dart:convert';

import 'package:draggable_bottom_sheet_nullsafety/draggable_bottom_sheet_nullsafety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:mysample/constants/color_constants.dart';
import 'package:mysample/cubit/dealer_cubit.dart';
import 'package:mysample/entities/dealer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import '../entities/response/dealer_response.dart';
import '../widgets/app_bar_widget.dart';
import 'add_gun_home.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class SellerFinderPage extends StatefulWidget {
  const SellerFinderPage({Key? key}) : super(key: key);

  @override
  State<SellerFinderPage> createState() => _SellerFinderPageState();
}

class _SellerFinderPageState extends State<SellerFinderPage> {
  DealerResponse _response = DealerResponse(dealerResponseList: [],isError: false,message: "");
  bool isClick = false;
  late LatLng _initialcameraposition = LatLng(41.036002, 28.9869123);
  late GoogleMapController _controller;
  Location _location = Location();
  late LatLng firsLocation;
  // var imageUrl = RandomImageList(randomimage: []);
  late PolylinePoints polylinePoints;
  List<LatLng> polylineCoordinates = [];
  Map<PolylineId,Polyline> polylines = {};
  DealerResponseModel selectedData = DealerResponseModel(active: false,closedTime: "",dealerName: "",latitude: "",location: "",longitude: "",openingTime: "");
  List<DealerResponseModel> datas = [];
 
  // getRandomImage() async{
  //   var requestHeader = <String, String>{
  //     'Content-Type': 'application/json; charset=UTF-8'};
  //   var url = Uri.parse("https://picsum.photos/v2/list");
  //   final result = await http.get(
  //     url,
  //     headers: requestHeader
  //     );
  //   if (result.statusCode == 200) {
  //     setState(() {
  //      imageUrl = RandomImageList.fromJson(jsonDecode(result.body));
  //     });
  //   }  
  // }

  getDealersData() async{
    var data = await context.read<DealerCubit>().getDealerList();
    setState(() {
      datas = data.dealerResponseList;
    });
  }

  _createPolylines(
    double startLatitude,
    double startLongitude,
    double destinationLatitude,
    double destinationLongitude
  ) async{
    polylinePoints = PolylinePoints();
    // AIzaSyBRcuU8zsCfqMY17CvWGaxjR37i_Q0dfX0
    PolylineResult res = await polylinePoints.getRouteBetweenCoordinates("AIzaSyAvd263Vg9rDyGJ0Fa_Ixw0ER7skoOl1U0",
    PointLatLng(startLatitude, startLongitude),
    PointLatLng(destinationLatitude,destinationLongitude),
    travelMode: TravelMode.transit,
    );
    if(res.points.isNotEmpty){
      for (var element in res.points) {
        polylineCoordinates.add(LatLng(element.latitude, element.longitude));
      }
    }

    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: projectColors.blue,
      points: polylineCoordinates,
      width: 3
      );
      setState(() {
        polylines[id] = polyline;
        isClick = true;
      });
      
  }
  
  void _onMapCreated(GoogleMapController _cntlr)
  async{
    _controller = _cntlr;
    if(_location.hasPermission() != PermissionStatus.denied || _location.hasPermission() != PermissionStatus.deniedForever){
     var currentlocation = await _location.getLocation();
      setState(() {
        firsLocation = LatLng(currentlocation.latitude!, currentlocation.longitude!);
      });
    }
    else{
      await _location.requestPermission();
    }
  }
  void _getCurrentLocation(GoogleMapController _cntlr)
  {
    _controller = _cntlr;
    _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: firsLocation,zoom: 15),
          ),
      );
  }

  void _getShopsLocation(GoogleMapController _cntlr)
  {
    _controller = _cntlr;
    _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(38.9654918,32.8198688),zoom: 5.5),
          ),
      );
  }
  animateMap(double lat,double long){
    _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(lat,long),zoom: 17)));
  }

  
 Set<Marker> _createMarker() {
     Set<Marker> listmarker = Set();
    for (var element in datas) {
      Marker marker =
       Marker(
        markerId: MarkerId("${element.dealerName}"),
        position: LatLng(double.parse(element.latitude), double.parse(element.longitude)),
        infoWindow: InfoWindow(title: '${element.dealerName}'),
        onTap: () {
          _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(double.parse(element.latitude),double.parse(element.longitude)),zoom: 17)));
          setState(() {
            selectedData = element;
          });
        },
        );
        listmarker.add(marker);
    }
    return listmarker;
  // return {
  //   Marker(
  //       markerId: MarkerId("marker_1"),
  //       position: LatLng(41.036002, 28.9869123),
  //       infoWindow: InfoWindow(title: 'CANiK STORE - İstanbul'),
  //       onTap: () {
  //         _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(41.036002,28.9869123),zoom: 17)));
  //         setState(() {
  //           selectedData = datas[0];
  //         });
  //       },
  //       )
  // };
}
  @override
  void initState() {
    getDealersData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: projectColors.black2,
      appBar: CustomAppBarWithText(text: AppLocalizations.of(context)!.dealers),
      body: DraggableBottomSheet(
        backgroundWidget:
          Stack(children: [
           isClick ? GoogleMap(
              initialCameraPosition: CameraPosition(target: _initialcameraposition,zoom: 5.5),
              mapType: MapType.normal,
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              markers: _createMarker(),
              zoomGesturesEnabled: true,
              // polylines:  Set<Polyline>.of(polylines.values) ,
            ) :
            GoogleMap(
              initialCameraPosition: CameraPosition(target: _initialcameraposition,zoom: 17),
              mapType: MapType.normal,
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              markers: _createMarker(),
              zoomGesturesEnabled: true,
            ),
            Positioned(
              right: 20,
              top: 35,
              child: FloatingActionButton(
                backgroundColor: projectColors.blue,
                foregroundColor: Colors.white,
                elevation: 5,
                onPressed: () => _getCurrentLocation(_controller),
                child: SizedBox(
                  height: 20,
                  child: Image.asset("assets/images/PP.png",color: Colors.white,)),),
            ),
            Positioned(
              right: 20,
              top: 105,
              child: FloatingActionButton(
                backgroundColor: projectColors.blue,
                foregroundColor: Colors.white,
                elevation: 5,
                onPressed: () => _getShopsLocation(_controller),
                child: SizedBox(
                  height: 20,
                  child: Image.asset("assets/images/NAVIGATON.png",color: Colors.white,)),
            )),
            // Positioned(
            //   right: 20,
            //   top: 175,
            //   child: FloatingActionButton(
            //     backgroundColor: projectColors.orange,
            //     foregroundColor: Colors.white,
            //     elevation: 5,
            //     onPressed: () =>  _createPolylines(41.036002,28.9869123,39.9346446,32.834063),
            //     child: Icon(Icons.calculate),
            // ))
          ],),
          previewChild: Container(
          padding: const EdgeInsets.only(top: 16,left: 22,right: 16),
          decoration:  BoxDecoration(
            color: projectColors.black,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            border: Border.all(color: Colors.white)
          ),
          child: selectedData.dealerName != "" ? 
          Column(
            children: [
               Container(
                width: 70,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  
                  SizedBox(height: 2.h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 10.h,
                        width: 20.w,
                        child:datas.isNotEmpty ? Image.asset("assets/images/canikstoreist.jpg",fit: BoxFit.contain,)
                        : const CircularProgressIndicator()
                        
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(selectedData.dealerName,style: TextStyle(color: projectColors.white,fontWeight: FontWeight.w500,fontSize: 14.sp),),
                            // Text(selectedData.address_1,style: TextStyle(color: projectColors.white,fontWeight: FontWeight.w500,fontSize: 12.sp),),
                          ],
                        ),

                       SizedBox()
                    ],
                  ),
                SizedBox(height: 1.h,),  
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Address",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 10.sp),),
                    Text(selectedData.location,style: TextStyle(color: projectColors.white,fontWeight: FontWeight.w500,fontSize: 13.sp),),
                    SizedBox(height: 1.h,),
                    Text("Working Times",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 10.sp),),
                    Text("${selectedData.openingTime} - ${selectedData.closedTime}",style: TextStyle(color: projectColors.white,fontWeight: FontWeight.w500,fontSize: 13.sp),),
                  ],
                )
                ],
              ),
            ],
          )
          :Column(
            children: [
               Container(
                width: 70,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                 
                  SizedBox(height: 2.h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 10.h,
                        width: 20.w,
                        child:datas.isNotEmpty ? Image.asset("assets/images/canikstoreist.jpg",fit: BoxFit.contain,)
                        : const CircularProgressIndicator()
                        
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("CANiK STORE - İSTANBUL ŞUBESİ",style: TextStyle(color: projectColors.white,fontWeight: FontWeight.w500,fontSize: 14.sp),),
                            // Text("İstanbul/Beyoğlu",style: TextStyle(color: projectColors.white,fontWeight: FontWeight.w500,fontSize: 12.sp),),
                          ],
                        ),
                        SizedBox()
                    ],
                  ),
                SizedBox(height: 1.h,),  
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Address",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 10.sp),),
                    Text("Gümüşsuyu, İnönü Cd. No: 41 D, 34437 Beyoğlu/İstanbul",style: TextStyle(color: projectColors.white,fontWeight: FontWeight.w500,fontSize: 13.sp),),
                    SizedBox(height: 1.h,),
                    Text("Working Times",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 10.sp),),
                    Text("08:00 - 18:00",style: TextStyle(color: projectColors.white,fontWeight: FontWeight.w500,fontSize: 13.sp),),
                  ],
                )
                ],
              ),
            ],
          ),
        ),
          expandedChild: Container(
          padding: const EdgeInsets.all(16),
          decoration:  BoxDecoration(
            color: projectColors.black,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            border: Border.all(color: Colors.white)
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:[
              Container(
                width: 70,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(height: 3.h,),
              Expanded(
                flex: 5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                  const Expanded(
                    flex: 1,
                    child:  Icon(Icons.search_rounded,color: Colors.white,)),
                    Expanded(
                      flex: 3,
                      child: SizedBox(
                        height: 4.h,
                        child:const TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: "Search",
                          labelStyle: TextStyle(color: Colors.white),
                          floatingLabelBehavior: FloatingLabelBehavior.never
                          
                          ),
                        ),
                      ),
                    ),
                   const Expanded(
                      flex: 1,
                      child: Icon(Icons.close_rounded,color: Colors.white,))
                  ],
                ),
              ),
              BlocBuilder<DealerCubit,DealerResponse>(
                builder: (context, response) {
                  return SizedBox(
                  height: 45.h,
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: response.dealerResponseList.length,
                    itemBuilder: (context, index) {
                      return  Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Divider(color: Colors.white,), 
                          GestureDetector(
                            onTap: () {
                              animateMap(double.parse(response.dealerResponseList[index].latitude),double.parse(response.dealerResponseList[index].longitude));
                              setState(() {
                                selectedData = response.dealerResponseList[index];
                              });
                            },
                            child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 2,
                                child: SizedBox(
                                  height: 10.h,
                                  width: 20.w,
                                  child:datas.isNotEmpty ? Image.asset("assets/images/canikstoreist.jpg",fit: BoxFit.contain,)
                                  : const CircularProgressIndicator()
                                  ),
                              ),
                                          
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(response.dealerResponseList[index].dealerName,style: TextStyle(color: projectColors.white,fontWeight: FontWeight.w500,fontSize: 13.sp),),
                                      // Text(datas[index].,style: TextStyle(color: projectColors.white,fontWeight: FontWeight.w500,fontSize: 11.sp),),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    } 
                   ),
                );
                },
               ),
           ],
          ),
        ),
          
        expansionExtent: 25.h,
        minExtent: 33.h,
        maxExtent:60.h,
         ),
    );
  }
 
}
class RandomImageList{
  List<RandomImage> randomimage;
  RandomImageList({required this.randomimage});

  factory RandomImageList.fromJson(List<dynamic> json){
    List<RandomImage> images = json.map((jsonDataObject) => RandomImage.fromJson(jsonDataObject)).toList();
    return RandomImageList(randomimage: images);
  }
}
class RandomImage{
  String id;
  String author;
  int width;
  int height;
  String url;
  String download_url;

  RandomImage({
    required this.id,
    required this.author,
    required this.width,
    required this.height,
    required this.url,
    required this.download_url
  });

  factory RandomImage.fromJson(Map<String,dynamic> json){
    String id = json["id"];
    String author = json["author"];
    int width = json["width"];
    int height = json["height"];
    String url = json["url"];
    String download_url = json["download_url"];

    return RandomImage(id: id, author: author, width: width, height: height, url: url, download_url: download_url);
  }
}

class MockData{
  String sellername;
  String address_1;
  String address_2;
  String telephone;

  MockData({required this.sellername,required this.address_1,required this.address_2,required this.telephone});
}
