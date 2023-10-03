import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
Future<IconData?> showIconPicker(
  BuildContext context, {
  bool showSearchBar = true,
  bool showTooltips = true,
  bool barrierDismissible = true,
  double iconSize = 40,
  Color? iconColor,
  double mainAxisSpacing = 5.0,
  double crossAxisSpacing = 5.0,
  ShapeBorder? iconPickerShape,
  Color? backgroundColor,
  BoxConstraints? constraints,
  Widget title = const Text('Sélectionner une icone'),
  Widget closeChild = const Text(
    'Close',
    textScaleFactor: 1.25,
  ),
  Icon searchIcon = const Icon(Icons.search),
  String searchHintText = 'Chercher',
  Icon searchClearIcon = const Icon(Icons.close),
  String noResultsText = 'pas de résultat pour:',
  required Map<String, IconData> icons,
}) async {
  iconColor ??= Theme.of(context).iconTheme.color;
  constraints ??=
      const BoxConstraints(maxHeight: 350, minWidth: 450, maxWidth: 678);
  iconPickerShape ??=
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0));
  backgroundColor ??= Theme.of(context).dialogBackgroundColor;
  IconData? iconPicked;
  final controller = IconController();
  iconPicked = await showDialog(
    barrierDismissible: barrierDismissible,
    context: context,
    builder: (BuildContext context) => IconPickerDialog(
      controller: controller,
      showSearchBar: showSearchBar,
      showTooltips: showTooltips,
      barrierDismissible: barrierDismissible,
      iconSize: iconSize,
      iconColor: iconColor,
      mainAxisSpacing: mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing,
      iconPickerShape: iconPickerShape,
      backgroundColor: backgroundColor,
      constraints: constraints,
      title: title,
      closeChild: closeChild,
      searchIcon: searchIcon,
      searchHintText: searchHintText,
      searchClearIcon: searchClearIcon,
      noResultsText: noResultsText,
      customIconPack: icons,
    ),
  );
  controller.searchTextController.clear();
  if (iconPicked != null) {
    return iconPicked;
  }
  return null;
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
/// IconPicker
/// Author Rebar Ahmad
/// https://github.com/Ahmadre
/// rebar.ahmad@gmail.com

class IconController with ChangeNotifier {
  IconController();
  Map<String, IconData> _icons = {};
  Map<String, IconData> get icons => _icons;
  set icons(Map<String, IconData> val) {
    _icons = val;
    notifyListeners();
  }

  final TextEditingController _searchTextController = TextEditingController();
  TextEditingController get searchTextController => _searchTextController;
  set searchTextController(TextEditingController val) {
    searchTextController = val;
    notifyListeners();
  }

  get length => _icons.length;
  get entries => _icons.entries;
  void addAll(Map<String, IconData> pack) {
    _icons.addAll(pack);
    notifyListeners();
  }

