import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:pllcare/auth/provider/auth_provider.dart';
import 'package:pllcare/auth/view/login_screen.dart';
import 'package:pllcare/common/component/default_layout.dart';
import 'package:pllcare/config/go_router_observer.dart';
import 'package:pllcare/profile/view/profile_screen.dart';
import 'package:pllcare/project/view/project_list_screen.dart';
import 'package:pllcare/project/view/project_management_screen.dart';

import '../home_screen.dart';
import '../post/view/post_screen.dart';
import '../profile/view/profile_eval_detail_screen.dart';
import '../test_screen.dart';

final GlobalKey<NavigatorState> rootNavKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> shellNavKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final provider = ref.read(tokenProvider);
  return GoRouter(
      initialLocation: '/home',
      debugLogDiagnostics: true,
      navigatorKey: rootNavKey,
      refreshListenable: TokenProvider(ref: ref),
      observers: [
        GoRouterObserver()
      ],
      routes: <RouteBase>[
        GoRoute(
            path: '/login',
            name: LoginScreen.routeName,
            pageBuilder: (context, state) {
              return NoTransitionPage(child: LoginScreen());
            }),
        GoRoute(
            parentNavigatorKey: rootNavKey,
            path: '/profile/:memberId',
            name: ProfileScreen.routeName,
            pageBuilder: (context, state) {
              final memberId = int.parse(state.pathParameters['memberId']!);
              return NoTransitionPage(
                  child: ProfileScreen(
                memberId: memberId,
              ));
            },
            routes: [
              GoRoute(
                parentNavigatorKey: rootNavKey,
                path: ':projectId/eval',
                name: ProfileEvalDetailScreen.routeName,
                pageBuilder: (context, state) {
                  final projectId =
                      int.parse(state.pathParameters['projectId']!);
                  final memberId = int.parse(state.pathParameters['memberId']!);
                  final projectName = state.extra as String;
                  return NoTransitionPage(
                      child: ProfileEvalDetailScreen(
                    projectId: projectId,
                    memberId: memberId, projectName: projectName,
                  ));
                },
              )
            ]),
        ShellRoute(
            navigatorKey: shellNavKey,
            builder: (context, state, child) {
              return DefaultLayout(body: child);
            },
            routes: [
              GoRoute(
                  path: '/management',
                  parentNavigatorKey: shellNavKey,
                  name: ProjectListScreen.routeName,
                  redirect: (_, state) => provider.redirectLogic(state),
                  pageBuilder: (context, state) {
                    return const NoTransitionPage(child: ProjectListScreen());
                  },
                  routes: [
                    GoRoute(
                      path: ':projectId/overview',
                      parentNavigatorKey: shellNavKey,
                      name: ProjectManagementScreen.routeName,
                      pageBuilder: (context, state) {
                        final int projectId =
                            int.parse(state.pathParameters['projectId']!);
                        return NoTransitionPage(
                            child: ProjectManagementScreen(
                          projectId: projectId,
                        ));
                      },
                    ),
                  ]),
              GoRoute(
                path: '/home',
                parentNavigatorKey: shellNavKey,
                name: HomeScreen.routeName,
                builder: (_, state) => const HomeScreen(),
                pageBuilder: (context, state) {
                  return const NoTransitionPage(child: HomeScreen());
                },
              ),
              GoRoute(
                  path: '/recruit',
                  parentNavigatorKey: shellNavKey,
                  name: PostScreen.routeName,
                  pageBuilder: (context, state) {
                    return const NoTransitionPage(child: PostScreen());
                  },
                  routes: [
                    GoRoute(
                        path: 'form',
                        parentNavigatorKey: shellNavKey,
                        name: PostFormScreen.routeName,
                        pageBuilder: (context, state) {
                          int? postId;
                          if (state.uri.queryParameters['postId'] != null) {
                            postId =
                                int.parse(state.uri.queryParameters['postId']!);
                          }
                          return NoTransitionPage(
                              child: PostFormScreen(
                            postId: postId,
                          ));
                        }),
                    GoRoute(
                        path: ':postId',
                        parentNavigatorKey: shellNavKey,
                        name: PostDetailScreen.routeName,
                        pageBuilder: (context, state) {
                          final int postId =
                              int.parse(state.pathParameters['postId']!);
                          return NoTransitionPage(
                              child: PostDetailScreen(
                            postId: postId,
                          ));
                        }),
                  ]),
            ]),
      ]);
});
