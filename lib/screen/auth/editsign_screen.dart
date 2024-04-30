import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:typed_data';
import 'package:team_project/exceptions/custom_exception.dart';
import 'package:team_project/providers/auth/auth_provider.dart';
import 'package:team_project/screen/auth/search_password.dart';
import 'package:team_project/screen/auth/search_password2.dart';
import 'package:team_project/theme/theme_manager.dart';
import 'package:team_project/widgets/error_dialog_widget.dart';

class EditSignScreen extends StatefulWidget {
  const EditSignScreen({Key? key}) : super(key: key);

  @override
  _EditSignScreenState createState() => _EditSignScreenState();
}

class _EditSignScreenState extends State<EditSignScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _nameEditingController = TextEditingController();
  TextEditingController _useridEditingController = TextEditingController();
  String? _selectedNumber;
  bool _isEditingName = false;
  bool _isEditingStudentID = false;
  Uint8List? _image;
  bool _isEnabled = true;
  bool _isLabelDark1 = true;
  bool _isLabelDark2 = true;

  // Method to toggle editing mode for name
  void _toggleNameEditing() {
    setState(() {
      _isEditingName = !_isEditingName;
    });
  }

  // Method to toggle editing mode for student ID
  void _toggleStudentIDEditing() {
    setState(() {
      _isEditingStudentID = !_isEditingStudentID;
    });
  }

  // Method to update user information
  void _updateUserInfo() async {
    final form = _formKey.currentState;

    if (form == null || !form.validate()) {
      return;
    }

    //Perform update logic here using Provider
    //Example:
    await context.read<AuthProvider>().updateUserInfo(
          name: _nameEditingController.text,
          studentID: _useridEditingController.text,
          profileImage: _image,
        );

    // Navigate back to previous screen after successful update
    Navigator.of(context).pop();
  }

  // Method to select and update profile image
  Future<void> _selectAndUploadImage() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageBytes = await pickedFile.readAsBytes();
      setState(() {
        _image = Uint8List.fromList(imageBytes);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final _themeManager = Provider.of<ThemeManager>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '정보 수정',
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Profile Image
              GestureDetector(
                onTap: _selectAndUploadImage,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[200],
                      ),
                      child: _image != null
                          ? CircleAvatar(
                              radius: 64,
                              backgroundImage: MemoryImage(_image!),
                            )
                          : Icon(
                              Icons.add_a_photo,
                              size: 64,
                              color: Colors.grey[700],
                            ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    _isLabelDark1 = !_isLabelDark1;
                  });
                },
                child: TextFormField(
                  enabled: _isEnabled,
                  controller: _nameEditingController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '이름',
                    labelStyle: TextStyle(
                      color: _themeManager.themeMode == ThemeMode.dark
                          ? Colors.black
                          : Colors.grey,
                    ),
                    prefixIcon: Icon(Icons.account_circle, color: Colors.black),
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: _themeManager.themeMode == ThemeMode.dark
                            ? Colors.black
                            : Color(0xFF2195F2),
                      ),
                    ),
                  ),
                  style: TextStyle(color: Colors.black),
                  onChanged: (value) {
                    // 입력이 변경될 때마다 색상 업데이트
                    setState(() {
                      _isLabelDark2 = value.isEmpty;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return '이름을 입력해주세요.';
                    }
                    if (value.length < 2 || value.length > 10) {
                      return '이름은 최소 3글자, 최대 10글자 까지 입력 가능합니다.';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    _isLabelDark2 = !_isLabelDark2;
                  });
                },
                child: SingleChildScrollView(
                  child: DropdownButtonFormField<String>(
                    value: _selectedNumber,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedNumber = newValue;
                        _isEnabled = newValue != null;
                        _useridEditingController.text = newValue ?? '';
                      });
                    },
                    items: [
                      '24학번',
                      '23학번',
                      '22학번',
                      '21학번',
                      '20학번',
                      '19학번',
                      '18학번',
                      '17학번',
                      '16학번',
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(
                              color: _themeManager.themeMode == ThemeMode.dark
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '학번 선택',
                      labelStyle: TextStyle(
                          color: _themeManager.themeMode == ThemeMode.dark
                              ? Colors.black
                              : Colors.grey),
                      prefixIcon: Icon(
                        Icons.account_box,
                        color: Colors.black,
                      ),
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: _themeManager.themeMode == ThemeMode.dark
                              ? Colors.black
                              : Color(0xFF2195F2),
                        ),
                      ),
                    ),
                    style: TextStyle(color: Colors.black),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return '학번을 선택해주세요.';
                      }
                      return null;
                    },
                    isExpanded: true,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              // Update Button
              ElevatedButton(
                onPressed: _updateUserInfo,
                child: Text(
                  '변경',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff1e2b67),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  textStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
              TextButton(
                onPressed: _isEnabled
                    ? () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ForgotPasswordScreen2(),
                        ))
                    : null,
                child: Text(
                  '비밀번호 수정하기',
                  style: TextStyle(
                      fontSize: 16,
                      color: _themeManager.themeMode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
