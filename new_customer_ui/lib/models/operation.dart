class Operation {
  late String day, start, end;

  Operation({
    this.day = '',
    this.start = '',
    this.end = ''
  });

  Operation.fromJson(Map<dynamic, dynamic> json, this.day) {
    start = json['start'];
    end = json['end'];
  }
}
