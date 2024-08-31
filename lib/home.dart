import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../model/wallpaper_model.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Wallpaper> wallpaperList = [];
  final ScrollController _scrollController = ScrollController();
  int _page = 1;
  bool _isLoading = false;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  final List<String> categories = [
    'Nature',
    'Animals',
    'City',
    'Travel',
    'Food',
    'Abstract',
  ];

  @override
  void initState() {
    super.initState();
    _getTrendingWallpapers();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _getTrendingWallpapers() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final url = Uri.parse("https://api.pexels.com/v1/curated?page=$_page");
      var response = await http.get(
        url,
        headers: {
          "Authorization": "gkWIpqBkP3zDOVPhsBR88VjsIJt9j3e130VBJKGLED2q86EDxsWb0j0I",
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        List<Wallpaper> tempList = [];
        jsonData["photos"].forEach((element) {
          Wallpaper wallpaper = Wallpaper.fromJson(element);
          tempList.add(wallpaper);
        });
        setState(() {
          wallpaperList.addAll(tempList);
          _page++;
        });
      } else {
        print("Failed to fetch wallpapers: ${response.statusCode}");
      }
    } catch (error) {
      print("An error occurred: $error");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _searchWallpapers(String query) async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
      wallpaperList.clear();
      _page = 1;
    });

    try {
      final url = Uri.parse("https://api.pexels.com/v1/search?query=$query&page=$_page");
      var response = await http.get(
        url,
        headers: {
          "Authorization": "gkWIpqBkP3zDOVPhsBR88VjsIJt9j3e130VBJKGLED2q86EDxsWb0j0I",
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        List<Wallpaper> tempList = [];
        jsonData["photos"].forEach((element) {
          Wallpaper wallpaper = Wallpaper.fromJson(element);
          tempList.add(wallpaper);
        });
        setState(() {
          wallpaperList.addAll(tempList);
          _page++;
        });
      } else {
        print("Failed to search wallpapers: ${response.statusCode}");
      }
    } catch (error) {
      print("An error occurred: $error");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _getTrendingWallpapers();
    }
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _getTrendingWallpapers();
      }
    });
  }

  void _performSearch(String query) {
    _searchWallpapers(query);
  }

  void _onCategoryTap(String category) {
    _searchWallpapers(category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: _isSearching
            ? TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search Wallpaper',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white54),
          ),
          style: const TextStyle(color: Colors.white),
          autofocus: true,
          onSubmitted: _performSearch,
        )
            : const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Wallpaper', style: TextStyle(fontWeight: FontWeight.bold)),
            Text("Hub", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: _toggleSearch,
          ),
        ],
        elevation: 0.0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Container(
            height: 50.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      _onCategoryTap(categories[index]);
                    },
                    child: Chip(
                      label: Text(categories[index]),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: <Widget>[
              SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 5.0,
                ),
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: GestureDetector(
                        onTap: () {
                          // Replace with the action you want to perform on tap
                        },
                        child: GridTile(
                          child: Hero(
                            tag: wallpaperList[index].src.portrait,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                wallpaperList[index].src.portrait,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(
                                    child: Icon(Icons.error),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: wallpaperList.length,
                ),
              ),
            ],
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
