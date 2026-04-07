import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide MultipartFile, FormData;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:social_book/app/components/snack_bar_view.dart';
import 'package:social_book/app/data/baseclient/base_client.dart';
import 'package:social_book/app/data/endpoint/end_pont.dart';
import 'package:social_book/app/routes/app_pages.dart';
import 'package:social_book/app/services/storage/local_storage_service.dart';

class ProfileRegistrationController extends GetxController {
  // Form Key
  final formKey = GlobalKey<FormState>();

  // Text Controllers
  final displayNameController = TextEditingController();
  final bioController = TextEditingController();
  final placeOfBirthController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final countryController = TextEditingController();
  final pincodeController = TextEditingController();
  final educationController = TextEditingController();
  final professionController = TextEditingController();
  final companyController = TextEditingController();
  final websiteController = TextEditingController();
  final languageController = TextEditingController();

  // Reactive Variables
  final Rx<File?> profilePicture = Rx<File?>(null);
  final Rx<File?> coverImage = Rx<File?>(null);
  final Rx<File?> verificationDocument = Rx<File?>(null);

  final Rx<DateTime?> dateOfBirth = Rx<DateTime?>(null);
  final Rx<TimeOfDay?> timeOfBirth = Rx<TimeOfDay?>(null);
  final RxString selectedGender = ''.obs;
  final RxString selectedProfileType = ''.obs;

  RxString? profileType = "".obs;

  final RxBool isLoading = false.obs;

  // Image Picker
  final ImagePicker _picker = ImagePicker();

  // Gender Options
  final List<String> genderOptions = ['Male', 'Female', 'Other'];
  final List<String> profileTypeOptions = [
    'Social',
    'Professional',
    'Hidden',
    "Matrimonial",
  ];

  @override
  void onInit() {
    profileType?.value = Get.arguments["profileType"];
    debugPrint("Profile Type ${profileType?.value ?? ""}");
    super.onInit();
  }

  @override
  void onClose() {
    displayNameController.dispose();
    bioController.dispose();
    placeOfBirthController.dispose();
    cityController.dispose();
    stateController.dispose();
    countryController.dispose();
    pincodeController.dispose();
    educationController.dispose();
    professionController.dispose();
    companyController.dispose();
    websiteController.dispose();
    languageController.dispose();
    super.onClose();
  }

  // Pick Image
  Future<void> pickImage(
    ImageSourceType sourceType,
    ImageType imageType,
  ) async {
    try {
      final ImageSource source =
          sourceType == ImageSourceType.camera
              ? ImageSource.camera
              : ImageSource.gallery;

      final XFile? pickedFile = await _picker.pickImage(source: source);

      if (pickedFile != null) {
        final File imageFile = File(pickedFile.path);

        switch (imageType) {
          case ImageType.profile:
            profilePicture.value = imageFile;
            break;
          case ImageType.cover:
            coverImage.value = imageFile;
            break;
          case ImageType.verification:
            verificationDocument.value = imageFile;
            break;
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Date Picker
  Future<void> selectDateOfBirth(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dateOfBirth.value ?? DateTime(1990),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      dateOfBirth.value = picked;
    }
  }

  // Time Picker
  Future<void> selectTimeOfBirth(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: timeOfBirth.value ?? TimeOfDay.now(),
    );
    if (picked != null) {
      timeOfBirth.value = picked;
    }
  }

  // Validation
  bool validateForm() {
    if (!formKey.currentState!.validate()) {
      return false;
    }

    if (selectedGender.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select gender',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (dateOfBirth.value == null) {
      Get.snackbar(
        'Error',
        'Please select date of birth',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    return true;
  }

  // Submit Profile
  Future<void> submitProfile() async {
    if (!validateForm()) return;

    if (profileType?.value == "Hidden" && verificationDocument.value == null) {
      SnackBarUiView.showSuccess(message: 'Please upload document');
      return;
    }

    try {
      isLoading.value = true;
      final userId = LocalStorageService.getUserId();
      // Prepare FormData
      final dataMap = {
        'UserID': userId,
        'ProfileType': profileType?.value,
        'DisplayName': displayNameController.text,
        'Bio': bioController.text,
        'DateOfBirth': dateOfBirth.value!.toIso8601String().split('T')[0],
        'TimeOfBirth':
            '${timeOfBirth.value?.hour.toString().padLeft(2, '0')}:${timeOfBirth.value?.minute.toString().padLeft(2, '0')}:00',
        'PlaceOfBirth': placeOfBirthController.text,
        'Gender': selectedGender.value,
        'PrivacyLevel': 'Public',
        'Language': languageController.text,
      };

      final formData = FormData.fromMap(dataMap);
      // Add files if selected
      if (profilePicture.value != null) {
        formData.files.add(
          MapEntry(
            'ProfilePicture',
            await MultipartFile.fromFile(profilePicture.value!.path),
          ),
        );
      }

      if (coverImage.value != null) {
        formData.files.add(
          MapEntry(
            'CoverImage',
            await MultipartFile.fromFile(coverImage.value!.path),
          ),
        );
      }

      if (verificationDocument.value != null) {
        formData.files.add(
          MapEntry(
            'VerificationDocument',
            await MultipartFile.fromFile(verificationDocument.value!.path),
          ),
        );
      }

      final response = await BaseClient.postMultipart(
        api: EndPoint.profileRegister,
        formData: formData,
      );

      if (response != null && response.statusCode == 201) {
        SnackBarUiView.showSuccess(message: 'Profile registered successfully');

        final res = response.data;
        final data = res["data"];
        final profileId = data["ProfileID"];
        await LocalStorageService.setProfileId(profileId);
        Get.offAllNamed(Routes.NAV);
      }
    } catch (e) {
      SnackBarUiView.showSuccess(message: 'Failed to register profile: $e');
      log("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}

// Enums
enum ImageSourceType { camera, gallery }

enum ImageType { profile, cover, verification }
