import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:voice_to_text/Constant/ApiConstants.dart';

class API {
  Future SignInAPI(String email, String password) async {
    final uri = Uri.parse(APIConstants.BaseURL + APIConstants.SignIn);
    final headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {"email": email, "password": password};
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');

    Response response = await post(
      uri,
      headers: headers,
      body: jsonBody,
      encoding: encoding,
    );
    return response;
  }

  Future<Response> SignUpAPI(
      String firstName,
      String lastName,
      String dob,
      String email,
      String password,
      String gender,
      String location,
      String city,
      String nationality) async {
    final uri = Uri.parse(APIConstants.BaseURL + APIConstants.SignUp);
    final headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {
      "firstName": firstName,
      "lastName": lastName,
      "dob": dob,
      "email": email,
      "phone": APIConstants.Phone,
      "password": password,
      "gender": gender,
      "location": location,
      "city": city,
      "nationality": nationality
    };
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');

    Response response = await post(
      uri,
      headers: headers,
      body: jsonBody,
      encoding: encoding,
    );
    return response;
  }

  Future<Response> ForgotPasswordAPI(String email) async {
    final uri = Uri.parse(APIConstants.BaseURL + APIConstants.ForgotPassword);
    final headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {
      "email": email,
    };
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');

    Response response = await post(
      uri,
      headers: headers,
      body: jsonBody,
      encoding: encoding,
    );
    return response;
  }

  Future<Response> ResetPasswordAPI(
      String email, String password, String confirmPassword) async {
    final uri = Uri.parse(APIConstants.BaseURL + APIConstants.ResetPassword);
    final headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {
      "email": email,
      "password": password,
      "confirmPassword": confirmPassword,
    };
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');

    Response response = await post(
      uri,
      headers: headers,
      body: jsonBody,
      encoding: encoding,
    );
    return response;
  }

  Future<Response> SendOTP(String email) async {
    final uri = Uri.parse(APIConstants.BaseURL + APIConstants.SendOTP);
    final headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {
      "email": email,
    };
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');

    Response response = await post(
      uri,
      headers: headers,
      body: jsonBody,
      encoding: encoding,
    );
    return response;
  }

  Future<Response> VerifyOTP(String email,String otp) async {
    final uri = Uri.parse(APIConstants.BaseURL + APIConstants.VerifyOTP);
    final headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {
      "email":email,
      "otp":otp
    };
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');

    Response response = await post(
      uri,
      headers: headers,
      body: jsonBody,
      encoding: encoding,
    );
    return response;
  }
}
