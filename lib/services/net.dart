import 'dart:math';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authentication {

  var baseUrl = "https://south-fitness.herokuapp.com";
  var uploadUrl = "https://api.cloudinary.com/v1_1/dolwj4vkq/image/upload";
  Dio dio;
  SharedPreferences prefs;

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
        print("----------------------------------------$result");
        prefs.setString("access_token", result["access_token"]);
        prefs.setString("email", result["user"]["email"]);
        prefs.setString("username", "${result["user"]["first_name"]} ${result["user"]["last_name"]}");

        prefs.setString("team", result["profile"]["team"]);
        prefs.setString("gender", result["profile"]["gender"]);
        prefs.setDouble("weight", result["profile"]["weight"]);
        prefs.setDouble("height", result["profile"]["height"]);
        prefs.setString("image", result["profile"]["image"]);
        prefs.setString("institution", result["profile"]["institution"]);
        prefs.setString("user_id", result["profile"]["user_id"]);
        return {"success": true, "payload": result, "status": 200};
      } else{
        // Unauthorised
        return {"success": false, "payload": {}, "status": 401};
      }
    } catch (e) {
      print("-------*ERROR*-----$e");
      return {"success": false, "payload": {}, "status": 400};
    }
  }

  addProfileInfo() async {
    prefs = await SharedPreferences.getInstance();
    var profileData = {
      "workout_duration" : prefs.getInt("duration"),
      "discipline": prefs.getString("interest").trim(),
      "goal": prefs.getString("goal").trim(),
      "height": prefs.getInt("height"),
      "weight": prefs.getInt("weight"),
      "gender": prefs.getString("gender").trim(),

      "fullname": "${prefs.getString("firstname")} ${prefs.getString("lastname")}",
      "email": prefs.getString("email").trim(),
      "birthDate": prefs.getString("birthDate").trim(),
      "team": prefs.getString("team").trim(),
      "activation_code": prefs.getString("code").trim()
    };
    print("Profile Data------------------------ $profileData");
    // dio.options.headers["Authorization"] = "Bearer ${prefs.getString("token")}";
    var profile = await dio.post(
        baseUrl + "/profiles/", data: profileData);
    var result = profile.data;
    print("------------------------ $result");
    if (result["status"] == "success") {
      return {"success": true, "user_id": result["user_id"]};
    } else {
      return {"success": false, "payload": ""};
    }
  }

  verifyActivationCode(codeData) async {
    var profile = await dio.post(
        baseUrl + "/profiles/code/", data: codeData);
    var result = profile.data;
    print("------------------------ $result");
    if (result["status"] == "success") {
      return true;
    } else {
      return false;
    }
  }

  updateProfile(profileData) async {

    print("------------------------ $profileData");
    // dio.options.headers["Authorization"] = "Bearer ${prefs.getString("token")}";
    var profile = await dio.put(
        baseUrl + "/profiles/", data: profileData);
    var result = profile.data;
    print("------------------------ $result");
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
      print("------------------------ $result");
      if (result["success"]) {
        return {"success": true};
      } else {
        return {"success": false};
      }
    } catch (e) {
      print("------------------------ $e");
      return {"success": false, "payload": []};
    }
  }

  resetPassword(userData) async {
    try {
      var forgot = await dio.put(
          baseUrl + "/auth/reset",
          data: userData);
      var result = forgot.data;
      print("------------------------ $result");
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
      print("----------------------------------------------- ${response.data["secure_url"]}");
      prefs.setString("image", response.data["secure_url"]);
      return response.data["secure_url"];
    } catch (e) {
      print(e);
    }
  }

  uploadImage(formData) async {
    try {
      Response response = await dio.post(uploadUrl, data: formData);
      print("----------------------------------------------- ${response.data["secure_url"]}");
      return response.data["secure_url"];
    } catch (e) {
      print(e);
    }
  }
}

class HomeResources {

  var baseUrl = "https://south-fitness.herokuapp.com";
  Dio dio;
  SharedPreferences prefs;

  HomeResources() {
    dio = Dio();
  }

  getVideos() async {
    var result = await dio.get(baseUrl + "/videos/all/");
    var videos = result.data;
    print("------------------------ $videos");

    return videos;
  }

  getTodayActivities(user_id) async {
    print("User ID------------------------ $user_id");
    var result = await dio.get(baseUrl + "/challenge/today/$user_id");
    var challenges = result.data;

    print("Challenge Data ------------------------ $challenges");
    return challenges;
  }

  getVideoCallDetails(videoId, channelName) async {
    var random = new Random();
    var uid = random.nextInt(1000000) + 1000;
    print("-------videoId----------------- $videoId");
    var result = await dio.post(baseUrl + "/videos/access_token/", data: {
      "channel_name": channelName,
      "video_id": videoId,
      "username": uid
    });
    var videoCall = result.data;

    print("-------videos----------------- $videoCall");
    return {"video": videoCall, "uid": uid};
  }

  updateVideoViews(videoData) async {
    try {
      var viewed = await dio.put(
          baseUrl + "/videos/",
          data: videoData);
      var result = viewed.data;
      print("------------------------ $result");
      if (result["status"] == "success") {
        return {"success": true};
      } else {
        return {"success": false};
      }
    } catch (e) {
      return {"success": false};
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
      print("------------------------ $result");
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
      print("------------------------ $result");
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
    print("Challenge data: $challengeData");
    try {
      var user = await dio.post(
        baseUrl + "/challenge/",
        data: challengeData,
      ).onError((error, stackTrace){
        print("Error is: $error");
        return;
      });
      var result = user.data;
      print("Challenge Post response data: $result");

      if (result["status"] == "success") {
        return {"success": true, "payload": result, "status": 200};
      } else{

        return {"success": false, "payload": {}, "status": 401};
      }
    } catch (e) {
      return {"success": false, "payload": {}, "status": 400};
    }
  }

  joinChallenge(challengeData) async {
    print("---------------------- e");
    try {
      var user = await dio.post(
        baseUrl + "/challenge/join/",
        data: challengeData,
      );
      var result = user.data;
      return result["state"];

    } catch (e) {
      print("---------------------- $e");
      return false;
    }
  }

  joinConfirmChallenge(challengeData) async {
    try {
      var user = await dio.put(
        baseUrl + "/challenge/join/",
        data: challengeData,
      );
      var result = user.data;

      return result["state"];

    } catch (e) {
      return false;
    }
  }
}

class PerformanceResource {

  var baseUrl = "https://south-fitness.herokuapp.com";
  Dio dio;
  SharedPreferences prefs;

  PerformanceResource() {
    dio = Dio();
  }

  var teams = [];
  var leaders = [];

  getPerformance() async {
    try {
      var perform = await dio.get(
        baseUrl + "/challenge/members/"
      );
      var result = perform.data;
      return result["members_list"] ;
    } catch (e) {
      return [];
    }
  }

  getDashboardPerformance(var email) async {
    var result = await dio.get(baseUrl + "/challenge/$email");
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

    return {"distance": distanceCovered, "calories": caloriesBurnt, "steps": stepsCount};
  }

  getIndividualPerformance(department) async {
    try {
      var perform = await dio.put(
        baseUrl + "/challenge/members/",
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
    print("---------userId-------------------------$userId");
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
}

class ChatService{

  Dio dio;
  var baseUrl = "https://south-fitness.herokuapp.com";
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

    print("---------- $result");

    if (result["status"]) {
      return {"success": true};
    } else {
      return {"success": false};
    }
  }


}