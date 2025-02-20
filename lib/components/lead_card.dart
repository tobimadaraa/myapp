import 'package:flutter/material.dart';
import 'package:flutter_application_2/shared/classes/colour_classes.dart';
import 'package:intl/intl.dart';

class LeadCard extends StatefulWidget {
  final String? rating;
  final String? numberOfWins;
  final String text;
  final String leaderboardname;
  final String reportLabel;
  final String cheaterReports;
  final String toxicityReports;
  final Color backgroundColor;
  final bool isFamous; // New flag: indicates whether to display a star icon
  final List<String> lastReported;

  const LeadCard({
    super.key,
    required this.text,
    this.rating,
    this.numberOfWins,
    required this.leaderboardname,
    required this.reportLabel,
    required this.cheaterReports,
    required this.toxicityReports,
    required this.backgroundColor,
    required this.isFamous,
    required this.lastReported,
    required String honourReports,
  });

  @override
  LeadCardState createState() => LeadCardState();
}

class LeadCardState extends State<LeadCard> {
  bool isExpanded = false;

  // Helper to format timestamps.
  String _formatTimestamp(String timestamp) {
    try {
      DateTime dateTime = DateTime.parse(timestamp);
      return DateFormat('MMM d, y h:mm a').format(dateTime);
    } catch (e) {
      return timestamp;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias, // ✅ Removes extra spacing
      color: widget.backgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, //
        children: [
          InkWell(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Row(
              children: [
                // Rank or rating.
                Expanded(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        Text(
                          '${widget.text})',
                          style: TextStyle(
                            color: CustomColours.whiteDiscordText,
                            fontSize: 16,
                          ),
                        ),
                        if (widget.rating !=
                            null) // ✅ Correctly conditionally showing rating
                          Text(
                            'RR: ${widget.rating ?? "N/A"}',
                            style: TextStyle(
                              color: CustomColours.whiteDiscordText,
                              fontSize: 14,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                // Username + Tagline with optional star for famous users.
                Expanded(
                  flex: 5,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.zero,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.leaderboardname,
                            style: TextStyle(
                              color: CustomColours.whiteDiscordText,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (widget.isFamous)
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                      ],
                    ),
                  ),
                ),
                // Report count (with label).
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerRight,
                    child: Column(
                      children: [
                        Text(
                          '${widget.reportLabel == "Toxicity Reports" ? widget.toxicityReports : widget.cheaterReports}\n${widget.reportLabel}',
                          style: TextStyle(
                            color: CustomColours.whiteDiscordText,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis,
                        ),
                        //    const SizedBox(height: 4),
                        Text(
                            'Wins: ${widget.numberOfWins ?? "N/A"}', // ✅ Fixed string formatting
                            style: TextStyle(
                              color: CustomColours.whiteDiscordText,
                              fontSize: 12,
                            )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Expanded section showing last reported times.
          if (isExpanded)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Last Reported Times:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: CustomColours.whiteDiscordText,
                  ),
                ),
                ...widget.lastReported.map(
                  (time) => Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: Text(
                      "• ${_formatTimestamp(time)}",
                      style: TextStyle(
                        color: CustomColours.whiteDiscordText,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
