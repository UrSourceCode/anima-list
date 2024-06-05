import 'package:flutter/material.dart';
import 'package:anima_list/enum/list_status_enum.dart';

class RatingDialog extends StatefulWidget {
  final String pictureUrl;
  final String title;
  final String status;
  final int? initialRating;
  final ListStatus? initialListStatus;
  final Function(int newRating, ListStatus newListStatus) onSave;

  const RatingDialog({
    Key? key,
    required this.pictureUrl,
    required this.title,
    required this.status,
    this.initialRating,
    this.initialListStatus,
    required this.onSave,
  }) : super(key: key);

  @override
  _RatingDialogState createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  late int? rating;
  late ListStatus? listStatus;

  @override
  void initState() {
    super.initState();
    rating = widget.initialRating ?? 1;
    listStatus = widget.initialListStatus;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: widget.pictureUrl != null
                  ? Image.network(
                widget.pictureUrl,
                width: 100,
                fit: BoxFit.cover,
              )
                  : const SizedBox(),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                widget.title,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Status:',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<ListStatus>(
              value: listStatus,
              decoration: InputDecoration(
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red.shade900),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              items: ListStatus.values.map((ListStatus status) {
                return DropdownMenuItem<ListStatus>(
                  value: status,
                  child: Text(status.toReadableString()),
                );
              }).toList(),
              onChanged: (ListStatus? newValue) {
                setState(() {
                  listStatus = newValue;
                });
              },
              style: const TextStyle(
                color: Colors.black87,
              ),
              dropdownColor: Colors.white,
            ),
            const SizedBox(height: 10),
            const Text(
              'Rating:',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    if (rating! > 1) {
                      setState(() {
                        rating = rating! - 1;
                      });
                    }
                  },
                ),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                  margin: const EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red),
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.white,
                  ),
                  child: Text(
                    '$rating',
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    if (rating! < 10) {
                      setState(() {
                        rating = rating! + 1;
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (listStatus != null && rating != null) {
                  widget.onSave(rating!, listStatus!);
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade900,
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: const Text(
                  'Update Watchlist',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
