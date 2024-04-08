import 'package:flutter/material.dart';

class AboutExplain extends StatelessWidget {
  @override
  const AboutExplain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 25),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          '앱 정보',
          style: TextStyle(
              fontFamily: 'Dongle', fontSize: 35, fontWeight: FontWeight.w200),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.lime,
                ),
                width: 50,
                height: 50,
              ),
              SizedBox(width: 5),
              Text('앱 이름')
            ],
          ),
          Divider(thickness: 1),
          Text(
            '버전 정보 :   ver 1.0',
            style: TextStyle(fontSize: 20),
          ),
          Divider(thickness: 1),
          Text('개발팀 :   CTRL', style: TextStyle(fontSize: 20)),
          Divider(thickness: 1),
          Text('개발자들 :   김성철, 박성회, 현진관', style: TextStyle(fontSize: 20)),
          Divider(thickness: 1),
          Text('앱 목표', style: TextStyle(fontSize: 20)),
          Divider(thickness: 1),
          Text("대구 가톨릭 대학교 학생들을 위한 동아리 정보 어플리케이션 입니다."),
          Text("사용자들은 동아리를 만들수도 있고, 그저 보기만 할수도 있습니다."),
          Text("동아리 활동을 하고 싶은데 정보를 얻기 어려웠던 재학생들,"),
          Text("동아리 인원을 늘려야 하는데 마땅한 홍보 방법이 없는 동아리들에게"),
          Text("아주 좋은 홍보 및 정보를 얻을수 있는 어플리케이션 입니다."),
          Text("대구가톨릭대학교의 동아리 활동을 증진시켜 보세요."),
          Divider(thickness: 1),
          Row(
            children: [
              Text("License : "),
              SizedBox(width: 5),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => LicensePage()));
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.white54,
                ),
                child: Text(
                  "확인하기",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
          Divider(),
        ],
      ),
    );
  }
}
