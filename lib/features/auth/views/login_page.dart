import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:showroom_mobil/app/config/app_theme.dart';
import 'package:showroom_mobil/app/routes/app_routes.dart';
import 'package:showroom_mobil/core/utils/validator_helper.dart';
import 'package:showroom_mobil/features/auth/controllers/auth_controller.dart';
import 'package:showroom_mobil/features/auth/views/widgets/auth_header.dart';
import 'package:showroom_mobil/features/auth/views/widgets/password_field.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {

    final controller = Get.put(AuthController());

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          child: Column(
            children: [
              const SizedBox(height: AppTheme.spacingXl),


              const AuthHeader(
                title: 'Masuk ke Akun',
                subtitle: 'Masuk sebagai admin atau seller\nuntuk mengakses fitur lengkap',
                icon: Icons.login_rounded,
              ),

              const SizedBox(height: AppTheme.spacingXl),


              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingMd),
                  child: Form(
                    key: controller.loginFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [


                        TextFormField(
                          controller: controller.loginEmailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: ValidatorHelper.email,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            hintText: 'contoh@email.com',
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ),

                        const SizedBox(height: AppTheme.spacingMd),


                        PasswordField(
                          controller: controller.loginPasswordCtrl,
                          isVisible: controller.isLoginPasswordVisible,
                          onToggleVisibility:
                              controller.toggleLoginPasswordVisibility,
                          label: 'Password',
                          validator: ValidatorHelper.password,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: controller.login,
                        ),

                        const SizedBox(height: AppTheme.spacingMd),


                        Obx(() {
                          if (controller.loginError.value.isEmpty) {
                            return const SizedBox.shrink();
                          }
                          return _ErrorBanner(
                            message: controller.loginError.value,
                          );
                        }),

                        const SizedBox(height: AppTheme.spacingMd),


                        Obx(() {
                          return ElevatedButton(
                            onPressed: controller.isLoginLoading.value
                                ? null
                                : controller.login,
                            child: controller.isLoginLoading.value
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text('Masuk'),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppTheme.spacingMd),


              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Belum punya akun seller? ',
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                  TextButton(
                    onPressed: () => Get.toNamed(AppRoutes.register),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Daftar di sini',
                      style: TextStyle(
                        color: AppTheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppTheme.spacingSm),


              TextButton.icon(
                onPressed: () => Get.offAllNamed(AppRoutes.guestHome),
                icon: const Icon(
                  Icons.arrow_back,
                  size: 16,
                  color: AppTheme.textSecondary,
                ),
                label: const Text(
                  'Kembali ke beranda',
                  style: TextStyle(color: AppTheme.textSecondary),
                ),
              ),

              const SizedBox(height: AppTheme.spacingMd),
            ],
          ),
        ),
      ),
    );
  }
}



class _ErrorBanner extends StatelessWidget {
  final String message;

  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: AppTheme.error.withOpacity(0.08),
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        border: Border.all(
          color: AppTheme.error.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: AppTheme.error,
            size: 18,
          ),
          const SizedBox(width: AppTheme.spacingSm),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: AppTheme.error,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}