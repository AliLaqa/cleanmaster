import 'dart:async';
import 'package:flutter/material.dart';
import '../HomeandBottomNavScreen/bottom_nav_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.push(context, MaterialPageRoute(builder: (context)=>const NavScreen()));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1578ff),
      body: Padding(
        padding:  const EdgeInsets.only(top: 180.0,left: 16,right: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/logo.png',height: 100,),
              ],
            ),
            const SizedBox(height: 40,),
            const Center(child: Text('CLEAN MASTER',style: TextStyle(color: Colors.white,fontFamily: 'alk',fontSize: 30,fontWeight: FontWeight.bold),)),
            const Text('Clean with just one touch',style: TextStyle(color: Colors.white54,fontFamily: 'alk',fontSize: 20,fontWeight: FontWeight.bold),),
            const SizedBox(height: 40,),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.network_wifi,color: Colors.white,size: 40,),
                Icon(Icons.av_timer_sharp,color: Colors.white,size: 40,),
                Icon(Icons.add_to_home_screen,color: Colors.white,size: 40,),
                Icon(Icons.rocket_rounded,color: Colors.white,size: 40,),
              ],
            ),
            const SizedBox(height: 30,),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.image_outlined,color: Colors.white,size: 40,),
                Icon(Icons.ondemand_video,color: Colors.white,size: 40,),
                Icon(Icons.broken_image,color: Colors.white,size: 40,),
                Icon(Icons.battery_saver_sharp,color: Colors.white,size: 40,),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
