
import 'package:dio/dio.dart' show FormData, MultipartFile;
import 'package:flutter/material.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_book/app/components/comman_image_picker.dart';
import 'package:social_book/app/components/snack_bar_view.dart'
    show SnackBarUiView;
import 'package:social_book/app/core/config/theme/app_colors.dart';
import 'package:social_book/app/core/utils/logger_utils.dart';
import 'package:social_book/app/data/baseclient/base_client.dart';
import 'package:social_book/app/data/endpoint/end_pont.dart';
import 'package:social_book/app/data/models/profile/user_profile_model.dart';
import 'package:social_book/app/modules/profile/controllers/profile_controller.dart';
import 'package:social_book/app/services/storage/local_storage_service.dart';

enum ImageSourceType { camera, gallery }

class EditProfileController extends GetxController {
  Rxn<UserProfileData> userProfile = Rxn<UserProfileData>();

  // Text Controllers
  final displayNameController = TextEditingController();
  final bioController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  final timeOfBirthController = TextEditingController();
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
  final hometownController = TextEditingController();
  final livingInController = TextEditingController();
  final motherTongueController = TextEditingController();
  final skillsController = TextEditingController();
  final workAtController = TextEditingController();
  final workLocationController = TextEditingController();

  // Observables
  final selectedGender = 'Male'.obs;
  final selectedRelationshipStatus = 'Single'.obs;
  final selectedMaritalStatus = 'Unmarried'.obs;
  final selectedBloodGroup = 'O+'.obs;
  final experienceYears = 0.obs;
  final isLoading = false.obs;
  final isSaving = false.obs;

  // Image Files
  final Rx<XFile?> profileImage = Rx<XFile?>(null);
  final Rx<XFile?> coverImage = Rx<XFile?>(null);

  // Network Image URLs
  final profileImageUrl = ''.obs;
  final coverImageUrl = ''.obs;

  // Dropdown Options
  final genderOptions = ['Male', 'Female', 'Other', 'Prefer not to say'];
  final relationshipOptions = [
    'Single',
    'In a relationship',
    'Engaged',
    'Married',
    'It\'s complicated',
  ];
  final maritalOptions = ['Unmarried', 'Married', 'Divorced', 'Widowed'];
  final bloodGroupOptions = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

  // Form Key
  final formKey = GlobalKey<FormState>();

