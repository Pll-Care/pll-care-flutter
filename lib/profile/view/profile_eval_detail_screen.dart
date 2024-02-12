import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pllcare/profile/model/profile_eval_model.dart';
import 'package:pllcare/profile/provider/profile_provider.dart';
import 'package:pllcare/theme.dart';

import '../../evaluation/model/midterm_model.dart';

class ProfileEvalDetailScreen extends ConsumerWidget {
  static String get routeName => 'profileEvalDetail';
  final int projectId;
  final int memberId;
  final String projectName;

  const ProfileEvalDetailScreen({
    super.key,
    required this.memberId,
    required this.projectId,
    required this.projectName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
            headerSliverBuilder: (_, __) {
              return [
                SliverAppBar(
                  backgroundColor: GREEN_200,
                )
              ];
            },
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: CustomScrollView(
                slivers: [
                  _EvalBadgeComponent(
                    memberId: memberId,
                    projectId: projectId,
                    projectName: projectName,
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(height: 27.h),
                  ),
                  _FinalComponent(
                    projectId: projectId,
                    memberId: memberId,
                  ),
                ],
              ),
            )),
      ),
    );
  }
}

class _EvalBadgeComponent extends StatelessWidget {
  final int memberId;
  final int projectId;
  final String projectName;

  const _EvalBadgeComponent(
      {super.key,
      required this.memberId,
      required this.projectId,
      required this.projectName});

  Widget getBadgeIcon({required String badge, required int quantity}) {
    final IconData icon;
    switch (badge) {
      case '최고의 서포터':
        icon = Icons.handshake;
        break;
      case '탁월한 리더':
        icon = Icons.people;
        break;
      case '열정적인 참여자':
        icon = Icons.local_fire_department;
        break;
      default:
        icon = Icons.lightbulb;
        break;
    }

    return Row(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Container(
            width: 30.w,
            height: 30.h,
            decoration: BoxDecoration(
                shape: BoxShape.circle, border: Border.all(color: GREEN_200)),
            child: Icon(
              icon,
              size: 20,
            ),
          ),
        ),
        Text(
          quantity.toString(),
          style: m_Body_01.copyWith(color: GREY_500),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (_, ref, __) {
      return ref
          .watch(profileEvalProvider(memberId: memberId, projectId: projectId))
          .when(
              data: (data) {
                final badge = data.badges;
                return SliverMainAxisGroup(slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(top: 40.h, bottom: 20.h),
                      child: Text(
                        '$projectName 평가',
                        style: Heading_06.copyWith(
                            color: GREEN_500, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.r),
                          border: Border.all(
                            color: GREEN_200,
                            width: 2.w,
                          ),
                          color: GREY_100,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFB5B5B5).withOpacity(.2),
                              blurRadius: 30.r,
                              spreadRadius: 5.r,
                              offset: Offset(0, 10.h),
                            )
                          ]),
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 15.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '중간평가 뱃지',
                            style: m_Heading_01.copyWith(color: GREEN_400),
                          ),
                          Row(
                            children: [
                              getBadgeIcon(
                                  badge: badge.leader,
                                  quantity: badge.quantity2),
                              getBadgeIcon(
                                  badge: badge.participant,
                                  quantity: badge.quantity3),
                              getBadgeIcon(
                                  badge: badge.support,
                                  quantity: badge.quantity1),
                              getBadgeIcon(
                                  badge: badge.bank, quantity: badge.quantity4),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ]);
              },
              error: (_, __) {
                return const SliverToBoxAdapter(
                  child: Text('error'),
                );
              },
              loading: () => const SliverToBoxAdapter(
                    child: CircularProgressIndicator(),
                  ));
    });
  }
}

class _FinalComponent extends StatelessWidget {
  final int projectId;
  final int memberId;

  const _FinalComponent(
      {super.key, required this.projectId, required this.memberId});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.r),
            border: Border.all(
              color: GREEN_200,
              width: 2.w,
            ),
            color: GREY_100,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFB5B5B5).withOpacity(.2),
                blurRadius: 30.r,
                spreadRadius: 5.r,
                offset: Offset(0, 10.h),
              )
            ]),
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '최종평가',
              style: m_Heading_01.copyWith(color: GREEN_400),
            ),
            SizedBox(height: 16.h),
            Consumer(builder: (_, ref, __) {
              return ref
                  .watch(profileEvalProvider(
                      projectId: projectId, memberId: memberId))
                  .when(
                      data: (data) {
                        return ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (_, idx) {
                            final model = data.finalEvals[idx];

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 15.r,
                                      backgroundImage: model.imageUrl.isNotEmpty
                                          ? NetworkImage(model.imageUrl)
                                          : const AssetImage(
                                                  'assets/main/main1.png')
                                              as ImageProvider,
                                    ),
                                    SizedBox(width: 14.w),
                                    Text(
                                      model.name,
                                      style: m_Heading_01.copyWith(
                                          color: GREY_500),
                                    )
                                  ],
                                ),
                                SizedBox(height: 10.h),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.w),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                          boxShadow: [
                                            BoxShadow(
                                              offset: Offset(0, 10.h),
                                              blurRadius: 30.r,
                                              spreadRadius: 5.r,
                                              color: const Color(0xFFB5B5B5)
                                                  .withOpacity(.2),
                                            )
                                          ],
                                          color: GREY_100,
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 20.w,
                                          vertical: 12.h,
                                        ),
                                        child: Column(
                                          children: [
                                            _getFinalEval(
                                                '성실도', model.score.sincerity),
                                            SizedBox(height: 10.h),
                                            _getFinalEval('업무 수행 능력',
                                                model.score.jobPerformance),
                                            SizedBox(height: 10.h),
                                            _getFinalEval('시간 엄수',
                                                model.score.punctuality),
                                            SizedBox(height: 10.h),
                                            _getFinalEval('의사 소통',
                                                model.score.communication),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 16.h),
                                      Text(
                                        model.content,
                                        style: m_Body_01.copyWith(
                                          color: GREY_500,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                          separatorBuilder: (_, idx) => SizedBox(height: 20.h),
                          itemCount: data.finalEvals.length,
                        );
                      },
                      error: (_, __) {
                        return const Text('error');
                      },
                      loading: () => const CircularProgressIndicator());
            }),
          ],
        ),
      ),
    );
  }

  Row _getFinalEval(String title, num score) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: m_Body_01.copyWith(color: GREY_500),
        ),
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: GREEN_200, width: 2.w),
          ),
          padding: EdgeInsets.all(8.r),
          child: Text(
            score.toInt().toString(),
            style: m_Body_01.copyWith(
                color: GREEN_200, fontWeight: FontWeight.w700),
          ),
        )
      ],
    );
  }
}