  void removeAll() {
    _icons.clear();
    notifyListeners();
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
class IconPicker extends StatefulWidget {
  final IconController iconController;
  final Map<String, IconData> customIconPack;
  final double? iconSize;
  final Color? iconColor;
  final String? noResultsText;
  final double? mainAxisSpacing;
  final double? crossAxisSpacing;
  final Color? backgroundColor;
  final bool? showTooltips;

  const IconPicker({
    Key? key,
    required this.iconController,
    required this.iconSize,
    required this.noResultsText,
    required this.backgroundColor,
    this.mainAxisSpacing,
    this.crossAxisSpacing,
    this.iconColor,
    this.showTooltips,
    required this.customIconPack,
  }) : super(key: key);

  @override
  IconPickerState createState() => IconPickerState();
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////
class IconPickerState extends State<IconPicker> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.iconController.addAll(widget.customIconPack);
    });
  }

  Widget _getListEmptyMsg() => Container(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: RichText(
            text: TextSpan(
              text: widget.noResultsText ?? '',
              style: TextStyle(
                color: ColorBrightness(widget.backgroundColor!).isLight()
                    ? Colors.black
                    : Colors.white,
              ),
              children: [
                TextSpan(
                  text: widget.iconController.searchTextController.text,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: ColorBrightness(widget.backgroundColor!).isLight()
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Consumer<IconController>(
      builder: (ctx, controller, _) => Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Stack(
          children: <Widget>[
            if (controller.icons.isEmpty)
              _getListEmptyMsg()
            else
              Positioned.fill(
                child: GridView.builder(
                    itemCount: controller.length,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      childAspectRatio: 1 / 1,
                      mainAxisSpacing: widget.mainAxisSpacing ?? 5,
                      crossAxisSpacing: widget.crossAxisSpacing ?? 5,
                      maxCrossAxisExtent:
                          widget.iconSize != null ? widget.iconSize! + 10 : 50,
                    ),
                    itemBuilder: (context, index) {
                      var item = controller.entries.elementAt(index);
                      return GestureDetector(
                        onTap: () => Navigator.pop(context, item.value),
                        child: widget.showTooltips!
                            ? Tooltip(
                                message: item.key,
                                child: Icon(
                                  item.value,
                                  size: widget.iconSize,
                                  color: widget.iconColor,
                                ),
                              )
                            : Icon(
                                item.value,
                                size: widget.iconSize,
                                color: widget.iconColor,
                              ),
                      );
                    }),
              ),
            IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.lerp(
                          Alignment.topCenter, Alignment.center, .05)!,
                      colors: [
                        widget.backgroundColor!,
                        widget.backgroundColor!.withOpacity(.1),
                      ],
                      stops: const [
                        0.0,
                        1.0
                      ]),
                ),
                child: Container(),
              ),
            ),
            IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.lerp(
                          Alignment.bottomCenter, Alignment.center, .05)!,
                      colors: [
                        widget.backgroundColor!,
                        widget.backgroundColor!.withOpacity(.1),
                      ],
                      stops: const [
                        0.0,
                        1.0
                      ]),
                ),
                child: Container(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
class ColorBrightness {
  late Color _color;

  ColorBrightness(Color color) {
    _color = Color.fromARGB(color.alpha, color.red, color.green, color.blue);
  }

  bool isDark() {
    return getBrightness() < 128.0;
  }

  bool isLight() {
    return !isDark();
  }

  double getBrightness() {
    return (_color.red * 299 + _color.green * 587 + _color.blue * 114) / 1000;
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
class IconPickerDialog extends StatelessWidget {
  const IconPickerDialog({
    Key? key,
    required this.controller,
    this.showSearchBar = true,
    this.showTooltips,
    this.barrierDismissible,
    this.iconSize,
    this.iconColor,
    this.mainAxisSpacing,
    this.crossAxisSpacing,
    this.iconPickerShape,
    this.backgroundColor,
    this.constraints,
    required this.title,
    this.closeChild,
    this.searchIcon,
    this.searchHintText,
    this.searchClearIcon,
    this.noResultsText,
    required this.customIconPack,
  }) : super(key: key);

  final IconController controller;
  final bool? showSearchBar;
  final bool? showTooltips;
  final bool? barrierDismissible;
  final double? iconSize;
  final Color? iconColor;
  final double? mainAxisSpacing;
  final double? crossAxisSpacing;
  final ShapeBorder? iconPickerShape;
  final Color? backgroundColor;
  final BoxConstraints? constraints;
  final Widget title;
  final Widget? closeChild;
  final Icon? searchIcon;
  final String? searchHintText;
  final Icon? searchClearIcon;
  final String? noResultsText;
  final Map<String, IconData> customIconPack;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: controller,
        builder: (ctx, w) {
          return AlertDialog(
            backgroundColor: backgroundColor,
            shape: iconPickerShape,
            title: DefaultTextStyle(
              style: TextStyle(
                color: ColorBrightness(backgroundColor!).isLight()
                    ? Colors.black
                    : Colors.white,
                fontSize: 20,
              ),
              child: title,
            ),
            content: Container(
              constraints: constraints,
              child: Column(
                children: <Widget>[
                  if (showSearchBar!)
                    IconSearchBar(
                      iconController: controller,
                      customIconPack: customIconPack,
                      searchIcon: searchIcon,
                      searchClearIcon: searchClearIcon,
                      searchHintText: searchHintText,
                      backgroundColor: backgroundColor,
                    ),
                  Expanded(
                    child: IconPicker(
                      iconController: controller,
                      showTooltips: showTooltips,
                      customIconPack: customIconPack,
                      iconColor: iconColor,
                      backgroundColor: backgroundColor,
                      noResultsText: noResultsText,
                      iconSize: iconSize,
                      mainAxisSpacing: mainAxisSpacing,
                      crossAxisSpacing: crossAxisSpacing,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.resolveWith(
                    (states) => const EdgeInsets.symmetric(horizontal: 20),
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: closeChild!,
              ),
            ],
          );
        });
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
class IconSearchBar extends StatefulWidget {
  const IconSearchBar({
    required this.iconController,
    required this.searchHintText,
    required this.searchIcon,
    required this.searchClearIcon,
    required this.backgroundColor,
    required this.customIconPack,
    Key? key,
  }) : super(key: key);

  final IconController iconController;
  final Map<String, IconData> customIconPack;
  final String? searchHintText;
  final Icon? searchIcon;
  final Icon? searchClearIcon;
  final Color? backgroundColor;

  @override
  IconSearchBarState createState() => IconSearchBarState();
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////
class IconSearchBarState extends State<IconSearchBar> {
  _search(String searchValue) {
    Map<String, IconData> searchResult = {};
    widget.customIconPack.forEach((String key, IconData val) {
      if (key.toLowerCase().contains(searchValue.toLowerCase())) {
        searchResult.putIfAbsent(key, () => val);
      }
    });
    setState(() {
      if (searchResult.isNotEmpty) {
        widget.iconController.icons = searchResult;
      } else {
        widget.iconController.removeAll();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<IconController>(builder: (ctx, controller, _) {
      return TextField(
        onChanged: (val) => _search(val),
        controller: controller.searchTextController,
        style: TextStyle(
          color: ColorBrightness(widget.backgroundColor!).isLight()
              ? Colors.black
              : Colors.white,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(top: 15),
          hintStyle: TextStyle(
            color: ColorBrightness(widget.backgroundColor!).isLight()
                ? Colors.black54
                : Colors.white54,
          ),
          hintText: widget.searchHintText,
          prefixIcon: widget.searchIcon,
          suffixIcon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: controller.searchTextController.text.isNotEmpty
                ? IconButton(
                    icon: widget.searchClearIcon!,
                    onPressed: () => setState(() {
                      controller.searchTextController.clear();
                      controller.addAll(widget.customIconPack);
                    }),
                  )
                : const SizedBox(
                    width: 10,
                  ),
          ),
        ),
      );
    });
  }
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////
