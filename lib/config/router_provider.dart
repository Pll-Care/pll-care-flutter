import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pllcare/auth/provider/auth_provider.dart';
import 'package:pllcare/auth/view/login_screen.dart';
import 'package:pllcare/common/component/default_layout.dart';
import 'package:pllcare/main/view/home.dart';

import '../project/component/project_body.dart';
import '../recruit/component/recruit_body.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final provider = ref.read(authProvider);
  return GoRouter(
      initialLocation: '/home',
      debugLogDiagnostics: true,
      routes: <RouteBase>[
        // GoRoute(
        //     path: '/home',
        //     name: HomeScreen.routeName,
        //     builder: (BuildContext context, GoRouterState state) {
        //       return const HomeScreen();
        //     }),
        GoRoute(
            path: '/login',
            name: LoginScreen.routeName,
            builder: (BuildContext context, GoRouterState state) {
              return LoginScreen();
            }),
        ShellRoute(
            builder: (context, state, child) {
              return DefaultLayout(body: child);
            },
            routes: [
              GoRoute(
                path: '/management',
                name: ProjectBody.routeName,
                builder: (_, state) =>  ProjectBody(),
              ),
              GoRoute(
                path: '/home',
                name: HomeBody.routeName,
                builder: (_, state) => const HomeBody(),
              ),
              GoRoute(
                path: '/recruit',
                name: RecruitBody.routeName,
                builder: (_, state) => const RecruitBody(),
              ),
            ]),
      ]);
});
