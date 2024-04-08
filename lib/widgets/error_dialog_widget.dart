import 'package:flutter/material.dart';
import 'package:team_project/exceptions/custom_exception.dart';

void errorDialogWidget(BuildContext context, CustomException e) {
  showDialog(
      context: context,
      //확인 버튼이 아닌 다른 영역을 클릭을 해도 닫히지 않게 지정
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          //에러 코드
          title: Text(e.code),
          //에러내용
          content: Text(e.message),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('확인'),
            ),
          ],
        );
      });
}
