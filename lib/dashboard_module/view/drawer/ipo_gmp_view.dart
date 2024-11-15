import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ipodaily/dashboard_module/components/ipo_gmp_card.dart';
import 'package:ipodaily/dashboard_module/controller/drawer/ipo_gmp_controller.dart';
import 'package:ipodaily/utilities/common/core_app_bar.dart';
import 'package:ipodaily/utilities/common/error_widget.dart';
import 'package:ipodaily/utilities/firebase/core_prefs.dart';

final _ipoGmpController = Get.put(IpoGmpController());

class IpoGmpView extends StatefulWidget {
  const IpoGmpView({super.key});

  @override
  State<IpoGmpView> createState() => _IpoGmpViewState();
}

class _IpoGmpViewState extends State<IpoGmpView> {
  @override
  void initState() {
    super.initState();
    _ipoGmpController.getGmpData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CoreAppBar(
        title: "Ipo GMP",
        showBackButton: true,
        centerTitle: false,
        showActions: false,
      ),
      body: isLoggedIn()
          ? _ipoGmpController.obx(
              (state) {
                return ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  itemCount: state?.gmp?.length ?? 0,
                  itemBuilder: (context, index) {
                    final gmpData = state?.gmp?[index];
                    return IpoGmpCard(state: gmpData);
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 16);
                  },
                );
              },
              onError: (error) => TryAgainWidget(
                onTap: () => _ipoGmpController.getGmpData(),
              ),
            )
          : const Text("Login"),
    );
  }
}
