
class Movie{
   String title;
   String name;
   String overview;
   String backdrop_path;
   String poster_path;
   String release_date;
   double vote_average;
    int vote_count;
   Movie({
    required this.title,
    required this.name,
    required this.overview,
    required this.backdrop_path,
    required this.poster_path,
    required this.release_date,
    required this.vote_average,
    required this.vote_count,
   });

   factory Movie.fromJson(Map<String,dynamic>json){
    return Movie(
      title: json['title']??" ", 
      name: json['name']??"",
      overview: json['overview'] ??" ", 
      backdrop_path: json['backdrop_path']??" ", 
      poster_path: json['poster_path']??" ", 
      release_date: json['release_date']??" ", 
      vote_average: json['vote_average']??" ",
      vote_count: json['vote_count']??" ",
      );
   }

}
// "results": [
//     {
//       "adult": false,
//       "backdrop_path": "/417tYZ4XUyJrtyZXj7HpvWf1E8f.jpg",
//       "genre_ids": [16, 878, 10751],
//       "id": 1184918,
//       "original_language": "en",
//       "original_title": "The Wild Robot",
//       "overview": "After a shipwreck, an intelligent robot called Roz is stranded on an uninhabited island. To survive the harsh environment, Roz bonds with the island's animals and cares for an orphaned baby goose.",
//       "popularity": 5113.594,
//       "poster_path": "/9w0Vh9eizfBXrcomiaFWTIPdboo.jpg",
//       "release_date": "2024-09-12",
//       "title": "The Wild Robot",
//       "video": false,
//       "vote_average": 8.646,
//       "vote_count": 744
//     },



// "results": [
//     {
//       "backdrop_path": "/bFVx0ydejF6NE8SEAVz95ns0o6A.jpg",
//       "id": 34307,
//       "name": "Shameless",
//       "original_name": "Shameless",
//       "overview": "Chicagoan Frank Gallagher is the proud single dad of six smart, industrious, independent kids, who without him would be... perhaps better off. When Frank's not at the bar spending what little money they have, he's passed out on the floor. But the kids have found ways to grow up in spite of him. They may not be like any family you know, but they make no apologies for being exactly who they are.",
//       "poster_path": "/9akij7PqZ1g6zl42DQQTtL9CTSb.jpg",
//       "media_type": "tv",
//       "adult": false,
//       "original_language": "en",
//       "genre_ids": [18, 35],
//       "popularity": 574.765,
//       "first_air_date": "2011-01-09",
//       "vote_average": 8.2,
//       "vote_count": 2694,
//       "origin_country": [
//         "US"
//       ]
//     },