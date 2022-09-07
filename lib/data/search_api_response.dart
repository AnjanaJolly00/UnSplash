import 'dart:convert';

class SearchApiResponse {
  int total;
  int totalPages;
  List<SearchResults>? searchResults;

  SearchApiResponse(
      {required this.searchResults,
      required this.total,
      required this.totalPages});

  factory SearchApiResponse.fromJson(String str) =>
      SearchApiResponse.fromJson(json.decode(str));

  factory SearchApiResponse.fromMap(
          Map<String, dynamic> json) =>
      SearchApiResponse(
          searchResults: json['results'] == null
              ? null
              : List<SearchResults>.from(
                  json['results'].map((x) => SearchResults.fromMap(x))),
          total: json['total'],
          totalPages: json['total_pages']);
}

class SearchResults {
  String? id;
  Url? url;
  int? height;
  int? width;

  SearchResults(
      {required this.height,
      required this.id,
      required this.url,
      required this.width});

  factory SearchResults.fromMap(Map<String, dynamic> json) => SearchResults(
      id: json["id"] == null ? null : json['id'],
      url: json["urls"] == null ? null : Url.fromMap(json['urls']),
      height: json["height"] == null ? null : json['height'],
      width: json["width"] == null ? null : json['width']);
}

class Url {
  String? rawUrl;
  String? fullUrl;
  String? thumbUrl;
  Url({required this.fullUrl, required this.rawUrl, required this.thumbUrl});

  factory Url.fromMap(Map<String, dynamic> url) => Url(
        fullUrl: url['full'] == null ? null : url['full'],
        rawUrl: url['raw'] == null ? null : url['raw'],
        thumbUrl: url['thumb'] == null ? null : url['thumb'],
      );
}
