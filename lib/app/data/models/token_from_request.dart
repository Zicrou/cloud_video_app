class TokenFromRequest {
  int? id;
  String? tokenableType;
  int? tokenableId;
  String? name;
  List<String>? abilities;
  String? lastUsedAt;
  String? expiresAt;
  String? createdAt;
  String? updatedAt;

  TokenFromRequest({
    this.id,
    this.tokenableType,
    this.tokenableId,
    this.name,
    this.abilities,
    this.lastUsedAt,
    this.expiresAt,
    this.createdAt,
    this.updatedAt,
  });

  TokenFromRequest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tokenableType = json['tokenable_type'];
    tokenableId = json['tokenable_id'];
    name = json['name'];
    abilities = json['abilities'].cast<String>();
    lastUsedAt = json['last_used_at'];
    expiresAt = json['expires_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tokenable_type'] = this.tokenableType;
    data['tokenable_id'] = this.tokenableId;
    data['name'] = this.name;
    data['abilities'] = this.abilities;
    data['last_used_at'] = this.lastUsedAt;
    data['expires_at'] = this.expiresAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
