import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:showroom_mobil/app/config/app_theme.dart';
import 'package:showroom_mobil/app/routes/app_routes.dart';
import 'package:showroom_mobil/core/utils/validator_helper.dart';
import 'package:showroom_mobil/features/auth/controllers/auth_controller.dart';
import 'package:showroom_mobil/features/auth/views/widgets/auth_header.dart';
import 'package:showroom_mobil/features/auth/views/widgets/password_field.dart';
import 'package:showroom_mobil/core/utils/app_input_formatter.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Gunakan Get.find karena AuthController sudah di-put di LoginPage.
    // Jika RegisterPage diakses langsung tanpa lewat LoginPage,
    // gunakan Get.put dengan kondisi agar tidak duplikat.
    final controller = Get.isRegistered<AuthController>()
        ? Get.find<AuthController>()
        : Get.put(AuthController());

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Daftar Akun Seller'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          child: Column(
            children: [
              const SizedBox(height: AppTheme.spacingMd),


              const AuthHeader(
                title: 'Buat Akun Seller',
                subtitle: 'Daftarkan diri kamu untuk\nmengajukan mobil ke showroom',
                icon: Icons.person_add_alt_1_rounded,
              ),

              const SizedBox(height: AppTheme.spacingLg),


              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingMd),
                  child: Form(
                    key: controller.registerFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [


                        _SectionLabel(label: 'Data Diri'),
                        const SizedBox(height: AppTheme.spacingSm),


                        TextFormField(
                          controller: controller.registerNamaCtrl,
                          inputFormatters: [
                            AppInputFormatter.textOnly,
                          ],
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.words,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: ValidatorHelper.namaLengkap,
                          decoration: const InputDecoration(
                            labelText: 'Nama Lengkap',
                            hintText: 'Masukkan nama lengkap',
                            prefixIcon: Icon(
                              Icons.person_outline,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ),

                        const SizedBox(height: AppTheme.spacingMd),


                        TextFormField(
                          controller: controller.registerWaCtrl,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: ValidatorHelper.nomorWhatsapp,
                          decoration: const InputDecoration(
                            labelText: 'Nomor WhatsApp',
                            hintText: '08xxxxxxxxxx',
                            prefixIcon: Icon(
                              Icons.phone_outlined,
                              color: AppTheme.textSecondary,
                            ),
                            helperText: 'Format: 08xx atau 628xx',
                          ),
                        ),

                        const SizedBox(height: AppTheme.spacingLg),


                        _SectionLabel(label: 'Informasi Akun'),
                        const SizedBox(height: AppTheme.spacingSm),


                        TextFormField(
                          controller: controller.registerEmailCtrl,
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
                          controller: controller.registerPasswordCtrl,
                          isVisible: controller.isRegisterPasswordVisible,
                          onToggleVisibility:
                              controller.toggleRegisterPasswordVisibility,
                          label: 'Password',
                          hint: 'Min. 6 karakter',
                          validator: ValidatorHelper.password,
                          textInputAction: TextInputAction.next,
                        ),

                        const SizedBox(height: AppTheme.spacingMd),

                        // Konfirmasi Password
                        // Menggunakan Obx agar validator bisa baca
                        // nilai registerPasswordCtrl secara reaktif
                        Obx(() {

                          controller.isRegisterPasswordVisible.value;
                          return PasswordField(
                            controller: controller.registerKonfirmasiCtrl,
                            isVisible: controller.isKonfirmasiPasswordVisible,
                            onToggleVisibility:
                                controller.toggleKonfirmasiVisibility,
                            label: 'Konfirmasi Password',
                            hint: 'Ulangi password kamu',
                            validator: (value) =>
                                ValidatorHelper.konfirmasiPassword(
                              value,
                              controller.registerPassword,
                            ),
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: controller.registerSeller,
                          );
                        }),

                        const SizedBox(height: AppTheme.spacingMd),


                        Obx(() {
                          if (controller.registerError.value.isEmpty) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppTheme.spacingMd,
                            ),
                            child: _ErrorBanner(
                              message: controller.registerError.value,
                            ),
                          );
                        }),


                        Obx(() {
                          return ElevatedButton(
                            onPressed: controller.isRegisterLoading.value
                                ? null
                                : controller.registerSeller,
                            child: controller.isRegisterLoading.value
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text('Buat Akun'),
                          );
                        }),

                        const SizedBox(height: AppTheme.spacingMd),


                        const Text(
                          'Dengan mendaftar, kamu menyetujui bahwa data yang '
                          'kamu berikan adalah benar dan dapat dipertanggungjawabkan.',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.textHint,
                          ),
                          textAlign: TextAlign.center,
                        ),
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
                    'Sudah punya akun? ',
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                  TextButton(
                    onPressed: () => Get.toNamed(AppRoutes.login),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Masuk di sini',
                      style: TextStyle(
                        color: AppTheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppTheme.spacingMd),
            ],
          ),
        ),
      ),
    );
  }
}



class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppTheme.primary,
        letterSpacing: 0.5,
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
        border: Border.all(color: AppTheme.error.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppTheme.error, size: 18),
          const SizedBox(width: AppTheme.spacingSm),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: AppTheme.error, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}