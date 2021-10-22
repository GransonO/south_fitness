import 'package:agora_rtc_engine/rtc_engine.dart' as rtc_engine_x;
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:south_fitness/pages/video_call/videoRating.dart';

import '../common.dart';

class VideoPlayer extends StatefulWidget {

  /// non-modifiable channel name of the page
  String channelName;
  String passedToken;
  String appID;
  int theUid;
  var element;

  /// Creates a call page with given channel name.
  /// ("token", "appId", "channelName")
  VideoPlayer(token, appId, channel, uid, telement){
    channelName = channel;
    passedToken = token;
    appID = appId;
    theUid = uid;
    element = telement;
  }

  @override
  _VideoPlayerState createState() => _VideoPlayerState(channelName, passedToken, appID, theUid, element);
}

class _VideoPlayerState extends State<VideoPlayer> {
  final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = true;
  bool hideVideo = true;
  rtc_engine_x.RtcEngine _engine;

  var APP_ID;
  var Token;
  var channelName;
  var userUID;
  rtc_engine_x.ClientRole _role = rtc_engine_x.ClientRole.Broadcaster;

  var element;

  _VideoPlayerState(channel, passedToken, appID, theUid, telement){
    APP_ID = appID;
    Token = passedToken;
    channelName = channel.toString().trim();
    userUID = theUid;
    element = telement;
  }

  @override
  void dispose() {
    // clear users
    _users.clear();
    // destroy sdk
    _engine.leaveChannel();
    _engine.destroy();
    super.dispose();
  }

  Color mainColor = Colors.white;

  setPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      var institutePrimaryColor = prefs.getString("institute_primary_color");
      List colors = institutePrimaryColor.split(",");
      mainColor = Color.fromARGB(255,int.parse(colors[0]),int.parse(colors[1]),int.parse(colors[2]));
    });
  }

  @override
  void initState() {
    super.initState();
    // initialize agora sdk
    initialize();
  }

  Future<void> initialize() async {
    print("The channel Name is ------------------:---------------------------- $channelName");
    print("The Token Name is ------------------:---------------------------- $Token");
    print("The AppID Name is ------------------:---------------------------- $APP_ID");

    if (APP_ID.isEmpty) {
      setState(() {
        _infoStrings.add(
          'APP_ID missing, please provide your APP_ID in settings.dart',
        );
        _infoStrings.add('Agora Engine is not starting');
      });
      return;
    }

    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    await _engine.enableWebSdkInteroperability(true);
    rtc_engine_x.VideoEncoderConfiguration configuration = rtc_engine_x.VideoEncoderConfiguration();
    configuration.dimensions = rtc_engine_x.VideoDimensions(1920, 1080);
    await _engine.setVideoEncoderConfiguration(configuration);
    await _engine.joinChannel(Token, channelName, null, userUID);
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    _engine = await rtc_engine_x.RtcEngine.create(APP_ID);
    await _engine.enableVideo();
    await _engine.setChannelProfile(rtc_engine_x.ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(_role);
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    _engine.setEventHandler(rtc_engine_x.RtcEngineEventHandler(error: (code) {
      setState(() {
        final info = 'The --- onError: $code';
        _infoStrings.add(info);
      });
    }, joinChannelSuccess: (channel, uid, elapsed) {
      setState(() {
        final info = 'onJoinChannel: $channel';
        _infoStrings.add(info);
      });
    }, leaveChannel: (stats) {
      setState(() {
        _infoStrings.add('onLeaveChannel');
        _users.clear();
      });
    }, userJoined: (uid, elapsed) {
      setState(() {
        final info = 'userJoined: $uid';
        _infoStrings.add(info);
        _users.add(uid);
      });
    }, userOffline: (uid, elapsed) {
      setState(() {
        final info = 'userOffline: $uid';
        _infoStrings.add(info);
        _users.remove(uid);
      });
    }, firstRemoteVideoFrame: (uid, width, height, elapsed) {
      setState(() {
        final info = 'firstRemoteVideo: $uid ${width}x $height';
        _infoStrings.add(info);
      });
    }));
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<StatefulWidget> list = [];
    // if (_role == rtc_engine_x.ClientRole.) {
    list.add(RtcLocalView.SurfaceView());
    // }
    _users.forEach((int uid) => list.add(RtcRemoteView.SurfaceView(uid: uid)));
    return list;
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  /// Video layout wrapper
  Widget _viewRows() {
    final views = _getRenderViews();
    switch (views.length) {
      case 1:
        return Container(
            child: Column(
              children: <Widget>[_videoView(views[0])],
            ));
      case 2:
        return Container(
            child: Column(
              children: <Widget>[
                _expandedVideoRow([views[0]]),
                _expandedVideoRow([views[1]])
              ],
            ));
      case 3:
        return Container(
            child: Column(
              children: <Widget>[
                _expandedVideoRow(views.sublist(0, 2)),
                _expandedVideoRow(views.sublist(2, 3))
              ],
            ));
      case 4:
        return Container(
            child: Column(
              children: <Widget>[
                _expandedVideoRow(views.sublist(0, 2)),
                _expandedVideoRow(views.sublist(2, 4))
              ],
            ));
      default:
    }
    return Container();
  }

  /// Toolbar layout
  Widget _toolbar() {
    if (_role == rtc_engine_x.ClientRole.Audience) return Container();
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: _onToggleMute,
            child: Icon(
              muted ? Icons.mic_off : Icons.mic,
              color: muted ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: muted ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
          RawMaterialButton(
            onPressed: () => _onCallEnd(context),
            child: Icon(
              Icons.call_end,
              color: Colors.white,
              size: 25.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
          ),
          // RawMaterialButton(
          //   onPressed: _onSwitchCamera,
          //   child: Icon(
          //     Icons.switch_camera,
          //     color: Colors.blueAccent,
          //     size: 20.0,
          //   ),
          //   shape: CircleBorder(),
          //   elevation: 2.0,
          //   fillColor: Colors.white,
          //   padding: const EdgeInsets.all(12.0),
          // ),

          RawMaterialButton(
            onPressed: _onToggleCam,
            child: Icon(
              hideVideo ? Icons.videocam_off : Icons.videocam,
              color: hideVideo ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: hideVideo ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
        ],
      ),
    );
  }

  /// Info panel to show logs
  Widget _panel() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        heightFactor: 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: ListView.builder(
            reverse: true,
            itemCount: _infoStrings.length,
            itemBuilder: (BuildContext context, int index) {
              if (_infoStrings.isEmpty) {
                return null;
              }
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 3,
                  horizontal: 10,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 5,
                        ),
                        decoration: BoxDecoration(
                          color: mainColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          _infoStrings[index],
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _onCallEnd(BuildContext context) async {
    await _engine.leaveChannel();
   Common().newActivity(context, VideoRating(element, true));
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    _engine.muteLocalAudioStream(muted);
  }

  void _onToggleCam() {
    setState(() {
      hideVideo = !hideVideo;
    });
    _engine.muteLocalVideoStream(hideVideo);
  }

  void _onSwitchCamera() {
    _engine.switchCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: _height(100),
        width: _width(100),
        color: Colors.black,
        child: Column(
          children: [
            SizedBox(height: _height(5),),
            Center(
              child: InkWell(
                onTap: () async {
                  await _engine.leaveChannel();
                  Common().newActivity(context, VideoRating(element, true));
                },
                child: Container(
                    height: _height(5),
                    width: _height(5),
                    decoration: BoxDecoration(
                        color: Color.fromARGB(25,255,255,255),
                        borderRadius: BorderRadius.all(Radius.circular(50))
                    ),
                    child: Center(child: Icon(Icons.close, color: Colors.white))
                ),
              ),
            ),
            Spacer(),
            Container(
              height: _height(80),
              width: _width(95),
              margin: EdgeInsets.only(top: _height(1), bottom: _height(4)),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                child: Center(
                  child: Stack(
                    children: <Widget>[
                      _viewRows(),
                      _panel(),
                      _toolbar(),
                    ],
                  ),
                ),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }

  _height(size){
    return Common().componentHeight(context, size);
  }

  _width(size){
    return Common().componentWidth(context, size);
  }
}
