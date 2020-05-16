import 'package:flutter/material.dart';
import 'package:flutternews/helper/news.dart';
import 'package:flutternews/models/article_model.dart';
import 'package:flutternews/views/article_view.dart';

class CategoryView extends StatefulWidget {
  final String category;

  CategoryView({this.category});

  @override
  _CategoryViewState createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  List<ArticleModel> articleList = new List<ArticleModel>();
  bool _loading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadArticlesByCategory();
  }

  loadArticlesByCategory() async {
    CategoryNews CategoryNewsClass = CategoryNews();
    await CategoryNewsClass.getNews(widget.category);
    articleList = CategoryNewsClass.news;

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("category name ${widget.category}");
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("${widget.category}'s "),
            Text(
              "News",
              style: TextStyle(
                color: Colors.blue,
              ),
            )
          ],
        ),
        centerTitle: true,
        elevation: 6.0,
      ),
      body: _loading
          ? Center(
              child: Container(
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: articleList.length,
                    itemBuilder: (context, index) {
                      return BlogTile(
                        imageUrl: articleList[index].urlToImage,
                        title: articleList[index].title ?? "",
                        desc: articleList[index].description ?? "",
                        url: articleList[index].url,
                      );
                    }),
              ),
            ),
    );
  }
}

class BlogTile extends StatelessWidget {
  final String imageUrl, title, desc, url;

  BlogTile(
      {@required this.imageUrl,
      @required this.title,
      @required this.desc,
      @required this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ArticleView(
                      blogUrl: url,
                    )));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        child: Column(
          children: <Widget>[
            ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.fill,
                  height: 150.0,
                  width: MediaQuery.of(context).size.width,
                )),
            SizedBox(height: 8),
            Text(title,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                )),
            SizedBox(height: 8),
            Text(desc,
                style: TextStyle(
                  color: Colors.black54,
                ))
          ],
        ),
      ),
    );
  }
}
