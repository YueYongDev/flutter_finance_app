import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:settings_ui/settings_ui.dart';

import 'edit_account_page_logic.dart';

class EditAccountPage extends StatelessWidget {
  final AccountController controller = Get.put(AccountController());

  EditAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: const Text('Edit Account'),
          // trailing: GestureDetector(
          //   onTap: () => Get.back(),
          //   child: const Text(
          //     'Save',
          //     style: TextStyle(color: Colors.teal),
          //   ),
          // ),
          leading: GestureDetector(
            onTap: () => Get.back(),
            child: const Icon(
              CupertinoIcons.back,
              color: Colors.teal,
            ),
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 16.0), // Add spacing
            Expanded(
              child: GetBuilder<AccountController>(
                builder: (controller) {
                  return SettingsList(
                    lightTheme: const SettingsThemeData(
                      settingsListBackground: Color(0xFFF8F8F8),
                    ),
                    sections: [
                      SettingsSection(
                        title: const Text('Account Info'),
                        tiles: [
                          SettingsTile(
                            title: const Text('Account Name'),
                            leading: const Icon(Icons.account_circle,
                                color: Colors.teal),
                            description: Text(
                                'Remaining characters: ${controller.remainingCharacters}',
                                style: TextStyle(
                                    color:
                                        controller.remainingCharactersColor)),
                            trailing: SizedBox(
                              width: 200,
                              child: TextField(
                                controller: controller.nameController,
                                decoration: const InputDecoration(
                                  hintStyle: TextStyle(color: Colors.grey),
                                  hintText: 'Enter account name',
                                  counterText: '',
                                  border: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 10),
                                ),
                                textAlign: TextAlign.right,
                                maxLength: 20,
                                // Limit the number of characters
                                onChanged: (text) {
                                  controller.updateRemainingCharacters(text);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      SettingsSection(
                        title: const Text('Appreance'),
                        tiles: [
                          SettingsTile(
                            title: const Text('Color'),
                            leading: const Icon(Icons.color_lens,
                                color: Colors.teal),
                            trailing: CircleAvatar(
                              radius: 12,
                              backgroundColor: Color(
                                  int.parse("0xFF${controller.selectedColor}")),
                            ),
                            onPressed: (context) => _showColorPicker(context),
                          ),
                          SettingsTile(
                            title: const Text('Currency'),
                            leading: const Icon(Icons.monetization_on,
                                color: Colors.teal),
                            trailing: PullDownButton(
                              itemBuilder: (context) {
                                var currencyList = ['CNY', 'USD', 'EUR'];
                                return List.generate(currencyList.length,
                                    (index) {
                                  return PullDownMenuItem(
                                    title: currencyList[index],
                                    onTap: () {
                                      controller.selectedCurrency =
                                          currencyList[index];
                                      controller.update();
                                    },
                                  );
                                });
                              },
                              buttonBuilder: (context, showMenu) =>
                                  GestureDetector(
                                onTap: showMenu,
                                child: Row(
                                  children: [
                                    Text(controller.selectedCurrency),
                                    const SizedBox(width: 3),
                                    const Icon(
                                      CupertinoIcons.chevron_up_chevron_down,
                                      color: Colors.grey,
                                      size: 18,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      CustomSettingsSection(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              controller.addAccount();
                              Get.snackbar(
                                'Success',
                                'Account saved successfully!',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.green,
                                colorText: Colors.white,
                              );
                            },
                            icon: const Icon(CupertinoIcons.cube,
                                color: Colors.teal),
                            label: const Text('Save Account',
                                style: TextStyle(color: Colors.teal)),
                            style: ElevatedButton.styleFrom(
                              // primary: Colors.teal, // Match the color theme
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 显示颜色选择器
  void _showColorPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: Color(int.parse("0xFF${controller.selectedColor}")),
              onColorChanged: (color) {
                controller.selectedColor =
                    color.value.toRadixString(16).padLeft(8, '0');
                controller.update();
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Got it'),
            ),
          ],
        );
      },
    );
  }
}
