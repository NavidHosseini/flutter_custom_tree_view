## 1.0.0

* TODO:  initial.

## [1.9.0] - 2026-02-17
### Breaking Changes
- **`onLastItemClick`** callback signature changed from `Function(List<String> recordParentKey, TreeNode node)` to `Function(List<TreeNode> roadmap, TreeNode node)`
- The first parameter now provides a complete roadmap (list of TreeNode objects) from root to the clicked node, instead of just string keys
- This allows access to full node information (title, value, customUi, etc.) in the path, not just keys

### Migration Guide
Before:
```dart
onLastItemClick: (parentKeys, node) {
  print('Path: ${parentKeys.join(' > ')}');
}
```

After:
```dart
onLastItemClick: (roadmap, node) {
  String path = roadmap.map((n) => n.title).join(' > ');
  print('Path: $path');
  // Now you can also access other node properties in the path
}
```

## [1.8.0] - 2025-04-30
### Added
- **`TreeViewController`** for programmatic control of node expansion/collapse
- **`divider`** parameter to add custom dividers between nodes
- **`showRootTitle`** toggle to show/hide root node title
- **`isLastChild`** tracking for improved divider placement
- Automatic node collapse during search operations
- Controller disposal in widget lifecycle
- Expanded documentation with new examples

### Changed
- Improved node rendering performance
- Refactored internal build methods for better maintainability
- Updated example app to demonstrate new features
- Search now collapses all nodes before filtering