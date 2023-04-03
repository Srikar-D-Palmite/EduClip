import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications',style:TextStyle(color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black)),
                iconTheme: IconThemeData(color:Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        centerTitle: true,
        foregroundColor: Colors.black,
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Align(
            alignment: Alignment.topLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.person),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Follow Requests",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Today",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      children: [
                        CircleAvatar(
                          child: Text("A"),
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.orange,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text.rich(TextSpan(
                            text: 'Alice ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            children: <InlineSpan>[
                              TextSpan(
                                text: 'started following you',
                              )
                            ])),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      "Yesterday",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: 25,
                        ),
                        Row(
                          children: [
                            CircleAvatar(
                              child: Text("P"),
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.red,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text.rich(TextSpan(
                                text: 'Patrick ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                                children: <InlineSpan>[
                                  TextSpan(
                                    text: 'commented on your video',
                                  )
                                ])),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      "This Week",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      "This Month",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      "Earlier",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                Row(
                  children: [
                    Icon(Icons.favorite),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Likes",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
