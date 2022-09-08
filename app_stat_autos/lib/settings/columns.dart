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
  final List<GridColumn> columns;
  
  ColumnGroup({required this.name, required this.columns});

  factory ColumnGroup.fromJson(Map<String, dynamic> json){
    var list = json["columns"] as List;
    List<GridColumn> columns = list.map((i) => GridColumn.fromJson(i)).toList();

    return ColumnGroup(
      name:json["name"],
      columns: columns
    );
  }
}

class GridColumn{
  final String id;
  final String title;
  final String type;
  final bool hide; 

  GridColumn({required this.id, required this.title, required this.type, required this.hide});

  factory GridColumn.fromJson(Map<String, dynamic> json){
    return GridColumn(
      id:json["id"],
      title:json["title"],
      type: json["type"],
      hide: json["hide"]
    );
  }
}


