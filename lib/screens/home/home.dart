import 'package:flutter/material.dart';
import 'package:flutter_note/controllers/authController.dart';
import 'package:flutter_note/screens/home/add_note.dart';
import 'package:flutter_note/screens/home/note_list.dart';
import 'package:flutter_note/screens/settings/setting.dart';
import 'package:flutter_note/screens/widgets/custom_icon_btn.dart';
import 'package:get/get.dart';

class HomePage extends GetWidget<AuthController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 16,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => CustomIconBtn(
                        color: Theme.of(context).colorScheme.surface,
                        onPressed: () {
                          controller.axisCount.value =
                              controller.axisCount.value == 2 ? 4 : 2;
                        },
                        icon: AnimatedSwitcher(
                          duration: Duration(milliseconds: 300),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                            return RotationTransition(
                              turns: animation,
                              child: FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                            );
                          },
                          child: Icon(
                            controller.axisCount.value == 2
                                ? Icons.list
                                : Icons.grid_on,
                            key: ValueKey(controller.axisCount.value),
                          ),
                        ),
                      )),
                  Text(
                    "Notes",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  CustomIconBtn(
                    color: Theme.of(context).colorScheme.surface,
                    onPressed: () {
                      Get.to(() => Setting());
                    },
                    icon: Icon(
                      Icons.settings,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              NoteList(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          tooltip: "Add Note",
          onPressed: () {
            Get.to(() => AddNotePage());
          },
          child: Icon(
            Icons.note_add,
            size: 30,
          )),
    );
  }
}
