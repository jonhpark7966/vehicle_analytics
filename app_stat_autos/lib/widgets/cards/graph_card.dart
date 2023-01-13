import 'package:flutter/material.dart';
import '../../settings/theme.dart';
import '../../settings/ui_constants.dart';


class GraphCard extends StatefulWidget {
  final Widget graph;
  final Color color;
  final String title;
  final String subtitle;
  final String help;

  const GraphCard({Key? key,
   required this.graph, required this.color, required this.title, required this.subtitle,
   this.help=""})
    : super(key: key);

  @override
  State<StatefulWidget> createState() => GraphCardState();
}

class GraphCardState extends State<GraphCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(18)),
          color: cardBackgroundColor,
          boxShadow: [BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 5,
            offset: const Offset(5, 5), // changes position of shadow
          )],
        ),
        child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(
                  height: defaultPadding,
                ),
                Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width:(widget.help == "")?1:30),
                Text(
                  widget.title,
                  style: TextStyle(
                    color: widget.color,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                (widget.help == "")
                    ? const SizedBox(width: 1)
                    : Container(
                      padding: const EdgeInsets.only(right: 10),
                      child:Tooltip(
                        padding: const EdgeInsets.all(defaultPadding),
                        message: widget.help,
                        child: const Icon(Icons.help_outline_outlined,
                            color: Colors.blueGrey))),
              ],
           ),
           const SizedBox(
              height: 5,
            ),
            Text(
              widget.subtitle,
              style: const TextStyle(
                color: Colors.blueGrey,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: defaultPadding,
            ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0, left: 6.0),
                    child: widget.graph,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
      ),
    );
  }
}
