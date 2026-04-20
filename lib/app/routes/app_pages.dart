import 'package:get/get.dart';
import 'package:showroom_mobil/app/routes/app_routes.dart';
import 'package:showroom_mobil/features/splash/splash_page.dart';
import 'package:showroom_mobil/features/auth/views/login_page.dart';
import 'package:showroom_mobil/features/auth/views/register_page.dart';
import 'package:showroom_mobil/features/guest/views/guest_home_page.dart';
import 'package:showroom_mobil/features/seller/pengajuan/controllers/pengajuan_controller.dart';
import 'package:showroom_mobil/features/seller/pengajuan/views/seller_main_page.dart';
import 'package:showroom_mobil/features/seller/pengajuan/views/detail_pengajuan_seller_page.dart';
import 'package:showroom_mobil/features/admin/mobil/views/kelola_mobil_page.dart';
import 'package:showroom_mobil/features/admin/mobil/views/form_mobil_page.dart';
import 'package:showroom_mobil/features/admin/dashboard/views/admin_main_page.dart';
import 'package:showroom_mobil/core/services/auth_service.dart';
import 'package:showroom_mobil/features/admin/pengajuan/views/kelola_pengajuan_page.dart';
import 'package:showroom_mobil/features/admin/pengajuan/views/detail_pengajuan_admin_page.dart';
import 'package:showroom_mobil/features/admin/transaksi/views/transaksi_page.dart';
import 'package:showroom_mobil/features/admin/transaksi/views/form_transaksi_page.dart';
import 'package:showroom_mobil/features/admin/laporan/views/laporan_page.dart';
import 'package:showroom_mobil/features/guest/views/katalog_page.dart';
import 'package:showroom_mobil/features/guest/views/detail_mobil_page.dart';
import 'package:showroom_mobil/features/guest/views/kredit_info_page.dart';
import 'package:showroom_mobil/features/admin/transaksi/views/detail_transaksi_page.dart';


class AppPages {
  AppPages._();

  static final routes = <GetPage>[


    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashPage(),
      transition: Transition.fadeIn,
    ),


    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterPage(),
      transition: Transition.rightToLeft,
    ),


    GetPage(
      name: AppRoutes.guestHome,
      page: () => const GuestHomePage(),
    ),
    GetPage(
      name:       AppRoutes.katalog,
      page:       () => const KatalogPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name:       AppRoutes.detailMobil,
      page:       () => const DetailMobilPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name:       AppRoutes.kreditInfo,
      page:       () => const KreditInfoPage(),
      transition: Transition.rightToLeft,
    ),



    GetPage(
      name:        AppRoutes.kelolaMobil,
      page:        () => const KelolaMobilPage(),
      transition:  Transition.rightToLeft,
    ),
    GetPage(
      name:       AppRoutes.tambahMobil,
      page:       () => const FormMobilPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name:       AppRoutes.editMobil,
      page:       () => const FormMobilPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name:        AppRoutes.adminDashboard,
      page:        () => const AdminMainPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut<AuthService>(() => Get.find<AuthService>());
      }),
    ),
    GetPage(
      name:       AppRoutes.kelolaPengajuan,
      page:       () => const KelolaPengajuanPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name:       AppRoutes.detailPengajuanAdmin,
      page:       () => const DetailPengajuanAdminPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name:       AppRoutes.transaksi,
      page:       () => const TransaksiPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name:       AppRoutes.formTransaksi,
      page:       () => const FormTransaksiPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name:       AppRoutes.laporan,
      page:       () => const LaporanPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.detailTransaksi,
      page: () => const DetailTransaksiPage(),
      transition: Transition.rightToLeft,
    ),

    // ── Seller ──
    GetPage(
      name: AppRoutes.sellerDashboard,
      page: () => const SellerMainPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut<PengajuanController>(() => PengajuanController());
      }),
    ),
    
    GetPage(
      name: AppRoutes.detailPengajuanSeller,
      page: () => const DetailPengajuanSellerPage(),
      transition: Transition.rightToLeft,
    ),
  ];
}