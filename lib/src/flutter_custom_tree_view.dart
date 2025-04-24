import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_custom_tree_view/src/models/tree_node.dart';
import 'package:flutter_custom_tree_view/src/models/tree_view_search_ui.dart';

class TreeViewCustom extends StatefulWidget {
  final TreeNode root;
  final Function(List<String> recordParentKey, TreeNode node) onLastItemClick;
  final Function(TreeNode node) onPressToLoadChildren;
  final bool showSearch;
  final TreeViewSearchUi? searchFieldUi;
  const TreeViewCustom({
    super.key,
    required this.root,
    required this.onLastItemClick,
    required this.onPressToLoadChildren,
    this.showSearch = false,
    this.searchFieldUi,
  });

  @override
  State<TreeViewCustom> createState() => _TreeViewCustomState();
}

class _TreeViewCustomState extends State<TreeViewCustom> {
  late TreeNode _filteredRoot;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredRoot = widget.root;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void didUpdateWidget(covariant TreeViewCustom oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.root != widget.root) {
      _filterTree(_searchController.text);
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _filterTree(_searchController.text);
  }

  void _filterTree(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredRoot = widget.root;
      });
      return;
    }

    setState(() {
      _filteredRoot = _filterNodes(widget.root, query.toLowerCase());
    });
  }

  TreeNode _filterNodes(TreeNode node, String query) {
    // Filter children recursively
    final List<TreeNode> filteredChildren = [];
    for (final child in node.preLoadedChildren) {
      final filteredChild = _filterNodes(child, query);
      if (filteredChild.preLoadedChildren.isNotEmpty ||
          filteredChild.title.toLowerCase().contains(query) ||
          (filteredChild.value?.toString().toLowerCase().contains(query) ?? false)) {
        filteredChildren.add(filteredChild);
      }
    }

    // Return new node with filtered children
    return TreeNode(
      title: node.title,
      value: node.value,
      key: node.key,
      preLoadedChildren: filteredChildren,
      isLastItem: node.isLastItem,
      customUi: node.customUi,
      completer: node.completer,
    )..completer = node.completer;
  }

  Widget _buildNode(TreeNode node, {bool initiallyExpanded = false, bool isRoot = false, required BuildContext context}) {
    if (isRoot || node.isLastItem) {
      return Column(
        children: [
          InkWell(
            onTap: node.isLastItem
                ? () {
                    _handleLastItemClick(node);
                  }
                : null,
            child: Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: IgnorePointer(
                child: ExpansionTile(
                  backgroundColor: node.customUi?.backgroundColor,
                  childrenPadding: node.customUi?.childrenPadding,
                  clipBehavior: node.customUi?.clipBehavior,
                  collapsedBackgroundColor: node.customUi?.collapsedBackgroundColor,
                  collapsedIconColor: node.customUi?.collapsedIconColor,
                  collapsedShape: node.customUi?.collapsedShape,
                  collapsedTextColor: node.customUi?.collapsedTextColor,
                  initiallyExpanded: true,
                  dense: node.customUi?.dense,
                  expandedAlignment: node.customUi?.expandedAlignment,
                  expansionAnimationStyle: node.customUi?.expansionAnimationStyle,
                  iconColor: node.customUi?.iconColor,
                  expandedCrossAxisAlignment: node.customUi?.expandedCrossAxisAlignment,
                  leading: node.customUi?.leading,
                  minTileHeight: node.customUi?.minTileHeight,
                  shape: node.customUi?.shape,
                  showTrailingIcon: node.customUi?.showTrailingIcon ?? true,
                  subtitle: node.customUi?.subtitle,
                  textColor: node.customUi?.textColor,
                  tilePadding: node.customUi?.childrenPadding,
                  trailing: node.customUi?.trailing ?? const SizedBox.shrink(),
                  visualDensity: node.customUi?.visualDensity,
                  title: node.customUi?.title ?? Text(node.title),
                ),
              ),
            ),
          ),
          if (isRoot) ...node.preLoadedChildren.map((child) => _buildNode(child, context: context)),
        ],
      );
    }

    return ExpansionTile(
      backgroundColor: node.customUi?.backgroundColor,
      childrenPadding: node.customUi?.childrenPadding,
      clipBehavior: node.customUi?.clipBehavior,
      collapsedBackgroundColor: node.customUi?.collapsedBackgroundColor,
      collapsedIconColor: node.customUi?.collapsedIconColor,
      collapsedShape: node.customUi?.collapsedShape,
      collapsedTextColor: node.customUi?.collapsedTextColor,
      initiallyExpanded: initiallyExpanded,
      dense: node.customUi?.dense,
      expandedAlignment: node.customUi?.expandedAlignment,
      expansionAnimationStyle: node.customUi?.expansionAnimationStyle,
      iconColor: node.customUi?.iconColor,
      expandedCrossAxisAlignment: node.customUi?.expandedCrossAxisAlignment,
      leading: node.customUi?.leading,
      minTileHeight: node.customUi?.minTileHeight,
      shape: node.customUi?.shape,
      showTrailingIcon: node.customUi?.showTrailingIcon ?? true,
      subtitle: node.customUi?.subtitle,
      textColor: node.customUi?.textColor,
      tilePadding: node.customUi?.childrenPadding,
      trailing: node.customUi?.trailing,
      visualDensity: node.customUi?.visualDensity,
      title: node.customUi?.title ?? Text(node.title),
      onExpansionChanged: (expanded) {
        if (expanded && !node.completer.isCompleted && node.preLoadedChildren.isEmpty) {
          widget.onPressToLoadChildren(node);
        }
      },
      children: node.preLoadedChildren.isNotEmpty
          ? node.preLoadedChildren.map((child) => _buildNode(child, context: context)).toList()
          : [
              FutureBuilder<List<TreeNode>>(
                future: node.completer.future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(padding: EdgeInsets.all(8.0), child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const ListTile(title: Text("No data available."));
                  }
                  return Column(children: snapshot.data!.map((child) => _buildNode(child, context: context)).toList());
                },
              ),
            ],
    );
  }

  void _handleLastItemClick(TreeNode node) async {
    List<String> parentKeys = await _getParentKeys(widget.root, node);
    widget.onLastItemClick(parentKeys, node);
  }

  Future<List<String>> _getParentKeys(TreeNode root, TreeNode targetNode) async {
    List<String> parentKeys = [];
    await _findPath(root, targetNode, parentKeys);
    return parentKeys;
  }

  Future<bool> _findPath(TreeNode currentNode, TreeNode targetNode, List<String> path) async {
    path.add(currentNode.key);

    if (currentNode == targetNode) {
      return true;
    }

    for (var child in currentNode.preLoadedChildren) {
      if (await _findPath(child, targetNode, path)) {
        return true;
      }
    }

    if (currentNode.completer.isCompleted) {
      List<TreeNode> lazyChildren = await currentNode.completer.future;
      for (var child in lazyChildren) {
        if (await _findPath(child, targetNode, path)) {
          return true;
        }
      }
    }

    path.removeLast();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.showSearch)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              style: widget.searchFieldUi?.style,
              keyboardType: widget.searchFieldUi?.keyboardType,
              textInputAction: widget.searchFieldUi?.textInputAction,
              autofocus: widget.searchFieldUi?.autofocus ?? false,
              autocorrect: widget.searchFieldUi?.autocorrect ?? true,
              maxLines: widget.searchFieldUi?.maxLines ?? 1,
              minLines: widget.searchFieldUi?.minLines,
              decoration: widget.searchFieldUi?.decoration ??
                  InputDecoration(
                    hintText: widget.searchFieldUi?.hintText ?? 'Search...',
                    prefixIcon: widget.searchFieldUi?.prefixIcon ?? const Icon(Icons.search),
                    border: widget.searchFieldUi?.border ?? OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                    contentPadding: widget.searchFieldUi?.contentPadding ?? const EdgeInsets.symmetric(vertical: 12.0),
                    hintStyle: widget.searchFieldUi?.hintStyle,
                    fillColor: widget.searchFieldUi?.fillColor,
                    filled: widget.searchFieldUi?.filled,
                  ),
            ),
          ),
        Expanded(child: ListView(children: [_buildNode(_filteredRoot, initiallyExpanded: true, isRoot: true, context: context)])),
      ],
    );
  }
}
