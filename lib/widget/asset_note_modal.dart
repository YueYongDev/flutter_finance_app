import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finance_app/page/edit_asset_page/edit_asset_page_logic.dart';
import 'package:get/get.dart';

class AssetNoteModal extends StatelessWidget {
  const AssetNoteModal({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AssetController>(builder: (assetLogic) {
      return Scaffold(
        appBar: CupertinoNavigationBar(
          middle: const Text('Asset Note',
              style: TextStyle(color: CupertinoColors.label, fontSize: 18)),
          leading: IconButton(
              onPressed: () {
                assetLogic.noteController.text = '';
                Navigator.of(context).pop();
                assetLogic.update();
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 24,
              )),
          trailing: GestureDetector(
            child: const Text("Save"),
            onTap: () {
              debugPrint("save note");
              Navigator.of(context).pop(assetLogic.noteController.text);
            },
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Note"),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18)),
                  child: SizedBox(
                    height: 150.0, // 设置高度
                    child: CupertinoTextField(
                      placeholder: "input your asset note",
                      controller: assetLogic.noteController,
                      textAlign: TextAlign.left, // 设置输入内容不居中
                      maxLength: 60, // 限制最大字符数为 60
                      onChanged: (value) {
                        // 更新字符数
                        assetLogic.update();
                      },
                      maxLines: null, // 允许多行输入
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '${assetLogic.noteController.text.length}/60',
                    style: const TextStyle(color: CupertinoColors.systemGrey),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
