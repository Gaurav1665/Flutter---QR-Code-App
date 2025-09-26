import 'package:flutter/material.dart';
import 'package:qrgen/utils/importExport.dart';
import 'package:qrgen/view/aboutUsView.dart';

class RootScreen extends StatelessWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RootScreenController controller = Get.put(RootScreenController());
    final RootScreenModel model = RootScreenModel();

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Theme(
      data: Theme.of(context).copyWith(
        useMaterial3: true,
      ),
      child: DefaultTabController(
        length: model.screens.length,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'QR Code',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface,
              ),
            ),
            
            backgroundColor: colorScheme.surfaceContainer,
            elevation: 1,
            surfaceTintColor: colorScheme.surfaceTint,
            actions: [
              PopupMenuButton<int>(
                onSelected: (int result) {
                  result==1 ? Get.to(AboutUsScreen()) : null ;
                },
                icon: Icon(
                  Icons.more_vert_rounded,
                  size: 24.0,
                ),
                itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                  const PopupMenuItem<int>(
                    value: 1,
                    child: Row(children: [ Icon(Icons.person), Text('About Us') ],),
                  ),
                ],
              ),
            ],
            scrolledUnderElevation: 3,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(48),
              child: Container(
                color: colorScheme.surface,
                child: Obx(
                  () => TabBar(
                    onTap: (int index) {
                      controller.changeTabIndex(index);
                    },
                    indicator: BoxDecoration(
                      color: colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    dividerColor: colorScheme.surfaceVariant,
                    labelColor: colorScheme.onSecondaryContainer,
                    unselectedLabelColor: colorScheme.onSurfaceVariant,
                    labelStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    isScrollable: false,
                    tabs: model.iconList.asMap().entries.map((entry) {
                      final index = entry.key;
                      final icon = entry.value;
                      final isSelected = controller.bottomNavIndex.value == index;
                      
                      return Tab(
                        height: 36,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              icon,
                              size: 18,
                              color: isSelected 
                                  ? colorScheme.onSecondaryContainer
                                  : colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              model.labels[index],
                              style: TextStyle(
                                color: isSelected 
                                    ? colorScheme.onSecondaryContainer
                                    : colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
          body: Obx(
            () => IndexedStack(
              index: controller.bottomNavIndex.value,
              children: model.screens,
            ),
          ),
        ),
      ),
    );
  }
}