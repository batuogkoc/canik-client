import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  
  // getTestConfiguratorGlbFile() async{
  //  await context.read<ConfiguratorCubit>().createConfiguratorWeapon();
  // }

  @override
  void initState() {
    // getTestConfiguratorGlbFile();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
      Stack(
        children:[
        // BlocBuilder<ConfiguratorCubit,CreateConfiguratorResponse>(builder: (context, response) {
        //   if(response.filepath != ""){
        //    return  Column(
        //      children: [
        //        Center(child: Text(response.filepath,style:const TextStyle(color: Colors.amber,fontSize: 25),)),
        //        ModelViewer(
        //           backgroundColor: Color.fromARGB(0xFF, 0xEE, 0xEE, 0xEE),
        //             cameraOrbit: "125deg 65deg",
        //             src: response.filepath, // a bundled asset file
        //             ar: false,
        //             autoRotate: false,
        //             cameraControls: true,
        //             iosSrc: 'https://modelviewer.dev/shared-assets/models/Astronaut.usdz',
        //         )
        //      ],
        //    );
        //   }
        //   else{
        //    return Column(
        //      children: [
        //        const Center(child: Text("FilePath Boş",style: TextStyle(color: Colors.amber,fontSize: 25),)),
        //        ElevatedButton(onPressed: () => getTestConfiguratorGlbFile(), child: Text("Getir",style: TextStyle(color: Colors.amber,fontSize: 25),))
        //      ],
        //    );
        //   }
        // },),  
       
        ModelViewer(
                  backgroundColor: Color.fromARGB(0xFF, 0xEE, 0xEE, 0xEE),
                    cameraOrbit: "125deg 65deg",
                    src: 'https://cors-anywhere.herokuapp.com/http://167.99.214.62/Glb/merged.glb', // a bundled asset file
                    ar: false,
                    autoRotate: false,
                    cameraControls: true,
                    
                    // iosSrc: 'https://modelviewer.dev/shared-assets/models/Astronaut.usdz',
                ),
        ] 
      )
      // ModelViewer(
      //   backgroundColor: Color.fromARGB(0xFF, 0xEE, 0xEE, 0xEE),
      //     src: 'https://modelviewer.dev/shared-assets/models/Astronaut.glb',
      //     alt: "A 3D model of an astronaut",
      //     ar: true,
      //     autoRotate: true,
      //     cameraControls: true,
      // ),
      
      );
  }
}