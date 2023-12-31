import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../db/config.dart';

class FavouriteList extends StatefulWidget {
  final dynamic user;

  FavouriteList({
    required this.user,
  });

  @override
  _FavouriteListState createState() => _FavouriteListState();
}

class _FavouriteListState extends State<FavouriteList> {
  List<dynamic> songs = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    print(widget.user);
    var userId = widget.user?['_id'];
    var reqbody = {"userId": userId};
    var response = await http.post(
      Uri.parse('$uri/user/getfavouritesongs'),
      headers: {"Content-type": "application/json"},
      body: jsonEncode(reqbody),
    );

    var res = jsonDecode(response.body);
    setState(() {
      songs = res['songs'];
    });
    // print(res);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: songs.length,
            itemBuilder: (BuildContext context, int i) {
              final item = songs[i];

              return Container(
                margin: EdgeInsets.only(top: 15, right: 12, left: 5),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                  color: Color(0xFF30314D),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () async {
                        var reqbody = {
                          "songId": item?['_id'],
                          "userId": widget.user['_id'],
                        };

                        try {
                          var response = await http.post(
                            Uri.parse('$uri/user/isfavourite'),
                            headers: {
                              "Content-type": "application/json",
                            },
                            body: jsonEncode(reqbody),
                          );

                          if (response.statusCode == 201) {
                            var res = jsonDecode(response.body);
                            bool isFavourite = res['isFavourite'];

                            Navigator.pushNamed(
                              context,
                              "musicPage",
                              arguments: {
                                "item": item,
                                "isFavourite": isFavourite,
                              },
                            );
                          } else {
                            var res = jsonDecode(response.body);
                            print(res['error']);
                            // Handle the error case if needed.
                          }
                        } catch (error) {
                          print("Error: $error");
                          // Handle any unexpected errors here.
                        }
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          item['imageUrl'],
                          fit: BoxFit.cover,
                          height: 60,
                          width: 60,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 25,
                    ),
                    GestureDetector(
                      onTap: () async {
                        var reqbody = {
                          "songId": item['_id'],
                          "userId": widget.user['_id'],
                        };

                        try {
                          var response = await http.post(
                            Uri.parse('$uri/user/isfavourite'),
                            headers: {
                              "Content-type": "application/json",
                            },
                            body: jsonEncode(reqbody),
                          );

                          if (response.statusCode == 201) {
                            var res = jsonDecode(response.body);
                            bool isFavourite = res['isFavourite'];

                            Navigator.pushNamed(
                              context,
                              "musicPage",
                              arguments: {
                                "item": item,
                                "isFavourite": isFavourite,
                              },
                            );
                          } else {
                            var res = jsonDecode(response.body);
                            print(res['error']);
                            // Handle the error case if needed.
                          }
                        } catch (error) {
                          print("Error: $error");
                          // Handle any unexpected errors here.
                        }
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${item['title']}",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                "${item['singer']}",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Spacer(),
                    Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(
                        Icons.play_arrow,
                        size: 25,
                        color: Color(0xff31314f),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}