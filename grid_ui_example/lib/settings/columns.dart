class ColumnGroups{
  final List<ColumnGroup> groups;

  ColumnGroups({required this.groups});

  factory ColumnGroups.fromJson(json){
    var list = json["columnGroups"] as List;
    List<ColumnGroup> groups  = list.map((i)=>ColumnGroup.fromJson(i)).toList();

    return ColumnGroups(groups:groups);
  }
}


class ColumnGroup{
  final String name;
  final List<Column> columns;
  
  ColumnGroup({required this.name, required this.columns});

  factory ColumnGroup.fromJson(Map<String, dynamic> json){
    var list = json["columns"] as List;
    List<Column> columns = list.map((i) => Column.fromJson(i)).toList();

    return ColumnGroup(
      name:json["name"],
      columns: columns
    );
  }
}

class Column{
  final String id;
  final String title;
  final String type;
  final bool hide; 

  Column({required this.id, required this.title, required this.type, required this.hide});

  factory Column.fromJson(Map<String, dynamic> json){
    return Column(
      id:json["id"],
      title:json["title"],
      type: json["type"],
      hide: json["hide"]
    );
  }
}


