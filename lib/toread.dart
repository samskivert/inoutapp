import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'model.dart';
import 'store.dart';

class ReadList extends StatefulWidget {
  const ReadList ({super.key});
  @override ReadListState createState () => ReadListState();
}

class ReadListState extends State<ReadList> {

  @override Widget build (BuildContext context) {
    return StreamBuilder<(List<Read>, List<Read>, List<Read>)>(
      stream: Provider.of<Store>(context).readItems(5),
      builder: (BuildContext ctx, AsyncSnapshot<(List<Read>, List<Read>, List<Read>)> snaps) {
        if (snaps.hasError) return const Text("What is this? I can't even.");
        if (snaps.data == null) return const Text('Loading...'); // TODO: spinner
        var (reading, toRead, recent) = snaps.data!;
        return ListView.separated(
          separatorBuilder: (BuildContext ctx, int index) => const Divider(),
          itemCount: reading.length + (reading.isNotEmpty ? 1 : 0) +
            toRead.length + (toRead.isNotEmpty ? 1 : 0) +
            recent.length + (recent.isNotEmpty ? 1 : 0),
          itemBuilder: (BuildContext ctx, int index) {
            if (reading.isNotEmpty) {
              if (index == 0) {
                return header('Reading');
              } else if (index-1 < reading.length) {
                return ReadItem(item: reading[index-1]);
              } else {
                index -= reading.length+1;
              }
            }
            if (toRead.isNotEmpty) {
              if (index == 0) {
                return header('To Read');
              } else if (index-1 < toRead.length) {
                return ReadItem(item: toRead[index-1]);
              } else {
                index -= toRead.length+1;
              }
            }
            return index == 0 ? header('Recently Read') : ReadItem(item: recent[index-1]);
          },
        );
      },
    );
  }

  Widget header (String label) => Row(children: <Widget>[
    const Icon(Icons.menu_book),
    const SizedBox(width: 5),
    Text(label, style: Theme.of(context).textTheme.titleMedium),
  ]);
}

void updateRead (BuildContext ctx, Read item, dynamic Function(ReadBuilder) updates) {
  Provider.of<Store>(ctx, listen: false).update(item, item.rebuild(updates));
}

class ReadItem extends StatelessWidget {

  ReadItem ({required this.item}) : super(key: Key(item.id));
  final Read item;

  @override Widget build (BuildContext ctx) {
    var (actionTip, actionIcon, action) =
      item.started == null ? ("Mark as started", Icons.play_arrow, () {
        updateRead(ctx, item, (b) => b..started = _dateFmt.format(DateTime.now()));
      }) :
      item.completed == null ? ("Mark as completed", Icons.check_box_outline_blank, () {
        updateRead(ctx, item, (b) => b..completed = _dateFmt.format(DateTime.now()));
      }) :
      ("Revert to uncompleted", Icons.check_box, () {
        updateRead(ctx, item, (b) => b..completed = null);
      });
    var items = <Widget>[
      IconButton(icon: Icon(actionIcon), tooltip: actionTip, onPressed: action),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(item.title),
          Text(item.author ?? "", style: Theme.of(ctx).textTheme.bodySmall?.merge(
            TextStyle(color: Colors.grey[600]))),
        ]),
      const Spacer(),
      if (item.rating != Rating.none) Text(
        '${item.rating.emoji} ', style: Theme.of(ctx).textTheme.titleLarge),
      if (item.link != null) IconButton(
        icon: const Icon(Icons.link),
        tooltip: item.link,
        onPressed: () async {
          if (!await launchUrl(Uri.parse(item.link!))) {
            print('Failed to launch: ${item.link}');
          }
        }
      ),
      IconButton(
        icon: const Icon(Icons.edit),
        tooltip: "Edit",
        onPressed: () => Navigator.push(
          ctx, MaterialPageRoute(builder: (context) => EditReadItem(item: item))),
      ),
      Icon(iconFor(item.type), color: Colors.grey[600]),
    ];
    return Row(children: items);
  }
}

IconData iconFor (ReadType type) {
  switch (type) {
  case ReadType.article: return Icons.bookmark;
  case ReadType.book: return Icons.menu_book;
  case ReadType.paper: return Icons.feed_outlined;
  }
}

var _dateFmt = DateFormat("yyyy-MM-dd");
var _createdFmt = DateFormat.yMMMd().add_jm();

String? nonNull (String? txt, String msg) { return txt == null || txt.isEmpty ? msg : null; }
String? beNull (String txt) => txt.isEmpty ? null : txt;

class EditReadItem extends StatefulWidget {
  const EditReadItem ({super.key, required this.item});
  final Read item;
  @override EditReadItemState createState () => EditReadItemState(item);
}

class EditReadItemState extends State<EditReadItem> {
  final _formKey = GlobalKey<FormState>();
  Read _item;

  EditReadItemState (Read item) : _item = item;

