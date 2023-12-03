import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../common/model/default_model.dart';
import '../image/model/image_model.dart';
import '../image/provider/image_provider.dart';
import '../project/component/project_body.dart';
import '../project/component/project_form.dart';
import '../project/param/param.dart';
import '../project/param/project_create_param.dart';
import '../project/provider/project_provider.dart';
import '../schedule/provider/date_range_provider.dart';

class CustomFormBottomSheet {
  static final formKey = GlobalKey<FormState>();
  static late String? title;
  static late String? description;
  static late String? startDate;
  static late String? endDate;

  static showCustomFormBottomSheet(
      {required BuildContext context,
      required WidgetRef ref,
      required bool isCreate,
      int? projectId}) {
    showModalBottomSheet(
        isScrollControlled: true,
        showDragHandle: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(32.r))),
        context: context,
        builder: (context) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: SingleChildScrollView(
              child: Form(
                autovalidateMode: AutovalidateMode.always,
                key: CustomFormBottomSheet.formKey,
                child: Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: ProjectForm(
                      onSavedTitle: onSavedTitle,
                      onSavedDesc: onSavedDesc,
                      onSaved: () async {
                        await _saveProject(ref, context, isCreate, projectId);
                      },
                      pickImage: pickImage,
                      deleteImage: deleteImage,
                      projectId: projectId,
                    )),
              ),
            ),
          );
        });
  }

  static void onSavedTitle(String? newValue) {
    if (formKey.currentState!.validate()) {
      title = newValue;
    }
  }

  static void onSavedDesc(String? newValue) {
    if (formKey.currentState!.validate()) {
      description = newValue;
    }
  }

  static Future<void> pickImage(WidgetRef ref) async {
    await ref.read(imageProvider.notifier).uploadImage();
    final imageModel = ref.read(imageProvider);
    if (imageModel is ErrorModel) {
      // todo error handling
    } else if (imageModel is ImageModel) {
      ref
          .read(imageUrlProvider.notifier)
          .update((state) => imageModel.imageUrl);
    }
  }

  static Future<void> deleteImage(WidgetRef ref) async {
    await ref.read(imageProvider.notifier).deleteImage();
    ref.read(imageUrlProvider.notifier).update((state) => null);
  }

  static Future<void> _saveProject(WidgetRef ref, BuildContext context,
      bool isCreate, int? projectId) async {
    final dateFormat = DateFormat('yyyy-MM-dd');
    formKey.currentState!.save();
    ref.read(checkDateValidateProvider.notifier).state = true;
    if (formKey.currentState!.validate() &&
        ref.read(dateRangeProvider.notifier).isValidate() &&
        ref.read(dateRangeProvider.notifier).isSaveValidate()) {
      final startDate =
          dateFormat.format(ref.read(dateRangeProvider).startDate!);
      final endDate = dateFormat.format(ref.read(dateRangeProvider).endDate!);
      final model = ref.read(imageProvider);
      if (model is ImageModel) {
        ref.read(imageUrlProvider.notifier).update((state) => model.imageUrl);
      }
      final param = CreateProjectFormParam(
          title: title!,
          description: description!,
          startDate: startDate,
          endDate: endDate,
          imageUrl: ref.read(imageUrlProvider) ?? '');
      log("title $title");
      log("description $description");

      isCreate
          ? await ref
              .read(projectFamilyProvider(const ProjectProviderParam(
                type: ProjectProviderType.create,
              )).notifier)
              .createProject(param: param)
          : await ref
              .read(projectFamilyProvider(ProjectProviderParam(
                      type: ProjectProviderType.update, projectId: projectId))
                  .notifier)
              .updateProject(
                param: UpdateProjectFormParam(
                    title: title!,
                    description: description!,
                    startDate: startDate,
                    endDate: endDate,
                    imageUrl: ref.read(imageUrlProvider) ?? ''),
              );
      final state = isCreate
          ? ref.read(projectFamilyProvider(const ProjectProviderParam(
              type: ProjectProviderType.create,
            )))
          : ref.read(projectFamilyProvider(ProjectProviderParam(
              type: ProjectProviderType.update, projectId: projectId)));
      if (state is ErrorModel) {
        log('프로젝트를 생성하지 못했습니다.');
      } else {
        await _onRefresh(ref);
        if (context.mounted) {
          context.pop();
        }
      }
    }
  }

  static Future<void> _onRefresh(WidgetRef ref) async {
    ref.read(projectListProvider.notifier).getList(
        params: ProjectParams(
            page: 1,
            size: 5,
            direction: 'DESC',
            state: [StateType.COMPLETE, StateType.ONGOING]));
    ref.read(isSelectAllProvider.notifier).update((state) => true);
  }
}
