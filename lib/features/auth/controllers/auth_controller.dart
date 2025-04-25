import 'package:get/get.dart';

class AuthController extends GetxController {
  final RxBool isLogin = true.obs;
  final RxBool isObscured = true.obs;

  void toggleMode() => isLogin.value = !isLogin.value;
  void toggleObscured() => isObscured.value = !isObscured.value;
}