  @override Widget build (BuildContext ctx) {
    final typeEntries = <DropdownMenuEntry<ReadType>>[];
    for (final ReadType type in ReadType.values) {
      typeEntries.add(DropdownMenuEntry<ReadType>(value: type, label: type.label));
    }

    final ratingEntries = <DropdownMenuEntry<Rating>>[];
    for (final Rating rating in Rating.values) {
      ratingEntries.add(DropdownMenuEntry<Rating>(
        value: rating, label: rating.emoji + rating.label));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              _textField(_item.title, 'Title', (text) {
                _item = _item.rebuild((b) => b..title = text);
              }),
              const SizedBox(height: 12),
              _textField(_item.author ?? "", 'Author', (text) {
                _item = _item.rebuild((b) => b..author = beNull(text));
              }),
              const SizedBox(height: 24),
              Row(children: <Widget>[
                Expanded(child: DropdownMenu<ReadType>(
                  initialSelection: _item.type,
                  label: const Text('Type'),
                  dropdownMenuEntries: typeEntries,
                  onSelected: (ReadType? type) {
                    setState(() {
                      if (type is ReadType) _item = _item.rebuild((b) => b..type = type);
                    });
                  },
                )),
                const SizedBox(width: 32),
                Expanded(child: _textField2(_item.tags.join(' '), 'Tags', (text) {
                  _item = _item.rebuild((b) {
                    text.isEmpty ? b.tags.clear() : b.tags.replace(text.split(' '));
                  });
                })),
              ]),
              Row(children: <Widget>[
                Expanded(child: _textField2(_item.link ?? "", 'Link', (text) {
                  _item = _item.rebuild((b) => b..link = beNull(text));
                })),
                const SizedBox(width: 32),
                Expanded(child: _textField2(_item.recommender ?? "", 'Recommender', (text) {
                  _item = _item.rebuild((b) => b..recommender = beNull(text));
                })),
              ]),
              const SizedBox(height: 24),
              Row(children: <Widget>[
                Expanded(child: DropdownMenu<Rating>(
                  initialSelection: _item.rating,
                  label: const Text('Rating'),
                  dropdownMenuEntries: ratingEntries,
                  onSelected: (Rating? rating) {
                    setState(() {
                      if (rating is Rating) _item = _item.rebuild((b) => b..rating = rating);
                    });
                  },
                )),
                Expanded(child: CheckboxListTile(
                  title: const Text('Abandoned'),
                  value: _item.abandoned,
                  onChanged: (selected) {
                    setState(() {
                      if (selected is bool) _item = _item.rebuild((b) => b..abandoned = selected);
                    });
                  },
                )),
              ]),
              const SizedBox(height: 12),
              Row(children: <Widget>[
                Expanded(child: _textFieldDate(_item.started ?? "", 'Started', (date) {
                  _item = _item.rebuild((b) => b..started = date);
                })),
                const SizedBox(width: 32),
                Expanded(child: _textFieldDate(_item.completed ?? "", 'Completed', (date) {
                  _item = _item.rebuild((b) => b..completed = date);
                })),
              ]),
              const SizedBox(height: 24),
              Text('Created: ${_createdFmt.format(_item.created.toDate())}'),
              const SizedBox(height: 24),
              Row(children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.delete),
                  tooltip: 'Delete item',
                  onPressed: () {
                    // TODO: delete
                  },
                ),
                const Spacer(),
                OutlinedButton(child: const Text('Cancel'), onPressed: () => Navigator.pop(ctx)),
                const SizedBox(width: 32),
                FilledButton(child: const Text('Update'), onPressed: () {
                  Provider.of<Store>(ctx, listen: false).update(widget.item, _item);
                  Navigator.pop(ctx);
                }),
              ]),
            ]
          ),
        ),
      ),
    );
  }

  TextFormField _textField (String value, String label, Function(String) onChanged) {
    return TextFormField(
      initialValue: value,
      decoration: InputDecoration(labelText: label),
      onChanged: (text) {
        setState(() {
          onChanged(text);
        });
      },
    );
  }

  TextFormField _textField2 (String value, String label, Function(String) onChanged) {
    return TextFormField(
      initialValue: value,
      decoration: InputDecoration(hintText: label),
      onChanged: (text) {
        setState(() {
          onChanged(text);
        });
      },
    );
  }

  Widget _textFieldDate (String? value, String label, Function(String?) onChanged) {
    var controller = TextEditingController();
    controller.text = value ?? '';
    var date = value is String && value.isNotEmpty ? _dateFmt.parse(value) : DateTime.now();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(child: TextFormField(
          controller: controller,
          decoration: InputDecoration(labelText: label),
          readOnly: true,
          onTap: () async {
            var pickedDate = await showDatePicker(
              context: context, initialDate: date,
              firstDate: DateTime(1990),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (pickedDate != null) {
              setState(() {
                onChanged(_dateFmt.format(pickedDate));
              });
            }
          },
        )),
        if (controller.text.isNotEmpty) IconButton(
          icon: const Icon(Icons.clear),
          tooltip: 'Clear date',
          onPressed: () => setState(() {
            onChanged(null);
          })
        )
      ]);
  }
}
