import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../theme.dart';
import '../../model/default_model.dart';

typedef OnTapPage = void Function(int page);

class BottomPageCount<T> extends ConsumerWidget {
  final PaginationModel<T> pModelList;
  final OnTapPage onTapPage;

  const BottomPageCount({
    super.key,
    required this.pModelList,
    required this.onTapPage,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // log('pModelList.pageNumber = ${pModelList.pageNumber}');
    // log('pModelList.totalPages = ${pModelList.totalPages}');
    // log('pModelList.numberOfElements = ${pModelList.numberOfElements}');
    final startPage = (pModelList.pageNumber! ~/ 5) * 5 + 1;
    final bool isLastPage =
        ((pModelList.pageNumber! ~/ 5) + 1) * 5 > pModelList.totalPages!;
    final lastPage = isLastPage // 마지막 페이지면 totalPage 아니면 시작페이지 + 5
        ? pModelList.totalPages!
        : ((pModelList.pageNumber! ~/ 5) + 1) * 5;
    //
    // log("startPage ${startPage}");
    // log("lastDividePage ${((pModelList.pageNumber! ~/ 5) + 1) * 5}");

    return SliverPadding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      sliver: SliverToBoxAdapter(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = startPage; i < lastPage + 1; i++)
              GestureDetector(
                onTap: () {
                  onTapPage(i);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    (i).toString(),
                    style: m_Heading_02.copyWith(
                        color: (pModelList.pageNumber!) == (i)
                            ? GREEN_200
                            : GREY_500),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
