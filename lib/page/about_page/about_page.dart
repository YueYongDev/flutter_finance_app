import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:settings_ui/settings_ui.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = CupertinoTheme.of(context).barBackgroundColor;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: backgroundColor,
          title: const Text('About'),
        ),
        body: SettingsList(
          lightTheme:
              SettingsThemeData(settingsListBackground: backgroundColor),
          sections: [
            // 关于
            _buildAboutAppSection(),
            SettingsSection(
              tiles: <SettingsTile>[
                SettingsTile.navigation(
                  enabled: false,
                  // leading: const Icon(Icons.cloud_sync, color: Colors.grey),
                  title: Text('What\'s new'),
                ),
                SettingsTile.navigation(
                  enabled: false,
                  // leading: const Icon(Icons.cloud_sync, color: Colors.grey),
                  title: Text('What\'s new'),
                ),
              ],
            )
          ],
        ));
  }

  // 关于
  _buildAboutAppSection() {
    return CustomSettingsSection(
      child: FutureBuilder<PackageInfo>(
        future: getAppInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            PackageInfo packageInfo = snapshot.data!;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 应用 Logo
                Image.asset('assets/images/app-logo-removebg.png',
                    width: 100, height: 100),
                Text(packageInfo.appName,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(height: 10.sp),
                Text('Version: ${packageInfo.version}'),
              ],
            );
          }
        },
      ),
    );
  }

  Future<PackageInfo> getAppInfo() async {
    return await PackageInfo.fromPlatform();
  }
}
