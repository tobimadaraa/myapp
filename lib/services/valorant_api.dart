import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_2/models/leaderboard_model.dart';

class RiotApiService {
  static const String apiKey = "RGAPI-1c4f2600-c7f1-4753-9db5-0be9c788badd";
  static const String baseUrl =
      "https://eu.api.riotgames.com"; // Change region if needed

  // Function to fetch current Act ID
  Future<String> getCurrentActId() async {
    final url = Uri.parse('$baseUrl/val/content/v1/contents');

    final response = await http.get(
      url,
      headers: {
        'X-Riot-Token': apiKey,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final acts = data['acts'];

      // Find the act where "isActive": true
      final currentAct =
          acts.firstWhere((act) => act['isActive'] == true, orElse: () => null);

      if (currentAct != null) {
        return currentAct['id'];
      } else {
        throw Exception("No active Act found.");
      }
    } else {
      throw Exception("Failed to fetch Act ID: ${response.statusCode}");
    }
  }

  // Function to fetch leaderboard using the current Act ID
  Future<List<LeaderboardModel>> getLeaderboard() async {
    String actId = await getCurrentActId(); // Fetch Act ID dynamically

    final url =
        Uri.parse('$baseUrl/val/ranked/v1/leaderboards/by-act/$actId?size=200');

    final response = await http.get(
      url,
      headers: {
        'X-Riot-Token': apiKey,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> players = data['players'];

      return players
          .map((player) => LeaderboardModel.fromJson(player))
          .toList();
    } else {
      throw Exception("Failed to fetch leaderboard: ${response.statusCode}");
    }
  }
}
