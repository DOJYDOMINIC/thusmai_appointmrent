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
    Provider.of<ZoomMeetingController>(context,listen: false).zoomClass();
  }


  @override
  Widget build(BuildContext context) {
    var meditation = Provider.of<MeditationController>(context);
    var data = Provider.of<VideoPlayerStateController>(context).playList;
    String currentDate = DateFormat('dd/MM/yy').format(DateTime.now());
    var connect = Provider.of<ConnectivityProvider>(context);
    return GestureDetector(
      onTap: () {
        if (!FocusScope.of(context).hasPrimaryFocus) {
          FocusScope.of(context).unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: shadeOne,
        body:connect.status == ConnectivityStatus.Offline
            ? Center(
          child: RefreshPage(
            onTap: () {
              Provider.of<AppLogin>(context, listen: false).validateSession(context);
              Provider.of<VideoPlayerStateController>(context, listen: false)
                  .playlistDetails();
            },
          ),
        )
            : SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8), color: shadeFour),
                child: Padding(
                  padding: EdgeInsets.all(8.sp),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(height: 8.h),
                        Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text("$currentDate : Guruji  Class Notes",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Container(
                          height: 130.h,
                          width: 368.w,
                          // decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                          child: Padding(
                            padding: EdgeInsets.only(left: 10.sp, right: 10.sp),
                            child: TextField(
                              controller: noteController,
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  hintText: "5 Class Learnings... ",
                                  hintStyle: TextStyle(
                                      color: shadeFive, fontSize: 16.sp),
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  fillColor: Colors.white,
                                  filled: true
                              ),
                              maxLength: 500,
                              cursorColor: Colors.grey,
                              maxLines: 4,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("Send to :"),
                              Checkbox(
                                  side: BorderSide(color: shadeNine, width: 2),
                                  activeColor: brown,
                                  value: _global,
                                  onChanged: (val) {
                                    setState(() {
                                      _global = val!;
                                    });
                                  }),
                              Text("Global"),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: SizedBox(
                            width: 128.w,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                    WidgetStateProperty.all(goldShade)),
                                onPressed: () {
                                  if (noteController.text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: Colors.red,
                                        content: Text("Please Fill Note"),
                                        duration: Duration(seconds: 1),
                                      ),
                                    );
                                  } else {
                                    DateTime now = DateTime.now();
                                    String formattedTime =
                                    DateFormat('h:mm a').format(now);
                                    String messageTDate =
                                    DateFormat('MMMM dd, yyyy')
                                        .format(DateTime.now());
                                    meditation.meditationNote(context, "Class Note : ${noteController.text}", _global ? "global" : "private", formattedTime, messageTDate,).then((result) {
                                      if (meditation.clearNote == true) {
                                        _global = false;
                                        noteController.clear();
                                        slidePageRoute(context, MessageTab());
                                      }
                                    });
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Send",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                )),
                          ),
                        )
                      ]),
                ),
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding:
                    const EdgeInsets.only(bottom: 16, top: 16, left: 16),
                    child: Text(
                      "Video Playlist",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )),
              data.playlists?.length != null
                  ? ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: data.playlists!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: GestureDetector(
                      onTap: () {
                        Provider.of<VideoPlayerStateController>(context, listen: false).videoPlaylistDetails("${data.playlists![index].playListHeading.toString()}");
                        Navigator.push(context, MaterialPageRoute(builder: (context) => VideoList()),
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
                            Padding(
                              padding: EdgeInsets.fromLTRB(8, 16, 8, 16),
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
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
                  : Center(child: CircularProgressIndicator()),
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
