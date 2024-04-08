import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:team_project/models/user_model.dart';

class AvatarWidget extends StatelessWidget {
  final UserModel userModel;

  const AvatarWidget({
    super.key,
    required this.userModel,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      //프로필 이미지 가져오기
      backgroundImage: userModel.profileImage == null
          ? ExtendedAssetImageProvider('assets/images/profile.png') as ImageProvider
          : ExtendedNetworkImageProvider(userModel.profileImage!),
      radius: 18,
    );
  }
}
