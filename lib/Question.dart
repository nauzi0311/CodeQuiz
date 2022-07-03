class Question<T> {
  int id = 0;
  String title;
  String question;
  String output;
  T answer;
  int exp;
  int point;
  int? restrict = 0;
  Question(this.id, this.title, this.question, this.output, this.answer,
      this.exp, this.point,
      {this.restrict});
}
