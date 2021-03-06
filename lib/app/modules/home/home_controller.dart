import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';
import 'package:whichcar/app/model/PredictCar.dart';

part 'home_controller.g.dart';

class HomeController = _HomeBase with _$HomeController;

abstract class _HomeBase with Store {
  final dio = new Dio();

  @observable
  PredictCar whichCar;

  @observable
  bool loading = false;

  @action
  addImage(File file) async {
    loading = true;
    String filename = file.path.split('/').last;
    FormData formData = new FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path, filename: filename),
    });

    try {
      Response response = await dio
          .post('https://which-car-backend.herokuapp.com/car', data: formData);
      // Response response =
      //     await dio.post('http://10.0.2.2:3333/car', data: formData);
      whichCar = PredictCar.fromJson(response.data);
      loading = false;
    } catch (err) {
      print(err);
      loading = false;
    }
  }
}
