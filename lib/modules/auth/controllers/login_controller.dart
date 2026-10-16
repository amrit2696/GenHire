import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/repositories/auth_repository.dart';
import '../../../data/services/auth_local_storage.dart';
import '../../../app/routes/app_routes.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  final formKey = GlobalKey<FormState>();

  final isPasswordVisible = false.obs;
  final rememberMe = false.obs;
  final isLoading = false.obs;

  final AuthLocalStorage _localStorage = AuthLocalStorage.instance;

  @override
  void onInit() {
    super.onInit();

    loadRememberedCredentials();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.toggle();
  }

  void toggleRememberMe() {
    rememberMe.toggle();
  }

  /// Load saved email/password when Remember Me was enabled.
  Future<void> loadRememberedCredentials() async {
    try {
      final remembered = await _localStorage.getRememberMe();

      if (!remembered) {
        return;
      }

      final savedEmail = await _localStorage.getSavedEmail();
      final savedPassword = await _localStorage.getSavedPassword();

      rememberMe.value = true;

      emailController.text = savedEmail ?? '';
      passwordController.text = savedPassword ?? '';
    } catch (error) {
      debugPrint('LOAD REMEMBERED CREDENTIALS ERROR: $error');
    }
  }

  Future<void> login() async {
    FocusManager.instance.primaryFocus?.unfocus();

    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;

    try {
      final body = {
        'UserName': emailController.text.trim(),
        'Password': passwordController.text,
        'MacAddress': 'dfdf',
        'IpAddress': 'sdfs',
        'lat': 'sdf',
        'Long': 'af',
        'Op': 1,
      };

      debugPrint('LOGIN REQUEST: $body');

      final response = await AuthRepository.loginUser(body: body);

      debugPrint('LOGIN RESPONSE: $response');

      final status = response['Status'] == true;

      if (!status) {
        Get.snackbar(
          'Login Failed',
          response['Message']?.toString() ??
              'Invalid credentials. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
        );

        return;
      }

      final data = response['Data'];

      if (data is! Map) {
        Get.snackbar(
          'Login Failed',
          'Invalid response from server.',
          snackPosition: SnackPosition.BOTTOM,
        );

        return;
      }

      final accessToken = data['AccessToken']?.toString();
      final userData = data['UserData'];

      if (accessToken == null || accessToken.isEmpty) {
        Get.snackbar(
          'Login Failed',
          'Access token not received.',
          snackPosition: SnackPosition.BOTTOM,
        );

        return;
      }

      debugPrint('ACCESS TOKEN RECEIVED');
      debugPrint('USER DATA: $userData');

      // --------------------------------------------------
      // SAVE LOGIN DATA LOCALLY
      // --------------------------------------------------

      await _localStorage.saveLoginData(
        accessToken: accessToken,
        userData: userData,
        rememberMe: rememberMe.value,
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      Get.offAllNamed(AppRoutes.dashboard);
      // --------------------------------------------------
      // NAVIGATE TO DASHBOARD
      // --------------------------------------------------

      Get.offAllNamed(AppRoutes.dashboard);
    } catch (error) {
      debugPrint('LOGIN ERROR: $error');

      // ApiHandler already shows the error popup.
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();

    emailFocusNode.dispose();
    passwordFocusNode.dispose();

    super.onClose();
  }
}
