import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "COBA PLAYLIST",
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: new MyDrawer(),
      appBar: new AppBar(backgroundColor: Colors.red),
      body: new Container(
        decoration: new BoxDecoration(
            image: new DecorationImage(
                image: new AssetImage("images/metube.png"), fit: BoxFit.cover)),
        child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(
                " ",
                style: new TextStyle(
                    fontSize: 25.0, fontFamily: "Pacifico", color: Colors.red),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: SingleChildScrollView(
        child: new Column(
          children: <Widget>[
            new Padding(padding: const EdgeInsets.all(20.0)),
            new ListTile(
              leading: new Icon(Icons.home),
              title: new Text(
                "HOME",
                style: new TextStyle(fontSize: 18.0),
              ),
            ),
            new Divider(),
            new ListTile(
              leading: new Icon(Icons.video_library),
              title: new Text(
                "PLAYLIST Metube",
                style: new TextStyle(fontSize: 18.0),
              ),
              onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => new ListVideo(
                        url: "https://flcoba.herokuapp.com/",
                        title: "MeTube Player",
                      ))),
            ),
            new Divider(),
            new ListTile(
              leading: new Icon(Icons.video_library),
              title: new Text(
                "CODE",
                style: new TextStyle(fontSize: 18.0),
              ),
              onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => new ListVideo(
                        url: "https://cookinglist.herokuapp.com/",
                        title: "CODE",
                      ))),
            ),
          ],
        ),
      ),
    );
  }
}

class ListVideo extends StatefulWidget {
  final String title;
  final String url;
  ListVideo({this.title, this.url});
  @override
  _ListVideoState createState() => _ListVideoState();
}

class _ListVideoState extends State<ListVideo> {
  Future<List> getData() async {
    final response = await http.get(widget.url);
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: new Text(widget.title),
      ),
      drawer: new MyDrawer(),
      body: new FutureBuilder<List>(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? new PlayListVideo(
                  list: snapshot.data,
                )
              : new CircularProgressIndicator();
        },
      ),
    );
  }
}

class PlayListVideo extends StatelessWidget {
  final List list;
  PlayListVideo({this.list});
  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (context, i) {
        return new Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              new GestureDetector(
                onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => new VideoPlay(
                          url:
                              "https://youtube.com/embed/${list[i]['contentDetails']['videoId']}",
                        ))),
                child: new Container(
                  height: 210.0,
                  decoration: new BoxDecoration(
                      image: new DecorationImage(
                          image: new NetworkImage(
                              list[i]['snippet']['thumbnails']['high']['url']),
                          fit: BoxFit.cover)),
                ),
              ),
              new Padding(padding: const EdgeInsets.all(10.0)),
              new Text(
                list[i]['snippet']['title'],
                style: new TextStyle(fontSize: 18.0),
              ),
              new Padding(padding: const EdgeInsets.all(10.0)),
              new Divider(),
            ],
          ),
        );
      },
    );
  }
}

class VideoPlay extends StatelessWidget {
  final String url;
  VideoPlay({this.url});

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new WebviewScaffold(
        url: url,
      ),
    );
  }
}
