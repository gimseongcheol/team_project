import 'package:flutter/material.dart';
import 'package:team_project/exceptions/custom_exception.dart';
import 'package:team_project/providers/feed/feed_provider.dart';
import 'package:team_project/providers/feed/feed_state.dart';
import 'package:team_project/utils/logger.dart';
import 'package:team_project/widgets/error_dialog_widget.dart';
import 'package:provider/provider.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> with AutomaticKeepAliveClientMixin<FeedScreen>{
  late final FeedProvider feedProvider;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    feedProvider = context.read<FeedProvider>();
    _getFeedList();
  }

  void _getFeedList(){
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try{
        await feedProvider.getFeedList();
      }on CustomException catch (e){
        errorDialogWidget(context, e);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    logger.d(context.read<FeedState>().feedList);
    return const Placeholder();
  }
}
