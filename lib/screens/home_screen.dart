import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/configs/colors.dart';
import 'package:notes_app/configs/theme_notifier.dart';
import 'package:notes_app/helpers/notes_helper.dart';
import 'package:notes_app/helpers/theme_helper.dart';
import 'package:notes_app/models/detail_notes_arguments.dart';
import 'package:notes_app/models/notes.dart';
import 'package:notes_app/widgets/confirmation_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _selectedNotesId = [];
  List<Notes> _notes = [];
  List<Notes> _showNotes = [];
  bool _selectionMode = false;
  bool _isShowArchived = false;
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadNotes();
    _loadTheme();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar:
            _selectionMode
                ? _buildSelectionAppBar(context)
                : _buildSearchAppBar(),
        body:
            _showNotes.isEmpty
                ? Center(child: Text('Empty Notes'))
                : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth < 600) {
                        return ListView.builder(
                          itemCount: _showNotes.length,
                          itemBuilder: (context, index) {
                            final Notes note = _showNotes[index];
                            final isSelected = _selectedNotesId.contains(
                              note.id,
                            );
                            return CardNote(
                              note: note,
                              isSelected: isSelected,
                              onTap: () => _onTapNote(note),
                              onLongPress: () => _onLongPressNote(note),
                              constraints: constraints,
                            );
                          },
                        );
                      } else if (constraints.maxWidth < 900) {
                        return GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 5,
                                crossAxisSpacing: 5,
                              ),
                          itemCount: _showNotes.length,
                          itemBuilder: (context, index) {
                            final Notes note = _showNotes[index];
                            final isSelected = _selectedNotesId.contains(
                              note.id,
                            );
                            return CardNote(
                              note: note,
                              isSelected: isSelected,
                              onTap: () => _onTapNote(note),
                              onLongPress: () => _onLongPressNote(note),
                              constraints: constraints,
                            );
                          },
                        );
                      } else {
                        return GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 5,
                                crossAxisSpacing: 5,
                              ),
                          itemCount: _showNotes.length,
                          itemBuilder: (context, index) {
                            final Notes note = _showNotes[index];
                            final isSelected = _selectedNotesId.contains(
                              note.id,
                            );
                            return CardNote(
                              note: note,
                              isSelected: isSelected,
                              onTap: () => _onTapNote(note),
                              onLongPress: () => _onLongPressNote(note),
                              constraints: constraints,
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
        floatingActionButton: FloatingActionButton(
          tooltip: 'Add Note',
          backgroundColor: primaryColor,
          onPressed: () async {
            resetSearch();
            final result = await Navigator.pushNamed(
              context,
              '/detail-note',
              arguments: DetailNotesArguments(notes: _notes),
            );
            _updateNotes(result as List<Notes>);
          },
          child: Icon(Icons.add, size: 24, color: whiteColor),
        ),
      ),
    );
  }

  AppBar _buildSearchAppBar() {
    return AppBar(
      foregroundColor: whiteColor,
      backgroundColor: primaryColor,
      automaticallyImplyLeading:
          false, // Remove back button default behavior when pushnamed from onboarding screen
      actionsPadding: EdgeInsets.only(right: 10),
      title: LayoutBuilder(
        builder:
            (context, constraints) => Container(
              width: constraints.maxWidth < 600 ? double.infinity : 400,
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextField(
                controller: _searchController,
                style: TextStyle(color: primaryColor),
                onChanged: (value) {
                  List<Notes> currentShowNotes = _getShowNotes();
                  setState(() {
                    if (value.isEmpty) {
                      _showNotes = currentShowNotes;
                    } else {
                      _showNotes =
                          currentShowNotes
                              .where(
                                (n) => n.title.toLowerCase().contains(
                                  value.toLowerCase(),
                                ),
                              )
                              .toList();
                    }
                  });
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, size: 24, color: primaryColor),
                  hintText: 'Search your notes...',
                  hintStyle: TextStyle(color: primaryColor, fontSize: 18),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
      ),
      actions: [
        PopupMenuButton(
          tooltip: 'Show menu',
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                value: 'Show Archived',
                child: StatefulBuilder(
                  builder:
                      (context, setState) => ListTile(
                        onTap: () {},
                        leading: Icon(Icons.archive),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Show Archived'),
                            Switch(
                              value: _isShowArchived,
                              activeColor: primaryColor,
                              onChanged: (bool value) {
                                setState(() {
                                  _isShowArchived = !_isShowArchived;
                                });
                                _updateNotes(_notes);
                              },
                            ),
                          ],
                        ),
                      ),
                ),
              ),
              PopupMenuItem(
                value: 'Dark Mode',
                child: StatefulBuilder(
                  builder:
                      (context, setState) => ListTile(
                        onTap: () {},
                        leading: Icon(Icons.dark_mode),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Dark Mode'),
                            Switch(
                              value: _isDarkMode,
                              activeColor: primaryColor,
                              onChanged: (bool value) {
                                setState(() {
                                  _isDarkMode = !_isDarkMode;
                                });
                                _updateTheme();
                              },
                            ),
                          ],
                        ),
                      ),
                ),
              ),
              PopupMenuItem(
                value: 'About',
                child: ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text('About'),
                  onTap: () {
                    Navigator.pop(
                      context,
                    ); // Close popup, context from PopupMenuButton
                    Navigator.pushNamed(
                      context,
                      '/about',
                    ); // Direct about page, context from parent Scaffold
                  },
                ),
              ),
            ];
          },
        ),
      ],
    );
  }

  AppBar _buildSelectionAppBar(BuildContext context) {
    return AppBar(
      foregroundColor: whiteColor,
      backgroundColor: primaryColor,
      actionsPadding: EdgeInsets.only(right: 10),
      leading: IconButton(
        tooltip: 'Cancel',
        icon: Icon(Icons.cancel_outlined, size: 24),
        onPressed: () {
          setState(() {
            _selectionMode = false;
            _selectedNotesId.clear();
          });
        },
      ),
      actions: [
        IconButton(
          tooltip: _isShowArchived ? 'Unarchive' : 'Archive',
          icon: Icon(
            _isShowArchived ? Icons.unarchive : Icons.archive,
            size: 24,
          ),
          onPressed: () async {
            for (var id in _selectedNotesId) {
              Notes note = _notes.firstWhere((note) => note.id == id);
              note.isArchived = !note.isArchived;
            }
            setState(() {
              _selectionMode = !_selectionMode;
            });
            _selectedNotesId.clear();
            await _updateNotes(_notes);
          },
        ),
        IconButton(
          tooltip: 'Delete',
          icon: Icon(Icons.delete, size: 24),
          onPressed: () async {
            final message = 'Are you sure want to delete?';
            final confirmed = await confirmationDelete(context, message);
            if (confirmed) {
              for (var id in _selectedNotesId) {
                _notes.removeWhere((note) => note.id == id);
              }
              setState(() {
                _selectionMode = !_selectionMode;
              });
              _selectedNotesId.clear();
              await _updateNotes(_notes);
            }
          },
        ),
      ],
    );
  }

  void resetSearch() {
    setState(() {
      _showNotes = _getShowNotes();
    });
    _searchController.clear();
  }

  Future<void> _loadNotes() async {
    _notes = await getNotes();
    setState(() {
      _showNotes = _getShowNotes();
    });
  }

  Future<void> _updateNotes(List<Notes> notes) async {
    await saveNotes(notes);
    setState(() {
      _showNotes = _getShowNotes();
    });
  }

  List<Notes> _getShowNotes() {
    final copyNotes = List<Notes>.from(_notes);
    final filteredNotes =
        copyNotes.where((n) => n.isArchived == _isShowArchived).toList();
    filteredNotes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return filteredNotes;
  }

  Future<void> _loadTheme() async {
    final bool theme = await getTheme();
    themeNotifier.value = theme ? ThemeMode.dark : ThemeMode.light;
    setState(() {
      _isDarkMode = theme;
    });
  }

  Future<void> _updateTheme() async {
    themeNotifier.value = _isDarkMode ? ThemeMode.dark : ThemeMode.light;
    await saveTheme(_isDarkMode);
  }

  void _selectNotes(Notes note) {
    if (_selectedNotesId.contains(note.id)) {
      _selectedNotesId.remove(note.id);
    } else {
      _selectedNotesId.add(note.id);
    }

    _selectionMode = _selectedNotesId.isNotEmpty;
  }

  Future<void> _onTapNote(Notes note) async {
    if (_selectionMode) {
      setState(() {
        _selectNotes(note);
      });
    } else {
      resetSearch();
      final result = await Navigator.pushNamed(
        context,
        '/detail-note',
        arguments: DetailNotesArguments(notes: _notes, idEditNote: note.id),
      );
      _updateNotes(result as List<Notes>);
    }
  }

  void _onLongPressNote(Notes note) {
    setState(() {
      _selectNotes(note);
    });
  }
}

class CardNote extends StatelessWidget {
  final Notes note;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final BoxConstraints constraints;

  const CardNote({
    super.key,
    required this.note,
    required this.isSelected,
    required this.onTap,
    required this.onLongPress,
    required this.constraints,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(color: greyColor, width: 1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: InkWell(
        splashColor: secondaryColor,
        onLongPress: onLongPress,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          color:
              isSelected
                  ? primaryColor.withAlpha(50)
                  : Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                note.title,
                style: Theme.of(context).textTheme.titleLarge,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 5),
              constraints.maxWidth < 600
                  ? Text(
                    note.description,
                    style: Theme.of(context).textTheme.labelLarge,
                    maxLines: constraints.maxWidth < 600 ? 3 : 10,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  )
                  : Expanded(
                    child: Text(
                      note.description,
                      style: Theme.of(context).textTheme.labelLarge,
                      maxLines: constraints.maxWidth < 600 ? 3 : 10,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                  ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  DateFormat.yMEd().add_jms().format(note.updatedAt),
                  style: Theme.of(
                    context,
                  ).textTheme.labelMedium!.copyWith(color: greyColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
