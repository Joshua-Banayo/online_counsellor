import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:online_counsellor/core/components/widgets/custom_button.dart';

import '../../../core/components/constants/strings.dart';
import '../../../core/components/widgets/custom_drop_down.dart';
import '../../../core/components/widgets/custom_input.dart';
import '../../../state/data_state.dart';

class ProfileEditPage extends ConsumerStatefulWidget {
  const ProfileEditPage({super.key});

  @override
  ConsumerState<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends ConsumerState<ProfileEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  final _aboutController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  String? region;
  File? imageFile;
  String? userProfile;
  @override
  void initState() {
    //check if widget is build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var user = ref.read(userProvider);
      _nameController.text = user.name ?? '';
      _dobController.text = user.dob ?? '';
      _aboutController.text = user.about ?? '';
      _phoneController.text = user.phone ?? '';
      _addressController.text = user.address ?? '';
      _cityController.text = user.city ?? '';
      region = user.region ?? '';
      setState(() {
        region = user.region ?? '';
        userProfile = user.profile ?? '';
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(children: [
            //edit profile image,name,phone number, and bio only
            const SizedBox(height: 20),
            //circle avatar image
            Row(
              children: [
                InkWell(
                  onTap: () => _pickImage(),
                  child: Container(
                    width: 150,
                    height: 150,
                    alignment: Alignment.bottomCenter,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[300],
                        image: userProfile != null && imageFile == null
                            ? DecorationImage(
                                image: NetworkImage(userProfile!),
                                fit: BoxFit.cover,
                              )
                            : imageFile != null
                                ? DecorationImage(
                                    image: FileImage(imageFile!),
                                    fit: BoxFit.cover,
                                  )
                                : null),
                    child: const Text('Profile Image'),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                const Expanded(
                  child: SizedBox(
                    height: 150,
                    child: Text(
                      'Choose a clear and high-quality photo: Your profile picture should be sharp, well-lit, and visually appealing.',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextFields(
              hintText: 'Full Name',
              prefixIcon: MdiIcons.account,
              controller: _nameController,
              onSaved: (name) {
                ref.read(userProvider.notifier).setUserName(name!);
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a valid name';
                }
                return null;
              },
            ),
            if (ref.watch(userTypeProvider) != 'Counsellor')
              const SizedBox(
                height: 20,
              ),
            if (ref.watch(userTypeProvider) != 'Counsellor')
              CustomTextFields(
                hintText: 'Date of Birth',
                prefixIcon: MdiIcons.calendar,
                controller: _dobController,
                isReadOnly: true,
                suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.calendar_today,
                      size: 18,
                    ),
                    onPressed: () => showDatePicker(
                                context: context,
                                initialDate: DateTime.now()
                                    .subtract(const Duration(days: 365 * 18)),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now()
                                    .subtract(const Duration(days: 365 * 18)))
                            .then((value) {
                          if (value != null) {
                            _dobController.text =
                                DateFormat('dd-MM-yyyy').format(value);
                          }
                        })),
                onSaved: (dob) {
                  ref.read(userProvider.notifier).setDOB(dob!);
                },
                validator: (value) {
                  if (ref.watch(userTypeProvider) != 'Counsellor' &&
                      value!.isEmpty) {
                    return 'Please enter a valid date of birth';
                  }
                  return null;
                },
              ),
            if (ref.watch(userTypeProvider) != 'Counsellor')
              const SizedBox(
                height: 20,
              ),
            CustomTextFields(
              hintText: 'Phone Number',
              prefixIcon: MdiIcons.phone,
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              onSaved: (phone) {
                ref.read(userProvider.notifier).setUserPhone(phone!);
              },
              validator: (value) {
                if (value!.length != 10) {
                  return 'Please enter a valid phone number';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextFields(
              hintText: 'Address',
              prefixIcon: MdiIcons.home,
              controller: _addressController,
              onSaved: (address) {
                ref.read(userProvider.notifier).setUserAddress(address!);
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a valid address';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            CustomDropDown(
                value: region,
                onChanged: (region) {
                  ref.read(userProvider.notifier).setUserRegion(region!);
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a region';
                  }
                  return null;
                },
                icon: MdiIcons.earth,
                items: regionList
                    .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(
                          e,
                        )))
                    .toList(),
                hintText: 'Region'),
            const SizedBox(
              height: 20,
            ),
            CustomTextFields(
              hintText: 'City',
              prefixIcon: MdiIcons.city,
              controller: _cityController,
              onSaved: (city) {
                ref.read(userProvider.notifier).setUserCity(city!);
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a valid city';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextFields(
              hintText: 'About you',
              controller: _aboutController,
              prefixIcon: MdiIcons.account,
              maxLines: 4,
              keyboardType: TextInputType.text,
              onSaved: (value) {
                ref.read(userProvider.notifier).setAbout(value!);
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomButton(
                  text: 'Update Profile',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      ref.read(userProvider.notifier).updateUser(
                            ref,
                            imageFile: imageFile,
                            name: _nameController.text,
                            dob: _dobController.text,
                            phone: _phoneController.text,
                            address: _addressController.text,
                            city: _cityController.text,
                            region: region!,
                            about: _aboutController.text,
                          );
                    }
                  }),
            ),
            const SizedBox(
              height: 20,
            ),
          ]),
        ),
      ),
    );
  }

  _pickImage() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: 150,
        child: Column(
          children: [
            ListTile(
              leading: Icon(MdiIcons.camera),
              title: const Text('Camera'),
              onTap: () async {
                Navigator.pop(context);
                final pickedFile = await ImagePicker().pickImage(
                  source: ImageSource.camera,
                  imageQuality: 50,
                );
                if (pickedFile != null) {
                  ref.read(userImageProvider.notifier).state =
                      File(pickedFile.path);
                }
              },
            ),
            ListTile(
              leading: Icon(MdiIcons.image),
              title: const Text('Gallery'),
              onTap: () async {
                Navigator.pop(context);
                final pickedFile = await ImagePicker().pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 50,
                );
                if (pickedFile != null) {
                  ref.read(userImageProvider.notifier).state =
                      File(pickedFile.path);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
