import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:team_project/screen/auth/editsign_screen.dart';
import 'package:team_project/screen/auth/signin_screen.dart';
import 'package:team_project/screen/mainPage/editProfile.dart';
import 'package:team_project/screen/mainPage/mainForm.dart';
import 'package:validators/validators.dart';

class ForgotPasswordScreen2 extends StatefulWidget {
  @override
  _ForgotPasswordScreenState2 createState() => _ForgotPasswordScreenState2();
}

class _ForgotPasswordScreenState2 extends State<ForgotPasswordScreen2> {
  GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  final TextEditingController _emailEditingController = TextEditingController();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  bool _isEnabled = true;
  bool _isLabelDark = true;

  @override
  void dispose() {
    _emailEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded),
            color: Colors.black,
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MainForm(),
                ),
              );
            },
          ),
        ),
        body: Form(
          key: _globalKey,
          autovalidateMode: _autovalidateMode,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20),
                Row(
                  children: [
                    Center(
                      child: Text(
                        '비밀번호 재설정',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30), // 조정 가능한 간격
                Text(
                  'DCU 학교 이메일 주소를 입력하세요',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blueGrey,
                  ),
                ),
                SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    setState(() {
                      _isLabelDark = !_isLabelDark;
                    });
                  },
                  child: TextFormField(
                    enabled: _isEnabled,
                    controller: _emailEditingController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'DCU 이메일 주소',
                      labelStyle: TextStyle(
                        color: _isLabelDark ? Colors.grey : Colors.black,
                      ),
                      //prefixIcon: Icon(Icons.email),
                      //labelStyle: TextStyle(fontSize: 20),
                      filled: true,
                    ),
                    validator: (value) {
                      //아무것도 입력x
                      //공백만 입력
                      //이메일 형식이 아닐때
                      if (value == null ||
                          value
                              .trim()
                              .isEmpty ||
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
                SizedBox(
                  height: 50, //
                  child: ElevatedButton(
                    onPressed: () async {
                      // 비밀번호 재설정 기능 호출
                      _resetPassword(context);

                      // 이메일 필드 유효성 검사 및 비활성화
                      if (_isEnabled) {
                        final form = _globalKey.currentState;
                        if (form == null || !form.validate()) {
                          return;
                        }
                        setState(() {
                          _isEnabled = false;
                          _autovalidateMode = AutovalidateMode.always;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff1e2b67),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      textStyle: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                      //padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: Text('이메일 전송', style: TextStyle(color: Colors.white),),
                  ),
                ),
                SizedBox(height: 16.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _resetPassword(BuildContext context) async {
    String email = _emailEditingController.text.trim();

    // 이메일이 학교 이메일 형식이 아닌 경우에는 전송하지 않고 함수 종료
    if (!email.endsWith("@cu.ac.kr")) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('이메일 형식 오류'),
            content: Text('학교 이메일 형식으로 입력해주세요.',
              style: TextStyle(fontSize: 15),),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('확인'),
              ),
            ],
          );
        },
      );
      return;
    }

    // 학교 이메일 형식인 경우에만 비밀번호 재설정 이메일 전송 시도
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      // 이메일을 보냈다는 메시지를 사용자에게 표시
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('이메일 전송 성공'),
            content: Text('비밀번호 재설정 이메일이 전송되었습니다.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SigninScreen(),
                    ),
                  );
                },
                child: Text('확인'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      // 이메일을 보내는 데 실패한 경우 에러 메시지를 사용자에게 표시
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('이메일 전송 실패'),
            content: Text('비밀번호 재설정 이메일을 보내는데 실패했습니다.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('확인'),
              ),
            ],
          );
        },
      );
    }
  }
}
