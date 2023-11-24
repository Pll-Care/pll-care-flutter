import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../common/logger/custom_logger.dart';
import '../../common/model/default_model.dart';
import '../model/image_model.dart';
import '../repository/image_repository.dart';

final imageProvider =
    StateNotifierProvider<ImageStateNotifier, BaseModel>((ref) {
  final repository = ref.watch(imageRepositoryProvider);
  return ImageStateNotifier(repository: repository);
});

class ImageStateNotifier extends StateNotifier<BaseModel> {
  final ImageRepository repository;

  ImageStateNotifier({required this.repository}) : super(LoadingModel());

  Future<void> uploadImage() async {
    final ImagePicker _picker = ImagePicker();
    XFile? selectImage = await _picker.pickImage(

      //이미지를 선택
      source: ImageSource.gallery, //위치는 갤러리
      maxHeight: 600,
      maxWidth: 600,
      imageQuality: 100, // 이미지 크기 압축을 위해 퀄리티를 30으로 낮춤.
    );

    if (selectImage != null) {
      final image = File(selectImage.path);
     await repository.uploadImage(image: image, dir: 'project').then((value) {
        logger.i(value);
        state = value;
      }).catchError((e) {
        logger.e(e);
        state = ErrorModel.respToError(e);
      });
    }
  }

  Future<void> deleteImage() async {
    if(state is ImageModel){
      final iState = state as ImageModel;
      repository.deleteImage(url: iState.imageUrl).then((value) {
        logger.i('image delete!!');
        state = LoadingModel();
      }).catchError((e) {
        logger.e(e);
        state = ErrorModel.respToError(e);
      });
    }

  }
}
