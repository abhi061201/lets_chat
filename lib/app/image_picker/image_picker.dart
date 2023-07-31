import 'dart:io';

import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class imagePickerController extends GetxController {
  RxString image_path = ''.obs;
  File ?Imagefile;

  Future<void> getImagefromGallery() async {
    final _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 10);

    if (image != null) {
      
      cropImage(image);
    }
  }

  Future<void> cropImage(XFile image) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: image.path,
      aspectRatio: CropAspectRatio(
        ratioX: 1,
        ratioY: 1,
      ),
      compressQuality: 90,
    );

    if (croppedImage != null) {
      Imagefile= File(croppedImage.path);
      image_path.value = croppedImage.path;
    }
  }

  Future<void> getImagefromCamera() async {
    final _picker = ImagePicker();
    final image = await _picker.pickImage(source: ImageSource.camera, imageQuality: 10);
    if (image != null) {
      cropImage(image);
    }
  }

  Future reset() async {
    image_path.value = '';
  }
}
