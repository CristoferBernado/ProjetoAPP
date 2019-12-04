class FaceDetect {
  final String faceId;

  // final FaceRetangle faceRetangle;

  FaceDetect({this.faceId});

  factory FaceDetect.fromJson(Map<String, dynamic> usersjson)=> FaceDetect(
      faceId: usersjson["faceId"],
      // faceRetangle: FaceRetangle.fromJson(usersjson['faceretangle'])
  );

}

class PersonalClient {
  String personId;

  PersonalClient({this.personId});

  PersonalClient.fromJson(Map<String, dynamic> json) {
    personId = json['personId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['personId'] = this.personId;
    return data;
  }
}

class FaceRetangle{

  final String top;
  final String left;
  final String width;
  final String height;

  FaceRetangle({this.top, this.left, this.width, this.height});

  factory FaceRetangle.fromJson(Map<String, dynamic> addjson){

    return FaceRetangle(
      top: addjson["top"],
      left:  addjson["left"],
      width: addjson["width"],
      height: addjson["height"]
    );
  }
}

// Teste de Classe feita com o json_to_dart //
class IdentifyFace {
  String faceId;
  List<Candidates> candidates;

  IdentifyFace({this.faceId, this.candidates});

  IdentifyFace.fromJson(Map<String, dynamic> json) {
    faceId = json['faceId'];
    if (json['candidates'] != null) {
      candidates = new List<Candidates>();
      json['candidates'].forEach((v) {
        candidates.add(new Candidates.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['faceId'] = this.faceId;
    if (this.candidates != null) {
      data['candidates'] = this.candidates.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Candidates {
  String personId;
  double confidence;

  Candidates({this.personId, this.confidence});

  Candidates.fromJson(Map<String, dynamic> json) {
    personId = json['personId'];
    confidence = json['confidence'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['personId'] = this.personId;
    data['confidence'] = this.confidence;
    return data;
  }
}
// ferramenta nova acaba aqui//


// class IdentifyFace {
//   final List<Candidates> candidatesNeed;

//   IdentifyFace({this.candidatesNeed});

//   factory IdentifyFace.fromJson(Map<String, dynamic> json){
//     return new IdentifyFace(
//       candidatesNeed: json["candidates"].map((value) => new Candidates.fromJson(value)).toList()
//     );
//   }
// }

// class Candidates {

//     final String personId;

//     Candidates({
//       this.personId
//     });

//     factory Candidates.fromJson(Map<String, dynamic> json){
//       return new Candidates(
//         personId: json["personId"]
//       );
//     }
// }