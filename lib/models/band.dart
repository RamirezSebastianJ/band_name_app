class Band {
  String id;
  String name;
  int votes;

  Band({required this.id, required this.name, required this.votes});

  factory Band.fromJson(Map<String, dynamic> json) => Band(
        id: json.containsKey('id') ? json['id'] : 'no-id',
        name: json.containsKey('name') ? json['name'] : 'no-name',
        votes: json.containsKey('votes') ? json['votes'] : 'no-votes',
      );
}
