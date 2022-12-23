import 'package:data_handler/data_handler.dart';
import 'package:flutter/material.dart';
import 'package:grid_ui_example/widgets/popups/login_widget.dart';
import 'package:grid_ui_example/widgets/popups/todo.dart';

class AutoStatAppBar extends StatefulWidget implements PreferredSizeWidget {
  AutoStatAppBar({Key? key,
   Color? bgColor }) : preferredSize = Size.fromHeight(kToolbarHeight), super(key: key);

  Color bgColor = const Color.fromARGB(255, 0x1e, 0x02, 0x45);

  @override
  final Size preferredSize; // default is 56.0

  @override
  _AutoStatAppBarState createState() => _AutoStatAppBarState();
}


enum AccountItem {signin, signout, more}

class _AutoStatAppBarState extends State<AutoStatAppBar>{
    
    @override
    Widget build(BuildContext context) {
      var user = AuthManage().getUser();

      return AppBar(
      iconTheme: const IconThemeData(color: Colors.white, opacity: 1),
      leading: const Icon(Icons.area_chart_outlined),
      title: const Text(
        "Automotive Statistics",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      centerTitle: false,
      backgroundColor: widget.bgColor,
      actions: [
        PopupMenuButton(
          itemBuilder: (BuildContext context){
            List<PopupMenuEntry<AccountItem>>  items = [];
            if(user == null){ items.add(
              const PopupMenuItem<AccountItem>(
                value: AccountItem.signin,
                child: Text('Sign In'),
              )
            );
            }else{
              items.add(
              const PopupMenuItem<AccountItem>(
                value: AccountItem.signout,
                child: Text('Sign Out'),
              ));
              items.add(
              const PopupMenuItem<AccountItem>(
                value: AccountItem.more,
                child: Text('More'),
              ),
              );
            }
            return items;
          },
          onSelected: (AccountItem value) async {
            if (value == AccountItem.signin) {
               await showDialog(
                  context: context,
                  barrierDismissible: true, 
                  builder: (BuildContext context) {
                    return AlertDialog(content:SizedBox(
                      width: 500,
                      child: LoginWidget()));
                  });
                  setState((){});
                  return;
            }else if(value == AccountItem.signout){
              AuthManage().signOut();
              setState((){});
              return;
            }else if(value == AccountItem.more){
              showTodoPopup(context);
            }
          },
          child:
            const Icon(Icons.account_circle),
          ),
        const SizedBox(width: 20),
      ],
    );

    }
}