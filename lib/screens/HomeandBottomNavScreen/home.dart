import 'package:flutter/material.dart';
import '../PhotoManagementScreens/photo_management.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1578ff),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 200, // Adjust the size of the circle as needed
                        height: 200, // Adjust the size of the circle as needed
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: const CircularProgressIndicator(
                          value: 0.3, // Adjust the progress value (0.0 to 1.0)
                          strokeWidth: 10, // Adjust the progress bar thickness
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent), // Progress bar color
                          backgroundColor: Colors.white,
                          // strokeCap: StrokeCap.round,// Background color
                        ),
                      ),
                      Positioned(
                        bottom: 85,
                          child: Image.asset('assets/images/rocket.png',height: 80,width: 80,)
                      ),
                      const Positioned(
                        bottom: 25, // Adjust the position of the text widgets as needed
                        child: Column(
                          children: [
                            Text(
                              'Cleaning',
                              style: TextStyle(
                                color: Colors.white, // Adjust the text color as needed
                                fontSize: 16,
                                fontFamily: 'alk'// Adjust the font size as needed
                              ),
                            ),
                            Text(
                              '70%',
                              style: TextStyle(
                                color: Colors.white, // Adjust the text color as needed
                                fontSize: 16,
                                fontFamily: 'alk'// Adjust the font size as needed
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 40,),
              Expanded(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                                child: Container(
                                  height:100,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black12,
                                        width: 1,
                                      ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)
                                      )
                                    ),
                                    onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>const PhotoManagement()));
                                    },
                                    child: const Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.image_sharp,color: Colors.blue,),
                                        SizedBox(height: 5,),
                                        Text('Photo',style: TextStyle(color:Colors.black,overflow: TextOverflow.ellipsis,fontFamily: 'alk'),),
                                        Text('Management',style: TextStyle(color:Colors.black,overflow: TextOverflow.ellipsis,fontFamily: 'alk'),),
                                      ],
                                    ),
                                  ),
                                ),
                            ),
                            const SizedBox(width: 5,),
                            Expanded(
                              child: Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black12,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)
                                    )
                                  ),
                                  onPressed: (){},
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.video_collection_outlined,color: Colors.blue,),
                                      SizedBox(height: 5,),
                                      Text('Video',style: TextStyle(color:Colors.black,overflow: TextOverflow.ellipsis,fontFamily: 'alk'),),
                                      Text('Management',style: TextStyle(color:Colors.black,overflow: TextOverflow.ellipsis,fontFamily: 'alk'),)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5,),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height:100,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black12,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)
                                    )
                                  ),
                                  onPressed: (){},
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.location_history,color: Colors.blue,),
                                      SizedBox(height: 5,),
                                      Text('Location',style: TextStyle(color:Colors.black,overflow: TextOverflow.ellipsis,fontFamily: 'alk'),),
                                      Text('Management',style: TextStyle(color:Colors.black,overflow: TextOverflow.ellipsis,fontFamily: 'alk'),)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 5,),
                            Expanded(
                              child: Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black12,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)
                                    )
                                  ),
                                  onPressed:(){},
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.upcoming_rounded,color: Colors.blue,),
                                      SizedBox(height: 5,),
                                      Text('Coming',style: TextStyle(color:Colors.black,overflow: TextOverflow.ellipsis,fontFamily: 'alk'),),
                                      Text('Soon',style: TextStyle(color:Colors.black,overflow: TextOverflow.ellipsis,fontFamily: 'alk'),)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30,),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff1578ff),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: (){},
                            child: const Center(
                              child: Text('Smart Cleaner',style: TextStyle(fontFamily: 'alk',fontSize: 20,color: Colors.white),),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
