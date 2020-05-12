class User {
  String login;
  String avatarUrl;
  String reposUrl;

  User({
    this.login,
    this.avatarUrl,
    this.reposUrl,
  });

  User.fromJson(Map<String, dynamic> json) {
    login = json['login'];
    avatarUrl = json['avatar_url'];
    reposUrl = json['repos_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['login'] = this.login;
    data['avatar_url'] = this.avatarUrl;
    data['repos_url'] = this.reposUrl;

    return data;
  }
}
