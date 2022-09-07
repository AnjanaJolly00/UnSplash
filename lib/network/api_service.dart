import 'package:dio/dio.dart';
import 'package:unsplash/data/api_response.dart';

class ApiService {
  final client = Dio();
  ApiResponse clientResponse = ApiResponse();
  String apiKey = "UH0hK4JDI9R6szCLNxafEhwG4sqcHaHJnSKi0ZSudd4";

  Future<ApiResponse> getSearchResults(searchValue, int pageNum) async {
    try {
      Options options = Options();
      options.method = "GET";
      var response = await client.getUri(
          Uri.parse(
              "https://api.unsplash.com/search/photos/?client_id=$apiKey&page=$pageNum&per_page=20&query=$searchValue"),
          options: options);

      clientResponse.code = response.statusCode;
      clientResponse.isSuccessful = true;
      clientResponse.rawResponse = response.data;
      //

    } on DioError catch (e) {
      clientResponse.errorMsg = e.response!.statusMessage;
      clientResponse.code = e.response!.statusCode;
      clientResponse.isSuccessful = false;
      clientResponse.rawResponse = e.response!.data;
    } catch (e) {
      clientResponse.errorMsg = e.toString();
    }
    return clientResponse;
  }
}
