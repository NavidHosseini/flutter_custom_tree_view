import 'package:flutter/material.dart';
import 'package:flutter_custom_tree_view/src/models/tree_node.dart';

class TreeViewController {
  final Map<TreeNode?, ExpansionTileController> nodeControllers = {};

  void registerController(TreeNode node, ExpansionTileController controller) {
    nodeControllers[node] = controller;
  }

  void unregisterController(String nodeKey) {
    nodeControllers.removeWhere((node, controller) => node?.key == nodeKey);
  }

  void expandNode(String key) {
    final controller = _getControllerByKey(key);
    if (controller != null && _isControllerValid(controller)) {
      controller.expand();
    }
  }

  void collapseNode(String key) {
    final controller = _getControllerByKey(key);
    if (controller != null && _isControllerValid(controller)) {
      controller.collapse();
    }
  }

  void toggleNode(String key) {
    final controller = _getControllerByKey(key);
    if (controller != null && _isControllerValid(controller)) {
      if (controller.isExpanded) {
        controller.collapse();
      } else {
        controller.expand();
      }
    }
  }

  void collapseAllNodes() {
    final allNodes = nodeControllers.keys.whereType<TreeNode>().toList().reversed;

    for (final node in allNodes) {
      final controller = nodeControllers[node];
      if (controller != null && _isControllerValid(controller) && !node.isLastItem) {
        controller.collapse();
      }
    }
  }

  bool isNodeExpanded(String key) {
    final controller = _getControllerByKey(key);
    return controller != null && _isControllerValid(controller) && controller.isExpanded;
  }

  ExpansionTileController? _getControllerByKey(String key) {
    final matchingNode = nodeControllers.keys.firstWhere(
      (node) => node?.key == key,
      orElse: () => null,
    );
    return matchingNode != null ? nodeControllers[matchingNode] : null;
  }

  bool _isControllerValid(ExpansionTileController controller) {
    try {
      return controller.isExpanded || !controller.isExpanded;
    } catch (e) {
      return false;
    }
  }

  void dispose() {
    nodeControllers.clear();
  }
}
