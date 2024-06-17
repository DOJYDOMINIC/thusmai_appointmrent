import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:thusmai_appointmrent/models/bankdetails.dart';
import 'package:thusmai_appointmrent/pages/profile/edit/profile_edit.dart';
import '../../../constant/constant.dart';
import '../../../controller/connectivitycontroller.dart';
import '../../../controller/login_register_otp_api.dart';
import '../../../controller/profileController.dart';
import '../../../widgets/custombutton.dart';
import '../../../widgets/customtextfield.dart';

class PersonalInfo extends StatefulWidget {
  const PersonalInfo({Key? key}) : super(key: key);

  @override
  State<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  final ImagePicker _picker = ImagePicker();
  File? _image;

  Future<void> _showImageSourceBottomSheet() async {
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera),
              title: Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                _pickImageFromCamera();
              },
            ),
            ListTile(
              leading: Icon(Icons.image),
              title: Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImageFromGallery();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImageFromGallery() async {
    final pickedFile =
    await _picker.pickImage(source: ImageSource.gallery, imageQuality: 15);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      Provider.of<ProfileController>(context, listen: false).uploadData(_image, context);
      setState(() {});
    }
  }

  Future<void> _pickImageFromCamera() async {
    final pickedFile =
    await _picker.pickImage(source: ImageSource.camera, imageQuality: 15);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      Provider.of<ProfileController>(context, listen: false).uploadData(_image, context);
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    // No need to assign anything to status as it is a getter.
    Provider.of<ConnectivityProvider>(context, listen: false).status;
  }

  @override
  void dispose() {
    // Any necessary cleanup can go here. If you have any controllers, dispose them.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var userdata = Provider.of<AppLogin>(context).userData;
    var connect = Provider.of<ConnectivityProvider>(context);

    var sizeHeight = SizedBox(height: 24);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: shadeOne,
            )),
        backgroundColor: darkShade,
        title: Text(
          "Personal details",
          style: TextStyle(color: shadeOne),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 100,
            child: Padding(
              padding: EdgeInsets.fromLTRB(8, 8, 8, 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 60.sp,
                              backgroundColor: goldShade,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 57.sp,
                                child: connect.status == ConnectivityStatus.Offline
                                    ? Container()
                                    : Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: _image?.path != null
                                          ? FileImage(File(_image!.path))
                                          : userdata?.profilePicUrl != null &&
                                          userdata!.profilePicUrl!.isNotEmpty
                                          ? NetworkImage(userdata.profilePicUrl!)
                                          : NetworkImage(imgFromFirebase) as ImageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: -8,
                              right: -12,
                              child: IconButton(
                                onPressed: () {
                                  _showImageSourceBottomSheet();
                                },
                                icon: Icon(Icons.camera_alt),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 0, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${userdata?.firstName} ${userdata?.lastName}"),
                              Text("${userdata?.phone}"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 10,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Email", style: TextStyle(fontSize: 16.sp)),
                            sizeHeight,
                            Text("Date of birth", style: TextStyle(fontSize: 16.sp)),
                            sizeHeight,
                            Text("Emergency no.", style: TextStyle(fontSize: 16.sp)),
                            sizeHeight,
                            Text("PIN code", style: TextStyle(fontSize: 16.sp)),
                            sizeHeight,
                            Text("State", style: TextStyle(fontSize: 16.sp)),
                            sizeHeight,
                            Text("District", style: TextStyle(fontSize: 16.sp)),
                            sizeHeight,
                            Text("Address", style: TextStyle(fontSize: 16.sp)),
                            sizeHeight,
                            Text("Country", style: TextStyle(fontSize: 16.sp)),
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 15,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(":  ${userdata?.email}", style: TextStyle(fontSize: 16.sp), overflow: TextOverflow.ellipsis),
                            sizeHeight,
                            Text(":  ${userdata?.dob?.replaceAll('-', '/')}", style: TextStyle(fontSize: 16.sp), overflow: TextOverflow.ellipsis),
                            sizeHeight,
                            Text(":  ${userdata?.phone}", style: TextStyle(fontSize: 16.sp), overflow: TextOverflow.ellipsis),
                            sizeHeight,
                            Text(":  ${userdata?.pincode}", style: TextStyle(fontSize: 16.sp), overflow: TextOverflow.ellipsis),
                            sizeHeight,
                            Text(":  ${userdata?.state}", style: TextStyle(fontSize: 16.sp), overflow: TextOverflow.ellipsis),
                            sizeHeight,
                            Text(":  ${userdata?.district}", style: TextStyle(fontSize: 16.sp), overflow: TextOverflow.ellipsis),
                            sizeHeight,
                            Text(":  ${userdata?.address}", style: TextStyle(fontSize: 16.sp), overflow: TextOverflow.ellipsis) ,
                            sizeHeight,
                            Text(":  ${userdata?.country}", style: TextStyle(fontSize: 16.sp), overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 100),
                  CustomButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileDetailsEdit(),
                        ),
                      );
                    },
                    buttonColor: goldShade,
                    buttonText: "Edit",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class VerhoeffAlgorithm {
  static final List<List<int>> d = [
    [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
    [1, 2, 3, 4, 0, 6, 7, 8, 9, 5],
    [2, 3, 4, 0, 1, 7, 8, 9, 5, 6],
    [3, 4, 0, 1, 2, 8, 9, 5, 6, 7],
    [4, 0, 1, 2, 3, 9, 5, 6, 7, 8],
    [5, 9, 8, 7, 6, 0, 4, 3, 2, 1],
    [6, 5, 9, 8, 7, 1, 0, 4, 3, 2],
    [7, 6, 5, 9, 8, 2, 1, 0, 4, 3],
    [8, 7, 6, 5, 9, 3, 2, 1, 0, 4],
    [9, 8, 7, 6, 5, 4, 3, 2, 1, 0]
  ];

  static final List<List<int>> p = [
    [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
    [1, 5, 7, 6, 2, 8, 3, 0, 9, 4],
    [5, 8, 0, 3, 7, 9, 6, 1, 4, 2],
    [8, 9, 1, 6, 0, 4, 3, 5, 2, 7],
    [9, 4, 5, 3, 1, 2, 6, 8, 7, 0],
    [4, 2, 8, 6, 5, 7, 3, 9, 0, 1],
    [2, 7, 9, 3, 8, 0, 6, 4, 1, 5],
    [7, 0, 4, 6, 9, 1, 3, 2, 5, 8]
  ];

  static final List<int> inv = [0, 4, 3, 2, 1, 5, 6, 7, 8, 9];

  static bool validateVerhoeff(String num) {
    int c = 0;
    List<int> myArray = stringToReversedIntArray(num);
    for (int i = 0; i < myArray.length; i++) {
      c = d[c][p[i % 8][myArray[i]]];
    }
    return (c == 0);
  }

  static List<int> stringToReversedIntArray(String num) {
    List<int> myArray = List<int>.generate(num.length, (i) => int.parse(num[i]));
    return myArray.reversed.toList();
  }
}
