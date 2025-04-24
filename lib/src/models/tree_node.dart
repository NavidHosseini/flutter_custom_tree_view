import 'dart:async';

import 'package:flutter_custom_tree_view/src/models/tree_node_ui.dart';

class TreeNode {
  final String title;
  final dynamic value;
  final String key;

  List<TreeNode> _preLoadedChildren;
  List<TreeNode> get preLoadedChildren => _preLoadedChildren;

  Completer<List<TreeNode>> completer;
  final bool isLastItem;
  final TreeNodeUi? customUi;

  TreeNode({
    this.customUi,
    required this.title,
    required this.value,
    required this.key,
    List<TreeNode> preLoadedChildren = const [],
    this.isLastItem = false,
    Completer<List<TreeNode>>? completer,
  })  : _preLoadedChildren = List.from(preLoadedChildren),
        completer = completer ?? Completer<List<TreeNode>>() {
    // Add listener to move data when completer completes
    if (!this.completer.isCompleted) {
      this.completer.future.then((children) {
        _preLoadedChildren = List.from(children);
      });
    }
  }

  TreeNode copyWith({
    String? title,
    dynamic value,
    String? key,
    List<TreeNode>? preLoadedChildren,
    bool? isLastItem,
    TreeNodeUi? customUi,
    Completer<List<TreeNode>>? completer,
  }) {
    return TreeNode(
      title: title ?? this.title,
      value: value ?? this.value,
      key: key ?? this.key,
      preLoadedChildren: preLoadedChildren ?? List.from(_preLoadedChildren),
      isLastItem: isLastItem ?? this.isLastItem,
      customUi: customUi ?? this.customUi,
      completer: completer ?? this.completer,
    );
  }

  @override
  String toString() {
    return 'TreeNode{'
        'title: $title, '
        'value: $value, '
        'key: $key, '
        'preLoadedChildren: ${preLoadedChildren.length} items, '
        'completer: ${completer.isCompleted ? "completed" : "not completed"}, '
        'isLastItem: $isLastItem'
        '}';
  }
}
