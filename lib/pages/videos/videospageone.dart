import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:thusmai_appointmrent/constant/constant.dart';
import 'package:thusmai_appointmrent/controller/videoplayer_controller.dart';
import 'package:thusmai_appointmrent/pages/videos/videolist.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controller/connectivitycontroller.dart';
import '../../controller/login_register_otp_api.dart';
import '../../controller/meditationController.dart';
import '../../controller/zoommeeting_controller.dart';
import '../../tabs/messsagetab.dart';
import '../../widgets/additionnalwidget.dart';
import '../refreshpage.dart';

class VideosPageOne extends StatefulWidget {
  const VideosPageOne({super.key});

  @override
  State<VideosPageOne> createState() => _VideosPageOneState();
}

class _VideosPageOneState extends State<VideosPageOne> {
  bool _global = false;
  TextEditingController noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<AppLogin>(context, listen: false).validateSession(context);
    Provider.of<VideoPlayerStateController>(context, listen: false)
        .playlistDetails();
    Provider.of<ZoomMeetingController>(context, listen: false).zoomClass();
  }

  @override
  Widget build(BuildContext context) {
    var meditation = Provider.of<MeditationController>(context);
    var data = Provider.of<VideoPlayerStateController>(context).playList;
    String currentDate = DateFormat('dd/MM/yy').format(DateTime.now());
    // var connect = Provider.of<ConnectivityProvider>(context);
    return GestureDetector(
      onTap: () {
        if (!FocusScope.of(context).hasPrimaryFocus) {
          FocusScope.of(context).unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: shadeOne,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(bottom: 16, top: 16, left: 16),
                    child: Text(
                      "Video Playlists :",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )),
              data.playlists == null || data.playlists!.isEmpty
                  ? Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 300.h),
                        child: Text(
                          "No Data Found",
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: data.playlists!.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: GestureDetector(
                            onTap: () {
                              Provider.of<VideoPlayerStateController>(context,
                                      listen: false)
                                  .videoPlaylistDetails(
                                      "${data.playlists![index].playListHeading.toString()}");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => VideoList()),
                              );
                            },
                            child: Container(
                              height: 120.h,
                              decoration: BoxDecoration(
                                color: shadeFour,
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 16.sp),
                                    child: Container(
                                      height: 100.h,
                                      width: 100.w,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  "${data.playlists![index].playListImage ?? noImage}"),
                                              fit: BoxFit.fill)),
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  Expanded(
                                    child: Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(8, 16, 8, 16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                              "${data.playlists![index].playListHeading}"),
                                          Row(
                                            children: [
                                              Icon(Icons.videocam),
                                              Text(
                                                  "(${data.playlists![index].videoLinkCount.toString()}) Videos"),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )
              //: Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ),
    );
  }

  launchURL(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch url');
    }
  }
}
