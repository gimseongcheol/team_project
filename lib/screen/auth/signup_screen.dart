import 'package:team_project/exceptions/custom_exception.dart';
import 'package:team_project/providers/auth/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:team_project/screen/auth/signin_screen.dart';
import 'package:team_project/widgets/error_dialog_widget.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  //다양한 텍스트필드 컨트롤러 생성
  TextEditingController _useridEditingController = TextEditingController();
  TextEditingController _emailEditingController = TextEditingController();
  TextEditingController _nameEditingController = TextEditingController();
  TextEditingController _passwordEditingController = TextEditingController();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  Uint8List? _image;
  bool _isEnabled = true;
  String? _selectedNumber;
  bool _passwordVisible = true;
  bool _password2Visible = true;
  bool _isLabelDark1 = true;
  bool _isLabelDark2 = true;
  bool _isLabelDark3 = true;
  bool _isLabelDark4 = true;
  bool _isLabelDark5 = true;

  Future<void> selectImage() async {
    ImagePicker imagePicker = new ImagePicker();
    XFile? file = await imagePicker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 512,
      maxWidth: 512,
    );
    if (file != null) {
      Uint8List uint8list = await file.readAsBytes();
      setState(() {
        _image = uint8list;
      });
    }
  }

  @override
  void dispose() {
    _useridEditingController.dispose();
    _emailEditingController.dispose();
    _nameEditingController.dispose();
    _passwordEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _globalKey,
                autovalidateMode: _autovalidateMode,
                child: ListView(
                  shrinkWrap: true,
                  reverse: true,
                  children: [
                    Image(
                      image: AssetImage('assets/images/dcu1.png'),
                      height: 70,
                      colorBlendMode: BlendMode.srcIn,
                      color:
                          Color(0xff1e2b67), // 만약 이미지에 색상을 적용하려면 여기에 색상을 설정하세요.
                    ),
                    SizedBox(height: 20),
                    //프로필사진
                    Container(
                      alignment: Alignment.center,
                      child: Stack(
                        children: [
                          _image == null
                              ? CircleAvatar(
                                  radius: 64,
                                  backgroundImage:
                                      AssetImage('assets/images/profile.png'),
                                )
                              : CircleAvatar(
                                  radius: 64,
                                  backgroundImage: MemoryImage(_image!),
                                ),
                          Positioned(
                            //left: 40,
                            //bottom: 50,
                            left: 85,
                            top: 0,
                            child: IconButton(
                              onPressed: _isEnabled
                                  ? () async {
                                      await selectImage();
                                    }
                                  : null,
                              icon: Icon(Icons.add_a_photo),
                              color: Color(0xff1e2b67),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    //email
                    InkWell(
                      onTap: () {
                        setState(() {
                          _isLabelDark1 = !_isLabelDark1;
                        });
                      },
                      child: TextFormField(
                        enabled: _isEnabled,
                        controller: _emailEditingController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: '학교 이메일',
                          labelStyle: TextStyle(
                            color: _isLabelDark1 ? Colors.grey : Colors.black,
                          ),
                          prefixIcon: Icon(Icons.email),
                          filled: true,
                        ),
                        onChanged: (value) {
                          // 입력이 변경될 때마다 색상 업데이트
                          setState(() {
                            _isLabelDark1 = value.isEmpty;
                          });
                        },
                        validator: (value) {
                          //아무것도 입력x
                          //공백만 입력
                          //이메일 형식이 아닐때
                          if (value == null ||
                              value.trim().isEmpty ||
                              !isEmail(value.trim())) {
                            return '이메일을 입력해주세요.';
                          }
                          if (!value.endsWith("@cu.ac.kr")) {
                            return '학교 이메일이 아닙니다.';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    //name
                    InkWell(
                      onTap: (){
                        setState(() {
                          _isLabelDark2 = !_isLabelDark2;
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
                            color: _isLabelDark2 ? Colors.grey : Colors.black,
                          ),
                          prefixIcon: Icon(Icons.account_circle),
                          filled: true,
                        ),
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
                    SizedBox(height: 20),
                    //학번
                      InkWell(
                        onTap: () {
                          setState(() {
                            _isLabelDark5 = !_isLabelDark5;
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
                                child: Text(value),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: '학번 선택',
                              labelStyle: TextStyle(
                                color: _isLabelDark5 ? Colors.grey : Colors.black,
                              ),
                              prefixIcon: Icon(Icons.account_box),
                              filled: true,
                            ),
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
                    SizedBox(height: 20),

                    //Password
                    InkWell(
                      onTap: () {
                        setState(() {
                          _isLabelDark3 = !_isLabelDark3;
                        });
                      },
                      child: TextFormField(
                        enabled: _isEnabled,
                        controller: _passwordEditingController,
                        obscureText: _passwordVisible,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: '비밀번호',
                          labelStyle: TextStyle(
                            color: _isLabelDark3 ? Colors.grey : Colors.black,
                          ),
                          prefixIcon: Icon(Icons.lock),
                          filled: true,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                        ),
                        onChanged: (value) {
                          // 입력이 변경될 때마다 색상 업데이트
                          setState(() {
                            _isLabelDark3 = value.isEmpty;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return '패스워드를 입력해주세요.';
                          }
                          if (value.length < 8 ||
                              value.length > 12 ||
                              !RegExp(r'^(?=.*?[a-zA-Z])(?=.*?[0-9])(?=.*?[!@#$%^&+=]).{8,12}$')
                                  .hasMatch(value)) {
                            return '영문, 숫자, 특수문자 조합으로 8~12자로 작성해야합니다.';
                          }
                          return null;
                        },
                      ),
                    ),

                    SizedBox(height: 20),
                    //Confirm Password
                    InkWell(
                      onTap: (){
                        setState(() {
                          _isLabelDark4 = !_isLabelDark4;
                        });
                      },
                      child: TextFormField(
                        enabled: _isEnabled,
                        obscureText: _password2Visible,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: '비밀번호 확인',
                          labelStyle: TextStyle(
                            color: _isLabelDark4 ? Colors.grey : Colors.black,
                          ),
                          prefixIcon: Icon(Icons.lock),
                          filled: true,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _password2Visible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _password2Visible = !_password2Visible; // 수정된 부분
                              });
                            },
                          ),
                        ),
                        onChanged: (value) {
                          // 입력이 변경될 때마다 색상 업데이트
                          setState(() {
                            _isLabelDark4 = value.isEmpty;
                          });
                        },
                        validator: (value) {
                          if (_passwordEditingController.text != value) {
                            return '패스워드가 일치하지 않습니다.';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: _isEnabled
                          ? () async {
                              final form = _globalKey.currentState;

                              if (form == null || !form.validate()) {
                                return;
                              }
                              setState(() {
                                _isEnabled = false;
                                _autovalidateMode = AutovalidateMode.always;
                              });
                              //회원가입 로직
                              try {
                                await context.read<AuthProvider>().signUp(
                                      userid: _useridEditingController.text,
                                      email: _emailEditingController.text,
                                      name: _nameEditingController.text,
                                      password: _passwordEditingController.text,
                                      profileImage: _image,
                                    );
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SigninScreen(),
                                  ),
                                );

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '인증 메일을 전송했습니다.',
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    duration: Duration(seconds: 30),
                                    elevation: 6.0,
                                    // 그림자 설정
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    margin: EdgeInsets.all(10.0),
                                  ),
                                );
                              } on CustomException catch (e) {
                                setState(() {
                                  _isEnabled = true;
                                });
                                errorDialogWidget(context, e);
                              }
                            }
                          : null,
                      child: Text('회원가입'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff1e2b67),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        textStyle: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextButton(
                      onPressed: _isEnabled
                          ? () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SigninScreen(),
                              ))
                          : null,
                      child: Text('이미 회원이신가요? 로그인하기',
                          style: TextStyle(fontSize: 16)),
                    ),
                  ].reversed.toList(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
