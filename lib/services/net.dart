import 'dart:math';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authentication {

  var baseUrl = "https://southfitness.epitomesoftware.live";
  var uploadUrl = "https://api.cloudinary.com/v1_1/dolwj4vkq/image/upload";
  late Dio dio;
  late SharedPreferences prefs;

  Authentication() {
    dio = Dio();
  }

  loginUser(loginData) async {
    try {
      var user = await dio.post(
        baseUrl + "/auth/login",
        data: loginData,
      );
      var result = user.data;
      prefs = await SharedPreferences.getInstance();
      if (result["status"] == "success") {
        prefs.setString("access_token", result["access_token"]);
        prefs.setString("email", result["user"]["email"]);
        prefs.setString("username", "${result["user"]["first_name"]} ${result["user"]["last_name"]}");
        prefs.setString("first_name", "${result["user"]["first_name"]}");
        prefs.setString("last_name", "${result["user"]["last_name"]}");
        prefs.setString("institution_id", "${result["institution_id"]}");
        print("------------------------institution id---------------------------${result["institution_id"]}");

        prefs.setString("institution", result["institution"]);

        if(result["profile"] != null){
          prefs.setString("team", result["profile"]["team"]);
          prefs.setString("gender", result["profile"]["gender"]);
          prefs.setDouble("weight", result["profile"]["weight"]);
          prefs.setDouble("height", result["profile"]["height"]);
          prefs.setString("image", result["profile"]["image"]);
          prefs.setString("user_id", result["profile"]["user_id"]);
        }

        return {"success": true, "payload": result, "status": 200};
      } else{
        // Unauthorised
        return {"success": false, "payload": {}, "status": 401};
      }
    } catch (e) {
      return {"success": false, "payload": {}, "status": 400};
    }
  }

  addProfileInfo() async {
    prefs = await SharedPreferences.getInstance();
    var profileData = {
      "workout_duration" : prefs.getInt("duration"),
      "discipline": prefs.getString("interest")!.trim(),
      "goal": prefs.getString("goal")!.trim(),
      "height": prefs.getInt("height"),
      "weight": prefs.getInt("weight"),
      "gender": prefs.getString("gender")!.trim(),

      "fullname": "${prefs.getString("firstname")} ${prefs.getString("lastname")}",
      "email": prefs.getString("email")!.trim(),
      "birthDate": prefs.getString("birthDate")!.trim(),
      "team": prefs.getString("team")!.trim(),
      "activation_code": prefs.getString("code")!.trim()
    };
    print("ProfileData------------$profileData");
    // dio.options.headers["Authorization"] = "Bearer ${prefs.getString("token")}";
    var profile = await dio.post(
        baseUrl + "/profiles/", data: profileData);
    var result = profile.data;
    if (result["status"] == "success") {
      prefs.setString("image", "https://res.cloudinary.com/dolwj4vkq/image/upload/v1618227174/South_Fitness/profile_images/GREEN_AVATAR.jpg");
      return {"success": true, "user_id": result["user_id"]};
    } else {
      return {"success": false, "payload": ""};
    }
  }

  verifyActivationCode(codeData) async {
    var profile = await dio.post(
        baseUrl + "/profiles/code/", data: codeData);
    var result = profile.data;
    if (result["status"] == "success") {
      return true;
    } else {
      return false;
    }
  }

  updateProfile(profileData) async {

    print("Profile profileData ------------------- $profileData");
    // dio.options.headers["Authorization"] = "Bearer ${prefs.getString("token")}";
    var profile = await dio.put(
        baseUrl + "/profiles/", data: profileData);
    var result = profile.data;
    print("Profile Update ------------------- $result");
    if (result["status"] == "success") {
      return {"success": true, "payload": result["message"]};
    } else {
      return {"success": false, "payload": ""};
    }
  }

  forgotPassword(userData) async {
    try {
      var forgot = await dio.post(
          baseUrl + "/auth/reset",
          data: userData);
      var result = forgot.data;
      print("Reset ------------------- $result");
      if (result["success"]) {
        return {"success": true};
      } else {
        print("Reset ------------------- $result");
        return {"success": false, "code":result["code"]};
      }
    } catch (e) {
      print("Reset ------------------- $e");
      return {"success": false, "payload": []};
    }
  }

  resetPassword(userData) async {
    try {
      var forgot = await dio.put(
          baseUrl + "/auth/reset",
          data: userData);
      var result = forgot.data;
      if (result["status"] == "success") {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  uploadProfileImage(formData) async {
    prefs = await SharedPreferences.getInstance();
    try {
      Response response = await dio.post(uploadUrl, data: formData);
      prefs.setString("image", response.data["secure_url"]);
      return response.data["secure_url"];
    } catch (e) {
      print(e);
    }
  }

  uploadImage(formData) async {
    try {
      Response response = await dio.post(uploadUrl, data: formData);
      return response.data["secure_url"];
    } catch (e) {
      print(e);
    }
  }
}

class HomeResources {

  var baseUrl = "https://southfitness.epitomesoftware.live";
  late Dio dio;
  late SharedPreferences prefs;

  HomeResources() {
    dio = Dio();
  }

  getSettings(instituteId) async {
    print("----------------------------------------- institute Id $instituteId");
    var result = await dio.get(baseUrl + "/institution/$instituteId");
    var institute = result.data;
    print("----------------------------------------- Home Setup $institute");

    return institute[0];
  }

  getVideos(day) async {
    print("---------------------------- passed day : $day");
    var startTime = DateTime.now();
    print("---------------------------- Today's day : ${startTime.day}");
    var theMonth = startTime.month;
    if(startTime.day == 1){
      theMonth = theMonth - 1;
    }
    var yesterday = "${startTime.year}-${theMonth < 10 ? "0$theMonth" : theMonth}-$day";

    print("---------------------------- Yesterday : $yesterday");
    var result = await dio.get(baseUrl + "/videos/all/$yesterday");
    var videos = result.data;

    return videos;
  }

  getDateActivities(date) async {
    var result = await dio.get(baseUrl + "/videos/date_request/$date");
    var challenges = result.data;

    return challenges;
  }

  getHistory(historyData) async {
    try {
      var history = await dio.post(baseUrl + "/videos/history/", data: historyData);
      var result = history.data;
      if (result["status"] == "success") {
        return result["history_list"];
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  getTodayActivities(user_id) async {
    var result = await dio.get(baseUrl + "/challenge/today/$user_id");
    var challenges = result.data;

    return challenges;
  }


  getSuggestedActivities() async {
    var result = await dio.get(baseUrl + "/videos/activities/all/");
    var activities = result.data;

    return activities;
  }

  getVideoCallDetails(videoId, channelName) async {
    var random = new Random();
    var uid = random.nextInt(1000000) + 1000;
    var result = await dio.post(baseUrl + "/videos/access_token/", data: {
      "channel_name": channelName,
      "video_id": videoId,
      "username": uid,
      "can_start": false
    });
    var videoCall = result.data;

    print("The video call ------------------------------------------------ $videoCall");

    return {"video": videoCall, "uid": uid};
  }

  getTestVideo(videoId, channelName) async {
    var random = new Random();
    var uid = random.nextInt(1000000) + 1000;
    var result = await dio.post("https://hello-alfie.herokuapp.com/connect/token/", data: {
        "channel_name": "name_14567_8765",
        "callUid": uid,
        "is_patient":true
      }
    );

    var videoCall = result.data;
    videoCall["isStarted"] = true;

    print("The video call ------------------------------**************----------------------------- $videoCall");

    return {"video": videoCall,"uid": uid};
  }

  rateLiveClass(rateData) async {
    print("---------- rateData : $rateData");
    try {
      var viewed = await dio.put(
          baseUrl + "/videos/",
          data: rateData);
      var result = viewed.data;
      if (result["status"] == "success") {
        return true;
      } else {

        print("---------- result : $result");
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  getAllBlogs() async {
    var result = await dio.get(baseUrl + "/blog/all/");
    var videos = result.data;

    return videos;
  }

  getBlogCallDetails(blogId) async {
    var result = await dio.get(baseUrl + "/blog/$blogId");
    var videos = result.data;

    return videos[0];
  }

  getBlogComments(blogId) async {
    var result = await dio.get(baseUrl + "/blog/comments/all/$blogId");
    return result.data;
  }

  postBlogComment(blogData) async {
    try {
      var comment = await dio.post(baseUrl + "/blog/comments/", data: blogData);
      var result = comment.data;
      if (result["status"] == "success") {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  updateBlogViews(blogData) async {
    try {
      var viewed = await dio.put(
          baseUrl + "/blog/",
          data: blogData);
      var result = viewed.data;
      if (result["status"] == "success") {
        return {"success": true};
      } else {
        return {"success": false};
      }
    } catch (e) {
      return {"success": false};
    }
  }

  postChallenge(challengeData) async {
    try {
      var user = await dio.post(
        baseUrl + "/challenge/",
        data: challengeData,
      );
      var result = user.data;

      if (result["status"] == "success") {
        return {"success": true, "payload": result, "status": 200};
      } else{

        return {"success": false, "payload": {}, "status": 401};
      }
    } catch (e) {
      return {"success": false, "payload": {}, "status": 400};
    }
  }

  joinLiveClass(challengeData) async {
    print("--------Sending this class: --------- $challengeData");
    try {
      var user = await dio.put(
        baseUrl + "/videos/activities/",
        data: challengeData,
      );
      var result = user.data;
      print("--------Result is: --------- $result");
      return result["status"] == "success";

    } catch (e) {
      return false;
    }
  }

  joinListedActivity(activityData) async {
    try {
      var user = await dio.post(
        baseUrl + "/challenge/members_added/",
        data: activityData,
      );
      var result = user.data;
      print("--------Result is: --------- $result");
      return result["status"] == "success";

    } catch (e) {
      return false;
    }
  }

  exitListedActivity(activityData) async {
    print("--------Sending this: --------- $activityData");
    try {
      var user = await dio.put(
        baseUrl + "/challenge/members_added/",
        data: activityData,
      );
      var result = user.data;
      print("--------Result is: --------- $result");
      return result["status"] == "success";

    } catch (e) {
      return false;
    }
  }

  getAllListedActivities() async {
    try {
      var perform = await dio.get(
          baseUrl + "/challenge/listed/all/"
      );
      var result = perform.data;
      return result;
    } catch (e) {
      return [];
    }
  }

}

class PerformanceResource {

  var baseUrl = "https://southfitness.epitomesoftware.live";
  late Dio dio;
  late SharedPreferences prefs;

  PerformanceResource() {
    dio = Dio();
  }

  var teams = [];
  var leaders = [];

  getPerformance() async {
    try {
      var perform = await dio.get(
        baseUrl + "/videos/participants/"
      );
      var result = perform.data;
      print("--------Result is: --------- $result");
      return result["members_list"] ;
    } catch (e) {
      return [];
    }
  }

  getUserPerformance(userId) async {
    try {
      var perform = await dio.get(
        baseUrl + "/challenge/members/$userId"
      );
      var result = perform.data;
      return result;
    } catch (e) {
      return [];
    }
  }

  getDashboardPerformance(user_id) async {
    var result = await dio.get(baseUrl + "/challenge/$user_id");
    List perform = result.data;

    var distanceCovered = 0.0;
    var caloriesBurnt = 0.0;
    var stepsCount = 0.0;
    var points = 0.0;

    perform.forEach((element) {
      distanceCovered = distanceCovered + element["distance"];
      caloriesBurnt = caloriesBurnt + element["caloriesBurnt"];
      stepsCount = stepsCount + element["steps_count"];
    });

    return {"distance": distanceCovered.toInt(), "calories": caloriesBurnt.toInt(), "steps": stepsCount.toInt()};
  }

  getIndividualPerformance(department) async {
    try {
      var perform = await dio.put(
        baseUrl + "/videos/participants/",
        data: {
          "user_department": department
        },
      );
      var result = perform.data;
      return result["members_list"] ;
    } catch (e) {
      return [];
    }
  }

  getUserHistory(userId) async {
    var result = await dio.get(baseUrl + "/challenge/$userId");
    var history = result.data;

    return history.toList();
  }

  getTeamPerformance(challengeData) async {
    try {
      var perform = await dio.post(
        baseUrl + "/challenge/members/",
        data: challengeData,
      );
      var result = perform.data;
      return result["members_list"] ;
    } catch (e) {
      return [];
    }
  }

  getClassMembers(classData) async {
    try {
      var perform = await dio.post(
        baseUrl + "/videos/participants/",
        data: classData,
      );
      var result = perform.data;
      return result["members_list"] ;
    } catch (e) {
      return [];
    }
  }

}

class ChatService{

  late Dio dio;
  var baseUrl = "https://southfitness.epitomesoftware.live";
  ChatService(){
    dio = Dio();
  }

  postChat(chatData) async {
    // post a chat
    var chat = await dio.post(
        baseUrl + "/chats/", data: chatData);
    var result = chat.data;

    if (result["status"] == "success") {
      return {"success": true};
    } else {
      return {"success": false};
    }
  }

  updateChat(chatData) async {
    // update a chat
    var chat = await dio.put(
        baseUrl + "/chats/", data: chatData);
    var result = chat.data;

    if (result["status"] == "success") {
      return {"success": true};
    } else {
      return {"success": false};
    }
  }

  groupChat(groupId) async {
    // get all group chats
    var chat = await dio.get(
        baseUrl + "/chats/all/" + groupId);
    var result = chat.data;

    return result;
  }

  createGroup(groupData) async {
    // create a group
    var chat = await dio.post(
        baseUrl + "/chats/groups/", data: groupData);
    var result = chat.data;

    if (result["status"] == "success") {
      return true;
    } else {
      return false;
    }
  }

  updateGroup(groupData) async {
    // update a group
    var chat = await dio.put(
        baseUrl + "/chats/groups/", data: groupData);
    var result = chat.data;

    if (result["status"] == "success") {
      return {"success": true};
    } else {
      return {"success": false};
    }
  }

  allGroups(institution) async {
    // get all group chats
    var chat = await dio.get(baseUrl + "/chats/groups/all/$institution");
    print("================tHE CHAT DATA=============================$institution");
    print("================tHE CHAT DATA=============================$chat");
    var result = chat.data;

    return result;
  }

  isContactRegistered(contact) async {
    // post a chat
    var chat = await dio.post(
        baseUrl + "/contacts/", data: contact);
    var result = chat.data;

    if (result["status"] == "success") {
      return true;
    } else {
      return false;
    }
  }

  isGeneralMember(memberData) async {
    var member = await dio.put(
        baseUrl + "/chats/general/", data: memberData);
    var result = member.data;
    if (result["status"]) {
      return {"success": true, "alias": result["alias"]};
    } else {
      return {"success": false};
    }
  }

  addGeneralMember(memberData) async {
    var member = await dio.post(
        baseUrl + "/chats/general/", data: memberData);
    var result = member.data;

    if (result["status"]) {
      return {"success": true};
    } else {
      return {"success": false};
    }
  }


}