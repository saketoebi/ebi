import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;

class HomeEntry {
  final String title;
  final int id;
  final List<int> tags;
  final String thumbnailUrl;

  HomeEntry({
    required this.title,
    required this.id,
    required this.tags,
    required this.thumbnailUrl,
  });
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<HomeEntry>> futureHomeEntries;
  late Future<List<HomeEntry>> newHomeEntries;

  Future<List<HomeEntry>> popular() async {
    final response = await http.get(Uri.parse('https://nhentai.net/'));
    final responseDocument = html.parse(response.bodyBytes);
    final contentElement = responseDocument.getElementById('content')!;
    final popularNowElements = contentElement.getElementsByClassName('index-popular').first.getElementsByClassName('gallery');

    return <HomeEntry>[
      for (final popularElement in popularNowElements)
        HomeEntry(
          title: popularElement.getElementsByClassName('caption').first.text,
          id: 0, // popularElement.getElementsByTagName('a').first.attributes['href']
          tags: popularElement.attributes['data-tags']!.split(' ').map((tag) => int.parse(tag)).toList(),
          thumbnailUrl: popularElement.getElementsByClassName('lazyload').first.attributes['data-src']!,
        ),
    ];
  }

  Future<List<HomeEntry>> newUploads() async {
    final response = await http.get(Uri.parse('https://nhentai.net/'));
    final responseDocument = html.parse(response.bodyBytes);
    final contentElement = responseDocument.getElementById('content')!;
    final popularNowElements = contentElement.getElementsByClassName('index-container')[1].getElementsByClassName('gallery');

    return <HomeEntry>[
      for (final popularElement in popularNowElements)
        HomeEntry(
          title: popularElement.getElementsByClassName('caption').first.text,
          id: 0, // popularElement.getElementsByTagName('a').first.attributes['href']
          tags: [],
          thumbnailUrl: popularElement.getElementsByClassName('lazyload').first.attributes['data-src']!,
        ),
    ];
  }

  @override
  void initState() {
    futureHomeEntries = popular();
    newHomeEntries = newUploads();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: ListView(
          children: [
            FutureBuilder<List<HomeEntry>>(
              future: futureHomeEntries,
              builder: (BuildContext context, AsyncSnapshot<List<HomeEntry>> snapshot) {
                return SizedBox(
                  height: 300.0,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    children: [
                      for (final entry in snapshot.data ?? [])
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AspectRatio(
                            aspectRatio: 300 / 450,
                            child: Material(
                              borderRadius: BorderRadius.circular(16.0),
                              clipBehavior: Clip.antiAlias,
                              child: Ink.image(
                                image: NetworkImage(entry.thumbnailUrl),
                                fit: BoxFit.cover,
                                child: InkWell(
                                  onTap: () {},
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
            FutureBuilder<List<HomeEntry>>(
              future: newHomeEntries,
              builder: (BuildContext context, AsyncSnapshot<List<HomeEntry>> snapshot) {
                return SizedBox(
                  height: 300.0,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    children: [
                      for (final entry in snapshot.data ?? [])
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AspectRatio(
                            aspectRatio: 300 / 450,
                            child: Material(
                              borderRadius: BorderRadius.circular(16.0),
                              clipBehavior: Clip.antiAlias,
                              child: Ink.image(
                                image: NetworkImage(entry.thumbnailUrl),
                                fit: BoxFit.cover,
                                child: InkWell(
                                  onTap: () {},
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
            TextButton(
              onPressed: () {
                popular();
              },
              child: Text('Reload'),
            ),
          ],
        ),
      );
}
