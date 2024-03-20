import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pllcare/common/component/skeleton.dart';
import 'package:pllcare/common/model/default_model.dart';
import 'package:pllcare/project/component/skeleton/project_main_card_skeleton.dart';
import 'package:pllcare/project/model/project_model.dart';
import 'package:pllcare/project/provider/project_provider.dart';
import 'package:pllcare/theme.dart';

import '../../post/view/post_screen.dart';
import '../../project/component/project_main_card.dart';

class HomeBody extends ConsumerWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: Image.asset(
              'assets/main/main1.png',
              fit: BoxFit.fitWidth,
            ),
          ),
          // TextButton(
          //   onPressed: () async {
          //     // await Permission.storage.request();
          //     await Permission.storage
          //         .onDeniedCallback(() {
          //           log('onDeniedCallback');
          //     })
          //         .onGrantedCallback(() {
          //       log('onGrantedCallback');
          //     })
          //         .onPermanentlyDeniedCallback(() {
          //       log('onPermanentlyDeniedCallback');
          //     })
          //         .onRestrictedCallback(() {
          //       log('onRestrictedCallback');
          //     })
          //         .onLimitedCallback(() {
          //       log('onLimitedCallback');
          //     })
          //         .onProvisionalCallback(() {
          //       log('onProvisionalCallback');
          //     })
          //         .request();
          //   },
          //   child: Text('요청'),
          // ),
          SizedBox(
            height: 42.h,
          ),
          Padding(
              padding: EdgeInsets.only(left: 33.w),
              child: Text(
                '프로젝트 관리 서비스, 풀케어',
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge!
                    .copyWith(color: GREEN_500), //m_Heading_05
              )),
          SizedBox(
            height: 10.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 37.w, right: 37.w),
            child: Text(
              '개발자들을 위한 프로젝트 관리 서비스를 제공하고 있습니다. 서로 관심있는 주제를 선정하여 프로젝트를 함께할 사람들을 구해보세요. 프로젝트 내에서는 팀원 평가, 일정 관리, 회의록 정리가 있으며 지원하는 사람의 프로젝트 이력이나 이전 프로젝트의 평가 이력을 확인하여 더 신중한 팀원을 모집할 수 있습니다.',
              overflow: TextOverflow.ellipsis,
              maxLines: 8,
              style: Theme.of(context).textTheme.labelLarge!.copyWith(color: GREY_500),
            ),
          ),
          SizedBox(
            height: 41.h,
          ),
          const _MainContent(),
        ],
      ),
    );
  }
}

enum MainCareType { DEADLINE, MOSTLIKE, UPTODATE }

class _MainContent extends ConsumerWidget {
  const _MainContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(50.r)),
          color: const Color(0x00fbfbfb),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              blurStyle: BlurStyle.outer,
              blurRadius: 20,
              spreadRadius: 10,
            )
          ]),
      child: Column(
        children: [
          SizedBox(
            height: 38.h,
          ),
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _getMainCard(
                    ref: ref, type: MainCareType.MOSTLIKE, context: context),
                _getMainCard(
                    ref: ref, type: MainCareType.DEADLINE, context: context),
                _getMainCard(
                    ref: ref, type: MainCareType.UPTODATE, context: context),
              ],
            ),
          ),
          SizedBox(height: 43.h),
          Divider(
            thickness: 2.h,
            color: GREY_400,
            indent: 26.w,
            endIndent: 26.w,
          ),
          SizedBox(height: 24.h),
          const _HomeFooter(),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }

  Widget _getMainCard(
      {required WidgetRef ref,
      required MainCareType type,
      required BuildContext context}) {
    return Consumer(
      builder: (_, ref, __) {
        BaseModel model = _getModel(type, ref);
        String title = _getTitle(type);
        if (model is LoadingModel) {
          return const CustomSkeleton(skeleton: ProjectMainCardSkeleton());
        } else if (model is ErrorModel) {
          return const Center(
            child: Text("error"),
          );
        }
        model as ListModel<ProjectMainModel>;
        if (model.data.isNotEmpty) {
          return InkWell(
            onTap: () {
              Map<String, String> pathParameters = {
                'postId': model.data.first.postId.toString()
              };
              context.pushNamed(PostDetailScreen.routeName,
                  pathParameters: pathParameters);
            },
            child: ProjectMainCard.fromModel(
                model: model.data.first, cardTitle: title),
          );
        } else {
          return Container();
          return Text('모집글이 없습니다.');
        }
      },
    );
  }

  String _getTitle(MainCareType type) {
    final String title;
    switch (type) {
      case MainCareType.DEADLINE:
        title = '마감 임박 프로젝트';
        break;
      case MainCareType.MOSTLIKE:
        title = '실시간 인기 프로젝트';
        break;
      case MainCareType.UPTODATE:
        title = '최근 올라온 프로젝트';
        break;
    }
    return title;
  }

  BaseModel _getModel(MainCareType type, WidgetRef ref) {
    late final BaseModel model;
    switch (type) {
      case MainCareType.DEADLINE:
        model = ref.watch(projectCloseDeadLineProvider);
        break;
      case MainCareType.MOSTLIKE:
        model = ref.watch(projectMostLikedProvider);
        break;
      case MainCareType.UPTODATE:
        model = ref.watch(projectUpToDateProvider);
        break;
    }
    return model;
  }
}

