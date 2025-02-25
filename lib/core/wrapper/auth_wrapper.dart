import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/auth/presentation/pages/signup_screen.dart';
import '../../features/home/presentation/widgets/bottom_nav.dart';
import 'package:chupachap/core/utils/colors.dart';
import 'package:chupachap/core/utils/custom_snackbar_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          CustomAnimatedSnackbar.show(
            context: context,
            message: "Authentication Error: ${state.message}",
            icon: Icons.error_outline,
            backgroundColor: Colors.red,
          );
        }

        if (state is Authenticated) {
          CustomAnimatedSnackbar.show(
            context: context,
            message: "Welcome back!!",
            icon: Icons.check_circle_outline,
            backgroundColor: Colors.green,
          );

          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const BottomNav()),
            (route) => false,
          );
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Scaffold(
            backgroundColor: AppColors.primaryColor,
            body: Center(
              child: CircularProgressIndicator(
                color: AppColors.background,
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(150),
            child: Container(
              color: Colors.white,
              child: SafeArea(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      'Welcome',
                      style: GoogleFonts.acme(
                        textStyle: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.brandPrimary,
                              fontSize: 32,
                            ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TabBar(
                      controller: _tabController,
                      labelColor: AppColors.brandPrimary,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: AppColors.brandPrimary,
                      indicatorWeight: 3,
                      labelStyle: GoogleFonts.acme(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      tabs: const [
                        Tab(text: 'Login'),
                        Tab(text: 'Sign Up'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: const [
              LoginScreen(),
              SignupScreen(),
            ],
          ),
        );
      },
    );
  }
}
