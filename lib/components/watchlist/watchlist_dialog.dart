import 'package:anima_list/enum/list_status_enum.dart';
import 'package:anima_list/models/anime_model.dart';
import 'package:anima_list/theme/colors.dart';
import 'package:flutter/material.dart';

class WatchlistDialog extends StatefulWidget {
  final Anime anime;
  final int initialRating;
  final int initialWatchedEpisodes;
  final ListStatus initialListStatus;
  final Function(int newRating, int newWatchedEpisodes, ListStatus newListStatus) onSave;

  const WatchlistDialog({
    super.key,
    required this.anime,
    required this.initialRating,
    required this.initialWatchedEpisodes,
    required this.initialListStatus,
    required this.onSave,
  });

  @override
  State<WatchlistDialog> createState() => _WatchlistDialogState();
}

class _WatchlistDialogState extends State<WatchlistDialog> {
  late int rating;
  late int watchedEpisodes;
  late ListStatus listStatus;

  @override
  void initState() {
    super.initState();
    rating = widget.initialRating;
    watchedEpisodes = widget.initialWatchedEpisodes;
    listStatus = widget.initialListStatus;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                widget.anime.pictureUrl,
                width: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                widget.anime.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 10),
            const Text('Rating:'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    if (rating > 1) {
                      setState(() {
                        rating = rating - 1;
                      });
                    }
                  },
                ),
                Container(
                  width: 60.0,
                  height: 32.0,
                  margin: const EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.lightPrimaryColor),
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Text(
                      '$rating',
                      style: const TextStyle(
                        color: AppColors.lightPrimaryColor,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    if (rating < 10) {
                      setState(() {
                        rating = rating + 1;
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text('Watched Episodes:'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    if (watchedEpisodes > 0) {
                      setState(() {
                        watchedEpisodes = watchedEpisodes - 1;
                      });
                    }
                  },
                ),
                Container(
                  width: 60.0,
                  height: 32.0,
                  margin: const EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.lightPrimaryColor),
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Text(
                      '$watchedEpisodes / ${widget.anime.episodes}',
                      style: const TextStyle(
                        color: AppColors.lightPrimaryColor,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    if (watchedEpisodes < widget.anime.episodes) {
                      setState(() {
                        watchedEpisodes = watchedEpisodes + 1;
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text('List Status:'),
            const SizedBox(height: 10),
            DropdownButton<String>(
              menuMaxHeight: 160,
              value: listStatus.toFirestoreString(),
              items: ListStatus.values.map((ListStatus value) {
                return DropdownMenuItem<String>(
                  value: value.toFirestoreString(),
                  child: Text(value.toReadableString()),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  listStatus = ListStatusExtension.fromString(value!);
                });
              },
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    widget.onSave(rating, watchedEpisodes, listStatus);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