class _HomeFooter extends StatelessWidget {
  const _HomeFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'assets/images/logo.png',
          width: 100.w,
          height: 30.h,
          fit: BoxFit.fitWidth,
        ),
        SizedBox(
          height: 8.h,
        ),
        Text('플케어 : PLL CARE, Project Manager',
            style: Theme.of(context).textTheme.labelMedium!.copyWith(color: GREY_500)),
        SizedBox(
          height: 3.h,
        ),
        Text(
          'Copyright 2023. Team Pll-Care. All rights reserved',
          style: Theme.of(context).textTheme.labelMedium!.copyWith(color: GREY_500),
        ),
      ],
    );
  }
}

class PermissionHandlerWidget extends StatefulWidget {
  /// Create a page containing the functionality of this plugin

  @override
  _PermissionHandlerWidgetState createState() =>
      _PermissionHandlerWidgetState();
}

class _PermissionHandlerWidgetState extends State<PermissionHandlerWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
          children: Permission.values
              .where((permission) {
                return permission != Permission.unknown &&
                    permission != Permission.mediaLibrary &&
                    permission != Permission.photosAddOnly &&
                    permission != Permission.reminders &&
                    permission != Permission.bluetooth &&
                    permission != Permission.appTrackingTransparency &&
                    permission != Permission.criticalAlerts;
              })
              .map((permission) => PermissionWidget(permission))
              .toList()),
    );
  }
}

/// Permission widget containing information about the passed [Permission]
class PermissionWidget extends StatefulWidget {
  /// Constructs a [PermissionWidget] for the supplied [Permission]
  const PermissionWidget(this._permission);

  final Permission _permission;

  @override
  _PermissionState createState() => _PermissionState(_permission);
}

class _PermissionState extends State<PermissionWidget> {
  _PermissionState(this._permission);

  final Permission _permission;
  PermissionStatus _permissionStatus = PermissionStatus.denied;

  @override
  void initState() {
    super.initState();

    _listenForPermissionStatus();
  }

  void _listenForPermissionStatus() async {
    final status = await _permission.status;
    setState(() => _permissionStatus = status);
  }

  Color getPermissionColor() {
    switch (_permissionStatus) {
      case PermissionStatus.denied:
        return Colors.red;
      case PermissionStatus.granted:
        return Colors.green;
      case PermissionStatus.limited:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        _permission.toString(),
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      subtitle: Text(
        _permissionStatus.toString(),
        style: TextStyle(color: getPermissionColor()),
      ),
      trailing: (_permission is PermissionWithService)
          ? IconButton(
              icon: const Icon(
                Icons.info,
                color: Colors.white,
              ),
              onPressed: () {
                checkServiceStatus(
                    context, _permission as PermissionWithService);
              })
          : null,
      onTap: () {
        requestPermission(_permission);
      },
    );
  }

  void checkServiceStatus(
      BuildContext context, PermissionWithService permission) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text((await permission.serviceStatus).toString()),
    ));
  }

  Future<void> requestPermission(Permission permission) async {
    final status = await permission.request();

    setState(() {
      print(status);
      _permissionStatus = status;
      print(_permissionStatus);
    });
  }
}
