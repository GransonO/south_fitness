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
        return {"success": true, "payload": result, "status": 200};
      } else{
        // Unauthorised
        prefs.setString("email", result["user"]["email"]);
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

      "fullname": prefs.getString("fullname").trim(),
      "email": prefs.getString("email").trim(),
      "birthDate": prefs.getString("birthDate").trim(),
      "team": prefs.getString("team").trim(),
      "activation_code": prefs.getString("code").trim()
    };
    print("------------------------ $profileData");
    // dio.options.headers["Authorization"] = "Bearer ${prefs.getString("token")}";
    var profile = await dio.post(
        baseUrl + "/profiles/", data: profileData);
    var result = profile.data;
    print("------------------------ $result");
    if (result["status"] == "success") {
      return {"success": true, "payload": result["message"]};
    } else {
      return {"success": false, "payload": ""};
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
        return {"success": true};
      } else {
        return {"success": false};
      }
    } catch (e) {
      return {"success": false, "payload": []};
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

    return videos;
  }

  getVideoCallDetails(videoId) async {
    print("-------videoId----------------- $videoId");
    var result = await dio.get(baseUrl + "/videos/$videoId");
    var videos = result.data;

    print("-------videos----------------- $videos");
    return videos[0];
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
    try {
      var user = await dio.post(
        baseUrl + "/challenge/",
        data: challengeData,
      );
      var result = user.data;

      if (result["status"] == "success") {

        return {"success": true, "payload": result, "status": 200};
      } else{
        // Unauthorised
        return {"success": false, "payload": {}, "status": 401};
      }
    } catch (e) {
      return {"success": false, "payload": {}, "status": 400};
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
    var result = await dio.get(baseUrl + "/challenge/all/");
    List perform = result.data;
    var speed, agility, endurance, balance, flexibility, power, coordination;

    speed = sieveData(perform, "speed");
    agility = sieveData(perform, "agility");
    balance = sieveData(perform, "balance");
    flexibility = sieveData(perform, "flexibility");
    power = sieveData(perform, "power");
    coordination = sieveData(perform, "coordination");
    endurance = sieveData(perform, "endurance");

    List teamList = [
      {"name": "speed", "points": speed.length},
      {"name": "agility", "points": agility.length},
      {"name": "endurance", "points": endurance.length},
      {"name": "coordination", "points": coordination.length},
      {"name": "power", "points": power.length},
      {"name": "flexibility", "points": flexibility.length},
      {"name": "balance", "points": balance.length},
      ];
    teamList.sort((a,b) => (a["points"]).compareTo(b["points"]));

    print("ordered teams list ---------> $teamList");
    return {
      "team_list": (teamList.reversed).toList(),
      "speed": calculateUserPoints(speed.toList()),
      "agility": calculateUserPoints(agility.toList()),
      "endurance": calculateUserPoints(endurance.toList()),
      "power": calculateUserPoints(power.toList()),
      "flexibility": calculateUserPoints(flexibility.toList()),
      "coordination": calculateUserPoints(coordination.toList()),
      "balance": calculateUserPoints(balance.toList())
    };
  }

  sieveData(List performance, listName){
    return (performance.where((element) => element["team"] == listName));
  }

  calculateUserPoints(List team){
    var totalPoints = 0.0;
    team.forEach((element) {
      // Get all points
      var points = element["distance"] + element["steps_count"] + element["caloriesBurnt"];
      totalPoints = totalPoints + points;
    });

    team.forEach((element) {
      // get percentage for each element
      var points = element["distance"] + element["steps_count"] + element["caloriesBurnt"];
      var accruedPoints = ((points/totalPoints) * 100).round();

      element["user_points"] = accruedPoints;
    });

    return team;
  }

  getPersonalPerformance(var email) async {
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

  getUserHistory(userId) async {
    print("---------userId-------------------------$userId");
    var result = await dio.get(baseUrl + "/challenge/$userId");
    var history = result.data;

    return history.toList();
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

    print("chay --------------------- $result");
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

  allGroups() async {
    // get all group chats
    var chat = await dio.get(
        baseUrl + "/chats/all_groups/");
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
}