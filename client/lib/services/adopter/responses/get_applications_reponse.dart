import 'package:json_annotation/json_annotation.dart';
import 'package:pet_share/applications/application.dart';

part 'get_applications_reponse.g.dart';

@JsonSerializable()
class GetApplicationsResponse {
  final List<Application> applications;
  final int pageNumber;
  final int count;

  GetApplicationsResponse(this.pageNumber, this.count, this.applications);

  Map<String, dynamic> toJson() => _$GetApplicationsResponseToJson(this);
  factory GetApplicationsResponse.fromJson(Map<String, dynamic> json) =>
      _$GetApplicationsResponseFromJson(json);
}
