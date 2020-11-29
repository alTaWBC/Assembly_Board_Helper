class Voting {
  List<String> options;
  List<String> voters;
  List<String> missing;
  List<String> complete;

  Voting(this.options, this.voters, this.missing, this.complete);

  Voting.fromJson(Map<String, dynamic> json)
      : options = json['options'],
        voters = json['voters'],
        missing = json['missing'],
        complete = json['complete'];

  Map<String, dynamic> toJson() => {
        'options': options,
        'voters': voters,
        'missing': missing,
        'complete': complete,
      };
}
