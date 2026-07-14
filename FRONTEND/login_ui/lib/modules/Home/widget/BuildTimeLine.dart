import 'package:flutter/material.dart';
import 'package:login_ui/models/note_models.dart';

class Buildtimeline extends StatefulWidget {
  final NoteModels item;
  final bool isSelectionmode;
  final ValueChanged<bool> onCheckChanged;
  final VoidCallback onLongPress;
  final bool isChecked;
  const Buildtimeline({required this.isChecked, required this.onLongPress, required this.isSelectionmode, required this.onCheckChanged, required this.item, super.key});

  @override
  State<Buildtimeline> createState() => _BuildtimelineState();
}

class _BuildtimelineState extends State<Buildtimeline> {
  bool changeColors = false;

  void ChangeColors(bool? colorsIs){
    setState(() {
      if(!colorsIs!){
        changeColors = false;
      }
      else{
        changeColors = true;
      }
    });
  }

  void longPrees(){
    widget.onLongPress();
    if(changeColors == false){
      ChangeColors(true);
    }
    else{
      ChangeColors(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
    child: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onLongPress: longPrees,
      child: Container(
        color: changeColors? Colors.redAccent: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Container(width: 2, height: 16, color: changeColors? Colors.white : Colors.grey[700]),
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: changeColors? Colors.white : Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(child: Container(width: 2, color: changeColors? Colors.white : Colors.grey[700])),
              ],
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        widget.item.time,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.item.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.item.pref,
                      style: TextStyle(color: Colors.grey[400], fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),

            widget.isSelectionmode? Checkbox(
              value: widget.isChecked, 
              onChanged: (bool? value) {
                ChangeColors(value);
                widget.onCheckChanged(value ?? false);
              }
            ) : SizedBox.shrink(),
          ],
        ),
      ),
    ),
  );
  }
}