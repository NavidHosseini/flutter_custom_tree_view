import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_custom_tree_view/src/controller/flutter_custom_tree_view_controller.dart';

import 'models/tree_node.dart';
import 'models/tree_view_search_ui.dart';

class TreeViewCustom extends StatefulWidget {
  final TreeNode root;
  final Function(List<String> recordParentKey, TreeNode node) onLastItemClick;
  final Function(TreeNode node) onPressToLoadChildren;
  final bool showSearch;
  final bool showRootTitle;
  final TreeViewSearchUi? searchFieldUi;
  final TreeViewController? controller;
  final Widget? divider;

  const TreeViewCustom({
    super.key,
    required this.root,
    required this.onLastItemClick,
    required this.onPressToLoadChildren,
    this.showSearch = false,
    this.searchFieldUi,
    this.controller,
    this.divider,
    this.showRootTitle = true,
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
    widget.controller?.dispose();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    widget.controller?.collapseAllNodes();
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
    final List<TreeNode> filteredChildren = [];
    for (final child in node.preLoadedChildren) {
      final filteredChild = _filterNodes(child, query);
      if (filteredChild.preLoadedChildren.isNotEmpty ||
          filteredChild.title.toLowerCase().contains(query) ||
          (filteredChild.value?.toString().toLowerCase().contains(query) ?? false)) {
        filteredChildren.add(filteredChild);
      }
    }

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

  Widget _buildNode(TreeNode node, {bool initiallyExpanded = false, bool isRoot = false, required BuildContext context, bool isLastChild = false}) {
    final controller = ExpansionTileController();
    widget.controller?.registerController(node, controller);
    final showDivider = widget.divider != null && !isLastChild;

    if (node.isLastItem) {
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
          if (showDivider) widget.divider!,
        ],
      );
    }
    if (isRoot) {
      widget.controller?.unregisterController(node.key);
      return Column(
        children: [
          widget.showRootTitle
              ? InkWell(
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
                )
              : SizedBox(),
          if (showDivider && widget.showRootTitle) widget.divider!,
          ...node.preLoadedChildren.asMap().entries.map((entry) {
            final index = entry.key;
            final child = entry.value;
            return _buildNode(
              child,
              context: context,
              isLastChild: index == node.preLoadedChildren.length - 1,
            );
          }),
        ],
      );
    }

    return Column(
      children: [
        ExpansionTile(
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
          shape: widget.divider != null ? Border() : node.customUi?.shape,
          showTrailingIcon: node.customUi?.showTrailingIcon ?? true,
          subtitle: node.customUi?.subtitle,
          textColor: node.customUi?.textColor,
          tilePadding: node.customUi?.childrenPadding,
          trailing: node.customUi?.trailing,
          visualDensity: node.customUi?.visualDensity,
          title: node.customUi?.title ?? Text(node.title),
          controller: controller,
          onExpansionChanged: (expanded) {
            if (expanded && !node.completer.isCompleted && node.preLoadedChildren.isEmpty) {
              widget.onPressToLoadChildren(node);
            }
          },
          children: node.preLoadedChildren.isNotEmpty
              ? node.preLoadedChildren.asMap().entries.map((entry) {
                  final index = entry.key;
                  final child = entry.value;
                  return _buildNode(
                    child,
                    context: context,
                    isLastChild: index == node.preLoadedChildren.length - 1,
                  );
                }).toList()
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
                      return Column(
                        children: snapshot.data!.asMap().entries.map((entry) {
                          final index = entry.key;
                          final child = entry.value;
                          return _buildNode(
                            child,
                            context: context,
                            isLastChild: index == snapshot.data!.length - 1,
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
        ),
        if (showDivider) widget.divider!
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
