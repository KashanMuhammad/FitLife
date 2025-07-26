class BlogModel {
  final String id;
  final String title;
  final String author;
  final String date;
  final String views;
  final String time;
  final String imagePath;
  BlogModel({
    required this.id,
    required this.title,
    required this.author,
    required this.date,
    required this.views,
    required this.time,
    required this.imagePath,
  });
}

List<BlogModel> blogs = [
  BlogModel(id: 'blog1', title: '10 kg Weight lose', author: 'Dasteen', date: 'Jan 10, 2024', views: '3', time: '3 mins', imagePath: 'assets/images/blogsPicture.png'),
  BlogModel(id: 'blog1', title: '10 kg Weight lose', author: 'Dasteen', date: 'Jan 10, 2024', views: '3', time: '3 mins', imagePath: 'assets/images/blogsPicture.png'),
  BlogModel(id: 'blog1', title: '10 kg Weight lose', author: 'Dasteen', date: 'Jan 10, 2024', views: '3', time: '3 mins', imagePath: 'assets/images/blogsPicture.png'),
  BlogModel(id: 'blog1', title: '10 kg Weight lose', author: 'Dasteen', date: 'Jan 10, 2024', views: '3', time: '3 mins', imagePath: 'assets/images/blogsPicture.png'),


  //BlogModel(id: 'blog2', title: '10 kg Weight lose', author: 'Dasteen', date: 'Jan 10, 2024', views: '3', time: '3 mins'),
];
