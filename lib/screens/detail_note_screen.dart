import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/configs/colors.dart';
import 'package:notes_app/helpers/notes_helper.dart';
import 'package:notes_app/models/notes.dart';
import 'package:notes_app/widgets/confirmation_widget.dart';

class DetailNoteScreen extends StatefulWidget {
  final List<Notes> notes;
  final String? idEditNote;
  const DetailNoteScreen({super.key, required this.notes, this.idEditNote});

  @override
  State<DetailNoteScreen> createState() => _DetailNoteScreenState();
}

class _DetailNoteScreenState extends State<DetailNoteScreen> {
  Timer? _debounce;
  Notes? _note;
  final Duration _debounceDuration = Duration(seconds: 2);
  String? _oldTitle;
  String? _oldDescription;

  @override
  void initState() {
    super.initState();
    _initNote();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: ListView(
            children: [
              TextFormField(
                initialValue: _note!.title,
                keyboardType: TextInputType.text,
                maxLines: null,
                style: Theme.of(context).textTheme.titleLarge,
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: greyColor, width: 1),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: greyColor, width: 1),
                  ),
                  hintText: 'Title',
                  hintStyle: Theme.of(
                    context,
                  ).textTheme.titleLarge!.copyWith(color: greyColor),
                  errorMaxLines: 90,
                ),
                maxLength: 100,
                onChanged: (value) {
                  _onTitleChanged(value);
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: _note!.description,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                style: Theme.of(context).textTheme.labelLarge,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Description',
                  hintStyle: Theme.of(
                    context,
                  ).textTheme.labelLarge!.copyWith(color: greyColor),
                ),
                onChanged: (value) {
                  _onDescriptionChanged(value);
                },
              ),
            ],
          ),
        ),
        bottomSheet: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 5),
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Text(
            'Last update: ${DateFormat.yMEd().add_jms().format(_note!.updatedAt)}',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      foregroundColor: whiteColor,
      backgroundColor: primaryColor,
      title: Text(widget.idEditNote == null ? 'Add Note' : 'Edit Note'),
      actionsPadding: EdgeInsets.only(right: 10),
      leading: IconButton(
        tooltip: 'Back',
        icon: Icon(Icons.arrow_back_ios_rounded),
        onPressed: () {
          if (_oldTitle != _note!.title &&
              _oldDescription != _note!.description) {
            _note!.updatedAt = DateTime.now();
          }
          Navigator.pop(context, widget.notes);
        },
      ),
      actions: [
        IconButton(
          tooltip:
              widget.idEditNote != null && _note!.isArchived
                  ? 'Unarchive'
                  : 'Archive',
          icon: Icon(
            widget.idEditNote != null && _note!.isArchived
                ? Icons.unarchive
                : Icons.archive,
            size: 24,
          ),
          onPressed: () {
            // Move data archive/unarchive
            Notes getNote = widget.notes.firstWhere((n) => n.id == _note!.id);
            getNote.isArchived = !getNote.isArchived;
            Navigator.pop(context, widget.notes);
          },
        ),
        IconButton(
          tooltip: 'Delete',
          icon: Icon(Icons.delete, size: 24),
          onPressed: () async {
            final String message = 'Are you sure want to delete?';
            final confirmed = await confirmationDelete(context, message);
            if (confirmed) {
              setState(() {
                widget.notes.removeWhere((n) => n.id == _note!.id);
              });
              if (context.mounted) {
                Navigator.pop(context, widget.notes);
              }
            }
          },
        ),
      ],
    );
  }

  void _initNote() {
    if (widget.idEditNote == null) {
      final String idAddNote = DateTime.now().toString();
      widget.notes.add(
        Notes(
          id: idAddNote,
          title: '',
          description: '',
          isArchived: false,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
      _note = widget.notes.firstWhere((n) => n.id == idAddNote);
    } else {
      _note = widget.notes.firstWhere((n) => n.id == widget.idEditNote);
    }

    _oldTitle = _note!.title;
    _oldDescription = _note!.description;
  }

  void _debounceSave() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(_debounceDuration, () async {
      _note!.updatedAt = DateTime.now();
      await saveNotes(widget.notes);
    });
  }

  void _onTitleChanged(String newTitle) {
    _note!.title = newTitle;
    _debounceSave();
  }

  void _onDescriptionChanged(String newDescription) {
    _note!.description = newDescription;
    _debounceSave();
  }
}
