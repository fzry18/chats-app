import 'package:get/get.dart';

import '../models/chats_model.dart';

class ChatsModelProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return ChatsModel.fromJson(map);
      if (map is List)
        return map.map((item) => ChatsModel.fromJson(item)).toList();
    };
    httpClient.baseUrl = 'YOUR-API-URL';
  }

  Future<ChatsModel?> getChatsModel(int id) async {
    final response = await get('chatsmodel/$id');
    return response.body;
  }

  Future<Response<ChatsModel>> postChatsModel(ChatsModel chatsmodel) async =>
      await post('chatsmodel', chatsmodel);
  Future<Response> deleteChatsModel(int id) async =>
      await delete('chatsmodel/$id');
}
