import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:ipodaily/auth_module/controller/auth_controller.dart';
import 'package:ipodaily/dashboard_module/controller/buyback/buyback_ipo_controller.dart';
import 'package:ipodaily/dashboard_module/controller/default_controller.dart';
import 'package:ipodaily/dashboard_module/controller/upcoming/mainboard_ipo_controller.dart';
import 'package:ipodaily/utilities/common/blur_bottom_navigation_bar_widget.dart';
import 'package:ipodaily/utilities/common/core_update_handler.dart';
import 'package:ipodaily/utilities/common/default_app_drawer.dart';
import 'package:ipodaily/utilities/common/drawer_controller.dart';
import 'package:ipodaily/utilities/firebase/analytics_service.dart';
import 'package:ipodaily/utilities/firebase/core_prefs.dart';
import 'package:ipodaily/utilities/navigation/navigator.dart';
import 'package:ipodaily/utilities/theme/app_box_decoration.dart';
import 'package:ipodaily/utilities/theme/app_colors.dart';

final _hiddenDrawerController = Get.put(HiddenDrawerController());
final _mainBoardIpoController = Get.put(MainBoardIpoController());
final _buybackIpoController = Get.put(BuybackBoardIpoController());
final _authController = Get.put(AuthController());
final _defaultController = Get.put(DefaultApiController());

class LandingView extends StatefulWidget {
  const LandingView({super.key, required this.child});

  final Widget child;

  @override
  State<LandingView> createState() => _LandingViewState();
}

class _LandingViewState extends State<LandingView> {
  final InAppReview inAppReview = InAppReview.instance;
  int selectedIndex = 0;

  @override
  void initState() {
    apiCalls();
    super.initState();
  }

  void apiCalls() async {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        _mainBoardIpoController.getMainboardData();
        _buybackIpoController.getBuybackData();
        _defaultController.getDefaultData();
      },
    );
    if (isLoggedIn()) {
      if (await inAppReview.isAvailable()) {
        inAppReview.requestReview();
      }
    }
    Future.delayed(
      const Duration(milliseconds: 400),
      () {
        return checkUpdate();
      },
    );
    final uid = getUuid();
    FirebaseAnalyticsService().init(uid);
    if (isLoggedIn()) {
      _authController.fetchUserData(uid);
    }
    FirebaseAnalyticsService().init(uid);
  }

  void checkUpdate() async {
    await appUpdateCheck(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => GestureDetector(
          onTap: () {
            if (_hiddenDrawerController.isDrawerOpen.value == false) {
              return;
            }
            _hiddenDrawerController.toggleDrawer();
          },
          child: AnimatedContainer(
            transform: Matrix4.translationValues(
              _hiddenDrawerController.xOffset.value,
              _hiddenDrawerController.yOffset.value,
              0,
            )..scale(
                _hiddenDrawerController.scaleFactor.value,
              ),
            duration: const Duration(
              milliseconds: 250,
            ),
            curve: Curves.easeInOut,
            decoration: AppBoxDecoration.getBoxDecoration(
              showShadow: true,
              color: AppColors.backgroundColor,
              borderRadius: _hiddenDrawerController.isDrawerOpen.value ? 40 : 0.0,
              spreadRadius: _hiddenDrawerController.isDrawerOpen.value ? 1 : 0,
              blurRadius: 24,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                _hiddenDrawerController.isDrawerOpen.value ? 24 : 0.0,
              ),
              child: IgnorePointer(
                ignoring: _hiddenDrawerController.isDrawerOpen.value,
                child: Scaffold(
                  key: _hiddenDrawerController.scaffoldKey,
                  body: widget.child,
                  drawer: const DefaultCustomDrawer(),
                  // bottomNavigationBar: const CustomBottomNavigationBar(),
                  floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
                  floatingActionButton: BlurBottomNavigationBar(
                    selectedIndex: selectedIndex,
                    onItemTapped: (index, route) {
                      _changeRoute(index, route);
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _changeRoute(int index, String route) {
    if (selectedIndex == index) {
      return;
    }
    selectedIndex = index;
    MyNavigator.go(route, extra: {"isAppBarHide": true});
    debugPrint("route navigated to: $route");
  }
}
