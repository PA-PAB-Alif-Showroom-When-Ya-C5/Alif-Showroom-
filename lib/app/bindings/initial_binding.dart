import 'package:get/get.dart';
import 'package:showroom_mobil/core/services/auth_service.dart';
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthService>(
      AuthService(),
      permanent: true,
    );
  }
}