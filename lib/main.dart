import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instafake_flutter/core/presentation/auth/auth_screen.dart';
import 'package:instafake_flutter/core/presentation/home/home_screen.dart';
import 'package:instafake_flutter/core/providers/auth_provider.dart';
import 'package:instafake_flutter/core/providers/home_provider.dart';
import 'package:instafake_flutter/core/providers/camera_provider.dart';
import 'package:instafake_flutter/core/providers/profile_provider.dart';
import 'package:instafake_flutter/dependency_injection.dart';
import 'package:instafake_flutter/services/account_service.dart';
import 'package:instafake_flutter/services/connectivity_service.dart';
import 'package:instafake_flutter/services/user_data_service.dart';
import 'package:instafake_flutter/utils/theme.dart';
import 'package:provider/provider.dart';

Future<void> main() async {

  await DependencyInjection.init();
  UserDataService userService = Get.find<UserDataService>();
  bool isLogin = false;
  
  if(DependencyInjection.isJwtExpired(userService.userModel==null? '' : userService.userModel!.token)){
    isLogin = false;
  }else {
    isLogin = true;
  }
  
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(InstafakeApp(isLogin: isLogin));
}

class InstafakeApp extends StatelessWidget {
  final bool isLogin;
  InstafakeApp({super.key, required this.isLogin});

  final DeviceStatusService accountService = Get.find<DeviceStatusService>();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context)=>AuthProvider(userModelRepository:  Get.find()),
        ),
        
        ChangeNotifierProvider(
          create: (context)=>ConnectivityProvider(),
        ),

        ChangeNotifierProvider(
          create: (context)=>HomeProvider(
            postModelRepository: Get.find(), 
            storyModelRepository: Get.find(),
            userModelRepository: Get.find()),
        ),

        ChangeNotifierProvider(
          create: (context)=>CameraProvider(postModelRepository: Get.find(), storyModelRepository: Get.find())
        ),

        ChangeNotifierProvider(
          create: (context)=>ProfileProvider(userRepo: Get.find())
        )

      ],
      child: GetMaterialApp(
        defaultTransition: Transition.cupertino,
        debugShowCheckedModeBanner: false,
        theme: MaterialTheme(
        TextTheme(
          displayLarge: GoogleFonts.poppins(
            fontSize: 72,
            fontWeight: FontWeight.w300,
          ),
          displayMedium: GoogleFonts.poppins(
            fontSize: 48,
            fontWeight: FontWeight.w300,
          ),
          displaySmall: GoogleFonts.poppins(
            fontSize: 42,
            fontWeight: FontWeight.w400
          ),
          headlineMedium: GoogleFonts.poppins(
            fontSize: 30,
            fontWeight: FontWeight.w400,
          ),
          headlineSmall: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w400
          ),
          titleLarge: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          titleMedium: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          titleSmall: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          bodyLarge: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          bodyMedium: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
          labelLarge: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          bodySmall: GoogleFonts.poppins(
            fontSize: 10,
            fontWeight: FontWeight.w400,
          ),
          labelSmall: GoogleFonts.poppins(
            fontSize: 8,
            fontWeight: FontWeight.w400,
          ),
        )
      ).light(),
      darkTheme: MaterialTheme(
        TextTheme(
          displayLarge: GoogleFonts.poppins(
            fontSize: 72,
            fontWeight: FontWeight.w300,
          ),
          displayMedium: GoogleFonts.poppins(
            fontSize: 48,
            fontWeight: FontWeight.w300,
          ),
          displaySmall: GoogleFonts.poppins(
            fontSize: 42,
            fontWeight: FontWeight.w400
          ),
          headlineMedium: GoogleFonts.poppins(
            fontSize: 30,
            fontWeight: FontWeight.w400,
          ),
          headlineSmall: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w400
          ),
          titleLarge: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          titleMedium: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          titleSmall: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          bodyLarge: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          bodyMedium: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
          labelLarge: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          bodySmall: GoogleFonts.poppins(
            fontSize: 10,
            fontWeight: FontWeight.w400,
          ),
          labelSmall: GoogleFonts.poppins(
            fontSize: 8,
            fontWeight: FontWeight.w400,
          ),
        )
      ).dark(),
        home: 
        accountService.permissionsGranted.value? (
          isLogin? const HomeScreen() : AuthScreen()
        ):
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Please every permissions to use this application!', style: TextStyle(fontSize: 18),),
              const SizedBox(height: 10,),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0
                ),
                onPressed: () => DependencyInjection.requestPermissions(accountService),
                child: const Text('Allow Permissions', style: TextStyle(fontSize: 18),),
              ),
            ],
          )
        ),
      ),
    );
  }
}

