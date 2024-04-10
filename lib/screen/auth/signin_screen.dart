import 'package:flutter/material.dart';
import 'package:team_project/providers/auth/auth_provider.dart';
import 'package:team_project/exceptions/custom_exception.dart';
import 'package:team_project/providers/auth/auth_state.dart';
import 'package:team_project/screen/auth/search_password.dart';
import 'package:team_project/screen/auth/signup_screen.dart';
import 'package:team_project/utils/logger.dart';
import 'package:team_project/widgets/error_dialog_widget.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  //다양한 텍스트필드 컨트롤러 생성
  TextEditingController _emailEditingController = TextEditingController();
  TextEditingController _passwordEditingController = TextEditingController();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  bool _isEnabled = true;
  bool _isLabelDark1 = true;
  bool _isLabelDark2 = true;

  @override
  void dispose() {
    _emailEditingController.dispose();
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
                      image: AssetImage('assets/images/dcu2.png'),
                      height: 250,
                      colorBlendMode: BlendMode.srcIn,
                      color:
                          Color(0xff1e2b67), // 만약 이미지에 색상을 적용하려면 여기에 색상을 설정하세요.
                    ),
                    SizedBox(height: 20),

                    //email
                    InkWell(
                      onTap: (){
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
                          labelText: 'DCU 이메일',
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
                            return '학교 이메일 형식으로 입력해주세요.';
                          }
                          if (!value.endsWith("@cu.ac.kr")) {
                            return '학교 이메일이 아닙니다.';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 20),

                    //Password
                    InkWell(
                      onTap: (){
                        setState(() {
                          _isLabelDark2 = !_isLabelDark2;
                        });
                      },
                      child: TextFormField(
                        enabled: _isEnabled,
                        controller: _passwordEditingController,
                        obscureText: true,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: '비밀번호',
                          labelStyle: TextStyle(
                            color: _isLabelDark2 ? Colors.grey : Colors.black,
                          ),
                          prefixIcon: Icon(Icons.lock),
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
                              //로그인 로직
                              try {
                                //d = debug 약자
                                logger.d(context.read<AuthState>().authStatus);

                                await context.read<AuthProvider>().signIn(
                                      email: _emailEditingController.text,
                                      password: _passwordEditingController.text,
                                    );

                                logger.d(context.read<AuthState>().authStatus);
                              } on CustomException catch (e) {
                                setState(() {
                                  _isEnabled = true;
                                });
                                errorDialogWidget(context, e);
                              }
                            }
                          : null,
                      child: Text('로그인', style: TextStyle(color: Colors.white),),
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
                    SizedBox(height: 20),
                    TextButton(
                      onPressed: _isEnabled
                          ? () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignupScreen(),
                              ))
                          : null,
                      child: Text('회원이 아니신가요? 회원가입 하기',
                          style: TextStyle(fontSize: 16, color: Colors.black)),
                    ),

                    TextButton(
                      onPressed: _isEnabled
                          ? () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ForgotPasswordScreen(),
                              ))
                          : null,
                      child: Text(
                        '비밀번호를 잊어버리셨나요?',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                    TextButton(
                      onPressed: _isEnabled
                          ? () async {
                              try {
                                // AuthProvider를 통해 익명 로그인을 수행
                                await context
                                    .read<AuthProvider>()
                                    .signInAnonymously();
                              } catch (e) {
                                // 익명 로그인 중 에러가 발생한 경우 처리
                                print('익명 로그인 에러: $e');
                              }
                            }
                          : null,
                      child: Text(
                        '비회원 입장',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
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
