import 'package:flutter/material.dart';

class MessagesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages'),
      ),
      body: ListView(
        children: <Widget>[
          Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage('https://picsum.photos/200'),
              ),
              title: Text('John Doe'),
              subtitle: Text('Hi, how are you?'),
              trailing: Text('2m'),
              onTap: () {
                // TODO: Navigate to chat screen
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage('https://picsum.photos/200'),
              ),
              title: Text('Jane Doe'),
              subtitle: Text('Check out my new post!'),
              trailing: Text('1h'),
              onTap: () {
                // TODO: Navigate to chat screen
              },
            ),
          ),
          // Add more message items here
        ],
      ),
    );
  }
}