  // Image Picker

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
  }

  @override
  void onClose() {
    // Dispose all controllers
    displayNameController.dispose();
    bioController.dispose();
    dateOfBirthController.dispose();
    timeOfBirthController.dispose();
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
    hometownController.dispose();
    livingInController.dispose();
    motherTongueController.dispose();
    skillsController.dispose();
    workAtController.dispose();
    workLocationController.dispose();
    super.onClose();
  }

  Future<void> loadUserProfile() async {
    try {
      isLoading.value = true;

      // Get user profile data from Get.arguments
      final data = Get.arguments as UserProfileData?;

      if (data != null) {
        userProfile.value = data;
        _populateFieldsFromModel(data);
      } else {
        LoggerUtils.warning("No profile data received in arguments");
      }
    } catch (e) {
      LoggerUtils.error("Error loading profile: $e");
      Get.snackbar(
        'Error',
        'Failed to load profile data',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Populate all form fields from UserProfileData model
  void _populateFieldsFromModel(UserProfileData data) {
    // Basic Info
    displayNameController.text = data.displayName ?? '';
    bioController.text = data.bio ?? '';

    // Birth Details
    dateOfBirthController.text = data.dateOfBirth ?? '';
    timeOfBirthController.text = data.timeOfBirth ?? '';
    placeOfBirthController.text = data.placeOfBirth ?? '';

    // Location
    cityController.text = data.city ?? '';
    stateController.text = data.state ?? '';
    countryController.text = data.country ?? '';
    pincodeController.text = data.pincode ?? '';
    hometownController.text = data.hometown?.toString() ?? '';
    livingInController.text = data.livingIn?.toString() ?? '';

    // Education & Work
    educationController.text = data.education ?? '';
    professionController.text = data.profession ?? '';
    companyController.text = data.company ?? '';
    workAtController.text = data.workAt?.toString() ?? '';
    workLocationController.text = data.workLocation?.toString() ?? '';
    skillsController.text = data.skills?.toString() ?? '';

    // Other Info
    websiteController.text = data.website?.toString() ?? '';
    languageController.text = data.language ?? '';
    motherTongueController.text = data.motherTongue?.toString() ?? '';

    // Dropdowns - with validation to ensure value exists in options
    if (data.gender != null && genderOptions.contains(data.gender)) {
      selectedGender.value = data.gender!;
    }

    if (data.relationshipStatus != null) {
      String relationshipValue = data.relationshipStatus.toString();
      if (relationshipOptions.contains(relationshipValue)) {
        selectedRelationshipStatus.value = relationshipValue;
      }
    }

    if (data.maritalStatus != null) {
      String maritalValue = data.maritalStatus.toString();
      if (maritalOptions.contains(maritalValue)) {
        selectedMaritalStatus.value = maritalValue;
      }
    }

    if (data.bloodGroup != null) {
      String bloodGroupValue = data.bloodGroup.toString();
      if (bloodGroupOptions.contains(bloodGroupValue)) {
        selectedBloodGroup.value = bloodGroupValue;
      }
    }

    // Experience Years
    if (data.experienceYears != null) {
      try {
        int expYears = 0;
        if (data.experienceYears is int) {
          expYears = data.experienceYears as int;
        } else if (data.experienceYears is String) {
          expYears = int.parse(data.experienceYears.toString());
        } else {
          expYears = data.experienceYears as int;
        }
        // Clamp between 0 and 20 for slider
        experienceYears.value = expYears.clamp(0, 20);
      } catch (e) {
        LoggerUtils.error("Error parsing experienceYears: $e");
        experienceYears.value = 0;
      }
    }

    // Image URLs
    profileImageUrl.value = data.profilePictureUrl ?? '';
    coverImageUrl.value = data.coverImageUrl ?? '';

    LoggerUtils.warning("Profile fields populated successfully");
  }

  Future<void> selectDate(BuildContext context) async {
    DateTime initialDate = DateTime(1998, 5, 21);

    // Try to parse existing date if available
    if (dateOfBirthController.text.isNotEmpty) {
      try {
        initialDate = DateTime.parse(dateOfBirthController.text);
      } catch (e) {
        LoggerUtils.error("Error parsing date: $e");
      }
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      dateOfBirthController.text = picked.toString().split(' ')[0];
    }
  }

  Future<void> selectTime(BuildContext context) async {
    TimeOfDay initialTime = const TimeOfDay(hour: 14, minute: 30);

    // Try to parse existing time if available
    if (timeOfBirthController.text.isNotEmpty) {
      try {
        final parts = timeOfBirthController.text.split(':');
        if (parts.length >= 2) {
          initialTime = TimeOfDay(
            hour: int.parse(parts[0]),
            minute: int.parse(parts[1]),
          );
        }
      } catch (e) {
        LoggerUtils.error("Error parsing time: $e");
      }
    }

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      timeOfBirthController.text =
          "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}:00";
    }
  }

  final profileController = Get.find<ProfileController>();

  Future<void> updateProfile() async {
    try {
      isSaving.value = true;
      final profileId = LocalStorageService.getProfileId();
      final res = await BaseClient.post(
        api: "${EndPoint.editProfile}/$profileId",
        payloadObj: {
          "DisplayName": displayNameController.text,
          "Bio": bioController.text,
          "DateOfBirth": dateOfBirthController.text,
          "TimeOfBirth": timeOfBirthController.text,
          "PlaceOfBirth": placeOfBirthController.text,
          "Gender": selectedGender.value,
          "City": cityController.text,
          "State": stateController.text,
          "Country": countryController.text,
          "Pincode": pincodeController.text,
          "Education": educationController.text,
          "Profession": professionController.text,
          "Company": companyController.text,
          "Website": websiteController.text,
          "Language": languageController.text,
          "Hometown": hometownController.text,
          "LivingIn": livingInController.text,
          "RelationshipStatus": selectedRelationshipStatus.value,
          "MotherTongue": motherTongueController.text,
          "MaritalStatus": selectedMaritalStatus.value,
          "BloodGroup": selectedBloodGroup.value,
          "ExperienceYears": experienceYears.value,
          "WorkAt": workAtController.text,
          "WorkLocation": workLocationController.text,
          "Skills": skillsController.text,
        },
      );
      if (res != null && res.statusCode == 200) {
        SnackBarUiView.showSuccess(message: res.data["message"]);
        LoggerUtils.error("Failed Update Profile ${res.data}");
        await Future.delayed(Duration(milliseconds: 100));
        await profileController.fetchUserProfile();
      } else {
        LoggerUtils.error("Failed Update Profile ${res.data}");
      }
    } catch (e) {
      LoggerUtils.error("Error: $e");
      SnackBarUiView.showSuccess(message: "Something went Wrong");
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> imageUpload() async {
    final XFile? image = await SingleImagePickerDialog.show(
      Get.context!,
      IMGType.profilePicture,
    );

    if (image != null) {
      coverImage.value = image;
      await uploadImagePicture();
    }
  }

  Future<void> uploadImagePicture() async {
    try {
      final profileId =  LocalStorageService.getProfileId();
      final formData = FormData.fromMap({
        'ProfilePicture': await MultipartFile.fromFile(
          coverImage.value?.path ?? "",
          filename: coverImage.value!.path.split('/').last,
        ),
        'ProfileID': profileId,
      });
      final res = await BaseClient.post(
        api: EndPoint.editProfilePicture,
        formData: formData,
      );

      if (res != null && res.statusCode == 201) {
        SnackBarUiView.showSuccess(message: res.data["message"]);
          await Future.delayed(Duration(milliseconds: 100));
        await profileController.fetchUserProfile();
      } else {
        SnackBarUiView.showError(message: "Something went wrong");
      }
    } catch (e) {
      LoggerUtils.error("Error: $e");
    }
  }

}
