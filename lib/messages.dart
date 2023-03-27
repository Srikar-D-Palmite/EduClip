import 'package:flutter/material.dart';

class MessagesPage extends StatelessWidget {
  final List<Map<String, String>> _messages = [
    {'sender': 'Alice', 'message': 'Hi there!'},
    {'sender': 'Bob', 'message': 'How are you?'},
    {'sender': 'Charlie', 'message': 'What are you up to?'},
    {'sender': 'Michael', 'message': 'Do you want to hang out later?'},
    {'sender': 'Jason', 'message': 'I have some news to share!'},
    {'sender': 'Johnson', 'message': 'Can we talk about something?'},
    {'sender': 'Tom', 'message': 'Did you see the new movie yet?'},
    {'sender': 'Ryan', 'message': 'Let me know if you need anything!'},
    {'sender': 'Jake', 'message': 'Thanks for the help!'},
    {'sender': 'Chris', 'message': 'You really are the best!'}
  ];
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(height: 12.0),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    'Messages',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  // The word "search" in the searchbox
                  hintText: 'Search Messages',
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                    // fontWeight: FontWeight.w500,
                  ),
                  // the search icon
                  prefixIcon: const Icon(Icons.search),
                  prefixIconColor: Colors.black,
                  // the delete text icon
                  suffixIcon: IconButton(
                    onPressed: _controller.clear,
                    icon: const Icon(Icons.close),
                    iconSize: 18,
                  ),
                  suffixIconColor: Colors.black,
                  // padding around the text (affects the size of the searchbox)
                  contentPadding: const EdgeInsets.all(5.0),
                  // defining the border normally, and when focused (pressed on)
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      // width: 3,
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      // width: 3,
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
                // border: InputBorder.none,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text(
                        _messages[index]["sender"]![0],
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(
                      _messages[index]["sender"]!,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      _messages[index]["message"]!,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Text(
                      '8:32 PM',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12.0,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
